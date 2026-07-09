import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';

/// Listens to network connectivity changes.
/// Triggers a callback when connectivity is restored.
class ConnectivityService {
  final Connectivity _connectivity = Connectivity();
  StreamSubscription<List<ConnectivityResult>>? _subscription;
  bool _isOnline = false;

  bool get isOnline => _isOnline;

  /// Start listening. Calls [onOnline] when the device comes back online.
  void listen({required VoidCallback onOnline}) {
    _subscription = _connectivity.onConnectivityChanged.listen((results) {
      final wasOffline = !_isOnline;
      _isOnline = results.any((r) => r != ConnectivityResult.none);

      if (_isOnline && wasOffline) {
        onOnline();
      }
    });

    // Check initial state and process any queue that was created while online.
    _connectivity.checkConnectivity().then((results) {
      final wasOffline = !_isOnline;
      _isOnline = results.any((r) => r != ConnectivityResult.none);

      if (_isOnline && wasOffline) {
        onOnline();
      }
    });
  }

  void dispose() {
    _subscription?.cancel();
  }
}

typedef VoidCallback = void Function();
