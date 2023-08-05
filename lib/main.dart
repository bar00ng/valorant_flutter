import 'package:flutter/material.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart'; // Package untuk splash screen animasi
import 'package:valorant_app/screens/splash_screen.dart'; // Widget SplashScreen yang akan ditampilkan saat splash screen
import 'package:page_transition/page_transition.dart'; // Package untuk mengatur tipe transisi antar halaman
import 'package:valorant_app/screens/walktrough_screen.dart'; // Package untuk menggunakan Google Fonts

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        fontFamily:
            'Poppins', // Mengatur font default ke Google Fonts "Poppins"
      ),
      home: AnimatedSplashScreen(
        splash: SplashScreen(),
        // Widget SplashScreen akan ditampilkan sebagai splash screen
        nextScreen: WalktroughScreen(),
        // Setelah splash screen, akan beralih ke halaman WalktroughScreen
        splashTransition: SplashTransition.scaleTransition,
        // Transisi animasi dari splash screen (berupa scaling)
        pageTransitionType: PageTransitionType.leftToRight,
        // Tipe transisi antar halaman ketika pindah dari splash ke walktrough
        duration:
            3000, // Durasi splash screen sebelum beralih ke halaman berikutnya (dalam milidetik, di sini 3000 ms atau 3 detik)
      ),
    );
  }
}
