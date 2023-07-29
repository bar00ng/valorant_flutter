import 'package:flutter/material.dart';

import 'package:valorant_app/data/constant.dart';

import 'package:valorant_app/widgets/agents_widget.dart';
import 'package:valorant_app/widgets/guns_widget.dart';
import 'package:valorant_app/widgets/maps_widget.dart';

const SizedBox mySizeBox = SizedBox(
  height: 20,
);

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: darkGrayColor,
      appBar: AppBar(
        title: Text(
          'Home',
          style: TextStyle(
            color: redColor,
          ),
        ),
        centerTitle: true, // Mengatur teks judul berada di tengah
        backgroundColor: darkGrayColor,
        elevation: 0,
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
