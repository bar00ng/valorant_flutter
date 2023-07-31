import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:page_transition/page_transition.dart';
import 'package:valorant_app/data/constant.dart';
import 'package:logger/logger.dart';
import 'dart:convert';
import 'package:valorant_app/screens/map_detail_screen.dart';
import 'package:valorant_app/widgets/content_widget.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

var logger = Logger(
  printer: PrettyPrinter(
    methodCount: 0,
  ),
);

Future<List<dynamic>> fetchData() async {
  String request = 'https://valorant-api.com/v1/maps';

  logger.t("Start fetch API maps");
  final response = await http.get(Uri.parse(request));

  if (response.statusCode == 200) {
    logger.i('Berhasil fetch API maps');
    final res = json.decode(response.body);
    final data = res['data'];

    return data;
  } else {
    logger.e(
      'Error!',
      error: 'Terjadi kesalahan saat fetch API maps',
    );

    throw Exception('Failed to load API');
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
            title: 'Maps',
            description: 'Kenali playground kamu sekarang juga!',
          ),
          Container(
            height: 250,
            child: FutureBuilder<List<dynamic>>(
              future: fetchData(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  // Menampilkan loading animation ketika fetch data dari API
                  return Center(
                    child: LoadingAnimationWidget.prograssiveDots(
                      color: redColor,
                      size: 25,
                    ),
                  );
                } else if (snapshot.hasError) {
                  // Return persan error jika fetch API gagal
                  return Text(
                    'Error : ${snapshot.error}',
                    style: TextStyle(
                      color: redColor,
                    ),
                  );
                } else {
                  final maps = snapshot.data!;

                  return ListView.builder(
                    itemCount: 5,
                    itemBuilder: (context, index) {
                      final map = maps[index];

                      return Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(8.0),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              PageTransition(
                                type: PageTransitionType.fade,
                                child: MapDetailScreen(
                                  uuid: map['uuid'],
                                  displayName: map['diplayName'],
                                ),
                              ),
                            );
                          },
                          child: Card(
                            elevation: 0,
                            color: Colors.grey,
                            child: Stack(
                              children: [
                                ColorFiltered(
                                  colorFilter: ColorFilter.mode(
                                      Colors.black.withOpacity(0.5),
                                      BlendMode.srcATop),
                                  child: Image.network(
                                    map['splash'],
                                    width: double.infinity,
                                    height: 150,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                Container(
                                  width: double.infinity,
                                  height: 150,
                                  alignment: Alignment.center,
                                  child: Text(
                                    map['displayName'],
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: redColor,
                                      fontWeight: FontWeight.bold,
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
