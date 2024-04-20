// ignore_for_file: prefer_const_constructors

import 'dart:convert';
import 'dart:async';
import 'package:battleships/utils/round_manager.dart';
import 'package:battleships/views/onGame_board_human.dart';
import 'package:battleships/views/valueProvider.dart';
import 'package:battleships/views/onGame_board_AI.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'navdrawer.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  final String baseUrl = "http://165.227.117.48/games";
  final String userName;

  const HomePage({Key? key, required this.userName}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List answer = [];
  List activeGames = [];
  List completedGames = [];
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _refreshButton();
    _timer =
        Timer.periodic(Duration(seconds: 0), (Timer t) => _refreshButton());
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _refreshButton() async {
    try {
      final response = await http.get(Uri.parse(widget.baseUrl), headers: {
        'Content-Type': 'application/json',
        'Authorization': await SessionManager.getSessionToken()
      });

      if (response.statusCode == 200) {
        var responseData = jsonDecode(response.body);
        if (responseData.containsKey('games') &&
            responseData['games'] != null) {
          answer = responseData['games'];
          activeGames = answer
              .where(
                  (element) => element['status'] == 0 || element['status'] == 3)
              .toList();
          completedGames = answer
              .where(
                  (element) => element['status'] == 1 || element['status'] == 2)
              .toList();
          setState(() {});
        } else {
          print('Response body does not contain valid game data');
        }
      } else {
        print('HTTP error: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavDrawer(userName: widget.userName),
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.purpleAccent,
        title: const Text(
          "The Battleships Game",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        actions: [
          IconButton(
            onPressed: () => _refreshButton(),
            icon: const Icon(Icons.refresh),
            color: Colors.white,
          )
        ],
      ),
      body: ListView(
        children: Provider.of<CommonValuesProvider>(context).completedGames
            ? List.generate(
                completedGames.length,
                (index) => GameListItem(
                  gameData: completedGames[index],
                  isCompleted: true,
                ),
              )
            : List.generate(
                activeGames.length,
                (index) => GameListItem(
                  gameData: activeGames[index],
                ),
              ),
      ),
    );
  }
}

class GameListItem extends StatelessWidget {
  final dynamic gameData;
  final bool isCompleted;

  const GameListItem({
    Key? key,
    required this.gameData,
    this.isCompleted = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        if (gameData['player2'].toString().contains("AI-")) {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => OnGoingGameBoardAI(
              gameId: gameData['id'].toString(),
              isCompleted: isCompleted,
            ),
          ));
        } else {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => OnGoingGameBoard(
              gameId: gameData['id'].toString(),
              isCompleted: isCompleted,
            ),
          ));
        }
      },
      child: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              child: Text(
                "#${gameData['id']} ${gameData['player1']} vs ${gameData['player2']}",
                style: const TextStyle(color: Colors.black),
              ),
            ),
            Text(
              gameData['status'] == 1 || gameData['status'] == 2
                  ? "Completed Game (${gameData['status'] == 1 ? gameData['player1'] : gameData['player2']})"
                  : gameData['status'] == 0
                      ? "Matchmaking"
                      : gameData['turn'] == gameData['position']
                          ? "My Turn"
                          : "Opponent Turn",
              style: const TextStyle(color: Colors.black, fontSize: 10),
            )
          ],
        ),
      ),
    );
  }
}
