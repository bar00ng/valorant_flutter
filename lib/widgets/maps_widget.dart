import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:page_transition/page_transition.dart';
import 'package:valorant_app/data/constant.dart';
import 'package:logger/logger.dart';
import 'dart:convert';
import 'package:valorant_app/screens/map_detail_screen.dart';
import 'package:valorant_app/widgets/content_widget.dart';

var logger = Logger(
  printer: PrettyPrinter(
    methodCount: 0,
  ),
);

class MapsWidget extends StatefulWidget {
  @override
  _MapsWidgetState createState() => _MapsWidgetState();
}

class _MapsWidgetState extends State<MapsWidget> {
  List<dynamic> _dataMaps = [];

  void initState() {
    super.initState();
    fetchDataMaps();
  }

  Future<void> fetchDataMaps() async {
    String request = 'https://valorant-api.com/v1/maps';
    try {
      logger.t("Start Fetch API Maps");
      final response = await http.get(Uri.parse(request));

      if (response.statusCode == 200) {
        setState(() {
          _dataMaps = json.decode(response.body)['data'];
          logger.i('Berhasil Feth API Maps');
        });
      } else {
        logger.e('Error!', error: 'Terjadi Kesalahan Saat Fetch API Maps');
      }
    } catch (e) {
      logger.e(
        'Error!',
        error: e,
      );
    }
  }

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
            height: 200,
            child: ListView.builder(
              itemCount: _dataMaps.length,
              itemBuilder: (context, index) {
                var mapUuid = _dataMaps[index]['uuid'];
                var mapName = _dataMaps[index]['displayName'];
                var displayIconUrl = _dataMaps[index]['splash'];

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
                            uuid: mapUuid,
                            displayName: mapName,
                          ),
                        ),
                      );
                    },
                    child: Card(
                      elevation: 0,
                      color: redColor,
                      child: Stack(
                        children: [
                          ColorFiltered(
                            colorFilter: ColorFilter.mode(
                                Colors.black.withOpacity(0.5),
                                BlendMode.srcATop),
                            child: Image.network(
                              displayIconUrl,
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
                              mapName,
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
            ),
          ),
        ],
      ),
    );
  }
}
