import 'package:flutter/material.dart';
import 'package:flutter_walkthrough_screen/flutter_walkthrough_screen.dart';
import 'package:valorant_app/data/constant.dart';
import 'package:valorant_app/screens/home_screen.dart';

class WalktroughScreen extends StatelessWidget {
  final List<OnbordingData> list = [
    OnbordingData(
      image: AssetImage("images/pic1.png"),
      titleText: Text(
        "Welcome!",
        style: TextStyle(
          color: redColor,
          fontSize: 26,
          fontWeight: FontWeight.bold,
        ),
      ),
      descText: Text(
        "Selamat datang di aplikasi Valorant! Mencari informasi seputar Valorant tidak pernah semudah ini!",
        style: TextStyle(
          fontSize: 16,
          color: darkGrayColor,
        ),
        textAlign: TextAlign.center,
      ),
    ),
    OnbordingData(
      image: AssetImage("images/pic2.png"),
      titleText: Text(
        "Start Your Journey Now!",
        style: TextStyle(
          color: redColor,
          fontSize: 26,
          fontWeight: FontWeight.bold,
        ),
      ),
      descText: Text(
        "Segeralah mulai perjalananmu!",
        style: TextStyle(
          fontSize: 16,
          color: darkGrayColor,
        ),
        textAlign: TextAlign.center,
      ),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return IntroScreen(
      onbordingDataList: list,
      colors: [
        darkGrayColor,
        darkGrayColor,
      ],
      pageRoute: MaterialPageRoute(
        builder: (context) => HomeScreen(),
      ),
      nextButton: Text(
        "NEXT",
        style: TextStyle(
          color: redColor,
          fontWeight: FontWeight.bold,
        ),
      ),
      lastButton: Text(
        "GOT IT",
        style: TextStyle(
          color: redColor,
          fontWeight: FontWeight.bold,
        ),
      ),
      skipButton: Text(
        "SKIP",
        style: TextStyle(
          color: redColor,
          fontWeight: FontWeight.bold,
        ),
      ),
      selectedDotColor: redColor,
      unSelectdDotColor: Color(0xFF808080),
    );
  }
}
