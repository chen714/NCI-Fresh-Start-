import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.lightBlueAccent,
      child: Center(
        child: SpinKitDoubleBounce(
          color: Colors.grey,
          size: 250.0,
        ),
      ),
    );
  }
}
