import 'package:flash_chat/screens/home/chat_screen.dart';
import 'package:flash_chat/screens/home/nci_bot.dart';
import 'package:flash_chat/screens/home/timetable_screen.dart';
import 'package:flutter/material.dart';
import 'package:flash_chat/models/user.dart';
import 'package:provider/provider.dart';
import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:flash_chat/screens/home/send_updates.dart';
import 'package:flash_chat/screens/home/class_updates.dart';
import 'package:flash_chat/screens/home/past_updates.dart';

class DrawerWidget extends StatefulWidget {
  final UserData userData;
  DrawerWidget({Key key, @required this.userData}) : super(key: key);

  @override
  _DrawerWidgetState createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {
  @override
  Widget build(BuildContext context) {
    User user = Provider.of<User>(context);
    return Drawer(
      child: new ListView(
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountName: Text('${userData.name} \n${userData.email}'),
            currentAccountPicture: GestureDetector(
              child: CircularProfileAvatar(
                '',
                radius: 25,
                backgroundColor: Colors.indigo,
                initialsText: Text(
                  userData.name[0],
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
              title: Text(userData.isFaculty ? 'Faculty Chat' : 'Class Chat'),
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
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) {
                  if (userData.isFaculty) {
                    return SendUpdate(
                      userData: userData,
                    );
                  } else {
                    return ClassUpdates(userData: userData);
                  }
                }),
              );
            },
            child: ListTile(
              title: Text(
                  userData.isFaculty ? 'Send Class Update' : 'Class Updates'),
              leading: Icon(userData.isFaculty ? Icons.send : Icons.grade),
            ),
          ),
          Divider(),
          userData.isFaculty
              ? InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) {
                        return PastUpdates(
                          userData: userData,
                        );
                      }),
                    );
                  },
                  child: ListTile(
                    title: Text('View previous updates'),
                    leading: Icon(Icons.folder_special),
                  ),
                )
              : Container()
        ],
      ),
    );
  }
}
