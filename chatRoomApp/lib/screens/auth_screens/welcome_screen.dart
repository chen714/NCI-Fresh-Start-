import 'package:flash_chat/screens/auth_screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flash_chat/components/RoundedButton.dart';
import 'package:provider/provider.dart';
import 'package:flash_chat/screens/auth_screens/registration_screen.dart';
import 'package:flash_chat/models/user.dart';
import 'package:flash_chat/screens/home/chat_screen.dart';
import 'package:flash_chat/services/localAuthService.dart';
import 'package:flash_chat/services/authService.dart';

class WelcomeScreen extends StatefulWidget {
  static const id = 'welcome_screen';

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation animation;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      upperBound: 2,
      duration: Duration(seconds: 2),
      vsync: this,
    );

    animation = ColorTween(begin: Colors.blueGrey, end: Colors.white)
        .animate(controller);
    controller.forward();

    controller.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: animation.value,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Flexible(
              child: Hero(
                tag: 'logo',
                child: Container(
                  child: Image.asset('images/logo.png'),
                  height: 100,
                ),
              ),
            ),
            SizedBox(
              height: 60.0,
            ),
            ColorizeAnimatedTextKit(
              text: ['NCI Fresh Start'],
              alignment: Alignment.center,
              textStyle: TextStyle(
                fontSize: 35.0,
                fontWeight: FontWeight.w900,
              ),
              colors: <Color>[
                Colors.blueAccent,
                Colors.black,
                Colors.yellowAccent,
              ],
            ),
            SizedBox(
              height: 20.0,
            ),
            RoundedButton(
              title: 'Log In',
              colour: Colors.lightBlueAccent,
              onPressed: () {
                //Go to login screen.
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) {
                    return LoginScreen();
                  }),
                );
              },
            ),
            RoundedButton(
              title: 'Sign Up',
              colour: Colors.blueAccent,
              onPressed: () {
                //Go to registration screen.

                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) {
                    return RegistrationScreen();
                  }),
                );
                //Navigator.pushNamed(context, RegistrationScreen.id);
              },
            )
          ],
        ),
      ),
    );
  }
}
