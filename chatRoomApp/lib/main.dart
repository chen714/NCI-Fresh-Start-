import 'package:flash_chat/screens/auth_screens/error_screen.dart';
import 'package:flash_chat/screens/auth_screens/local_auth.dart';
import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:provider/provider.dart';
import 'services/authService.dart';
import 'models/user.dart';

import 'package:flash_chat/services/localAuthService.dart';
import 'package:flash_chat/services/authService.dart';
import 'package:flash_chat/shared/loading.dart';

void main() => runApp(FlashChat());

class FlashChat extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamProvider<User>.value(
      value: AuthService().user,
      child: OverlaySupport(
        child: MaterialApp(
          home: FutureBuilder<bool>(
            future: LocalAuthService().authorizeNow(),
            builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
              if (!snapshot.hasData) {
                return Loading();
              } else {
                if (snapshot.data == true) {
                  return LocalAuth();
                }

                return ErrorScreen();
              }
            },
          ),
        ),
      ),
    );
  }
}
