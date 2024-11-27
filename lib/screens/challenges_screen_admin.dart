import 'package:flutter/material.dart';

class ChallengesScreenAdmin extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0a0322),
      appBar: AppBar(
        backgroundColor: Color(0xFFF5EDE4),
        elevation: 0,
        automaticallyImplyLeading: true,
        title: Text(
          'Retos admin',
          style: TextStyle(color: Colors.black),
        ),
        iconTheme: IconThemeData(color: Colors.black),
      )
    );
  }
}
