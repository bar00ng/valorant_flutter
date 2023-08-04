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
    required this.displayName
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
      body: SingleChildScrollView(
        child: Container(
          child: FutureBuilder<Map<String, dynamic>> (
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

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      color: Colors.grey,
                      child: Align(
                        alignment: Alignment.center,
                        child: Image.network(
                          weaponData['displayIcon'],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                  ],
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
// class GunDetailScreen extends StatefulWidget {
//   final String uuid;
//   final String displayName;
//
//   GunDetailScreen({
//     required this.uuid,
//     required this.displayName,
//   });
//
//   @override
//   _GunDetailScreenState createState() => _GunDetailScreenState();
// }
//
// class _GunDetailScreenState extends State<GunDetailScreen> {
//   List<dynamic> _data = [];
//
//   @override
//   void initState() {
//     super.initState();
//     fetchData();
//   }
//
//   Future<void> fetchData() async {
//     String request = 'https://valorant-api.com/v1/weapons/${widget.uuid}';
//     try {
//       final response = await http.get(Uri.parse(request));
//
//       if (response.statusCode == 200) {
//         setState(() {
//           _data = json.decode(response.body)['data'];
//           print(_data);
//         });
//       } else {
//         print('Error');
//       }
//     } catch (e) {
//       print('Error : $e');
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     // Build the UI to display the data fetched from the API
//     // You can use the _data list here to display the relevant information
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         title: Text(
//           widget.displayName,
//           style: TextStyle(color: redColor, fontWeight: FontWeight.bold),
//         ),
//         iconTheme: IconThemeData(
//           color: redColor, // Change the color of the back icon here
//         ),
//         centerTitle: true, // Mengatur teks judul berada di tengah
//         backgroundColor: Colors.white,
//       ),
//       body: Container(
//         padding: EdgeInsets.all(15.0),
//         child: Column(
//           children: [],
//         ),
//       ),
//     );
//   }
// }
