import 'package:flash_chat/screens/home/chat_screen.dart';
import 'package:flash_chat/screens/home/nci_bot.dart';
import 'package:flash_chat/screens/home/timetable_screen.dart';
import 'package:flutter/material.dart';
import 'package:flash_chat/models/user.dart';
import 'package:provider/provider.dart';
import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:flash_chat/services/UserDbService.dart';
import 'package:flash_chat/services/authService.dart';
import 'package:flash_chat/screens/home/send_updates.dart';
import 'package:flash_chat/screens/home/class_updates.dart';
import 'package:flash_chat/screens/home/past_updates.dart';

User loggedInUser;
UserData userData;
UserDbService _userDbService;
bool isFaculty;

class DrawerWidget extends StatefulWidget {
  final String title;

  DrawerWidget({Key key, this.title}) : super(key: key);

  @override
  _DrawerWidgetState createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {
  final _authService = AuthService();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrentUserData();
  }

  void getCurrentUserData() async {
    try {
      final user = await _authService.currentUser();
      if (user != null) {
        loggedInUser = user;
        _userDbService = UserDbService(uid: loggedInUser.uid);
        userData = await _userDbService.getUserDataFromUid();
        setState(() {
          isFaculty = userData.isFaculty;
        });

        print('----------------------------------$isFaculty');
        print(loggedInUser.email);
      }
    } catch (e) {
      print(e);
    }
  }

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
              title: Text(isFaculty ? 'Faculty Chat' : 'Class Chat'),
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
                  if (isFaculty) {
                    return SendUpdate();
                  } else {
                    return ClassUpdates();
                  }
                }),
              );
            },
            child: ListTile(
              title: Text(isFaculty ? 'Send Class Update' : 'Class Updates'),
              leading: Icon(isFaculty ? Icons.send : Icons.grade),
            ),
          ),
          Divider(),
          isFaculty
              ? InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) {
                        return PastUpdates();
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
