import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:logger/logger.dart';
import 'dart:convert';

import 'package:valorant_app/data/constant.dart';

var logger = Logger(
  printer: PrettyPrinter(
    methodCount: 0,
  ),
);

class GunDetailScreen extends StatelessWidget {
  final String uuid;
  final String displayName;

  GunDetailScreen({
    required this.uuid,
    required this.displayName,
  });

  Future<Map<String, dynamic>> fetchData() async {
    String request = 'https://valorant-api.com/v1/weapons/$uuid?language=id-ID';

    logger.t("Start fetch data");
    final response = await http.get(Uri.parse(request));

    if (response.statusCode == 200) {
      logger.i('Berhasil fetch data');
      final res = json.decode(response.body);
      final data = res['data'];

      return data;
    } else {
      logger.e(
        'Error!',
        error: 'Terjadi kesalahan saat fetch data',
      );

      throw Exception('Failed to fetch data');
    }
  }

  String formatStatsTitle(String key) {
    final words = key.replaceAllMapped(
        RegExp(r'(?<=[a-z])[A-Z]'), (match) => ' ${match.group(0)!}');
    return words[0].toUpperCase() + words.substring(1);
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          displayName,
          style: TextStyle(
            color: redColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: IconThemeData(
          color: redColor,
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: fetchData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: LoadingAnimationWidget.prograssiveDots(
                color: redColor,
                size: 25,
              ),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error : ${snapshot.error}'),
            );
          } else {
            final weaponData = snapshot.data!;

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
                          weaponData['displayIcon'],
                          height: 200,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    GunShopCard(
                      gunName: displayName,
                      gunPrice: weaponData['shopData']['cost'],
                      gunCategory: weaponData['shopData']['category'],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      'Stats',
                      style: TextStyle(
                          color: redColor,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: 6,
                      itemBuilder: (context, index) {
                        final statsKeys =
                            weaponData['weaponStats'].keys.toList();
                        final statsTitle = formatStatsTitle(statsKeys[index]);
                        final statsValue =
                            weaponData['weaponStats'][statsKeys[index]];

                        return GunStatsCard(
                          statsTitle: statsTitle,
                          statsNumber: statsValue.toString(),
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

class GunStatsCard extends StatelessWidget {
  final String statsTitle;
  final String statsNumber;

  const GunStatsCard({required this.statsTitle, required this.statsNumber});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.symmetric(
        horizontal: 16.0,
      ),
      child: Center(
        child: Card(
          elevation: 0,
          shape: Border(
            bottom: BorderSide(
              color: redColor,
              width: 2.0,
            ),
          ),
          child: Container(
            height: 50,
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  statsTitle,
                  style: TextStyle(
                    color: redColor,
                    fontSize: 16,
                  ),
                ),
                Text(
                  statsNumber,
                  style: TextStyle(
                    color: redColor,
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

class GunShopCard extends StatelessWidget {
  final String gunName;
  final int gunPrice;
  final String gunCategory;

  GunShopCard({
    required this.gunName,
    required this.gunPrice,
    required this.gunCategory,
  });

  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Card(
        elevation: 4,
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
                      gunName,
                      style: TextStyle(
                        color: redColor,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.left,
                    ),
                    Text(
                      gunCategory,
                      style: TextStyle(
                        color: redColor,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                '${gunPrice} VP',
                style: TextStyle(color: redColor, fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
