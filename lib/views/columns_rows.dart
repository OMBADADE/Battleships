// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';

class RowsAndColumns extends StatelessWidget {
  final String number;

  const RowsAndColumns({Key? key, required this.number}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      height: MediaQuery.of(context).size.height / 8.5,
      width: MediaQuery.of(context).size.width / 6,
      padding: const EdgeInsets.all(8.0), // Added padding to the container
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.blueAccent, Colors.lightBlueAccent],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3), // changes the position of the shadow
          ),
        ],
      ),
      child: Card(
        elevation: 6,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Center(
          child: Text(
            number.toString(),
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
