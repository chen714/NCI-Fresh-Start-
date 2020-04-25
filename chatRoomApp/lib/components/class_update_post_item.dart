import 'package:flutter/material.dart';
import 'package:flash_chat/models/message.dart';
import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:flash_chat/constants/colorAndDesignConstants.dart';

class ClassUpdatePostItem extends StatelessWidget {
  final Message post;
  ClassUpdatePostItem({this.post});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 8.0),
      child: Card(
        color: kPrimaryColourLight,
        margin: EdgeInsets.fromLTRB(20, 6, 20, 0),
        child: ListTile(
          leading: CircularProfileAvatar(
            '',
            radius: 25,
            backgroundColor: Colors.blueGrey,
            initialsText: Text(
              post.senderDisplayName[0],
              style: TextStyle(fontSize: 40, color: Colors.white),
            ),
          ),
          title: SizedBox(
            width: 300,
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Text(
                        'Update from ${post.senderDisplayName} \n${post.sender}',
                        style: TextStyle(fontSize: 10)),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Text(
                      post.dateTime.toString().substring(2, 16),
                      style: TextStyle(fontSize: 10),
                    )
                  ],
                )
              ],
            ),
          ),
          subtitle: Text(post.text),
        ),
      ),
    );
  }
}
