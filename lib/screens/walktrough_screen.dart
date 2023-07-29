import 'package:flutter/material.dart';
import 'package:flutter_walkthrough_screen/flutter_walkthrough_screen.dart';
import 'package:valorant_app/screens/home_screen.dart';

class WalktroughScreen extends StatelessWidget {
  final List<OnbordingData> list = [
    OnbordingData(
      image: AssetImage("images/pic1.png"),
      titleText: Text("This is Title1"),
      descText: Text("This is desc1"),
    ),
    OnbordingData(
      image: AssetImage("images/pic2.png"),
      titleText: Text("This is Title2"),
      descText: Text("This is desc2"),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return IntroScreen(
      onbordingDataList: list,
      colors: [
        //list of colors for per pages
        Colors.white,
        Colors.red,
      ],
      pageRoute: MaterialPageRoute(
        builder: (context) => HomeScreen(),
      ),
      nextButton: Text(
        "NEXT",
        style: TextStyle(
          color: Colors.purple,
        ),
      ),
      lastButton: Text(
        "GOT IT",
        style: TextStyle(
          color: Colors.purple,
        ),
      ),
      skipButton: Text(
        "SKIP",
        style: TextStyle(
          color: Colors.purple,
        ),
      ),
      selectedDotColor: Colors.orange,
      unSelectdDotColor: Colors.grey,
    );
  }
}
