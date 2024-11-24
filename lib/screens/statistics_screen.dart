import 'package:flutter/material.dart';

class StatisticsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Retos'),
      ),
      body: Center(
        child: Text(
          'Aquí van las estadisticas.',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
