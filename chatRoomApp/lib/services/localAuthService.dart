import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:local_auth/local_auth.dart';
import 'package:flash_chat/shared/flutterToast.dart';
import 'dart:core';
import 'dart:async';

class LocalAuthService {
  final LocalAuthentication _localAuthentication = LocalAuthentication();

  Future<bool> _checkBiometric() async {
    bool checkBiometric = false;
    List<BiometricType> listofBiometric;
    try {
      if (await _localAuthentication.canCheckBiometrics) {
        listofBiometric = await _localAuthentication.getAvailableBiometrics();
        if (listofBiometric.contains(BiometricType.fingerprint) ||
            listofBiometric.contains(BiometricType.face)) {
          checkBiometric = true;
        }
      }
    } on PlatformException catch (e) {
      displayErrorToast();
      return false;
    }
    return checkBiometric;
  }

  Future<bool> _authenticate() async {
    bool isAuthorized = false;
    isAuthorized = await _localAuthentication.authenticateWithBiometrics(
      localizedReason: "Please authenticate to open the application",
      useErrorDialogs: true,
      stickyAuth: false,
    );
    return isAuthorized;
  }

  Future<bool> authorizeNow() async {
    bool isAuth = false;
    if (await _checkBiometric()) {
      try {
        isAuth = await _authenticate();
      } on PlatformException catch (e) {
        displayErrorToast();
        return false;
      }
      return isAuth;
    }
    displayErrorToast();
    return false;
  }

  void displayErrorToast() {
    FlutterToast().showToast(
      message:
          'An error occured, please ensure device support biometrics scanner to continue.',
      toastColor: Colors.red,
      textColor: Colors.white,
    );
  }
}
