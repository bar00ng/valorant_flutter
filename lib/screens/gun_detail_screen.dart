import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart'; // Package untuk menampilkan animasi loading
import 'package:logger/logger.dart'; // Package logger untuk melakukan logging
import 'package:dio/dio.dart';

import 'package:valorant_app/data/constant.dart'; // Import file constant.dart yang berisi konstanta seperti warna, ukuran, dll.

var logger = Logger(
  printer: PrettyPrinter(
    methodCount:
        0, // Jumlah metode dalam log yang akan ditampilkan (0 agar hanya menampilkan log dari kode yang kita tulis)
  ),
);

class GunDetailScreen extends StatelessWidget {
  final String uuid;
  final String displayName;

  const GunDetailScreen({
    required this.uuid,
    required this.displayName,
  });

  // Fungsi untuk mengambil data senjata dari API berdasarkan UUID
  Future<Map<String, dynamic>> fetchData() async {
    String request =
        'https://valorant-api.com/v1/weapons/$uuid?language=id-ID'; // URL endpoint untuk mengambil data senjata dari API

    logger.t(
        "Start fetch API senjata"); // Log awal pengambilan data weapon dari API

    try {
      final response = await Dio()
          .get(request); // Lakukan HTTP GET request ke API menggunakan dio

      if (response.statusCode == 200) {
        // Jika response status code adalah 200 (berhasil)
        logger.i(
            'Berhasil fetch API senjata'); // Log berhasilnya pengambilan data weapon dari API
        final res =
            response.data; // Response data dari API sudah dalam bentuk JSON
        final data = res['data']; // Ambil data weapon dari hasil decode

        return data; // Kembalikan data weapon
      } else {
        // Jika response status code tidak 200 (gagal)
        logger.e('Error!',
            error:
                'Terjadi kesalahan saat fetch API senjata'); // Log error saat pengambilan data weapon dari API

        throw Exception(
            'Failed to load API'); // Jika fetch API gagal, throw exception dengan pesan "Failed to load API"
      }
    } catch (e) {
      logger.e('Error!', error: e.toString());
      throw Exception(
          'Failed to load API'); // Jika fetch API gagal, throw exception dengan pesan "Failed to load API"
    }
  }

  // Fungsi untuk mengubah format judul statistik (dari camel case menjadi judul yang lebih ramah)
  String formatStatsTitle(String key) {
    final words = key.replaceAllMapped(
        RegExp(r'(?<=[a-z])[A-Z]'), (match) => ' ${match.group(0)!}');
    return words[0].toUpperCase() + words.substring(1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          displayName, // Tampilkan nama senjata pada judul AppBar
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
      body: FutureBuilder<Map<String, dynamic>>(
        future: fetchData(),
        // Panggil fungsi fetchData() untuk mengambil data senjata dari API
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
            final weaponData =
                snapshot.data!; // Ambil data senjata dari snapshot

            return Container(
              height: MediaQuery.of(context).size.height,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      color: Colors.grey,
                      // Warna latar belakang container gambar senjata (abu-abu)
                      child: Align(
                        alignment: Alignment.center,
                        child: Image.network(
                          weaponData['displayIcon'],
                          // Tampilkan gambar senjata dari URL displayIcon
                          height: 200, // Ukuran tinggi gambar senjata
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    GunShopCard(
                      gunName: displayName,
                      // Nama senjata yang akan ditampilkan pada GunShopCard
                      gunPrice: weaponData['shopData']['cost'],
                      // Harga senjata yang akan ditampilkan pada GunShopCard
                      gunCategory: weaponData['shopData'][
                          'category'], // Kategori senjata yang akan ditampilkan pada GunShopCard
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      'Stats', // Teks "Stats"
                      style: TextStyle(
                          color: redColor,
                          // Warna teks "Stats" (sesuai dengan nilai konstanta redColor)
                          fontSize: 20,
                          // Ukuran teks "Stats"
                          fontWeight: FontWeight
                              .bold), // Teks "Stats" akan ditebalkan (bold)
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: 6,
                      // Jumlah statistik senjata yang akan ditampilkan (disesuaikan sesuai data)
                      itemBuilder: (context, index) {
                        final statsKeys =
                            weaponData['weaponStats'].keys.toList();
                        final statsTitle = formatStatsTitle(
                            statsKeys[index]); // Ubah format judul statistik
                        final statsValue = weaponData['weaponStats'][statsKeys[
                            index]]; // Ambil nilai statistik berdasarkan index

                        return GunStatsCard(
                          statsTitle: statsTitle,
                          // Judul statistik yang akan ditampilkan pada GunStatsCard
                          statsNumber: statsValue
                              .toString(), // Nilai statistik yang akan ditampilkan pada GunStatsCard
                        );
                      },
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

// Widget untuk menampilkan statistik senjata pada GunDetailScreen
class GunStatsCard extends StatelessWidget {
  final String statsTitle;
  final String statsNumber;

  const GunStatsCard({
    required this.statsTitle,
    required this.statsNumber,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context)
          .size
          .width, // Lebar kontainer sesuai dengan lebar layar
      padding: const EdgeInsets.symmetric(
        horizontal: 16.0,
      ),
      child: Center(
        child: Card(
          elevation: 0, // Tidak ada bayangan pada Card
          shape: Border(
            bottom: BorderSide(
              color: redColor,
              // Warna garis bawah pada GunStatsCard (sesuai dengan nilai konstanta redColor)
              width: 2.0, // Ketebalan garis bawah pada GunStatsCard
            ),
          ),
          child: Container(
            height: 50, // Tinggi kontainer GunStatsCard
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  statsTitle, // Tampilkan judul statistik pada GunStatsCard
                  style: TextStyle(
                    color: redColor,
                    // Warna teks judul statistik (sesuai dengan nilai konstanta redColor)
                    fontSize: 16, // Ukuran teks judul statistik
                  ),
                ),
                Text(
                  statsNumber, // Tampilkan nilai statistik pada GunStatsCard
                  style: TextStyle(
                    color:
                        redColor, // Warna teks nilai statistik (sesuai dengan nilai konstanta redColor)
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Widget untuk menampilkan informasi senjata pada GunDetailScreen
class GunShopCard extends StatelessWidget {
  final String gunName;
  final int gunPrice;
  final String gunCategory;

  const GunShopCard({
    required this.gunName,
    required this.gunPrice,
    required this.gunCategory,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Card(
        elevation: 4, // Ketinggian Card (bayangan)
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 15.0,
            vertical: 12.0,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      gunName, // Tampilkan nama senjata pada GunShopCard
                      style: TextStyle(
                        color: redColor,
                        // Warna teks nama senjata (sesuai dengan nilai konstanta redColor)
                        fontSize: 20,
                        // Ukuran teks nama senjata
                        fontWeight: FontWeight
                            .bold, // Teks nama senjata akan ditebalkan (bold)
                      ),
                      textAlign: TextAlign.left,
                    ),
                    Text(
                      gunCategory,
                      // Tampilkan kategori senjata pada GunShopCard
                      style: TextStyle(
                        color: redColor,
                        // Warna teks kategori senjata (sesuai dengan nilai konstanta redColor)
                        fontSize: 12, // Ukuran teks kategori senjata
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                '${gunPrice} VP',
                // Tampilkan harga senjata dalam bentuk 'VP' (Valorant Points) pada GunShopCard
                style: TextStyle(
                  color: redColor,
                  fontSize: 16,
                ), // Warna dan ukuran teks harga (sesuai dengan nilai konstanta redColor)
              ),
            ],
          ),
        ),
      ),
    );
  }
}
