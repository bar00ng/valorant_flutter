import 'package:flutter/material.dart';
import 'package:valorant_app/data/constant.dart'; // Import file constant.dart yang berisi konstanta seperti warna, ukuran, dll.

class SkillDetailScreen extends StatelessWidget {
  final String skillName;
  final String skillDisplayIcon;
  final String skillDescription;

  SkillDetailScreen({
    required this.skillDescription,
    required this.skillDisplayIcon,
    required this.skillName,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          skillName, // Tampilkan nama skill pada judul AppBar
          style: TextStyle(
            color: redColor,
            // Warna teks judul AppBar (sesuai dengan nilai konstanta redColor)
            fontWeight:
                FontWeight.bold, // Teks judul AppBar akan ditebalkan (bold)
          ),
        ),
        iconTheme: IconThemeData(
          color:
              redColor, // Warna icon (back button) di AppBar (sesuai dengan nilai konstanta redColor)
        ),
        centerTitle: true, // Judul AppBar berada di tengah
        backgroundColor: Colors.white, // Warna latar belakang AppBar (putih)
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              color: Colors.white,
              // Warna latar belakang kontainer gambar skill (putih)
              child: Align(
                alignment: Alignment.center,
                child: ColorFiltered(
                  colorFilter: ColorFilter.mode(redColor, BlendMode.srcIn),
                  // Berlakukan efek color filter pada gambar skill (menjadi berwarna merah)
                  child: Image.network(
                    skillDisplayIcon,
                    // Tampilkan gambar skill dari URL skillDisplayIcon
                    width: 200, // Lebar gambar skill
                    height: 200, // Tinggi gambar skill
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 8.0,
              ),
              alignment: Alignment.center,
              child: Text(
                skillDescription, // Tampilkan deskripsi skill pada tampilan
                textAlign: TextAlign.center,
                // Atur teks deskripsi skill menjadi rata tengah
                style: const TextStyle(
                  color: Color(0xFF808080),
                  // Warna teks deskripsi skill (abu-abu)
                  fontSize: 15, // Ukuran teks deskripsi skill
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
