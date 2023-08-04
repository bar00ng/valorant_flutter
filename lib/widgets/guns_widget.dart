import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:logger/logger.dart';

import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:page_transition/page_transition.dart';
import 'package:valorant_app/data/constant.dart';
import 'package:valorant_app/screens/gun_detail_screen.dart';
import 'package:valorant_app/widgets/content_widget.dart';

var logger = Logger(
  printer: PrettyPrinter(
    methodCount: 0,
  ),
);

Future<List<dynamic>> fetchData() async {
  String request = 'https://valorant-api.com/v1/weapons';

  logger.t("Start fetch API guns");
  final response = await http.get(Uri.parse(request));

  if (response.statusCode == 200) {
    logger.i('Berhasil fetch API guns');
    final res = json.decode(response.body);
    final data = res['data'];

    return data;
  } else {
    logger.e(
      'Error!',
      error: 'Terjadi kesalahan saat fetch API guns',
    );

    throw Exception('Failed to load API');
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
            title: 'Guns',
            description: 'Pelajari juga persenjataan kamu!',
          ),
          Container(
            height: 200,
            child: Center(
              child: FutureBuilder<List<dynamic>>(
                future: fetchData(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    // Menampilkan loading animation ketika fetch data dari API
                    return LoadingAnimationWidget.prograssiveDots(
                      color: redColor,
                      size: 25,
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
                    // Jika berhasil fetch API
                    final guns = snapshot.data!;

                    return ListView.builder(
                      itemCount: 5,
                      itemBuilder: (context, index) {
                        final gun = guns[index];

                        final displayName = gun['displayName'];
                        final uuid = gun['uuid'];

                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              PageTransition(
                                type: PageTransitionType.fade,
                                child: GunDetailScreen(
                                  uuid: uuid,
                                  displayName: displayName,
                                ),
                              ),
                            );
                          },
                          child: ListTile(
                            title: Text(displayName),
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
