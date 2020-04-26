import 'package:flash_chat/constants/colorAndDesignConstants.dart';
import 'package:flash_chat/components/RoundedButton.dart';
import 'package:flash_chat/services/authService.dart';
import 'package:flash_chat/validators/textFormFieldValidators.dart';
import 'package:flutter/material.dart';
import 'package:flash_chat/constants/constants.dart';
import 'package:overlay_support/overlay_support.dart';

class ResetPassword extends StatefulWidget {
  @override
  _ResetPasswordState createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  //state
  final _formKey = GlobalKey<FormState>();
  AuthService _authService = AuthService();

  //form values
  String _email = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: kPrimaryColourDark,
        elevation: 0.0,
        title: Text('🚀 Reset Password'),
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
                    'Please enter your email.',
                    style: TextStyle(fontSize: 18.0),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    decoration: kTextFieldDecoration.copyWith(
                      hintText: 'Enter your email ',
                    ),
                    validator: (value) =>
                        TextFormFieldValidator.validateEmail(value),
                    onChanged: (value) {
                      setState(() {
                        _email = value;
                      });
                    },
                  ),
                  RoundedButton(
                    colour: kPrimaryColour,
                    title: '⚡ Reset Password',
                    onPressed: () {
                      setState(() async {
                        if (_formKey.currentState.validate()) {
                          _authService.resetPassword(_email);
                          _formKey.currentState.reset();

                          showOverlayNotification((context) {
                            return Card(
                              margin: const EdgeInsets.symmetric(horizontal: 4),
                              child: SafeArea(
                                child: ListTile(
                                  leading: SizedBox.fromSize(
                                    size: const Size(40, 40),
                                    child: Image.asset('images/confirm.png'),
                                  ),
                                  title: Text('Password Reset Email Sent'),
                                  subtitle: Text(
                                      'A password reset email has been sent to: \'$_email\'. Please check your email to finish the passwork reset process.'),
                                ),
                              ),
                            );
                          }, duration: Duration(milliseconds: 10000));
                        }
                      });
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
