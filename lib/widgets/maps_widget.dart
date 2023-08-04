import 'package:flutter/material.dart';
import 'package:http/http.dart'
    as http; // Package http untuk melakukan HTTP request
import 'package:page_transition/page_transition.dart'; // Package untuk mengatur tipe transisi antar halaman
import 'package:valorant_app/data/constant.dart'; // Import file constant.dart yang berisi konstanta seperti warna, ukuran, dll.
import 'package:logger/logger.dart'; // Package logger untuk melakukan logging
import 'dart:convert'; // Package untuk encoding/decoding JSON data
import 'package:valorant_app/screens/map_detail_screen.dart'; // Import halaman MapDetailScreen yang akan ditampilkan saat detail peta dipilih
import 'package:valorant_app/widgets/content_widget.dart'; // Import widget ContentWidget yang akan menampilkan judul dan deskripsi
import 'package:loading_animation_widget/loading_animation_widget.dart'; // Package untuk menampilkan animasi loading

var logger = Logger(
  printer: PrettyPrinter(
    methodCount:
        0, // Jumlah metode dalam log yang akan ditampilkan (0 agar hanya menampilkan log dari kode yang kita tulis)
  ),
);

Future<List<dynamic>> fetchData() async {
  String request =
      'https://valorant-api.com/v1/maps'; // URL endpoint untuk mengambil data peta dari API

  logger.t(
      "Start fetch API maps"); // Log untuk menandai awal pengambilan data peta dari API
  final response =
      await http.get(Uri.parse(request)); // Lakukan HTTP GET request ke API

  if (response.statusCode == 200) {
    // Jika response status code adalah 200 (berhasil)
    logger.i(
        'Berhasil fetch API maps'); // Log untuk menandai berhasilnya pengambilan data peta dari API
    final res = json.decode(response.body); // Decode data JSON dari response
    final data = res['data']; // Ambil data peta dari hasil decode

    return data; // Kembalikan data peta
  } else {
    // Jika response status code tidak 200 (gagal)
    logger.e(
      'Error!',
      error:
          'Terjadi kesalahan saat fetch API maps', // Log error untuk menandai kesalahan saat pengambilan data peta dari API
    );

    throw Exception(
        'Failed to load API'); // Jika fetch API gagal, throw exception dengan pesan "Failed to load API"
  }
}

class MapsWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ContentWidget(
            title: 'Maps', // Teks judul dari ContentWidget
            description:
                'Kenali playground kamu sekarang juga!', // Deskripsi dari ContentWidget
          ),
          Container(
            height: 250,
            child: FutureBuilder<List<dynamic>>(
              future: fetchData(),
              // Panggil fungsi fetchData() untuk mengambil data peta dari API
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  // Jika masih dalam proses fetch data dari API
                  // Menampilkan loading animation ketika fetch data dari API
                  return Center(
                    child: LoadingAnimationWidget.prograssiveDots(
                      color: redColor,
                      // Warna loading animation (sesuai dengan nilai konstanta redColor)
                      size: 25, // Ukuran loading animation
                    ),
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
                  final maps = snapshot.data!; // Ambil data peta dari snapshot

                  return ListView.builder(
                    itemCount: 5, // Tampilkan hanya 5 peta (misalnya)
                    itemBuilder: (context, index) {
                      final map =
                          maps[index]; // Ambil data peta berdasarkan indeks

                      return Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(8.0),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              PageTransition(
                                type: PageTransitionType.fade,
                                // Tipe transisi antar halaman saat berpindah ke halaman MapDetailScreen
                                child: MapDetailScreen(
                                  uuid: map['uuid'],
                                  // Kirim UUID peta ke halaman MapDetailScreen
                                  displayName: map[
                                      'displayName'], // Kirim nama peta ke halaman MapDetailScreen
                                ),
                              ),
                            );
                          },
                          child: Card(
                            elevation: 0, // Tidak ada bayangan pada Card
                            color: Colors.grey, // Warna latar belakang Card
                            child: Stack(
                              children: [
                                ColorFiltered(
                                  colorFilter: ColorFilter.mode(
                                      Colors.black.withOpacity(0.5),
                                      BlendMode.srcATop),
                                  child: Image.network(
                                    map['splash'],
                                    // Tampilkan gambar peta dari URL splash
                                    width: double.infinity,
                                    height: 150,
                                    fit: BoxFit
                                        .cover, // Tampilkan gambar secara proporsional sesuai ukuran container
                                  ),
                                ),
                                Container(
                                  width: double.infinity,
                                  height: 150,
                                  alignment: Alignment.center,
                                  child: Text(
                                    map['displayName'],
                                    // Tampilkan nama peta di tengah gambar
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: redColor,
                                      // Warna teks nama peta (sesuai dengan nilai konstanta redColor)
                                      fontWeight: FontWeight
                                          .bold, // Teks nama peta akan ditebalkan (bold)
                                    ),
                                  ),
                                ),
                              ],
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
        ],
      ),
    );
  }
}
