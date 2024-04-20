// ignore_for_file: prefer_const_constructors

import 'dart:convert';
import 'package:battleships/views/valueProvider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import '../utils/round_manager.dart';
import 'package:battleships/views/homepage.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late TextEditingController usernameController, passwordController;

  @override
  void initState() {
    usernameController = TextEditingController();
    passwordController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    final username = usernameController.text;
    final password = passwordController.text;

    final url = Uri.parse("http://165.227.117.48/login");
    final response = await http.post(
      url,
      headers: {'Content-Type': "application/json"},
      body: jsonEncode({"username": username, "password": password}),
    );

    if (!mounted) return;

    if (response.statusCode == 200) {
      final sessionToken = jsonDecode(response.body)['access_token'];
      await SessionManager.setSessionToken(sessionToken);
      Provider.of<CommonValuesProvider>(context, listen: false).userName =
          username;

      if (!mounted) return;

      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (_) => HomePage(userName: username),
      ));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invalid Credentials !!!')),
      );
    }
  }

  Future<void> _register() async {
    final username = usernameController.text;
    final password = passwordController.text;

    final url = Uri.parse("http://165.227.117.48/register");
    final response = await http.post(
      url,
      headers: {'Content-Type': "application/json"},
      body: jsonEncode({'username': username, 'password': password}),
    );

    if (!mounted) return;

    if (response.statusCode == 200) {
      final sessionToken = jsonDecode(response.body)['access_token'];
      await SessionManager.setSessionToken(sessionToken);

      if (!mounted) return;

      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (_) => HomePage(
          userName: Provider.of<CommonValuesProvider>(context, listen: false)
              .userName,
        ),
      ));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Registration Failed !!!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.purple,
        title: const Text(
          "Login",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(
              controller: usernameController,
              style: TextStyle(fontSize: 18),
              decoration: const InputDecoration(
                labelText: "Username",
              ),
              textAlign: TextAlign.left,
            ),
            SizedBox(height: 20),
            TextFormField(
              controller: passwordController,
              obscureText: true,
              enableSuggestions: false,
              autocorrect: false,
              style: TextStyle(fontSize: 18),
              decoration: const InputDecoration(
                labelText: "Password",
              ),
              textAlign: TextAlign.left,
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () => _login(),
                  child: const Text(
                    "Log In",
                    style: TextStyle(fontSize: 18),
                  ),
                ),
                ElevatedButton(
                  onPressed: () => _register(),
                  child: const Text(
                    "Register",
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
