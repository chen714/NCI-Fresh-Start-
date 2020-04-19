import 'package:flash_chat/components/RoundedButton.dart';
import 'package:flash_chat/screens/home/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:flash_chat/shared/loading.dart';
import 'package:flash_chat/services/UserDbService.dart';
import 'package:flash_chat/constants.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class SetUserData extends StatefulWidget {
  final String uid;
  final String email;
  SetUserData({this.uid, this.email});

  @override
  _SetUserDataState createState() => _SetUserDataState();
}

class _SetUserDataState extends State<SetUserData> {
  FirebaseMessaging _fcm = FirebaseMessaging();
  void initState() {
    // TODO: implement initState
    super.initState();

    _fcm.configure(onMessage: (Map<String, dynamic> message) async {
      print("onMessage: $message");
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          content: ListTile(
            title: Text(message['notification']['title']),
            subtitle: Text(message['notification']['body']),
          ),
          actions: <Widget>[
            RoundedButton(
              title: 'Ok',
              colour: Colors.pink,
              bold: true,
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      );
    }, onLaunch: (Map<String, dynamic> message) async {
      print("onLaunch: $message");
      // TODO optional
    }, onResume: (Map<String, dynamic> message) async {
      print("onResume: $message");
      // TODO optional
    });
  }

  //state
  final _formKey = GlobalKey<FormState>();

  //form values
  String _name;

  String _courseCode;
  String _error = '';

  bool isFaculty(String email) {
    if (email.contains('@ncirl.ie')) {
      return true;
    } else {
      return false;
    }
  }

  Widget sizedBox() {
    return SizedBox(
      height: 20,
    );
  }

  Widget showCourseCodeDropdown() {
    if (isFaculty(widget.email)) {
      return SizedBox(
        height: 0,
      );
    } else {
      return Container(
        alignment: Alignment.bottomCenter,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            SizedBox(
              width: 100,
              child: Text(
                'Please select course: ',
                style: TextStyle(fontSize: 14),
                softWrap: true,
              ),
            ),
            SizedBox(
              width: 150,
              child: DropdownButtonFormField(
                decoration: kTextFieldDecoration,
                value: _courseCode,
                icon: Icon(Icons.keyboard_arrow_down),
                iconSize: 24,
                elevation: 16,
                style: TextStyle(color: Colors.black),
                onChanged: (String newValue) {
                  setState(() {
                    _courseCode = newValue;
                  });
                },
                items: kCourseCode.map((courCode) {
                  return DropdownMenuItem(
                    value: courCode,
                    child: Text('$courCode'),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    print('++++++++++++++++++++++++++++++++++++++++++++++++ ${widget.uid}');

    UserDbService userDbService = UserDbService(uid: widget.uid);

    return FutureBuilder<bool>(
        future: userDbService.doesUserExist(),
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
          if (!snapshot.hasData) {
            return Loading();
          } else {
            if (snapshot.data == true) {
              return ChatScreen();
            } else {
              return Scaffold(
                appBar: AppBar(
                  backgroundColor: Colors.lightBlue,
                  elevation: 0.0,
                  title: Text('🚀 Sign up NCI Fresh Start '),
                ),
                body: Container(
                  padding:
                      EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
                  child: ListView(
                    children: <Widget>[
                      Form(
                        key: _formKey,
                        child: Column(
                          children: <Widget>[
                            Text(
                              'Please enter your name and course details.',
                              style: TextStyle(fontSize: 18.0),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            TextFormField(
                              decoration: kTextFieldDecoration.copyWith(
                                hintText: 'Enter your name',
                              ),
                              validator: (value) =>
                                  value.isEmpty ? 'Required' : null,
                              onChanged: (value) {
                                setState(() {
                                  _name = value;
                                });
                              },
                            ),
                            SizedBox(
                              height: !isFaculty(widget.email) ? 20 : 0,
                            ),
                            showCourseCodeDropdown(),
                            SizedBox(
                              height: 50,
                            ),
                            RoundedButton(
                              colour: Colors.lightBlue,
                              title: '⚡ Sign Me Up!',
                              onPressed: () {
                                setState(() async {
                                  if (_formKey.currentState.validate()) {
                                    if (isFaculty(widget.email)) {
                                      await userDbService.updateUserData(
                                          email: widget.email,
                                          name: _name.trim(),
                                          isFaculty: true,
                                          courseCode: 'FACULTY');
                                    } else {
                                      await userDbService.updateUserData(
                                          email: widget.email,
                                          name: _name.trim(),
                                          isFaculty: false,
                                          courseCode: _courseCode);
                                      _fcm.subscribeToTopic('$_courseCode');
                                    }

                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) {
                                        return ChatScreen();
                                      }),
                                    );
                                  } else {
                                    _error =
                                        '⛔ Opps... Something went wrong, try again later';
                                  }
                                });
                              },
                            ),
                            SizedBox(height: 12.0),
                            Text(
                              _error,
                              style:
                                  TextStyle(color: Colors.red, fontSize: 14.0),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }
          }
        });
  }
}
