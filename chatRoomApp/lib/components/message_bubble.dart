import 'package:flash_chat/shared/loading.dart';
import 'package:flutter/material.dart';
import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:flash_chat/models/message.dart';
import 'package:cached_network_image/cached_network_image.dart';

class MessageBubble extends StatelessWidget {
  MessageBubble({@required this.msg});
  final Message msg;
  @override
  Widget build(BuildContext context) {
    return msg.isMe
        ? messageSenderIsUserLoggedIn()
        : messageSenderNotUserLoggedIn();
  }

//  double textLength() {
//    if (isImage) {
//      return null;
//    } else {
//      return ;
//    }
//  }

  Widget messageSenderNotUserLoggedIn() {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: Row(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: msg.sender == 'virtualassistant@ncirl.ie'
                ? Material(
                    borderRadius: BorderRadius.all(Radius.circular(25.0)),
                    elevation: 10,
                    child: CircleAvatar(
                        maxRadius: 25,
                        backgroundImage: AssetImage('images/bot.png')),
                  )
                : Material(
                    borderRadius: BorderRadius.all(Radius.circular(25.0)),
                    elevation: 10,
                    child: CircularProfileAvatar(
                      '',
                      radius: 25,
                      backgroundColor:
                          msg.isMe ? Colors.indigo : Colors.blueGrey,
                      initialsText: Text(
                        msg.sender[0],
                        style: TextStyle(fontSize: 40, color: Colors.white),
                      ),
                    ),
                  ),
          ),
          Column(
            crossAxisAlignment:
                msg.isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: <Widget>[
              senderName(),
              Material(
                borderRadius: msg.isMe
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
                color: msg.isMe ? Colors.lightBlueAccent : Colors.pinkAccent,
                child: Padding(
                  padding:
                      EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                  child: SizedBox(
                    width: msg.text.length > 30 ? 200.0 : null,
                    child: checkIsImage(),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10, top: 5),
                child: Text(
                  '${msg.dateTime.toString().substring(2, 16)}',
                  style: TextStyle(
                    fontSize: 12.0,
                    color: Colors.black38,
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget messageSenderIsUserLoggedIn() {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Column(
            crossAxisAlignment:
                msg.isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: <Widget>[
              senderName(),
              Material(
                borderRadius: msg.isMe
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
                color: msg.isMe ? Colors.lightBlueAccent : Colors.pinkAccent,
                child: Padding(
                  padding:
                      EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                  child: SizedBox(
                    width: msg.text.length > 30 ? 200.0 : null,
                    child: checkIsImage(),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 20, top: 5),
                child: Text(
                  '${msg.dateTime.toString().substring(2, 16)}',
                  style: TextStyle(
                    fontSize: 12.0,
                    color: Colors.black38,
                  ),
                ),
              )
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Material(
              borderRadius: BorderRadius.all(Radius.circular(25.0)),
              elevation: 10,
              child: CircularProfileAvatar(
                '',
                radius: 25,
                backgroundColor: msg.isMe ? Colors.indigo : Colors.blueGrey,
                initialsText: Text(
                  msg.sender[0],
                  style: TextStyle(fontSize: 40, color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget senderName() {
    return Text(
      '${msg.sender} - ${msg.senderDisplayName}',
      style: TextStyle(
        fontSize: 12.0,
        color: Colors.black38,
      ),
    );
  }

  Widget checkIsImage() {
    print(
        '-------------------------------------------------------------isImage: ${msg.isImage}');
    if (msg.isImage == true) {
      return CachedNetworkImage(
        imageUrl: msg.text,
        placeholder: (context, url) => new Loading(),
        errorWidget: (context, url, error) => new Icon(Icons.error),
      );
    } else {
      return Text(
        '${msg.text}',
        softWrap: true,
        style: TextStyle(
          color: Colors.white,
          fontSize: 15,
        ),
      );
    }
  }
}
