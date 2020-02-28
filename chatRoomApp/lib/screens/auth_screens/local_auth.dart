import 'package:flash_chat/models/user.dart';
import 'package:flash_chat/screens/auth_screens/setUserData.dart';
import 'package:flash_chat/screens/auth_screens/welcome_screen.dart';
import 'package:flash_chat/screens/home/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flash_chat/services/UserDbService.dart';
import 'package:flash_chat/services/localAuthService.dart';
import 'package:flash_chat/services/authService.dart';
import 'package:flash_chat/shared/loading.dart';

class LocalAuth extends StatefulWidget {
  @override
  _LocalAuthState createState() => _LocalAuthState();
}

class _LocalAuthState extends State<LocalAuth> {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    AuthService _auth = AuthService();

    //return either home or authenticate widget
    if (user == null) {
      return WelcomeScreen();
    } else {
      return SetUserData(uid: user.uid, email: user.email);
    }
  }
}
