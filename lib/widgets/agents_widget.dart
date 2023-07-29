import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:valorant_app/data/constant.dart';
import 'dart:convert';

import 'package:valorant_app/screens/agent_detail_screen.dart';
import 'package:valorant_app/widgets/content_widget.dart';

class AgentsWidget extends StatefulWidget {
  @override
  _AgentsWidgetState createState() => _AgentsWidgetState();
}

class _AgentsWidgetState extends State<AgentsWidget> {
  List<dynamic> _dataAgents = [];

  void initState() {
    super.initState();
    fetchDataAgents();
  }

  Future<void> fetchDataAgents() async {
    String request =
        'https://valorant-api.com/v1/agents?isPlayableCharacter=true';
    try {
      final response = await http.get(Uri.parse(request));

      if (response.statusCode == 200) {
        setState(() {
          _dataAgents = json.decode(response.body)['data'];
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
            title: 'Agents',
            description:
                'Berikut merupakan Agent yang dapat kamu mainkan di game Valorant. Klik untuk informasi lebih lanjut.',
          ),
          Container(
            height: 200,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _dataAgents.length,
              itemBuilder: (context, index) {
                var uuid = _dataAgents[index]['uuid'];
                var agentName = _dataAgents[index]['displayName'];
                var displayIcon = _dataAgents[index]['displayIcon'];

                return Padding(
                  padding: EdgeInsets.all(8.0),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AgentDetailScreen(
                            uuid: uuid,
                            displayName: agentName,
                          ),
                        ),
                      );
                    },
                    child: Card(
                      elevation: 0,
                      color: redColor,
                      child: Container(
                        width: 150,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Image.network(
                                displayIcon,
                                width: 150,
                                height: 150,
                                fit: BoxFit.cover,
                              ),
                            ),
                            SizedBox(height: 3),
                            Container(
                              width: 150,
                              color: darkGrayColor,
                              padding: EdgeInsets.all(
                                8.0,
                              ),
                              child: Align(
                                alignment: Alignment.center,
                                child: Text(
                                  agentName,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: redColor,
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
        ],
      ),
    );
  }
}