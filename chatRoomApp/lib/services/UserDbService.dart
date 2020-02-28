import 'package:flash_chat/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class UserDbService {
  final String uid;
  UserDbService({@required this.uid});

  final CollectionReference _userCollection =
      Firestore.instance.collection('users');

  Future<void> updateUserData(
      {String email, String name, bool isFaculty, String courseCode}) async {
    return await _userCollection.document(uid).setData({
      'email': email,
      'name': name,
      'isFaculty': isFaculty,
      'courseCode': courseCode,
    }).catchError((onError) {
      print(onError);
    });
  }

  //create user from document snapshot
  UserData _userFromDocument(DocumentSnapshot snapshot) {
    Map userData = snapshot.data;
    return UserData(
        uid: uid,
        email: userData['email'],
        name: userData['name'],
        courseCode: userData['courseCode'],
        isFaculty: userData['isFaculty']);
  }

  Future<dynamic> getUserDataFromUid() async {
    DocumentSnapshot doc = await _userCollection.document(uid).get();
    print(
        '____________!!!!!!!!!!!!!!!!!!!user data: ${doc.data.toString()}!!!!!!!!!!!!!!!!!!!!!!_________');
    return doc.data != null ? _userFromDocument(doc) : null;
  }

  Future<bool> doesUserExist() async {
    print('*********************************uid is: $uid');
    DocumentSnapshot doc = await _userCollection.document(uid).get();
    print('********************************* ${doc.data}');
    print('********************************* doc.exists: ${doc.exists}');
    if (doc.exists) {
      return true;
    } else {
      return false;
    }
  }
}
