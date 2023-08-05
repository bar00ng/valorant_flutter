import 'package:flutter/material.dart';
import 'package:http/http.dart'
    as http; // Package http untuk melakukan HTTP request
import 'dart:convert'; // Package untuk encoding/decoding JSON data
import 'package:logger/logger.dart'; // Package logger untuk melakukan logging
import 'package:loading_animation_widget/loading_animation_widget.dart'; // Package untuk menampilkan animasi loading
import 'package:page_transition/page_transition.dart'; // Package untuk mengatur tipe transisi antar halaman

import 'package:valorant_app/data/constant.dart'; // Import file constant.dart yang berisi konstanta seperti warna, ukuran, dll.
import 'package:valorant_app/screens/skill_detail_screen.dart'; // Import halaman SkillDetailScreen yang akan ditampilkan saat detail kemampuan agen dipilih

var logger = Logger(
  printer: PrettyPrinter(
    methodCount:
        0, // Jumlah metode dalam log yang akan ditampilkan (0 agar hanya menampilkan log dari kode yang kita tulis)
  ),
);

class AgentDetailScreen extends StatelessWidget {
  final String uuid;
  final String displayName;

  const AgentDetailScreen({
    required this.uuid,
    required this.displayName,
  });

  Future<Map<String, dynamic>> fetchData() async {
    String request =
        'https://valorant-api.com/v1/agents/$uuid?language=id-ID'; // URL endpoint untuk mengambil data agen dari API

    logger.t(
        "Start fetch data"); // Log untuk menandai awal pengambilan data agen dari API
    final response =
        await http.get(Uri.parse(request)); // Lakukan HTTP GET request ke API

    if (response.statusCode == 200) {
      // Jika response status code adalah 200 (berhasil)
      logger.i(
          'Berhasil fetch data'); // Log untuk menandai berhasilnya pengambilan data agen dari API
      final res = json.decode(response.body); // Decode data JSON dari response
      final data = res['data']; // Ambil data agen dari hasil decode

      return data; // Kembalikan data agen
    } else {
      // Jika response status code tidak 200 (gagal)
      logger.e(
        'Error!',
        error:
            'Terjadi kesalahan saat fetch data', // Log error untuk menandai kesalahan saat pengambilan data agen dari API
      );

      throw Exception(
          'Failed to fetch data'); // Jika fetch data agen gagal, throw exception dengan pesan "Failed to fetch data"
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          displayName, // Tampilkan nama agen pada judul AppBar
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
        child: Container(
          child: FutureBuilder<Map<String, dynamic>>(
            future: fetchData(),
            // Panggil fungsi fetchData() untuk mengambil data agen dari API
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
                  child: Text(
                      'Error : ${snapshot.error}'), // Tampilkan pesan error
                );
              } else {
                final agentData =
                    snapshot.data!; // Ambil data agen dari snapshot

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      color: Colors.grey,
                      // Warna latar belakang container gambar agen (abu-abu)
                      child: Align(
                        alignment: Alignment.center,
                        child: Image.network(
                          agentData[
                              'displayIcon'], // Tampilkan gambar agen dari URL displayIcon
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
                        agentData['description'],
                        // Tampilkan deskripsi agen di tengah container
                        textAlign: TextAlign.center,
                        // Teks akan diatur menjadi rata tengah
                        style: const TextStyle(
                          color: Color(0xFF808080),
                          // Warna teks deskripsi agen (abu-abu)
                          fontSize: 15, // Ukuran teks deskripsi agen
                        ),
                      ),
                    ),
                    MyDivider(), // Widget garis pemisah
                    Text(
                      "Roles", // Teks "Roles"
                      style: TextStyle(
                        color: redColor,
                        // Warna teks "Roles" (sesuai dengan nilai konstanta redColor)
                        fontSize: 24,
                        // Ukuran teks "Roles"
                        fontWeight: FontWeight
                            .bold, // Teks "Roles" akan ditebalkan (bold)
                      ),
                    ),
                    ColorFiltered(
                      colorFilter: ColorFilter.mode(redColor, BlendMode.srcIn),
                      // Warna gambar role akan diubah sesuai dengan warna redColor
                      child: Image.network(
                        agentData['role']['displayIcon'],
                        // Tampilkan gambar role agen dari URL displayIcon role
                        height: 200, // Ukuran tinggi gambar role
                        width: 200, // Ukuran lebar gambar role
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8.0,
                      ),
                      child: Text(
                        agentData['role']['description'],
                        // Tampilkan deskripsi role agen
                        textAlign: TextAlign.center,
                        // Teks akan diatur menjadi rata tengah
                        style: const TextStyle(
                          color: Color(0xFF808080),
                          // Warna teks deskripsi role (abu-abu)
                          fontSize: 15, // Ukuran teks deskripsi role
                        ),
                      ),
                    ),
                    MyDivider(), // Widget garis pemisah
                    Text(
                      "Abilities", // Teks "Abilities"
                      style: TextStyle(
                        color: redColor,
                        // Warna teks "Abilities" (sesuai dengan nilai konstanta redColor)
                        fontSize: 24,
                        // Ukuran teks "Abilities"
                        fontWeight: FontWeight
                            .bold, // Teks "Abilities" akan ditebalkan (bold)
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Container(
                      height: 150, // Tinggi container list kemampuan agen
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        // List kemampuan akan menggulir secara horizontal
                        itemCount: 4,
                        // Jumlah kemampuan agen yang akan ditampilkan (disesuaikan sesuai data)
                        itemBuilder: (context, index) {
                          final ability = agentData['abilities'][
                              index]; // Ambil data kemampuan agen berdasarkan index

                          return Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10.0,
                            ),
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  PageTransition(
                                    type: PageTransitionType.fade,
                                    // Tipe transisi halaman (fade)
                                    child: SkillDetailScreen(
                                      skillDescription: ability['description'],
                                      // Deskripsi kemampuan yang akan ditampilkan di halaman SkillDetailScreen
                                      skillDisplayIcon: ability['displayIcon'],
                                      // URL gambar kemampuan yang akan ditampilkan di halaman SkillDetailScreen
                                      skillName: ability[
                                          'displayName'], // Nama kemampuan yang akan ditampilkan di halaman SkillDetailScreen
                                    ),
                                  ),
                                );
                              },
                              child: Card(
                                elevation: 0,
                                // Tidak ada bayangan pada Card
                                color: Colors.white,
                                // Warna latar belakang Card (putih)
                                child: Container(
                                  width: 150, // Lebar Card
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Expanded(
                                        child: ColorFiltered(
                                          colorFilter: ColorFilter.mode(
                                              redColor, BlendMode.srcIn),
                                          // Warna gambar kemampuan akan diubah sesuai dengan warna redColor
                                          child: Image.network(
                                            ability['displayIcon'] ?? '',
                                            // Tampilkan gambar kemampuan dari URL displayIcon kemampuan
                                            height: 100,
                                            // Ukuran tinggi gambar kemampuan
                                            width:
                                                100, // Ukuran lebar gambar kemampuan
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Container(
                                        width: 150,
                                        // Lebar kontainer nama kemampuan
                                        color: Colors.white,
                                        // Warna latar belakang kontainer nama kemampuan (putih)
                                        padding: const EdgeInsets.all(
                                          8.0,
                                        ),
                                        child: Align(
                                          alignment: Alignment.center,
                                          child: Text(
                                            ability['displayName'] ?? '',
                                            // Tampilkan nama kemampuan
                                            style: const TextStyle(
                                              fontSize: 14,
                                              // Ukuran teks nama kemampuan
                                              color: Color(0xFFfb3e44),
                                              // Warna teks nama kemampuan (merah)
                                              fontWeight: FontWeight
                                                  .bold, // Teks nama kemampuan akan ditebalkan (bold)
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                  ],
                );
              }
            },
          ),
        ),
      ),
    );
  }
}

class MyDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 20,
        ),
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 8.0,
          ),
          child: Divider(
            color: redColor,
            // Warna garis pemisah (sesuai dengan nilai konstanta redColor)
            thickness: 1.0, // Ketebalan garis pemisah
          ),
        ),
        const SizedBox(
          height: 20,
        ),
      ],
    );
  }
}
