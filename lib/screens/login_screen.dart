import 'package:flutter/material.dart';
import 'package:gym_fitgo/screens/gym_suvery_screen.dart';
import 'package:gym_fitgo/services/notification_services.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}
// Función para programar la notificación automática
void _scheduleNotification() async {
  await Future.delayed(Duration(seconds: 10)); // Retraso de 10 segundos
  await mostrarNotificacion(); // Llama a la función para mostrar la notificación
}
class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Credenciales preestablecidas
  final String _correctUsername = "usuario"; // Cambia esto por tu usuario deseado
  final String _correctPassword = "123"; // Cambia esto por tu contraseña deseada

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0a0322),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Bienvenido a GYM FITGO",
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
              SizedBox(height: 20),
              Icon(Icons.fitness_center, size: 50, color: Colors.white), // Icono del gimnasio
              SizedBox(height: 20),
              TextField(
                controller: _usernameController,
                decoration: InputDecoration(
                  hintText: "Usuario",
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 10),
              TextField(
                controller: _passwordController,
                decoration: InputDecoration(
                  hintText: "Contraseña",
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _login,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple, // Color del botón
                ),
                child: Text("Iniciar sesión",
                style: TextStyle(
                  color: Colors.white,
                ),),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _login() {
    String username = _usernameController.text;
    String password = _passwordController.text;

    // Verifica las credenciales
    if (username == _correctUsername && password == _correctPassword) {
      // Si las credenciales son correctas, navega a la pantalla principal
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => GymSurveyScreen()),
      );
    } else {
      // Si las credenciales son incorrectas, muestra un mensaje de error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Usuario o contraseña incorrectos."),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
