import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:valorant_app/data/constant.dart';
import 'dart:convert';
import 'package:logger/logger.dart';
import 'package:valorant_app/widgets/content_widget.dart';

var logger = Logger(
  printer: PrettyPrinter(
    methodCount: 0,
  ),
);

class GunsWidget extends StatefulWidget {
  @override
  _GunsWidgetState createState() => _GunsWidgetState();
}

class _GunsWidgetState extends State<GunsWidget> {
  List<dynamic> _dataGuns = [];

  void initState() {
    super.initState();
    fetcDataGuns();
  }

  Future<void> fetcDataGuns() async {
    String request = 'https://valorant-api.com/v1/guns';
    try {
      logger.t("Start Fetch API Guns");
      final response = await http.get(Uri.parse(request));

      if (response.statusCode == 200) {
        setState(() {
          _dataGuns = json.decode(response.body)['data'];
          logger.i('Berhasil Feth API Guns');
        });
      } else {
        logger.e('Error!', error: 'Terjadi Kesalahan Saat Fetch API Guns');
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
            title: 'Guns',
            description: 'Pelajari juga persenjataan kamu!',
          ),
        ],
      ),
    );
  }
}
