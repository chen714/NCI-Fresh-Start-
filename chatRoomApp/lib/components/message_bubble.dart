import 'package:flutter/material.dart';
import 'package:circular_profile_avatar/circular_profile_avatar.dart';

class MessageBubble extends StatelessWidget {
  MessageBubble({this.sender, this.text, this.isMe});

  final String sender;
  final String text;
  final bool isMe;

  @override
  Widget build(BuildContext context) {
    return isMe
        ? Padding(
            padding: EdgeInsets.all(10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Column(
                  crossAxisAlignment:
                      isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      sender,
                      style: TextStyle(
                        fontSize: 12.0,
                        color: Colors.black38,
                      ),
                    ),
                    Material(
                      borderRadius: isMe
                          ? BorderRadius.only(
                              topLeft: Radius.circular(30.0),
                              bottomLeft: Radius.circular(30.0),
                              bottomRight: Radius.circular(30.0),
                            )
                          : BorderRadius.only(
                              topRight: Radius.circular(30.0),
                              bottomLeft: Radius.circular(30.0),
                              bottomRight: Radius.circular(30.0),
                            ),
                      elevation: 10.0,
                      color: isMe ? Colors.lightBlueAccent : Colors.pinkAccent,
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 20.0),
                        child: SizedBox(
                          width: text.length > 30 ?? false ? 200 : null,
                          child: Text(
                            '$text',
                            softWrap: true,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: sender == 'NCI Bot'
                      ? CircleAvatar(
                          maxRadius: 25,
                          backgroundImage: NetworkImage(
                              "https://clipground.com/images/bot-clipart-8.jpg"))
                      : CircularProfileAvatar(
                          '',
                          radius: 25,
                          backgroundColor:
                              isMe ? Colors.indigo : Colors.blueGrey,
                          initialsText: Text(
                            sender[0],
                            style: TextStyle(fontSize: 40, color: Colors.white),
                          ),
                        ),
                ),
              ],
            ),
          )
        : Padding(
            padding: EdgeInsets.all(10.0),
            child: Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: sender == 'NCI Bot'
                      ? CircleAvatar(
                          maxRadius: 25,
                          backgroundImage: NetworkImage(
                              "https://clipground.com/images/bot-clipart-8.jpg"))
                      : CircularProfileAvatar(
                          '',
                          radius: 25,
                          backgroundColor:
                              isMe ? Colors.indigo : Colors.blueGrey,
                          initialsText: Text(
                            sender[0],
                            style: TextStyle(fontSize: 40, color: Colors.white),
                          ),
                        ),
                ),
                Column(
                  crossAxisAlignment:
                      isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      sender,
                      style: TextStyle(
                        fontSize: 12.0,
                        color: Colors.black38,
                      ),
                    ),
                    Material(
                      borderRadius: isMe
                          ? BorderRadius.only(
                              topLeft: Radius.circular(30.0),
                              bottomLeft: Radius.circular(30.0),
                              bottomRight: Radius.circular(30.0),
                            )
                          : BorderRadius.only(
                              topRight: Radius.circular(30.0),
                              bottomLeft: Radius.circular(30.0),
                              bottomRight: Radius.circular(30.0),
                            ),
                      elevation: 10.0,
                      color: isMe ? Colors.lightBlueAccent : Colors.pinkAccent,
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 20.0),
                        child: SizedBox(
                          width: text.length > 30 ? 200 : null,
                          child: Text(
                            '$text',
                            softWrap: true,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
  }
}
