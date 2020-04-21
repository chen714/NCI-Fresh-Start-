import 'package:flash_chat/constants/colorAndDesignConstants.dart';
import 'package:flash_chat/components/RoundedButton.dart';
import 'package:flash_chat/components/drawer.dart';
import 'package:flash_chat/models/message.dart';
import 'package:flash_chat/models/user.dart';
import 'package:flash_chat/screens/home/image_upload_screen.dart';
import 'package:flash_chat/services/UserDbService.dart';
import 'package:flash_chat/services/authService.dart';
import 'package:flash_chat/services/CommunicationService.dart';
import 'package:flash_chat/shared/loading.dart';
import 'package:flutter/material.dart';
import 'package:flash_chat/constants/constants.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flash_chat/components/message_bubble.dart';
import 'package:provider/provider.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

final _firestore = Firestore.instance;
final key = encrypt.Key.fromLength(32);
final iv = encrypt.IV.fromLength(16);
final encrypter = encrypt.Encrypter(encrypt.AES(key));

UserData userData;

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  final messageTextController = TextEditingController();
  final _authService = AuthService();

  String messageText;

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    UserDbService userDbService = UserDbService(uid: user.uid);
    return FutureBuilder<dynamic>(
        future: userDbService.getUserDataFromUid(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (!snapshot.hasData) {
            return Loading();
          } else {
            userData = snapshot.data;
            CommunicationService commsService =
                CommunicationService(userData: userData);

            return Scaffold(
              drawer: DrawerWidget(userData: userData),
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
                title: Text('${userData.courseCode} Chat 🚀'),
                backgroundColor: kPrimaryColourDark,
              ),
              body: SafeArea(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    MessageStream(
                      userData: userData,
                    ),
                    Container(
                      padding: EdgeInsets.only(top: 10, bottom: 10, left: 8),
                      decoration: kMessageContainerDecoration,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Expanded(
                            child: TextField(
                              minLines: 1,
                              maxLines: 8,
                              controller: messageTextController,
                              onChanged: (value) {
                                //Do something with the user input.
                                messageText = value;
                              },
                              decoration: kTextFieldDecoration,
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              messageTextController.clear();
                              Message message = Message(
                                  sender: userData.email,
                                  text: encrypter
                                      .encrypt(messageText, iv: iv)
                                      .base64,
                                  senderDisplayName: userData.name,
                                  isMe: true,
                                  dateTime: DateTime.now(),
                                  isImage: false);
                              commsService.sendMessage(message);
                            },
                            icon: Icon(Icons.send),
                          ),
                          IconButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) {
                                  return ImageUploadScreen();
                                }),
                              );
                            },
                            icon: Icon(Icons.camera_enhance),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
        });
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
        stream: commsService.chatMessages,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(
                backgroundColor: kPrimaryColourDark,
              ),
            );
          }
          final messages = snapshot.data.documents.reversed;
          List<MessageBubble> messageWidgets = [];
          for (var message in messages) {
            final messageText = message.data['text'];
            final messageSender = message.data['sender'];
            final senderDisplayName = message.data['senderDisplayName'];
            final messageImage = message.data['isImage'];
            final userLoggedIn = userData.email;
            final dateTime = message.data['sentOn'].toDate();

            final Message msg = Message(
              sender: messageSender,
              text: encrypter.decrypt64(messageText, iv: iv),
              senderDisplayName: senderDisplayName,
              isMe: messageSender == userLoggedIn,
              isImage: messageImage,
              dateTime: dateTime,
            );

            final MessageBubble messageBubble = MessageBubble(msg: msg);

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
