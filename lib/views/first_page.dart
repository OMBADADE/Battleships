// ignore_for_file: use_key_in_widget_constructors

import 'package:battleships/views/homepage.dart';
import 'package:battleships/views/login.dart';
import 'package:flutter/material.dart';
import '../utils/round_manager.dart';

class StartUpPage extends StatefulWidget {
  const StartUpPage({Key? key});

  @override
  State<StartUpPage> createState() => _StartUpPageState();
}

class _StartUpPageState extends State<StartUpPage> {
  bool _isLoggedIn = false;
  String _userName = "";

  Future<void> _checkLoginStatus() async {
    final loggedIn = await SessionManager.isLoggedIn();
    if (mounted) {
      setState(() {
        _isLoggedIn = loggedIn;
        _userName = SessionManager.getUserName() as String;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: _isLoggedIn
          ? HomePage(
              userName: _userName,
            )
          : const LoginPage(),
    );
  }
}
