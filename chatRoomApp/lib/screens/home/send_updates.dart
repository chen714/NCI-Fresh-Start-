import 'package:flash_chat/constants/colorAndDesignConstants.dart';
import 'package:flash_chat/constants/courseCode.dart';
import 'package:flash_chat/models/message.dart';
import 'package:flash_chat/models/user.dart';
import 'package:flash_chat/services/CommunicationService.dart';
import 'package:flash_chat/services/authService.dart';
import 'package:flash_chat/validators/textFormFieldValidators.dart';
import 'package:flutter/material.dart';
import 'package:flash_chat/constants/constants.dart';
import 'package:flash_chat/components/RoundedButton.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:overlay_support/overlay_support.dart';

class SendUpdate extends StatefulWidget {
  final UserData userData;
  SendUpdate({this.userData});
  @override
  _SendUpdateState createState() => _SendUpdateState();
}

class _SendUpdateState extends State<SendUpdate> {
  //state
  final _formKey = GlobalKey<FormState>();
  AuthService _authService = AuthService();

  //form value
  String _message;
  String _courseCode;
  String _courseCodeDescription;
  String _error = '';

  @override
  Widget build(BuildContext context) {
    CommunicationService commsService =
        CommunicationService(userData: widget.userData);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPrimaryColourDark,
        elevation: 0.0,
        title: Text(
          '🚀 Send Updates To your Class',
          style: TextStyle(fontSize: 18),
        ),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                //Implement logout functionality
                _authService.signOut();
                Navigator.popUntil(context, ModalRoute.withName('/'));
              }),
        ],
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
                    maxLines: 6,
                    maxLength: 200,
                    maxLengthEnforced: true,
                    decoration: kTextFieldDecoration.copyWith(
                      hintText: 'Enter your update',
                    ),
                    validator: (value) =>
                        TextFormFieldValidator.validateUpdate(value),
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
                          width: 180,
                          child: DropdownButtonFormField(
                            validator: (value) =>
                                value == null ? 'Required' : null,
                            decoration: kTextFieldDecoration,
                            value: _courseCodeDescription,
                            icon: Icon(Icons.keyboard_arrow_down),
                            itemHeight: 50,
                            iconSize: 24,
                            elevation: 16,
                            style: TextStyle(color: Colors.black),
                            onChanged: (String newValue) {
                              setState(() {
                                _courseCodeDescription = newValue;
                                int _courseCodeIndex = newValue.indexOf('-');
                                _courseCode = newValue
                                    .substring(0, _courseCodeIndex)
                                    .trim();
                              });
                            },
                            items: kCourseCode.map((courCode) {
                              return DropdownMenuItem(
                                value: courCode,
                                child: Container(
                                    width: 116, child: Text('$courCode')),
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
                    colour: kPrimaryColourLight,
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
                        _showConfirmationDialog(message, commsService);
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

  _showConfirmationDialog(Message message, CommunicationService commsService) {
    Alert(
      context: context,
      type: AlertType.info,
      title: "Your update to $_courseCode",
      desc: message.text,
      buttons: [
        DialogButton(
          child: Text(
            "Send",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () {
            commsService
                .sendUpdateToCohort(message, _courseCode)
                .whenComplete(() {
              showSimpleNotification(
                Text("Update Sent!"),
                background: Colors.green,
              );
            }).catchError((e) {
              showSimpleNotification(
                Text(
                    "An error occured while sending your update, Please try again later. "),
                background: Colors.red,
              );
            });
            _formKey.currentState.reset();
            Navigator.pop(context);
          },
          gradient: LinearGradient(colors: [
            Color.fromRGBO(116, 116, 191, 1.0),
            Color.fromRGBO(52, 138, 199, 1.0)
          ]),
        ),
        DialogButton(
          child: Text(
            "Cancel",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () => Navigator.pop(context),
          color: Colors.red[300],
        ),
      ],
    ).show();
  }
}
