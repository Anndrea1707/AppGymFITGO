import 'package:flutter/material.dart';

class ProgressScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Progresos'),
      ),
      body: Center(
        child: Text(
          'Aquí va la información de los progresos.',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
