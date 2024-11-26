import 'package:flutter/material.dart';

class ManagementUsersAdmin extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Usuarios'),
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
