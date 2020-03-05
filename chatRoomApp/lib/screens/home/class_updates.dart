import 'package:flash_chat/components/drawer.dart';
import 'package:flash_chat/models/user.dart';
import 'package:flash_chat/screens/home/image_upload_screen.dart';
import 'package:flash_chat/services/UserDbService.dart';
import 'package:flash_chat/services/authService.dart';
import 'package:flutter/material.dart';
import 'package:flash_chat/constants.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flash_chat/components/message_bubble.dart';

final _firestore = Firestore.instance;

User loggedInUser;
UserData userData;
UserDbService _userDbService;
String courseCode;

class ClassUpdates extends StatefulWidget {
  @override
  _ClassUpdatesState createState() => _ClassUpdatesState();
}

class _ClassUpdatesState extends State<ClassUpdates> {
  final _authService = AuthService();

  String messageText;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrentUserData();
  }

  void getCurrentUserData() async {
    try {
      final user = await _authService.currentUser();
      if (user != null) {
        loggedInUser = user;
        _userDbService = UserDbService(uid: loggedInUser.uid);
        userData = await _userDbService.getUserDataFromUid();
        setState(() {
          courseCode = userData.courseCode;
        });

        print('----------------------------------$courseCode');
        print(loggedInUser.email);
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: DrawerWidget(),
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
        title: Text('$courseCode Updates 🙋‍♀'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            MessageStream(),
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
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: _firestore
            .collection('updates-$courseCode')
            .orderBy('sentOn', descending: false)
            .snapshots(),
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

            final messageBubble = MessageBubble(
              sender: messageSender,
              text: messageText,
              isMe: false,
              isImage: false,
              dateTime: sentOn,
            );

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
