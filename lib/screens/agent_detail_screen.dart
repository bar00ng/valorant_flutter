import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:valorant_app/data/constant.dart';

class AgentDetailScreen extends StatefulWidget {
  final String uuid;
  final String displayName;

  AgentDetailScreen({
    required this.uuid,
    required this.displayName,
  });

  @override
  _AgentDetailScreenState createState() => _AgentDetailScreenState();
}

class _AgentDetailScreenState extends State<AgentDetailScreen> {
  List<dynamic> _data = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    String request = 'https://valorant-api.com/v1/agents/${widget.uuid}';
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
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          widget.displayName,
          style: TextStyle(
            color: redColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: IconThemeData(
          color: redColor, // Change the color of the back icon here
        ),
        centerTitle: true, // Mengatur teks judul berada di tengah
        backgroundColor: Colors.white,
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
