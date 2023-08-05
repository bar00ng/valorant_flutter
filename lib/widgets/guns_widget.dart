import 'package:flutter/material.dart';
import 'package:http/http.dart'
    as http; // Package http untuk melakukan HTTP request
import 'dart:async'; // Package async untuk mengatur kode asynchronous
import 'dart:convert'; // Package untuk encoding/decoding JSON data
import 'package:logger/logger.dart'; // Package logger untuk melakukan logging

import 'package:loading_animation_widget/loading_animation_widget.dart'; // Package untuk menampilkan animasi loading
import 'package:page_transition/page_transition.dart'; // Package untuk mengatur tipe transisi antar halaman
import 'package:valorant_app/data/constant.dart'; // Import file constant.dart yang berisi konstanta seperti warna, ukuran, dll.
import 'package:valorant_app/screens/gun_detail_screen.dart'; // Import halaman GunDetailScreen yang akan ditampilkan saat detail senjata dipilih
import 'package:valorant_app/widgets/content_widget.dart'; // Import widget ContentWidget yang akan menampilkan judul dan deskripsi

var logger = Logger(
  printer: PrettyPrinter(
    methodCount:
        0, // Jumlah metode dalam log yang akan ditampilkan (0 agar hanya menampilkan log dari kode yang kita tulis)
  ),
);

Future<List<dynamic>> fetchData() async {
  String request =
      'https://valorant-api.com/v1/weapons'; // URL endpoint untuk mengambil data senjata dari API

  logger.t(
      "Start fetch API guns"); // Log untuk menandai awal pengambilan data senjata dari API
  final response =
      await http.get(Uri.parse(request)); // Lakukan HTTP GET request ke API

  if (response.statusCode == 200) {
    // Jika response status code adalah 200 (berhasil)
    logger.i(
        'Berhasil fetch API guns'); // Log untuk menandai berhasilnya pengambilan data senjata dari API
    final res = json.decode(response.body); // Decode data JSON dari response
    final data = res['data']; // Ambil data senjata dari hasil decode

    return data; // Kembalikan data senjata
  } else {
    // Jika response status code tidak 200 (gagal)
    logger.e(
      'Error!',
      error:
          'Terjadi kesalahan saat fetch API guns', // Log error untuk menandai kesalahan saat pengambilan data senjata dari API
    );

    throw Exception(
        'Failed to load API'); // Jika fetch API gagal, throw exception dengan pesan "Failed to load API"
  }
}

class GunsWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ContentWidget(
            title: 'Guns', // Teks judul dari ContentWidget
            description:
                'Pelajari juga persenjataan kamu!', // Deskripsi dari ContentWidget
          ),
          Container(
            height: 200,
            child: Center(
              child: FutureBuilder<List<dynamic>>(
                future: fetchData(),
                // Panggil fungsi fetchData() untuk mengambil data senjata dari API
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    // Jika masih dalam proses fetch data dari API
                    // Menampilkan loading animation ketika fetch data dari API
                    return LoadingAnimationWidget.prograssiveDots(
                      color: redColor,
                      // Warna loading animation (sesuai dengan nilai konstanta redColor)
                      size: 25, // Ukuran loading animation
                    );
                  } else if (snapshot.hasError) {
                    // Jika terjadi error saat fetch API
                    // Return pesan error jika fetch API gagal
                    return Text(
                      'Error : ${snapshot.error}', // Tampilkan pesan error
                      style: TextStyle(
                        color:
                            redColor, // Warna teks error (sesuai dengan nilai konstanta redColor)
                      ),
                    );
                  } else {
                    // Jika berhasil fetch API
                    final guns =
                        snapshot.data!; // Ambil data senjata dari snapshot

                    return ListView.builder(
                      itemCount:
                          guns.length, // Tampilkan semua senjata (misalnya)
                      itemBuilder: (context, index) {
                        final gun = guns[
                            index]; // Ambil data senjata berdasarkan indeks

                        final displayName = gun['displayName']; // Nama senjata
                        final uuid = gun['uuid']; // UUID senjata

                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              PageTransition(
                                type: PageTransitionType.fade,
                                // Tipe transisi antar halaman saat berpindah ke halaman GunDetailScreen
                                child: GunDetailScreen(
                                  uuid: uuid,
                                  // Kirim UUID senjata ke halaman GunDetailScreen
                                  displayName:
                                      displayName, // Kirim nama senjata ke halaman GunDetailScreen
                                ),
                              ),
                            );
                          },
                          child: ListTile(
                            title: Text(
                              displayName,
                              // Tampilkan nama senjata pada ListTile
                              style: TextStyle(
                                color:
                                    Colors.grey, // Warna teks senjata (abu-abu)
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
