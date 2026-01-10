import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';

abstract class NetworkInfo {
  Future<bool> get isConnected;
}

class NetworkInfoImpl implements NetworkInfo {
  final Connectivity connectionChecker;

  NetworkInfoImpl({required this.connectionChecker});

  @override
  Future<bool> get isConnected async {
    // 1. Check if connected to Wifi or Mobile
    final result = await connectionChecker.checkConnectivity();
    if (result.contains(ConnectivityResult.none)) {
      return false;
    }

    // 2. Check for ACTUAL internet access by looking up a common address
    try {
      final list = await InternetAddress.lookup('google.com');
      return list.isNotEmpty && list[0].rawAddress.isNotEmpty;
    } on SocketException catch (_) {
      return false;
    }
  }
}