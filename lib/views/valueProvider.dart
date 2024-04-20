// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';

class CommonValuesProvider extends ChangeNotifier {
  bool completedGames = false;
  String userName = "";

  set UserName(String userName) {
    this.userName = userName;
  }

  String get UserName => userName;

  bool get CompletedGames => completedGames;

  void toggleCompletedGames() {
    completedGames = !completedGames;
    notifyListeners();
  }
}
