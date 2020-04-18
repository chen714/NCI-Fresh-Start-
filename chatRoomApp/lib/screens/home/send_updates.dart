import 'package:flash_chat/models/message.dart';
import 'package:flash_chat/models/user.dart';
import 'package:flash_chat/services/CommunicationService.dart';
import 'package:flutter/material.dart';
import 'package:flash_chat/constants.dart';
import 'package:flash_chat/components/RoundedButton.dart';

class SendUpdate extends StatefulWidget {
  final UserData userData;
  SendUpdate({this.userData});
  @override
  _SendUpdateState createState() => _SendUpdateState();
}

class _SendUpdateState extends State<SendUpdate> {
  //state
  final _formKey = GlobalKey<FormState>();

  //form value
  String _message;
  String _courseCode;
  String _error = '';

  @override
  Widget build(BuildContext context) {
    CommunicationService commsService =
        CommunicationService(userData: widget.userData);
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
                        Message message = Message(
                            sender: widget.userData.email,
                            senderDisplayName: widget.userData.name,
                            text: _message,
                            isImage: false,
                            isMe: true,
                            dateTime: DateTime.now());
                        commsService.sendUpdateToCohort(message, _courseCode);
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
