import 'package:flash_chat/components/drawer.dart';
import 'package:flash_chat/models/message.dart';
import 'package:flash_chat/models/user.dart';
import 'package:flash_chat/screens/home/chat_screen.dart';

import 'package:flash_chat/services/authService.dart';
import 'package:flash_chat/services/CommunicationService.dart';
import 'package:flutter/material.dart';
import 'package:flash_chat/constants.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flash_chat/components/message_bubble.dart';

CommunicationService chatService;

class ClassUpdates extends StatefulWidget {
  ClassUpdates({this.userData});
  UserData userData;
  @override
  _ClassUpdatesState createState() => _ClassUpdatesState();
}

class _ClassUpdatesState extends State<ClassUpdates> {
  final _authService = AuthService();

  String messageText;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: DrawerWidget(
        userData: userData,
      ),
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                //Implement logout functionality
                _authService.signOut();
                Navigator.popUntil(context, ModalRoute.withName('/'));
              }),
        ],
        title: Text('${widget.userData.courseCode} Updates 🙋‍♀'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            MessageStream(
              userData: widget.userData,
            ),
            SizedBox(
              height: 100.0,
            ),
          ],
        ),
      ),
    );
  }
}

class MessageStream extends StatelessWidget {
  final UserData userData;
  MessageStream({this.userData});
  @override
  Widget build(BuildContext context) {
    CommunicationService commsService =
        CommunicationService(userData: userData);
    return StreamBuilder<QuerySnapshot>(
        stream: commsService.classUpdates,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.lightBlueAccent,
              ),
            );
          }
          final messages = snapshot.data.documents.reversed;
          List<MessageBubble> messageWidgets = [];
          for (var message in messages) {
            final messageText = message.data['text'];
            final messageSender = message.data['sender'];
            final sentOn = message.data['sentOn'].toDate();

            final msg = Message(
              sender: messageSender,
              text: messageText,
              isMe: false,
              isImage: false,
              dateTime: sentOn,
            );
            MessageBubble messageBubble = MessageBubble(msg: msg);

            messageWidgets.add(messageBubble);
          }
          return Expanded(
            child: ListView(
              reverse: true,
              padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
              children: messageWidgets,
            ),
          );
        });
  }
}
