import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'dart:core';

class LocalAuthService {
  final LocalAuthentication _localAuthentication = LocalAuthentication();

  Future<bool> _checkBiometric() async {
    bool checkBiometric = false;
    try {
      checkBiometric = await _localAuthentication.canCheckBiometrics;
    } on PlatformException catch (e) {
      print(e);
      return false;
    }
    return checkBiometric;
  }

  Future<bool> _checkFingerPrint() async {
    if (await _checkBiometric()) {
      List<BiometricType> listofBiometric;
      try {
        listofBiometric = await _localAuthentication.getAvailableBiometrics();
      } on PlatformException catch (e) {
        print(e);
        return false;
      }
      if (listofBiometric.contains(BiometricType.fingerprint)) {
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  }

  Future<bool> authorizeNow() async {
    bool isAuthorized = false;
    if (await _checkFingerPrint()) {
      try {
        isAuthorized = await _localAuthentication.authenticateWithBiometrics(
          localizedReason: "Please authenticate to login",
          useErrorDialogs: true,
          stickyAuth: true,
        );
      } on PlatformException catch (e) {
        return false;
      }
      return isAuthorized;
    } else {
      return false;
    }
  }
}
