import 'package:flash_chat/constants/colorAndDesignConstants.dart';
import 'package:flash_chat/components/RoundedButton.dart';
import 'package:flash_chat/constants/constants.dart';
import 'package:flash_chat/validators/textFormFieldValidators.dart';
import 'package:flutter/material.dart';
import 'package:flash_chat/services/authService.dart';
import 'package:flash_chat/shared/loading.dart';
import 'package:password_compromised/password_compromised.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class RegistrationScreen extends StatefulWidget {
  static const id = 'registration_screen';

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
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
              title: Text('🚀 Sign up NCI Fresh Start '),
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
                          validator: (value) =>
                              TextFormFieldValidator.validatePassword(value),
                          onChanged: (value) {
                            setState(() {
                              _password = value;
                            });
                          },
                        ),
                        SizedBox(height: 20.0),
                        TextFormField(
                          decoration: kTextFieldDecoration.copyWith(
                              hintText: 'Retype password'),
                          obscureText: true,
                          validator: (value) => value != _password
                              ? 'Passwords don\'t match'
                              : null,
                          onChanged: (value) {},
                        ),
                        SizedBox(height: 20.0),
                        RoundedButton(
                          colour: kPrimaryColour,
                          title: '🔥 Register',
                          onPressed: () async {
                            if (_formKey.currentState.validate()) {
                              if (await isPasswordCompromised(_password)) {
                                _showDialog(
                                    context: context,
                                    title: 'Password Compromised!',
                                    content:
                                        'The password that you have choosen have appeared on pwned password databases meaning that its insecure and can be easily compromised, please change account password to something else.');
                              } else {
                                setState(() => _showSpinner = true);
                                dynamic result =
                                    await _auth.registerWithEmailAndPassword(
                                        _email.replaceAll(' ', ''), _password);

                                setState(() => _showSpinner = false);
                                if (result != null) {
                                  _showDialog(
                                      context: context,
                                      title: "Email Verification Required!",
                                      content:
                                          "Registration successful, please check your student mail for the email verification link. After email has been verified please proceed to login. ");
                                } else {
                                  setState(() {
                                    _error =
                                        '⛔ Opps... Something went wrong, try again later';
                                    _showSpinner = false;
                                  });
                                }
                              }
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

  _showDialog({BuildContext context, String title, String content}) {
    Alert(context: context, title: title, desc: content).show();
  }
}
