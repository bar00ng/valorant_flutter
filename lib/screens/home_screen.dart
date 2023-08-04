import 'package:flutter/material.dart';
import 'package:valorant_app/data/constant.dart'; // Import file constant.dart yang berisi konstanta seperti warna, ukuran, dll.
import 'package:valorant_app/widgets/agents_widget.dart'; // Import widget AgentsWidget yang ditampilkan di layar
import 'package:valorant_app/widgets/guns_widget.dart'; // Import widget GunsWidget yang ditampilkan di layar
import 'package:valorant_app/widgets/maps_widget.dart'; // Import widget MapsWidget yang ditampilkan di layar

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // Latar belakang halaman akan berwarna putih
      appBar: AppBar(
        title: Text(
          'Home', // Teks judul AppBar
          style: TextStyle(
            color: redColor,
            // Warna teks judul akan disesuaikan dengan nilai dari konstanta 'redColor'
            fontWeight: FontWeight.bold, // Teks judul akan ditebalkan (bold)
          ),
        ),
        automaticallyImplyLeading: false,
        // Hilangkan tombol back di AppBar
        iconTheme: IconThemeData(
          color:
              redColor, // Mengubah warna icon back di AppBar (tombol kembali)
        ),
        centerTitle: true,
        // Teks judul AppBar akan berada di tengah
        backgroundColor: Colors.white, // Warna AppBar akan berwarna putih
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          // Widget-child di dalam Column akan disusun dari kiri ke kanan
          children: [
            AgentsWidget(),
            // Tampilkan widget AgentsWidget di dalam halaman
            mySizeBox,
            // Gunakan widget mySizeBox dari file constant.dart untuk memberikan spasi
            MapsWidget(),
            // Tampilkan widget MapsWidget di dalam halaman
            mySizeBox,
            // Gunakan widget mySizeBox dari file constant.dart untuk memberikan spasi
            GunsWidget(),
            // Tampilkan widget GunsWidget di dalam halaman
          ],
        ),
      ),
    );
  }
}
