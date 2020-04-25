import 'package:flash_chat/constants/colorAndDesignConstants.dart';
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: msg.sender == 'virtualassistant@ncirl.ie'
                ? botAvatar()
                : circularProfileAvatar(msg.senderDisplayName, msg.isMe),
          ),
          Column(
            crossAxisAlignment:
                msg.isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: <Widget>[
              senderName(),
              Material(
                borderRadius: widgetBorder(msg.isMe),
                elevation: 8.0,
                color: kSecondaryColor,
                child: Padding(
                  padding:
                      EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                  child: SizedBox(
                    width: msg.text.length > 30 ? 200.0 : null,
                    child: checkIsImage(),
                  ),
                ),
              ),
              sentOnDateTime(msg.isMe)
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Column(
            crossAxisAlignment:
                msg.isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: <Widget>[
              senderName(),
              Material(
                borderRadius: widgetBorder(msg.isMe),
                elevation: 8.0,
                color: kPrimaryColour,
                child: Padding(
                  padding:
                      EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                  child: SizedBox(
                    width: msg.text.length > 30 ? 200.0 : null,
                    child: checkIsImage(),
                  ),
                ),
              ),
              sentOnDateTime(msg.isMe)
            ],
          ),
          Padding(
              padding: const EdgeInsets.all(8.0),
              child: circularProfileAvatar(msg.senderDisplayName, msg.isMe)),
        ],
      ),
    );
  }

  Widget circularProfileAvatar(String senderName, bool isMe) {
    return Material(
      borderRadius: BorderRadius.all(Radius.circular(25.0)),
      elevation: 8.0,
      child: CircularProfileAvatar(
        '',
        radius: 25,
        backgroundColor: isMe ? Colors.indigo : Colors.blueGrey,
        initialsText: Text(
          senderName[0],
          style: TextStyle(fontSize: 40, color: Colors.white),
        ),
      ),
    );
  }

  Widget sentOnDateTime(bool isMe) {
    if (isMe)
      return Padding(
        padding: const EdgeInsets.only(right: 20, top: 5),
        child: Text(
          '${msg.dateTime.toString().substring(2, 16)}',
          style: TextStyle(
            fontSize: 12.0,
            color: Colors.black38,
          ),
        ),
      );
    else
      return Padding(
        padding: const EdgeInsets.only(left: 10, top: 5),
        child: Text(
          '${msg.dateTime.toString().substring(2, 16)}',
          style: TextStyle(
            fontSize: 12.0,
            color: Colors.black38,
          ),
        ),
      );
  }

  Widget botAvatar() {
    return Material(
      borderRadius: BorderRadius.all(Radius.circular(25.0)),
      elevation: 8.0,
      child: CircleAvatar(
          maxRadius: 25, backgroundImage: AssetImage('images/bot.png')),
    );
  }

  BorderRadiusGeometry widgetBorder(bool isMe) {
    if (isMe)
      return BorderRadius.only(
          topLeft: Radius.circular(30.0),
          bottomLeft: Radius.circular(30.0),
          bottomRight: Radius.circular(30.0));
    else
      return BorderRadius.only(
          topRight: Radius.circular(30.0),
          bottomLeft: Radius.circular(30.0),
          bottomRight: Radius.circular(30.0));
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
