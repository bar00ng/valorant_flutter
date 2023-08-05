import 'package:flutter/material.dart';
import 'package:http/http.dart'
    as http; // Package http untuk melakukan HTTP request
import 'package:page_transition/page_transition.dart'; // Package untuk mengatur tipe transisi antar halaman
import 'dart:convert'; // Package untuk encoding/decoding JSON data
import 'package:logger/logger.dart'; // Package logger untuk melakukan logging

import 'package:valorant_app/data/constant.dart'; // Import file constant.dart yang berisi konstanta seperti warna, ukuran, dll.
import 'package:valorant_app/screens/agent_detail_screen.dart'; // Import halaman AgentDetailScreen yang akan ditampilkan saat detail agent dipilih
import 'package:valorant_app/widgets/content_widget.dart'; // Import widget ContentWidget yang akan menampilkan judul dan deskripsi

var logger = Logger(
  printer: PrettyPrinter(
    methodCount:
        0, // Jumlah metode dalam log yang akan ditampilkan (0 agar hanya menampilkan log dari kode yang kita tulis)
  ),
);

class AgentsWidget extends StatefulWidget {
  @override
  _AgentsWidgetState createState() => _AgentsWidgetState();
}

class _AgentsWidgetState extends State<AgentsWidget> {
  List<dynamic> _dataAgents = []; // List yang akan berisi data agent dari API

  void initState() {
    super.initState();
    fetchDataAgents(); // Panggil fungsi untuk mengambil data agent dari API saat widget diinisialisasi
  }

  Future<void> fetchDataAgents() async {
    String request =
        'https://valorant-api.com/v1/agents?isPlayableCharacter=true'; // URL endpoint untuk mengambil data agent dari API
    try {
      logger.t(
          "Start Fetch API Agents"); // Log untuk menandai awal pengambilan data agent dari API
      final response =
          await http.get(Uri.parse(request)); // Lakukan HTTP GET request ke API

      if (response.statusCode == 200) {
        // Jika response status code adalah 200 (berhasil)
        setState(() {
          _dataAgents = json.decode(response.body)[
              'data']; // Decode data JSON dari response dan simpan ke dalam _dataAgents
          logger.i(
              'Berhasil Fetch API Agents'); // Log untuk menandai berhasilnya pengambilan data agent dari API
        });
      } else {
        // Jika response status code tidak 200 (gagal)
        logger.e('Error!',
            error:
                'Terjadi Kesalahan Saat Fetch API Agents'); // Log error untuk menandai kesalahan saat pengambilan data agent dari API
      }
    } catch (e) {
      // Tangani exception jika terjadi error saat melakukan HTTP request
      logger.e(
        'Error!',
        error: e,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ContentWidget(
            title: 'Agents', // Teks judul dari ContentWidget
            description:
                'Berikut merupakan Agent yang dapat kamu mainkan di game Valorant. Klik untuk informasi lebih lanjut.', // Deskripsi dari ContentWidget
          ),
          Container(
            height: 200,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              // ListView akan menyusun item secara horizontal
              itemCount: _dataAgents.length,
              // Jumlah item di ListView sesuai dengan jumlah data agent
              itemBuilder: (context, index) {
                var uuid = _dataAgents[index]['uuid']; // UUID dari agent
                var agentName = _dataAgents[index]['displayName']; // Nama agent
                var displayIcon =
                    _dataAgents[index]['displayIcon']; // URL icon agent

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
                      elevation: 0, // Tidak ada bayangan pada Card
                      color: Colors.grey, // Warna latar belakang Card
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
                                fit: BoxFit
                                    .cover, // Tampilkan icon secara proporsional sesuai ukuran container
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
                                  agentName, // Tampilkan nama agent
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: redColor, // Warna teks nama agent
                                    fontWeight: FontWeight
                                        .bold, // Teks nama agent akan ditebalkan (bold)
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
        ],
      ),
    );
  }
}
