import 'package:flash_chat/constants/colorAndDesignConstants.dart';
import 'package:flash_chat/components/drawer.dart';
import 'package:flash_chat/models/user.dart';
import 'package:flash_chat/services/CommunicationService.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:flash_chat/services/authService.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flash_chat/components/message_bubble.dart';
import 'package:flash_chat/models/message.dart';

class PastUpdates extends StatefulWidget {
  final UserData userData;
  PastUpdates({@required this.userData});

  @override
  _PastUpdatesState createState() => _PastUpdatesState();
}

class _PastUpdatesState extends State<PastUpdates> {
  final _authService = AuthService();

  String messageText;

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
        title: Text('${widget.userData.name}\'s \nPast Updates 🙋‍♀'),
        backgroundColor: kPrimaryColourDark,
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
    CommunicationService _commsService =
        CommunicationService(userData: userData);
    return StreamBuilder<QuerySnapshot>(
        stream: _commsService.pastUpdates,
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
            final messageSenderDisplayName = message.data['senderDisplayName'];
            final sentOn = message.data['sentOn'].toDate();

            final msg = Message(
              sender: messageSender,
              text: messageText,
              senderDisplayName: messageSenderDisplayName,
              isMe: true,
              isImage: false,
              dateTime: sentOn,
            );
            final messageBubble = MessageBubble(msg: msg);

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
