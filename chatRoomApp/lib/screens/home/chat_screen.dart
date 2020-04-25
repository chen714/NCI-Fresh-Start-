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
import 'package:flutter/services.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:overlay_support/overlay_support.dart';

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
                                  return ImageUploadScreen(
                                    userData: userData,
                                  );
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
          List<GestureDetector> messageWidgets = [];
          for (var message in messages) {
            final messageText =
                encrypter.decrypt64(message.data['text'], iv: iv);
            final messageSender = message.data['sender'];
            final senderDisplayName = message.data['senderDisplayName'];
            final messageImage = message.data['isImage'];
            final userLoggedIn = userData.email;
            final dateTime = message.data['sentOn'].toDate();

            final Message msg = Message(
              sender: messageSender,
              text: messageText,
              senderDisplayName: senderDisplayName,
              isMe: messageSender == userLoggedIn,
              isImage: messageImage,
              dateTime: dateTime,
            );

            final MessageBubble messageBubble = MessageBubble(msg: msg);
            final GestureDetector messageGestureDetector = GestureDetector(
              child: messageBubble,
              onLongPress: () {
                showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    builder: (BuildContext context) => SingleChildScrollView(
                          child: Container(
                            padding: EdgeInsets.only(
                                bottom:
                                    MediaQuery.of(context).viewInsets.bottom),
                            child: Container(
                              color: Color(0xFF737373),
                              child: Container(
                                padding: EdgeInsets.all(20.0),
                                decoration: BoxDecoration(
                                  color:
                                      ThemeData.dark().scaffoldBackgroundColor,
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(20),
                                    topRight: Radius.circular(20),
                                  ),
                                ),
                                child: SizedBox(
                                  width: 300,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: <Widget>[
                                      Visibility(
                                        visible: !msg.isImage,
                                        child: SizedBox(
                                          width: 120,
                                          child: RoundedButton(
                                              title: 'Copy Text 📋',
                                              colour: kPrimaryColourLight,
                                              onPressed: () {
                                                Clipboard.setData(
                                                        new ClipboardData(
                                                            text: messageText))
                                                    .whenComplete(() {
                                                  showSimpleNotification(
                                                    Text(
                                                        "Message copied to clipboard."),
                                                    background: Colors.green,
                                                  );
                                                }).catchError((e) {
                                                  showSimpleNotification(
                                                    Text(
                                                        "Opps.. Something went wrong please try again."),
                                                    background: Colors.red,
                                                  );
                                                });
                                              }),
                                        ),
                                      ),
                                      Visibility(
                                        visible: messageSender == userLoggedIn,
                                        child: SizedBox(
                                          width: 120,
                                          child: RoundedButton(
                                              title: 'Delete ✖',
                                              colour: kSecondaryColorLight,
                                              onPressed: () {
                                                _showConfirmationDialog(
                                                    messageImage,
                                                    dateTime,
                                                    commsService,
                                                    context,
                                                    messageText);
                                              }),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ));
              },
            );

            messageWidgets.add(messageGestureDetector);
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

  _showConfirmationDialog(
      bool isImage,
      DateTime sentOn,
      CommunicationService commsService,
      BuildContext context,
      String originalMessage) {
    Alert(
      context: context,
      type: AlertType.warning,
      title: "Your about to delete your ${isImage ? 'image' : 'message'}: ",
      desc: isImage
          ? 'Your image will be permently deleted and cannot be recovered. Are you sure you want to remove the image from the chat?'
          : originalMessage,
      buttons: [
        DialogButton(
          child: Text(
            "Delete",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () {
            commsService
                .deleteMessage(
                    sentOn,
                    encrypter
                        .encrypt(
                            '${isImage ? 'Image' : 'Message'} deleted by sender.',
                            iv: iv)
                        .base64)
                .whenComplete(() {
              showSimpleNotification(
                Text("Message deleted!"),
                background: Colors.green,
              );
            }).catchError((e) {
              print(e);
              showSimpleNotification(
                Text(
                    "An error occured while deleteing your message, Please try again later. "),
                background: Colors.red,
              );
            });

            Navigator.pop(context);
          },
          color: Colors.red[300],
        ),
        DialogButton(
          child: Text(
            "Cancel",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () => Navigator.pop(context),
          gradient: LinearGradient(colors: [
            Color.fromRGBO(116, 116, 191, 1.0),
            Color.fromRGBO(52, 138, 199, 1.0)
          ]),
        ),
      ],
    ).show();
  }
}
