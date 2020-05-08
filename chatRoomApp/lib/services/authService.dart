import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash_chat/models/user.dart';
import 'package:flash_chat/shared/flutterToast.dart';
import 'package:flutter/material.dart';
import 'dart:async';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  FlutterToast toast = FlutterToast();

  //create user object based on firebase user
  User _userFromFirebaseUser(FirebaseUser user) {
    return user != null ? User(uid: user.uid, email: user.email) : null;
  }

  //getCurrentLoggedInUser
  Future<User> currentUser() async {
    return _userFromFirebaseUser(await _auth.currentUser());
  }

  //auth change user stream
  Stream<User> get user {
    return _auth.onAuthStateChanged.map(_userFromFirebaseUser);
  }

  Future<void> resetPassword(String email) {
    return _auth.sendPasswordResetEmail(email: email);
  }

  //register with email and password
  Future registerWithEmailAndPassword(String email, String password) async {
    try {
      AuthResult result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      FirebaseUser fUser = result.user;
      //create new document for user with the uid
      try {
        await fUser.sendEmailVerification();
        signOut();
        toast.showToast(
            message: "Registration successful",
            toastColor: Colors.green,
            textColor: Colors.black);
        return _userFromFirebaseUser(fUser);
      } catch (e) {
        toast.showToast(
            message:
                "An error has occured while sending the verification email. Please try again later.",
            toastColor: Colors.red,
            textColor: Colors.white);

        return null;
      }
    } catch (e) {
      if (e.code == 'ERROR_EMAIL_ALREADY_IN_USE') {
        toast.showToast(
            message:
                "Email in use, Please use the recover email button in the login section to recover your password.",
            toastColor: Colors.red,
            textColor: Colors.white);
      } else if (e.code == 'ERROR_NETWORK_REQUEST_FAILED') {
        toast.showToast(
            message:
                "Network request failed, please check your internet connection",
            toastColor: Colors.red,
            textColor: Colors.white);
      } else {
        toast.showToast(
            message: "An error has occured please check input fields.",
            toastColor: Colors.red,
            textColor: Colors.white);
      }
    }
  }

  //signin with email and password
  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      AuthResult result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      FirebaseUser fUser = result.user;

      //email verification check turned off
//      if (fUser.isEmailVerified) {
//        return _userFromFirebaseUser(fUser);
//      } else {
//        fUser.sendEmailVerification();
//        signOut();
//        toast.showToast(
//            message: "Please ensure email is verified and try again.",
//            toastColor: Colors.red,
//            textColor: Colors.white);
//      }
      return _userFromFirebaseUser(fUser);
    } catch (e) {
      if (e.code == 'ERROR_WRONG_PASSWORD' ||
          e.code == 'ERROR_USER_NOT_FOUND') {
        toast.showToast(
            message:
                "Incorrect username or passowed please check login credentials and try again.",
            toastColor: Colors.red,
            textColor: Colors.white);
      } else if (e.code == 'ERROR_NETWORK_REQUEST_FAILED') {
        toast.showToast(
            message:
                "Network request failed, please check your internet connection",
            toastColor: Colors.red,
            textColor: Colors.white);
      } else {
        toast.showToast(
            message: "An error has occured pleased try again later",
            toastColor: Colors.red,
            textColor: Colors.white);
      }

      return null;
    }
  }

  //logout
  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      toast.showToast(
          message:
              "An error occurred while logging you out. Please check internet connection and try again later. ",
          toastColor: Colors.red,
          textColor: Colors.white);
      return null;
    }
  }
}
