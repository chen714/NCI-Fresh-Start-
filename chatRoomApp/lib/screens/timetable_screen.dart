import 'package:easy_web_view/easy_web_view.dart';
import 'package:flash_chat/components/drawer.dart';
import 'package:flutter/material.dart';

class TimetableScreen extends StatefulWidget {
  static const id = 'timetable_screen';

  @override
  _TimetableScreenState createState() => _TimetableScreenState();
}

class _TimetableScreenState extends State<TimetableScreen> {
  String url = 'https://scientia-publish-ncirl.azurewebsites.net/';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: DrawerWidget(),
      appBar: AppBar(
        title: Text('Timetable'),
      ),
      body: EasyWebView(
        src: url,
      ),
    );
  }

}
