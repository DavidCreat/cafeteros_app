import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';

class ConnectivityService {
  static final ConnectivityService _instance = ConnectivityService._internal();
  
  factory ConnectivityService() {
    return _instance;
  }
  
  ConnectivityService._internal();
  
  // Stream controller for connectivity status
  final _connectivityController = StreamController<bool>.broadcast();
  
  // Stream getter
  Stream<bool> get connectivityStream => _connectivityController.stream;
  
  // Current connectivity status
  bool _isConnected = false;
  bool get isConnected => _isConnected;
  
  // Initialize the service
  void initialize() {
    // Check connectivity immediately
    checkConnectivity();
    
    // Set up periodic connectivity check
    Timer.periodic(const Duration(seconds: 10), (_) {
      checkConnectivity();
    });
  }
  
  // Check internet connectivity
  Future<void> checkConnectivity() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        _updateConnectivityStatus(true);
      } else {
        _updateConnectivityStatus(false);
      }
    } on SocketException catch (_) {
      _updateConnectivityStatus(false);
    }
  }
  
  // Update connectivity status
  void _updateConnectivityStatus(bool isConnected) {
    if (_isConnected != isConnected) {
      _isConnected = isConnected;
      _connectivityController.add(isConnected);
    }
  }
  
  // Dispose resources
  void dispose() {
    _connectivityController.close();
  }
}

// Widget to display connectivity status
class ConnectivityStatusWidget extends StatelessWidget {
  final Widget connectedWidget;
  final Widget disconnectedWidget;
  
  const ConnectivityStatusWidget({
    super.key,
    required this.connectedWidget,
    required this.disconnectedWidget,
  });
  
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool>(
      stream: ConnectivityService().connectivityStream,
      initialData: ConnectivityService().isConnected,
      builder: (context, snapshot) {
        final isConnected = snapshot.data ?? false;
        return isConnected ? connectedWidget : disconnectedWidget;
      },
    );
  }
}
