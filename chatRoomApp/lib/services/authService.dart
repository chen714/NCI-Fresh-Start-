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
    return _auth.onAuthStateChanged
        //.map((FirebaseUser user) => _userFromFirebaseUser(user)); -- the same as the below line
        .map(_userFromFirebaseUser);
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

        print(e.message);
        return null;
      }
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  //signin with email and password
  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      AuthResult result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      FirebaseUser fUser = result.user;

      //email verification check turned off
      if (fUser.isEmailVerified) {
        return _userFromFirebaseUser(fUser);
      } else {
        fUser.sendEmailVerification();
        signOut();
        toast.showToast(
            message: "Please ensure email is verified and try again.",
            toastColor: Colors.red,
            textColor: Colors.white);
      }
      return _userFromFirebaseUser(fUser);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  //logout
  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
