import 'package:battleships/views/valueProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'views/login.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => CommonValuesProvider(),
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Battleships',
        home: LoginPage(),
      ),
    ),
  );
}
