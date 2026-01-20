import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

/// Service for handling Firebase Authentication
class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  
  /// Current user
  User? get currentUser => _auth.currentUser;
  
  /// Stream of auth state changes
  Stream<User?> get authStateChanges => _auth.authStateChanges();
  
  /// Whether user is authenticated
  bool get isAuthenticated => currentUser != null;
  
  /// Whether user is anonymous
  bool get isAnonymous => currentUser?.isAnonymous ?? false;
  
  /// Get user display info
  String get userDisplayName => currentUser?.displayName ?? currentUser?.email ?? 'Anonymous';
  String? get userEmail => currentUser?.email;
  String? get userPhotoUrl => currentUser?.photoURL;
  
  /// Sign in with Google (Web compatible)
  Future<User?> signInWithGoogle() async {
    try {
      if (kIsWeb) {
        final provider = GoogleAuthProvider();
        final result = await _auth.signInWithPopup(provider);
        debugPrint('✅ Signed in with Google: ${result.user?.displayName}');
        return result.user;
      }
      throw UnimplementedError('Google Sign-In is currently only supported on Web.');
    } catch (e) {
      debugPrint('❌ Google sign-in failed: $e');
      rethrow;
    }
  }

  /// Sign in anonymously (for frictionless onboarding)
  Future<User?> signInAnonymously() async {
    try {
      final result = await _auth.signInAnonymously();
      debugPrint('✅ Signed in anonymously: ${result.user?.uid}');
      return result.user;
    } catch (e) {
      debugPrint('❌ Anonymous sign-in failed: $e');
      rethrow;
    }
  }
  
  /// Sign out
  Future<void> signOut() async {
    await _auth.signOut();
    debugPrint('👋 Signed out');
  }
  
  /// Delete account
  Future<void> deleteAccount() async {
    try {
      await currentUser?.delete();
      debugPrint('🗑️ Account deleted');
    } catch (e) {
      debugPrint('❌ Account deletion failed: $e');
      rethrow;
    }
  }
}
