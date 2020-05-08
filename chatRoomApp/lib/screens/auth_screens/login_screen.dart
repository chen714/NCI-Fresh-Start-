import 'package:flash_chat/constants/colorAndDesignConstants.dart';
import 'package:flash_chat/components/RoundedButton.dart';
import 'package:flash_chat/constants/constants.dart';
import 'package:flash_chat/screens/auth_screens/password_reset_screen.dart';
import 'package:flutter/material.dart';
import 'package:flash_chat/services/authService.dart';
import 'package:flash_chat/shared/loading.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  //state
  String _email;
  String _password;

  String _error = '';
  bool _showSpinner = false;

  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return _showSpinner
        ? Loading()
        : Scaffold(
            appBar: AppBar(
              backgroundColor: kPrimaryColourDark,
              elevation: 0.0,
              title: Text('🚀 Sign in NCI Fresh Start '),
            ),
            body: Container(
              padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
              child: ListView(
                children: <Widget>[
                  Form(
                    key: _formKey,
                    child: Column(
                      children: <Widget>[
                        Container(
                          child: Image.asset('images/logo.png'),
                          height: 100,
                        ),
                        SizedBox(height: 20.0),
                        TextFormField(
                          validator: (value) =>
                              value.isEmpty ? 'Enter an email' : null,
                          decoration:
                              kTextFieldDecoration.copyWith(hintText: 'email'),
                          onChanged: (value) {
                            setState(() {
                              _email = value;
                            });
                          },
                        ),
                        SizedBox(height: 20.0),
                        TextFormField(
                          decoration: kTextFieldDecoration.copyWith(
                              hintText: 'password'),
                          obscureText: true,
                          validator: (value) => value.length < 8
                              ? 'Enter a password that\'s longer then 8 characters'
                              : null,
                          onChanged: (value) {
                            setState(() {
                              _password = value;
                            });
                          },
                        ),
                        SizedBox(height: 20.0),
                        RoundedButton(
                          colour: kSecondaryColor,
                          title: '💎  Log In',
                          onPressed: () async {
                            if (_formKey.currentState.validate()) {
                              setState(() => _showSpinner = true);

                              dynamic result =
                                  await _auth.signInWithEmailAndPassword(
                                      _email.replaceAll(' ', ''), _password);

                              setState(() => _showSpinner = false);
                              if (result != null) {
                                Navigator.pop(context);
                              } else {
                                setState(() {
                                  _error =
                                      '⛔ Opps... Something went wrong, try again later';
                                  _showSpinner = false;
                                });
                              }
                            }
                          },
                        ),
                        SizedBox(height: 12.0),
                        FlatButton(
                          child: Text(
                            'Forget Password?',
                            style: TextStyle(
                                decoration: TextDecoration.underline,
                                color: kPrimaryColourLight),
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) {
                                return ResetPassword();
                              }),
                            );
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
