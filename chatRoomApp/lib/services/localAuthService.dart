import 'package:flutter/cupertino.dart';
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
      print('!!!!!!!!!!!!!!!!!!!!!! platform error: $e');
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
        print('!!!!!!!!!!!!!!!!!!!!!! Finger print not set up');
        return false;
      }
    } else {
      print('!!!!!!!!!!!!!!!!!!!!!! Check biometric returned false ');
      return false;
    }
  }

  Future<bool> _authenticate() async {
    bool isAuthorized = false;
    isAuthorized = await _localAuthentication.authenticateWithBiometrics(
      localizedReason: "Please authenticate to login",
      useErrorDialogs: true,
      stickyAuth: false,
    );
    return isAuthorized;
  }

  Future<bool> authorizeNow() async {
    bool isAuth = false;
    if (await _checkFingerPrint()) {
      try {
        isAuth = await _authenticate();
      } on PlatformException catch (e) {
        print(
            '^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ platform error: $e');
        return false;
      }
      return isAuth;
    } else {
      print('!!!!!!!!!!!!!!!!!!!!!! Check fingerprint  returned false ');
      return false;
    }
  }
}
