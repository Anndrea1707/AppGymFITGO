import 'package:flutter/material.dart';

class AdminMainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Administrador'),
      ),
      body: Center(
        child: Text(
          'Bienvenido!!!!!!!!!!!!!!!!!!!',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
