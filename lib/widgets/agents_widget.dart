import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:page_transition/page_transition.dart';
import 'package:logger/logger.dart';
import 'package:dio/dio.dart';

import 'package:valorant_app/data/constant.dart';
import 'package:valorant_app/screens/agent_detail_screen.dart';
import 'package:valorant_app/widgets/content_widget.dart';

// Inisialisasi logger untuk melakukan logging (optional)
var logger = Logger(
  printer: PrettyPrinter(
    methodCount: 0,
    // Jumlah metode dalam log yang akan ditampilkan (0 agar hanya menampilkan log dari kode yang kita tulis)
  ),
);

// Fungsi fetchData untuk mengambil data agent dari API menggunakan package dio
Future<List<dynamic>> fetchData() async {
  String request =
      'https://valorant-api.com/v1/agents?isPlayableCharacter=true';

  logger
      .t("Start fetch API agents"); // Log awal pengambilan data agent dari API

  try {
    final response = await Dio()
        .get(request); // Lakukan HTTP GET request ke API menggunakan dio

    if (response.statusCode == 200) {
      // Jika response status code adalah 200 (berhasil)
      logger.i(
          'Berhasil fetch API agents'); // Log berhasilnya pengambilan data agent dari API
      final res =
          response.data; // Response data dari API sudah dalam bentuk JSON
      final data = res['data']; // Ambil data agent dari hasil decode

      return data; // Kembalikan data agent
    } else {
      // Jika response status code tidak 200 (gagal)
      logger.e('Error!',
          error:
              'Terjadi kesalahan saat fetch API agents'); // Log error saat pengambilan data agent dari API

      throw Exception(
          'Failed to load API'); // Jika fetch API gagal, throw exception dengan pesan "Failed to load API"
    }
  } catch (e) {
    logger.e('Error!', error: e.toString());
    throw Exception(
        'Failed to load API'); // Jika fetch API gagal, throw exception dengan pesan "Failed to load API"
  }
}

// Widget AgentsWidget untuk menampilkan daftar agent dalam bentuk horizontal ListView
class AgentsWidget extends StatelessWidget {
  const AgentsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ContentWidget(
            title: 'Agents',
            // Teks judul dari ContentWidget
            description:
                'Berikut merupakan Agent yang dapat kamu mainkan di game Valorant. Klik untuk informasi lebih lanjut.',
            // Deskripsi dari ContentWidget
          ),
          Container(
            height: 200,
            child: FutureBuilder<List<dynamic>>(
              future: fetchData(),
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
                      color: redColor,
                      // Warna teks error (sesuai dengan nilai konstanta redColor)
                    ),
                  );
                } else {
                  final agents = snapshot.data!;

                  return ListView.builder(
                    scrollDirection: Axis.horizontal,
                    // ListView akan menyusun item secara horizontal
                    itemCount: agents.length,
                    // Jumlah item di ListView sesuai dengan jumlah data agent
                    itemBuilder: (context, index) {
                      var uuid = agents[index]['uuid']; // UUID dari agent
                      var agentName =
                          agents[index]['displayName']; // Nama agent
                      var displayIcon =
                          agents[index]['displayIcon']; // URL icon agent

                      return Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8.0,
                        ),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              // Navigasi ke halaman AgentDetailScreen saat salah satu agent dipilih
                              context,
                              PageTransition(
                                type: PageTransitionType.fade,
                                // Tipe transisi antar halaman saat berpindah ke halaman AgentDetailScreen
                                child: AgentDetailScreen(
                                  uuid: uuid,
                                  displayName: agentName,
                                ),
                              ),
                            );
                          },
                          child: Card(
                            elevation: 0,
                            // Tidak ada bayangan pada Card
                            color: Colors.grey,
                            // Warna latar belakang Card
                            child: Container(
                              width: 150,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: Image.network(
                                      displayIcon,
                                      // Tampilkan icon agent dari URL displayIcon
                                      width: 150,
                                      height: 150,
                                      fit: BoxFit.cover,
                                      // Tampilkan icon secara proporsional sesuai ukuran container
                                    ),
                                  ),
                                  const SizedBox(height: 3),
                                  Container(
                                    width: 150,
                                    color: Colors.white,
                                    // Warna latar belakang teks nama agent
                                    padding: const EdgeInsets.all(
                                      8.0,
                                    ),
                                    child: Align(
                                      alignment: Alignment.center,
                                      child: Text(
                                        agentName,
                                        // Tampilkan nama agent
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: redColor,
                                          // Warna teks nama agent
                                          fontWeight: FontWeight.bold,
                                          // Teks nama agent akan ditebalkan (bold)
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
