import 'package:valorant_app/main.dart';
import 'package:flutter/material.dart';

class ContentWidget extends StatelessWidget {
  final String title;
  final String description;

  ContentWidget({required this.title, required this.description});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            color: Color(0xFF808080),
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(
          height: 12,
        ),
        Text(
          description,
          style: TextStyle(
            color: Color(0xFF808080),
            fontSize: 12,
            letterSpacing: 1,
          ),
        ),
        SizedBox(
          height: 15,
        ),
      ],
    );
  }
}
