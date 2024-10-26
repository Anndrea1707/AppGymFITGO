import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Perfil'),
      ),
      body: Center(
        child: Text(
          'Aquí van el perfil.',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
