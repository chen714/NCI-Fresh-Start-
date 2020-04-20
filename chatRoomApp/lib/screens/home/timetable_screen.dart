import 'package:easy_web_view/easy_web_view.dart';
import 'package:flash_chat/components/drawer.dart';
import 'package:flash_chat/services/authService.dart';
import 'package:flutter/material.dart';

class TimetableScreen extends StatefulWidget {
  @override
  _TimetableScreenState createState() => _TimetableScreenState();
}

class _TimetableScreenState extends State<TimetableScreen> {
  AuthService _authService = AuthService();
  String url =
      'https://scientia-publish-ncirl.azurewebsites.net/#/app/my-timetable';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: DrawerWidget(),
      appBar: AppBar(
        title: Text('Timetable'),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                //Implement logout functionality
                _authService.signOut();
                Navigator.popUntil(context, ModalRoute.withName('/'));
              }),
        ],
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: EasyWebView(
        src: url,
      ),
    );
  }
}
