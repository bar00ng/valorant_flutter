import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:valorant_app/data/constant.dart';

class MapDetailScreen extends StatefulWidget {
  final String uuid;
  final String displayName;

  MapDetailScreen({
    required this.uuid,
    required this.displayName,
  });

  @override
  _MapDetailScreenState createState() => _MapDetailScreenState();
}

class _MapDetailScreenState extends State<MapDetailScreen> {
  List<dynamic> _data = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    String request = 'https://valorant-api.com/v1/maps/${widget.uuid}';
    try {
      final response = await http.get(Uri.parse(request));

      if (response.statusCode == 200) {
        setState(() {
          _data = json.decode(response.body)['data'];
          print(_data);
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
    // Build the UI to display the data fetched from the API
    // You can use the _data list here to display the relevant information
    return Scaffold(
      backgroundColor: darkGrayColor,
      appBar: AppBar(
        title: Text(
          widget.displayName,
          style: TextStyle(
            color: redColor,
          ),
        ),
        iconTheme: IconThemeData(
          color: redColor, // Change the color of the back icon here
        ),
        centerTitle: true, // Mengatur teks judul berada di tengah
        backgroundColor: darkGrayColor,
        elevation: 0,
      ),
      body: Container(
        padding: EdgeInsets.all(15.0),
        child: Column(
          children: [],
        ),
      ),
    );
  }
}
