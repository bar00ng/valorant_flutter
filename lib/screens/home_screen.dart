import 'package:flutter/material.dart';

import 'package:valorant_app/data/constant.dart';

import 'package:valorant_app/widgets/agents_widget.dart';
import 'package:valorant_app/widgets/guns_widget.dart';
import 'package:valorant_app/widgets/maps_widget.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Home',
          style: TextStyle(
            color: redColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        automaticallyImplyLeading: false,
        iconTheme: IconThemeData(
          color: redColor, // Change the color of the back icon here
        ),
        centerTitle: true, // Mengatur teks judul berada di tengah
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AgentsWidget(),
            mySizeBox,
            MapsWidget(),
            mySizeBox,
            GunsWidget(),
          ],
        ),
      ),
    );
  }
}
