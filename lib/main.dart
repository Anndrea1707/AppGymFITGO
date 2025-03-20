import 'package:flutter/material.dart';
import 'package:gym_fitgo/screens/login_screen.dart'; // Importa la pantalla de login
import 'services/notification_services.dart'; // Importa el servicio de notificaciones
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); 
  await initNotifications(); // Inicializa las notificaciones
  runApp(MyGymApp());
}


class MyGymApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: LoginScreen(), // Cambia a LoginScreen como pantalla inicial
      debugShowCheckedModeBanner: false,
    );
  }
}
