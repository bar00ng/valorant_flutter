import 'package:flutter/material.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:valorant_app/screens/home_screen.dart';
import 'package:valorant_app/screens/splash_screen.dart';
import 'package:page_transition/page_transition.dart';
import 'package:google_fonts/google_fonts.dart';

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
        splash: SplashScreen(), // Ganti dengan gambar splash screen Anda
        nextScreen: HomeScreen(),
        splashTransition: SplashTransition.rotationTransition,
        pageTransitionType: PageTransitionType.fade,
        duration: 3000, // Durasi animasi splash screen dalam milidetik
      ),
    );
  }
}
