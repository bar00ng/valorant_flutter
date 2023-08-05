import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:loading_animation_widget/loading_animation_widget.dart'; // Package untuk menampilkan animasi loading
import 'dart:convert';
import 'package:logger/logger.dart'; // Package logger untuk melakukan logging

import 'package:valorant_app/data/constant.dart';

var logger = Logger(
  printer: PrettyPrinter(
    methodCount:
        0, // Jumlah metode dalam log yang akan ditampilkan (0 agar hanya menampilkan log dari kode yang kita tulis)
  ),
);

class MapDetailScreen extends StatelessWidget {
  final String uuid;
  final String displayName;

  const MapDetailScreen({
    required this.uuid,
    required this.displayName,
  });

  // Fungsi untuk mengambil data maps dari API berdasarkan UUID
  Future<Map<String, dynamic>> fetchData() async {
    String request =
        'https://valorant-api.com/v1/maps/$uuid?language=id-ID'; // URL endpoint untuk mengambil data maps dari API

    logger.t(
        "Start fetch data"); // Log untuk menandai awal pengambilan data maps dari API
    final response =
        await http.get(Uri.parse(request)); // Lakukan HTTP GET request ke API

    if (response.statusCode == 200) {
      // Jika response status code adalah 200 (berhasil)
      logger.i(
          'Berhasil fetch data'); // Log untuk menandai berhasilnya pengambilan data maps dari API
      final res = json.decode(response.body); // Decode data JSON dari response
      final data = res['data']; // Ambil data maps dari hasil decode

      return data; // Kembalikan data maps
    } else {
      // Jika response status code tidak 200 (gagal)
      logger.e(
        'Error!',
        error:
            'Terjadi kesalahan saat fetch data', // Log error untuk menandai kesalahan saat pengambilan data maps dari API
      );

      throw Exception(
          'Failed to fetch data'); // Jika fetch data maps gagal, throw exception dengan pesan "Failed to fetch data"
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          displayName,
          style: TextStyle(color: redColor, fontWeight: FontWeight.bold),
        ),
        iconTheme: IconThemeData(
          color: redColor, // Change the color of the back icon here
        ),
        centerTitle: true, // Mengatur teks judul berada di tengah
        backgroundColor: Colors.white,
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: fetchData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Jika masih dalam proses fetch data dari API
            return Center(
              child: LoadingAnimationWidget.prograssiveDots(
                color: redColor,
                // Warna loading animation (sesuai dengan nilai konstanta redColor)
                size: 25, // Ukuran loading animation
              ),
            );
          } else if (snapshot.hasError) {
            // Jika terjadi error saat fetch API
            return Center(
              child: Text('Error : ${snapshot.error}'), // Tampilkan pesan error
            );
          } else {
            final mapData = snapshot.data!;

            return Container(
              height: MediaQuery.of(context).size.height,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      color: Colors.grey,
                      child: Align(
                        alignment: Alignment.center,
                        child: Image.network(
                          mapData['splash'],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      'Layout Map',
                      style: TextStyle(
                        color: redColor,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Container(
                      color: Colors.grey,
                      child: Align(
                        alignment: Alignment.center,
                        child: Image.network(
                          mapData['displayIcon'],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
