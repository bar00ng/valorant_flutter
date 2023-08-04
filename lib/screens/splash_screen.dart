import 'package:flutter/material.dart';
import 'package:valorant_app/data/constant.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/splash_logo.png',
              height: 500,
              width: 500,
            ),
            SizedBox(height: 16), // Add some spacing between the image and text
            Text(
              'Valorant Verum',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: redColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
