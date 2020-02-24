import 'package:flash_chat/models/user.dart';
import 'package:flash_chat/screens/auth_screens/welcome_screen.dart';
import 'package:flash_chat/screens/home/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
    print(user);

    //return either home or authenticate widget
    if (user == null) {
      return WelcomeScreen();
    } else {
      return FutureBuilder<bool>(
        future: LocalAuthService().authorizeNow(),
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
          if (!snapshot.hasData) {
            return Loading();
          } else {
            if (snapshot.data == true) {
              return ChatScreen();
            }
            return WelcomeScreen();
          }
        },
      );
    }
  }
}
