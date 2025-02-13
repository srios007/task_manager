import 'dart:developer';

import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityService {
  factory ConnectivityService() {
    return _instance;
  }

  ConnectivityService._internal();
  static final _instance = ConnectivityService._internal();

  Future<bool> checkStatus() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    log('Connectivity result: $connectivityResult');
    if (connectivityResult.contains(ConnectivityResult.none)) {
      log('No internet connection');
      return false;
    } else {
      log('Internet connection available');
      return true;
    }
  }
}

final connectivityService = ConnectivityService._internal();
