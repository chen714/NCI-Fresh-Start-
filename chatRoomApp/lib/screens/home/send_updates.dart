import 'package:flash_chat/models/user.dart';
import 'package:flash_chat/services/UserDbService.dart';
import 'package:flutter/material.dart';
import 'package:flash_chat/constants.dart';
import 'package:flash_chat/components/RoundedButton.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flash_chat/services/authService.dart';

final _firestore = Firestore.instance;

class SendUpdate extends StatefulWidget {
  @override
  _SendUpdateState createState() => _SendUpdateState();
}

class _SendUpdateState extends State<SendUpdate> {
  final _authService = AuthService();
  UserData userData;

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
        User loggedInUser = user;
        UserDbService _userDbService = UserDbService(uid: loggedInUser.uid);
        userData = await _userDbService.getUserDataFromUid();
      }
    } catch (e) {
      print(e);
    }
  }

  //state
  final _formKey = GlobalKey<FormState>();

  //form value
  String _message;
  String _courseCode;
  String _error = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlue,
        elevation: 0.0,
        title: Text('🚀 Send Updates To your Class'),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
        child: ListView(
          children: <Widget>[
            Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  Text(
                    'Please enter your update and the class that you would like to send it to.',
                    style: TextStyle(fontSize: 18.0),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    decoration: kTextFieldDecoration.copyWith(
                      hintText: 'Enter your update',
                    ),
                    validator: (value) => value.isEmpty ? 'Required' : null,
                    onChanged: (value) {
                      setState(() {
                        _message = value;
                      });
                    },
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
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
                            validator: (value) =>
                                value == null ? 'Required' : null,
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
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  RoundedButton(
                    colour: Colors.lightBlue,
                    title: '⚡ Send Update to ${_courseCode ?? '...'}',
                    onPressed: () {
                      if (_formKey.currentState.validate()) {
                        _firestore.collection('updates-$_courseCode').add({
                          'sentOn': DateTime.now(),
                          'text': _message,
                          'sender': userData.email,
                        });
                        _firestore
                            .collection('past updates-${userData.email}')
                            .add({
                          'sentOn': DateTime.now(),
                          'text': _message,
                          'courseCode': _courseCode,
                        });
                        Navigator.pop(context);
                      } else {
                        _error =
                            '⛔ Opps... Something went wrong, try again later';
                      }
                    },
                  ),
                  SizedBox(height: 12.0),
                  Text(
                    _error,
                    style: TextStyle(color: Colors.red, fontSize: 14.0),
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
