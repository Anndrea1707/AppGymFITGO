import 'package:flutter/material.dart';
import 'package:gym_fitgo/screens/login_screen.dart'; // Importa la pantalla de login
import 'services/notification_services.dart'; // Importa el servicio de notificaciones

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initNotifications(); // Inicializa las notificaciones

  runApp(MyGymApp());
}

// Función para programar la notificación automática
void _scheduleNotification() async {
  await Future.delayed(Duration(seconds: 10)); // Retraso de 10 segundos
  await mostrarNotificacion(); // Llama a la función para mostrar la notificación
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
