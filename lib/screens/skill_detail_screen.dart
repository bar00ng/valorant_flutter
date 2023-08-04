import 'package:flutter/material.dart';
import 'package:valorant_app/data/constant.dart';

class SkillDetailScreen extends StatelessWidget{
  final String skillName;
  final String skillDisplayIcon;
  final String skillDescription;

  SkillDetailScreen({
    required this.skillDescription,
    required this.skillDisplayIcon,
    required this.skillName
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          skillName,
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              color: Colors.white,
              child: Align(
                alignment: Alignment.center,
                child: ColorFiltered(
                  colorFilter: ColorFilter.mode(redColor, BlendMode.srcIn),
                  child: Image.network(
                    skillDisplayIcon,
                    width: 200,
                    height: 200,
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 8.0,
              ),
              alignment: Alignment.center,
              child: Text(
                skillDescription,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Color(0xFF808080),
                  fontSize: 15,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
