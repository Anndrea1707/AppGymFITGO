import 'package:flutter/material.dart';

class UserManagement extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Retos'),
      ),
      body: Center(
        child: Text(
          'Aquí van los usuarios regitrados',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
