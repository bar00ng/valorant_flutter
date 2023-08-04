import 'package:flutter/material.dart';
import 'package:flutter_walkthrough_screen/flutter_walkthrough_screen.dart';
import 'package:valorant_app/data/constant.dart';
import 'package:valorant_app/screens/home_screen.dart';

class WalktroughScreen extends StatelessWidget {
  final List<OnbordingData> list = [
    // Data untuk layar onboarding pertama
    OnbordingData(
      image: const AssetImage(
        'assets/images/Walktrough_Screen_1.jpg',
      ),
      titleText: Text(
        "Selamat Datang!",
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
    // Data untuk layar onboarding kedua
    OnbordingData(
      image: const AssetImage(
        'assets/images/Walktrough_Screen_2.jpg',
      ),
      titleText: Text(
        "Mulai Perjalananmu Sekarang!",
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
      // Menggunakan data list yang telah didefinisikan di atas
      onbordingDataList: list,
      // Menentukan warna latar belakang untuk setiap layar onboarding
      colors: [
        darkGrayColor,
        darkGrayColor,
      ],
      // Menentukan rute halaman yang akan dituju setelah proses onboarding selesai
      pageRoute: MaterialPageRoute(
        builder: (context) => HomeScreen(),
      ),
      // Menyesuaikan gaya tombol Next, Got It, dan Skip
      nextButton: Text(
        "LANJUT",
        style: TextStyle(
          color: redColor,
          fontWeight: FontWeight.bold,
        ),
      ),
      lastButton: Text(
        "SELESAI",
        style: TextStyle(
          color: redColor,
          fontWeight: FontWeight.bold,
        ),
      ),
      skipButton: Text(
        "LEWATI",
        style: TextStyle(
          color: redColor,
          fontWeight: FontWeight.bold,
        ),
      ),
      // Menentukan warna dot aktif pada indikator paginasi
      selectedDotColor: redColor,
      // Menentukan warna dot tidak aktif pada indikator paginasi
      unSelectdDotColor: Color(0xFF808080),
    );
  }
}
