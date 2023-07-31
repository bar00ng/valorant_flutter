import 'package:flutter/material.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:valorant_app/screens/splash_screen.dart';
import 'package:page_transition/page_transition.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:valorant_app/screens/walktrough_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        fontFamily: GoogleFonts.poppins().fontFamily,
      ),
      home: AnimatedSplashScreen(
        splash: SplashScreen(),
        nextScreen: WalktroughScreen(),
        splashTransition: SplashTransition.scaleTransition,
        pageTransitionType: PageTransitionType.leftToRight,
        duration: 3000,
      ),
    );
  }
}
