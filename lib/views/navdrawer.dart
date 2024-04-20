// ignore_for_file: must_be_immutable, prefer_const_constructors, use_key_in_widget_constructors

import 'package:battleships/utils/round_manager.dart';
import 'package:battleships/views/valueProvider.dart';
import 'package:battleships/views/game_screen.dart';
import 'package:battleships/views/login.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NavDrawer extends StatefulWidget {
  String userName;
  NavDrawer({Key? key, required this.userName});

  @override
  State<NavDrawer> createState() => _NavDrawerState();
}

class _NavDrawerState extends State<NavDrawer> {
  Future<void> _showMyDialog() async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Select AI Opponent"),
          actions: [
            _dialogOption("Random", "random"),
            _dialogOption("Perfect", "perfect"),
            _dialogOption("One Ship (A1)", "oneship"),
          ],
        );
      },
    );
  }

  Widget _dialogOption(String title, String gameType) {
    return TextButton(
      onPressed: () {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (_) => GameScreen(isAI: true, gameType: gameType),
        ));
      },
      child: Text(title),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: Colors.blue),
            padding: EdgeInsets.symmetric(vertical: 20, horizontal: 16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Battleships",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                SizedBox(height: 10),
                Text("Logged in as ${widget.userName}"),
              ],
            ),
          ),
          ListTile(
            leading: Icon(Icons.add),
            title: Text("New Game"),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (_) => GameScreen(),
              ));
            },
          ),
          ListTile(
            leading: Icon(Icons.smart_toy),
            title: Text("New Game (AI)"),
            onTap: () => _showMyDialog(),
          ),
          ListTile(
            leading: Icon(Icons.list),
            title: Text(
                Provider.of<CommonValuesProvider>(context).CompletedGames
                    ? "Show Active Games"
                    : "Show Completed Games"),
            onTap: () {
              setState(() {
                Provider.of<CommonValuesProvider>(context, listen: false)
                    .toggleCompletedGames();
              });
            },
          ),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text("Logout"),
            onTap: () async {
              await SessionManager.clearSession();
              if (!mounted) return;
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (_) => LoginPage()),
              );
            },
          ),
        ],
      ),
    );
  }
}
