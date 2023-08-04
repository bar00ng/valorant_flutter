import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:logger/logger.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:page_transition/page_transition.dart';

import 'package:valorant_app/data/constant.dart';
import 'package:valorant_app/screens/skill_detail_screen.dart';

var logger = Logger(
  printer: PrettyPrinter(
    methodCount: 0,
  ),
);

class AgentDetailScreen extends StatelessWidget {
  final String uuid;
  final String displayName;

  AgentDetailScreen({required this.uuid, required this.displayName});

  Future<Map<String, dynamic>> fetchData() async {
    String request = 'https://valorant-api.com/v1/agents/$uuid?language=id-ID';

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
        error: 'Terjadi kesalahan saat data',
      );

      throw Exception('Failed to data');
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
            child: FutureBuilder<Map<String, dynamic>>(
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
              final agentData = snapshot.data!;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    color: Colors.grey,
                    child: Align(
                      alignment: Alignment.center,
                      child: Image.network(
                        agentData['displayIcon'],
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
                      agentData['description'],
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Color(0xFF808080),
                        fontSize: 15,
                      ),
                    ),
                  ),
                  MyDivider(),
                  Text(
                    "Roles",
                    style: TextStyle(
                      color: redColor,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  ColorFiltered(
                    colorFilter: ColorFilter.mode(redColor, BlendMode.srcIn),
                    child: Image.network(
                      agentData['role']['displayIcon'],
                      height: 200,
                      width: 200,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8.0,
                    ),
                    child: Text(
                      agentData['role']['description'],
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Color(0xFF808080),
                        fontSize: 15,
                      ),
                    ),
                  ),
                  MyDivider(),
                  Text(
                    "Abilities",
                    style: TextStyle(
                      color: redColor,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    height: 150,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: 4,
                      itemBuilder: (context, index) {
                        final ability = agentData['abilities'][index];

                        return Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10.0,
                          ),
                          child:GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  PageTransition(
                                      type: PageTransitionType.fade,
                                      child: SkillDetailScreen(
                                          skillDescription: ability['description'],
                                          skillDisplayIcon: ability['displayIcon'],
                                          skillName: ability['displayName'],
                                      ),
                                  ),
                              );
                            },
                            child: Card(
                              elevation: 0,
                              color: Colors.white,
                              child: Container(
                                width: 150,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      child: ColorFiltered(
                                        colorFilter: ColorFilter.mode(
                                            redColor, BlendMode.srcIn),
                                        child: Image.network(
                                          ability['displayIcon'] ?? '',
                                          height: 100,
                                          width: 100,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Container(
                                      width: 150,
                                      color: Colors.white,
                                      padding: const EdgeInsets.all(
                                        8.0,
                                      ),
                                      child: Align(
                                        alignment: Alignment.center,
                                        child: Text(
                                          ability['displayName'] ?? '',
                                          style: const TextStyle(
                                            fontSize: 14,
                                            color: Color(0xFFfb3e44),
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                ],
              );
            }
          },
        )),
      ),
    );
  }
}

class MyDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 20,
        ),
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 8.0,
          ),
          child: Divider(
            color: redColor,
            thickness: 1.0,
          ),
        ),
        const SizedBox(
          height: 20,
        ),
      ],
    );
  }
}
