// ignore_for_file: must_be_immutable

import 'dart:convert';
import 'package:battleships/utils/round_manager.dart';
import 'package:battleships/views/valueProvider.dart';
import 'package:battleships/views/homepage.dart';
import 'package:battleships/views/columns_rows.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import '../models/location.dart';

class GameScreen extends StatefulWidget {
  bool isAI;
  String gameType;
  final String baseUrl = "http://165.227.117.48/games";

  GameScreen({Key? key, this.isAI = false, this.gameType = ""})
      : super(key: key);

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late List<String> rowNumbers = ["", "1", "2", "3", "4", "5"];
  late List<String> columnAlphas = ["A", "B", "C", "D", "E"];
  late List<bool> shipToggles = List.generate(25, (index) => false);
  late List<String> selectedLocations = [];
  late var locationToIndex = Locations();

  void _submitShips() async {
    if (selectedLocations.length != 5) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Please Select The Right Number Of Boats")));
      return;
    }
    Map<String, dynamic> data;
    if (widget.isAI) {
      data = {"ships": selectedLocations, "ai": widget.gameType};
    } else {
      data = {"ships": selectedLocations};
    }
    final response = await http.post(Uri.parse(widget.baseUrl),
        headers: {
          "Content-Type": "application/json",
          "Authorization": await SessionManager.getSessionToken()
        },
        body: jsonEncode(data));
    if (response.statusCode == 200) {
      // Navigate to the home page after submitting ships
      Future.delayed(const Duration(seconds: 1), () {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => HomePage(
                userName:
                    Provider.of<CommonValuesProvider>(context, listen: false)
                        .userName)));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Place Ships",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: rowNumbers
                .map((number) => RowsAndColumns(number: number))
                .toList(),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.6,
            width: MediaQuery.of(context).size.width,
            child: Row(
              children: [
                Container(
                  alignment: Alignment.center,
                  child: Column(
                    children: columnAlphas
                        .map((alpha) => RowsAndColumns(number: alpha))
                        .toList(),
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.82,
                  child: GridView.count(
                    crossAxisCount: 5,
                    childAspectRatio: MediaQuery.of(context).size.width /
                        MediaQuery.of(context).size.height *
                        1.4,
                    children: List.generate(
                      25,
                      (index) => Padding(
                        padding: const EdgeInsets.all(3),
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black),
                            borderRadius: BorderRadius.circular(
                                10), // Added border radius
                            color: Colors.white, // Added background color
                          ),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              hoverColor: shipToggles[index] == false
                                  ? Colors.greenAccent
                                      .withOpacity(0.5) // Adjusted opacity
                                  : Colors.red
                                      .withOpacity(0.5), // Adjusted opacity
                              splashColor: Colors.blue
                                  .withOpacity(0.5), // Adjusted opacity
                              onTap: () {
                                setState(() {
                                  if (selectedLocations.length < 5) {
                                    shipToggles[index] = !shipToggles[index];
                                    if (shipToggles[index]) {
                                      selectedLocations.add(locationToIndex
                                          .indexToLocations[index]!);
                                    } else {
                                      selectedLocations.remove(locationToIndex
                                          .indexToLocations[index]!);
                                    }
                                  } else {
                                    if (shipToggles[index] == true) {
                                      selectedLocations.remove(locationToIndex
                                          .indexToLocations[index]!);
                                      shipToggles[index] = !shipToggles[index];
                                    }
                                  }
                                });
                              },
                              child: Center(
                                child: shipToggles[index]
                                    ? const Text("🚢",
                                        style: TextStyle(
                                            fontSize: 20)) // Adjusted font size
                                    : const Text(""),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              elevation: 6,
            ),
            onPressed: _submitShips,
            child: const Text(
              "Submit",
              style: TextStyle(color: Colors.white),
            ),
          )
        ],
      ),
    );
  }
}
