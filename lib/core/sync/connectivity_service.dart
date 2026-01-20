import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';

/// Service to monitor network connectivity state
class ConnectivityService {
  final Connectivity _connectivity = Connectivity();
  
  final _connectivityController = StreamController<bool>.broadcast();
  StreamSubscription<List<ConnectivityResult>>? _subscription;
  
  bool _isOnline = false;
  
  /// Whether the device is currently online
  bool get isOnline => _isOnline;
  
  /// Stream of connectivity changes (true = online, false = offline)
  Stream<bool> get onConnectivityChanged => _connectivityController.stream;
  
  /// Initialize the connectivity service
  Future<void> initialize() async {
    final results = await _connectivity.checkConnectivity();
    _isOnline = _hasInternetConnection(results);
    debugPrint('🌐 Initial connectivity: ${_isOnline ? "Online" : "Offline"}');
    
    _subscription = _connectivity.onConnectivityChanged.listen((results) {
      final wasOnline = _isOnline;
      _isOnline = _hasInternetConnection(results);
      
      if (wasOnline != _isOnline) {
        debugPrint('🌐 Connectivity changed: ${_isOnline ? "Online" : "Offline"}');
        _connectivityController.add(_isOnline);
      }
    });
  }
  
  bool _hasInternetConnection(List<ConnectivityResult> results) {
    return results.any((result) =>
      result == ConnectivityResult.wifi ||
      result == ConnectivityResult.mobile ||
      result == ConnectivityResult.ethernet
    );
  }
  
  void dispose() {
    _subscription?.cancel();
    _connectivityController.close();
  }
}
