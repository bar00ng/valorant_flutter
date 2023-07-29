import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:valorant_app/data/constant.dart';
import 'dart:convert';
import 'package:valorant_app/widgets/content_widget.dart';

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
      final response = await http.get(Uri.parse(request));

      if (response.statusCode == 200) {
        setState(() {
          _dataGuns = json.decode(response.body)['data'];
          print('Sukses');
        });
      } else {
        print('Error');
      }
    } catch (e) {
      print('Error : $e');
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
