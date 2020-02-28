import 'package:flash_chat/screens/home/chat_screen.dart';
import 'package:flash_chat/screens/home/timetable_screen.dart';
import 'package:flutter/material.dart';

class DrawerWidget extends StatelessWidget {
  final String title;

  DrawerWidget({Key key, this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: new ListView(
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountName: Text("x1689723@student.ncirl.ie"),
            currentAccountPicture: GestureDetector(
              child: CircleAvatar(
                backgroundImage: NetworkImage(
                    "https://img2.thejournal.ie/inline/1881369/original/?width=630&version=1881369"),
                backgroundColor: Colors.white,
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
              return ChatScreen();
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
