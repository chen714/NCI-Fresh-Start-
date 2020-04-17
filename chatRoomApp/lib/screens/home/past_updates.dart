import 'package:flash_chat/components/drawer.dart';
import 'package:flash_chat/models/user.dart';
import 'package:flash_chat/screens/home/nci_bot.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:flash_chat/services/authService.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flash_chat/components/message_bubble.dart';
import 'package:flash_chat/models/message.dart';

final _firestore = Firestore.instance;

class PastUpdates extends StatefulWidget {
  @override
  _PastUpdatesState createState() => _PastUpdatesState();
}

class _PastUpdatesState extends State<PastUpdates> {
  final _authService = AuthService();

  String messageText;

  @override
  Widget build(BuildContext context) {
    final User user = Provider.of<User>(context);
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
        //TODO: EMAIL DISPLAY NAME
        title: Text('${user.email}\'s Past Updates 🙋‍♀'),
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
            .collection('past updates-${user.email}')
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
            final messageSender = message.data['courseCode'];
            final sentOn = message.data['sentOn'].toDate();

            final msg = Message(
              sender: messageSender,
              text: messageText,
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
