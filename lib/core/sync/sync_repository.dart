import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

/// Repository for syncing data with Firestore
class SyncRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  
  String? get userId => _auth.currentUser?.uid;
  bool get isAuthenticated => _auth.currentUser != null;
  
  CollectionReference<Map<String, dynamic>> _userCollection(String collection) {
    final uid = userId;
    if (uid == null) throw StateError('User must be authenticated to sync');
    return _firestore.collection('users').doc(uid).collection(collection);
  }
  
  /// Push a record to Firestore
  Future<String> pushRecord({
    required String collection,
    required Map<String, dynamic> data,
    String? existingRemoteId,
  }) async {
    try {
      final cleanData = Map<String, dynamic>.from(data)
        ..remove('id')
        ..remove('syncStatus')
        ..remove('remoteId');
      
      cleanData['updatedAt'] = FieldValue.serverTimestamp();
      
      if (existingRemoteId != null) {
        await _userCollection(collection).doc(existingRemoteId).update(cleanData);
        debugPrint('📤 Updated $collection/$existingRemoteId');
        return existingRemoteId;
      } else {
        cleanData['createdAt'] = FieldValue.serverTimestamp();
        final docRef = await _userCollection(collection).add(cleanData);
        debugPrint('📤 Created $collection/${docRef.id}');
        return docRef.id;
      }
    } catch (e) {
      debugPrint('❌ Failed to push to $collection: $e');
      rethrow;
    }
  }
  
  /// Delete a record from Firestore
  Future<void> deleteRecord({
    required String collection,
    required String remoteId,
    bool hardDelete = false,
  }) async {
    try {
      if (hardDelete) {
        await _userCollection(collection).doc(remoteId).delete();
      } else {
        await _userCollection(collection).doc(remoteId).update({
          'isDeleted': true,
          'deletedAt': FieldValue.serverTimestamp(),
        });
      }
    } catch (e) {
      debugPrint('❌ Failed to delete from $collection: $e');
      rethrow;
    }
  }
  
  /// Test Firestore connection by writing a test document
  Future<bool> testConnection() async {
    try {
      final uid = userId;
      if (uid == null) return false;
      
      await _firestore.collection('users').doc(uid).set({
        'lastSeen': FieldValue.serverTimestamp(),
        'testConnection': true,
      }, SetOptions(merge: true));
      
      debugPrint('✅ Firestore connection test passed');
      return true;
    } catch (e) {
      debugPrint('❌ Firestore connection test failed: $e');
      return false;
    }
  }
  
  static const Map<String, String> tableToCollection = {
    'exercise_logs': 'exerciseLogs',
    'food_logs': 'foodLogs',
    'supplement_logs': 'supplementLogs',
    'alcohol_logs': 'alcoholLogs',
    'weight_logs': 'weightLogs',
    'body_fat_logs': 'bodyFatLogs',
    'expenses': 'expenses',
  };
  
  String getCollectionName(String tableName) {
    return tableToCollection[tableName] ?? tableName;
  }
  /// Sync a record based on action
  Future<String?> syncRecord({
    required String table,
    required String action,
    required int localId, // Not used directly in Firestore but helpful for context
    required Map<String, dynamic>? data,
  }) async {
    final collection = getCollectionName(table);
    
    if (action == 'delete') {
      // For delete, we generally need the remoteId. 
      // If data is null (shouldn't be for delete in my implementation assumption, but could be), we can't delete.
      // Actually SyncEngine logic for delete might not fetch data if the record is gone?
      // But SyncQueue should have trapped the remoteId? 
      // No, SyncQueue only stores recordId.
      // ISSUE: If I delete a record locally, I might not have preserved its remoteId in SyncQueue.
      // Usually "Soft Delete" is used: isDeleted=true, syncStatus=0. Data still exists.
      // My BaseRepository uses soft delete for 'delete' action if implemented that way.
      // Let's verify BaseRepository delete action:
      // "Mark as deleted instead of hard delete for sync safety". Yes.
      // So 'data' will be available and contain 'remoteId'.
      
      final remoteId = data?['remoteId'] as String?;
      if (remoteId != null) {
        await deleteRecord(collection: collection, remoteId: remoteId);
      }
      return remoteId;
    } else {
      if (data == null) throw ArgumentError('Data cannot be null for create/update');
      final remoteId = data['remoteId'] as String?;
      
      final newRemoteId = await pushRecord(
        collection: collection, 
        data: data, 
        existingRemoteId: remoteId
      );
      
      return newRemoteId;
    }
  }
}
