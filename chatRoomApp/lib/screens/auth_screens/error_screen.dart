import 'package:flutter/material.dart';

class ErrorScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Text(
            "Biometrics required to use this application, Please close the application and try again.",
            style: Theme.of(context).textTheme.title,
          ),
        ),
      ),
    );
  }
}
