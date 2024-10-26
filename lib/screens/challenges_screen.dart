import 'package:flutter/material.dart';

class ChallengesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Retos'),
      ),
      body: Center(
        child: Text(
          'Aquí van los retos.',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
