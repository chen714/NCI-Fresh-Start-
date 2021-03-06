import 'dart:async';
import 'package:flash_chat/models/message.dart';
import 'package:flash_chat/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flash_chat/shared/flutterToast.dart';
import 'package:flutter/material.dart';

class CommunicationService {
  final UserData userData;
  CommunicationService({this.userData});
  final _firestore = Firestore.instance;
  FlutterToast toast;

  Future<void> deleteMessage(DateTime sentOn, String deleteMessage) async {
    return await _firestore
        .collection('messages-${userData.courseCode}')
        .document('${userData.uid}-${sentOn.toString().substring(0, 20)}')
        .updateData(
      {'text': deleteMessage, 'isImage': false},
    ).catchError((e) {});
  }

  Future<void> sendMessage(Message message) async {
    return await _firestore
        .collection('messages-${userData.courseCode}')
        .document(
            '${userData.uid}-${message.dateTime.toString().substring(0, 20)}')
        .setData({
      'sentOn': message.dateTime,
      'text': message.text,
      'sender': message.sender,
      'senderDisplayName': message.senderDisplayName,
      'isImage': message.isImage,
    }).catchError((onError) {
      toast.showToast(
          message:
              'Something went wrong while sending your message. Try again later.',
          toastColor: Colors.red,
          textColor: Colors.black);
    });
  }

  Stream<QuerySnapshot> get chatMessages {
    return _firestore
        .collection('messages-${userData.courseCode}')
        .orderBy('sentOn', descending: false)
        .snapshots()
        .handleError((e) {
      toast.showToast(
          message:
              'Something went wrong while getting your messages. Try again later.',
          toastColor: Colors.red,
          textColor: Colors.black);
    });
  }

  Stream<QuerySnapshot> get classUpdates {
    return _firestore
        .collection('updates-${userData.courseCode}')
        .orderBy('sentOn', descending: false)
        .snapshots()
        .handleError((e) {
      toast.showToast(
          message:
              'Something went wrong while getting your updates. Try again later.',
          toastColor: Colors.red,
          textColor: Colors.black);
    });
  }

  Future<void> sendUpdateToCohort(Message message, String courseCode) async {
    _firestore.collection('updates-$courseCode').add({
      'sentOn': message.dateTime,
      'senderDisplayName': message.senderDisplayName,
      'text': message.text,
      'sender': message.sender,
    }).catchError((onError) {
      toast.showToast(
          message:
              'Something went wrong while sending your class update. Try again later.',
          toastColor: Colors.red,
          textColor: Colors.black);
      return;
    }).whenComplete(() {
      _firestore.collection('notificationUpdates').add({
        'sender': message.sender,
        'courseCode': courseCode,
        'message': message.text,
        'senderName': message.senderDisplayName
      });
    }).catchError((onError) {
      toast.showToast(
          message:
              'Something went wrong while sending your class update. Try again later.',
          toastColor: Colors.red,
          textColor: Colors.black);
      return;
    });
    _firestore.collection('past updates-${userData.email}').add({
      'sentOn': message.dateTime,
      'senderDisplayName': message.senderDisplayName,
      'text': message.text,
      'sender': message.sender,
    }).catchError((onError) {
      toast.showToast(
          message:
              'Something went wrong while sending your class update. Try again later.',
          toastColor: Colors.red,
          textColor: Colors.black);
    });
  }

  Stream<QuerySnapshot> get pastUpdates {
    return _firestore
        .collection('past updates-${userData.email}')
        .orderBy('sentOn', descending: false)
        .snapshots()
        .handleError((e) {
      toast.showToast(
          message:
              'Something went wrong while getting your past updates. Try again later.',
          toastColor: Colors.red,
          textColor: Colors.black);
    });
  }
}
