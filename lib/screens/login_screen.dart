import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gym_fitgo/screens/beginner_routine_screen.dart';
import 'package:gym_fitgo/screens/admin_home_screen.dart';
import 'package:gym_fitgo/screens/register_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: LoginScreen(),
    );
  }
}

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isPasswordVisible = false; // Controla la visibilidad de la contraseña

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
              Image.asset(
                "images/mancuerna.png", // Ruta de la imagen
                width: 50, // Tamaño de la imagen
                height: 50,
              ),
              SizedBox(height: 20),
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  hintText: "Correo electrónico",
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 10),
              TextField(
                controller: _passwordController,
                obscureText: !_isPasswordVisible, // Cambiar visibilidad
                decoration: InputDecoration(
                  hintText: "Contraseña",
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isPasswordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        _isPasswordVisible = !_isPasswordVisible;
                      });
                    },
                  ),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _login,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple,
                ),
                child: Text(
                  "Iniciar sesión",
                  style: TextStyle(color: Colors.white),
                ),
              ),
              SizedBox(height: 10),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => RegisterScreen()),
                  );
                },
                child: Text(
                  "¿No tienes cuenta? Regístrate",
                  style: TextStyle(
                    color: Colors.orangeAccent,
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _login() async {
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    try {
      final userDoc = await FirebaseFirestore.instance
          .collection('usuarios')
          .where('email', isEqualTo: email)
          .where('password', isEqualTo: password)
          .get();

      if (userDoc.docs.isNotEmpty) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('user_email', email); // Guardar el email

        if (email == 'gymfitgo8@gmail.com') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => AdminHomeScreen()),
          );
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => BeginnerRoutineScreen()),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Correo o contraseña incorrectos."),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error al conectarse. Verifique su conexión."),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
