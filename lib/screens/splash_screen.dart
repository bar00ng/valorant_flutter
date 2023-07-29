import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
          child: Image.asset(
            'assets/images/splash_logo.png',
            width: 200,
            height: 200,
          ),
        ),
      ),
    );
  }
}
