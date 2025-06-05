import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gym_fitgo/screens/home_screen.dart';
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
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();
  bool _isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true, // Permite que el contenido se ajuste al teclado
      body: Stack(
        children: [
          // Fondo claro
          Container(
            color: const Color(0xFFF8E1FF), // Claro: #f8e1ff
          ),
          // Figura triangular media (más grande) en la esquina superior izquierda
          CustomPaint(
            painter: MediumTrianglePainter(),
            child: Container(
              height: 300,
              width: 300,
            ),
          ),
          // Figura triangular oscura (más pequeña) encima en la esquina superior izquierda
          CustomPaint(
            painter: DarkTrianglePainter(),
            child: Container(
              height: 250,
              width: 250,
            ),
          ),
          // Logo con círculo claro de fondo
          Positioned(
            top: 40,
            left: 20,
            child: CircleAvatar(
              radius: 35,
              backgroundColor: Color(0xFFF8E1FF), // Claro: #f8e1ff
              child: Image.asset(
                "images/logoGym.png",
                width: 60,
                height: 60,
              ),
            ),
          ),
          // Contenido principal
          SafeArea(
            child: SingleChildScrollView(
              physics: const NeverScrollableScrollPhysics(), // Desactiva el desplazamiento manual
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom, // Ajusta al teclado
                left: 32.0,
                right: 32.0,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 180), // Espacio para el logo y triángulos
                  // Título "Login"
                  Text(
                    "Login",
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF7A0180), // Medio: #7a0180
                    ),
                  ),
                  const SizedBox(height: 40),
                  // Campo de Correo
                  TextField(
                    controller: _emailController,
                    focusNode: _emailFocus,
                    style: const TextStyle(color: Colors.black),
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.email, color: Color(0xFF7A0180)),
                      hintText: "Correo",
                      hintStyle: TextStyle(color: Colors.grey),
                      border: UnderlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFF7A0180)),
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFF7A0180)),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFF7A0180), width: 2),
                      ),
                    ),
                    onSubmitted: (value) {
                      // Cambia el foco al campo de contraseña
                      FocusScope.of(context).requestFocus(_passwordFocus);
                    },
                  ),
                  const SizedBox(height: 20),
                  // Campo de Contraseña
                  TextField(
                    controller: _passwordController,
                    focusNode: _passwordFocus,
                    obscureText: !_isPasswordVisible,
                    style: const TextStyle(color: Colors.black),
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.lock, color: Color(0xFF7A0180)),
                      hintText: "Contraseña",
                      hintStyle: TextStyle(color: Colors.grey),
                      border: UnderlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFF7A0180)),
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFF7A0180)),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFF7A0180), width: 2),
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isPasswordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: Color(0xFF7A0180),
                        ),
                        onPressed: () {
                          setState(() {
                            _isPasswordVisible = !_isPasswordVisible;
                          });
                        },
                      ),
                    ),
                    onSubmitted: (value) {
                      // Inicia sesión al presionar "Enter"
                      _login();
                    },
                  ),
                  const SizedBox(height: 40),
                  // Botón Iniciar Sesión con gradiente, sin sombra
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _login,
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 15.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        elevation: 0, // Sin sombra
                      ).copyWith(
                        backgroundColor: MaterialStateProperty.resolveWith<Color>(
                          (states) => Colors.transparent,
                        ),
                        foregroundColor: MaterialStateProperty.all(Colors.transparent),
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Color(0xFF7A0180),
                              Color(0xFF2B192E),
                            ],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          ),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        padding: EdgeInsets.symmetric(vertical: 15.0),
                        child: Center(
                          child: Text(
                            "Iniciar Sesión",
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Enlace Regístrate
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => RegisterScreen()),
                      );
                    },
                    child: Text(
                      "¿No tienes cuenta? Regístrate!",
                      style: TextStyle(
                        color: Color(0xFF7A0180),
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20), // Espacio adicional al final
                ],
              ),
            ),
          ),
        ],
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
        await prefs.setString('user_email', email);

        if (email == 'gymfitgo8@gmail.com') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => AdminHomeScreen()),
          );
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => HomeScreen()),
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

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocus.dispose();
    _passwordFocus.dispose();
    super.dispose();
  }
}

// Clase para pintar la figura triangular oscura (más pequeña) en la esquina superior izquierda
class DarkTrianglePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Color(0xFF2B192E) // Oscuro: #2b192e
      ..style = PaintingStyle.fill;

    final path = Path();
    path.moveTo(0, 0);
    path.lineTo(size.width, 0);
    path.lineTo(0, size.height);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

// Clase para pintar la figura triangular media (más grande) en la esquina superior izquierda
class MediumTrianglePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Color(0xFF7A0180) // Medio: #7a0180
      ..style = PaintingStyle.fill;

    final path = Path();
    path.moveTo(0, 0);
    path.lineTo(size.width, 0);
    path.lineTo(0, size.height);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}