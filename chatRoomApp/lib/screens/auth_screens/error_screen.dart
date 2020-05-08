import 'package:flutter/material.dart';
import 'package:flash_chat/constants/colorAndDesignConstants.dart';

class ErrorScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.brown[50],
        appBar: AppBar(
          title: Text(
            'NCI - Fresh Start',
          ),
          centerTitle: true,
          backgroundColor: kPrimaryColourDark,
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Container(
              height: 200,
              width: 200,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      alignment: Alignment.center,
                      image: AssetImage('images/error.png'))),
            ),
            Text(
              "Biometrics required to use this application, Please close the application and try again.",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ));
  }
}
