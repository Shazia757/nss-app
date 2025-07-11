
  import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';
import 'package:nss/database/local_storage.dart';
import 'package:nss/view/authentication/token_expired_screen.dart';
import 'package:nss/view/common_pages/no_connection_page.dart';
import 'package:nss/view/common_pages/splash_screen.dart';

bool checkValidations(String response) {
    if (response.contains('Invalid token')) {
      Get.offAll(() => TokenExpiredScreen());
      return false;
    } else if (response.contains('updation required') ||
        response.contains('Unsupported OS or app version.')) {
      Get.offAll(() => AppUpdateScreen(status: false));

      return false;
    }
    return true;
  }


checkConnectivity() async {
  final connectivityResult = await Connectivity().checkConnectivity();
  if (connectivityResult.contains(ConnectivityResult.none)) {
    Get.to(() => NoInternetScreen());
  }
}

Future<Map<String, String>?> getHeader() async {
  return {
    "Content-type": "application/json",
    "OS": Platform.operatingSystem,
    "App-version": "0.0.1",
    "Authorization": await LocalStorage().readToken() ?? ''
  };
}
