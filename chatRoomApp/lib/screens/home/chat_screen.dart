import 'package:flash_chat/components/drawer.dart';
import 'package:flash_chat/models/user.dart';
import 'package:flash_chat/screens/home/image_upload_screen.dart';
import 'package:flash_chat/services/UserDbService.dart';
import 'package:flash_chat/services/authService.dart';
import 'package:flutter/material.dart';
import 'package:flash_chat/constants.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flash_chat/components/message_bubble.dart';

final _firestore = Firestore.instance;
final key = encrypt.Key.fromLength(32);
final iv = encrypt.IV.fromLength(16);
final encrypter = encrypt.Encrypter(encrypt.AES(key));

User loggedInUser;
UserData userData;
UserDbService _userDbService;
String courseCode;

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final messageTextController = TextEditingController();
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
        title: Text('$courseCode Chat 🚀'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            MessageStream(),
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: messageTextController,
                      onChanged: (value) {
                        //Do something with the user input.
                        messageText = value;
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  FlatButton(
                    onPressed: () {
                      messageTextController.clear();

                      _firestore.collection('messages-$courseCode').add({
                        'sentOn': DateTime.now(),
                        'text': encrypter.encrypt(messageText, iv: iv).base64,
                        'sender': loggedInUser.email,
                        'isImage': false,
                      });
                    },
                    child: Text(
                      'Send',
                      style: kSendButtonTextStyle,
                    ),
                  ),
                  FlatButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) {
                          return ImageUploadScreen();
                        }),
                      );
                    },
                    child: Text(
                      '📸',
                      style: kSendButtonTextStyle,
                    ),
                  )
                ],
              ),
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
            .collection('messages-$courseCode')
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
            final messageImage = message.data['isImage'];
            final userLoggedIn = loggedInUser.email;
            print(
                '&&isImage: $messageImage messageText: ${encrypter.decrypt64(messageText, iv: iv)}');
            if (messageSender == userLoggedIn) {}

            final messageBubble = MessageBubble(
              sender: messageSender,
              text: encrypter.decrypt64(messageText, iv: iv),
              isMe: messageSender == userLoggedIn,
              isImage: messageImage,
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
