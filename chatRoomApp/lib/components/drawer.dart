import 'package:flash_chat/screens/home/chat_screen.dart';
import 'package:flash_chat/screens/home/nci_bot.dart';
import 'package:flash_chat/screens/home/timetable_screen.dart';
import 'package:flutter/material.dart';
import 'package:flash_chat/models/user.dart';
import 'package:provider/provider.dart';
import 'package:circular_profile_avatar/circular_profile_avatar.dart';

class DrawerWidget extends StatelessWidget {
  final String title;

  DrawerWidget({Key key, this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    User user = Provider.of<User>(context);
    return Drawer(
      child: new ListView(
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountName: Text(user.email),
            currentAccountPicture: GestureDetector(
              child: CircularProfileAvatar(
                '',
                radius: 25,
                backgroundColor: Colors.indigo,
                initialsText: Text(
                  user.email[0],
                  style: TextStyle(fontSize: 40, color: Colors.white),
                ),
              ),
            ),
            decoration: BoxDecoration(color: Colors.lightBlueAccent),
          ),
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) {
                  return ChatScreen();
                }),
              );
            },
            child: ListTile(
              title: Text('Class Chat'),
              leading: Icon(Icons.message),
            ),
          ),
          Divider(),
          InkWell(
            onTap: () {
              print('------------------------------VIRTUAL ASSISTANT');
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) {
                  return NCIBotDialogFlow();
                }),
              );
            },
            child: ListTile(
              title: Text('Virtual Assistant'),
              leading: Icon(Icons.assignment_ind),
            ),
          ),
          Divider(),
          InkWell(
            onTap: () {
              print('------------------------------TIMETABLE');
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) {
                  return TimetableScreen();
                }),
              );
            },
            child: ListTile(
              title: Text('Timetable'),
              leading: Icon(Icons.calendar_today),
            ),
          ),
          Divider(),
          InkWell(
            onTap: () {
              return ChatScreen();
            },
            child: ListTile(
              title: Text('Class Updates'),
              leading: Icon(Icons.grade),
            ),
          ),
        ],
      ),
    );
  }
}
