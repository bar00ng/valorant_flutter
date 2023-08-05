import 'package:flutter/material.dart';

class ContentWidget extends StatelessWidget {
  final String title; // Variabel untuk menyimpan judul konten
  final String description; // Variabel untuk menyimpan deskripsi konten

  ContentWidget({required this.title, required this.description});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      // Konten dalam Column akan disusun dari kiri ke kanan
      children: [
        Text(
          title, // Tampilkan judul konten
          style: const TextStyle(
            color: Color(0xFF808080), // Warna teks judul (abu-abu muda)
            fontSize: 24, // Ukuran font judul
            fontWeight: FontWeight.bold, // Teks judul akan ditebalkan (bold)
          ),
        ),
        const SizedBox(
          height:
              12, // Spacer (spasi vertikal) sebanyak 12 piksel antara judul dan deskripsi
        ),
        Text(
          description, // Tampilkan deskripsi konten
          style: const TextStyle(
            color: Color(0xFF808080), // Warna teks deskripsi (abu-abu muda)
            fontSize: 14, // Ukuran font deskripsi
            letterSpacing:
                1, // Spasi antar huruf pada deskripsi (menggunakan nilai 1 untuk sedikit spasi)
          ),
        ),
        const SizedBox(
          height:
              15, // Spacer (spasi vertikal) sebanyak 15 piksel setelah deskripsi
        ),
      ],
    );
  }
}
