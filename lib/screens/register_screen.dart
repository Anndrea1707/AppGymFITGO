import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gym_fitgo/screens/login_screen.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _isFemale = true;
  bool _hasLimitations = false;
  bool _termsAccepted = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Color(0xFF0a0322),
      appBar: AppBar(
        title: Text("Registro"),
        backgroundColor: Color(0xFFF5EDE4),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    hintText: "Nombre completo",
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 10),
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
                  obscureText: !_isPasswordVisible,
                  decoration: InputDecoration(
                    hintText: "Contraseña",
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          _isPasswordVisible = !_isPasswordVisible;
                        });
                      },
                    ),
                  ),
                ),
                SizedBox(height: 10),
                TextField(
                  controller: _ageController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: "Edad",
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Género: ", style: TextStyle(color: Colors.white)),
                    ToggleButtons(
                      borderColor: Colors.white,
                      selectedBorderColor: Colors.purple,
                      fillColor: Colors.purple,
                      selectedColor: Colors.white,
                      color: Colors.white,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Text("Mujer"),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Text("Hombre"),
                        ),
                      ],
                      isSelected: [_isFemale, !_isFemale],
                      onPressed: (index) {
                        setState(() {
                          _isFemale = index == 0;
                        });
                      },
                    ),
                  ],
                ),
                SizedBox(height: 10),
                TextField(
                  controller: _heightController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: "Altura (cm)",
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 10),
                TextField(
                  controller: _weightController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: "Peso (kg)",
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Limitaciones: ", style: TextStyle(color: Colors.white)),
                    Switch(
                      value: _hasLimitations,
                      onChanged: (value) {
                        setState(() {
                          _hasLimitations = value;
                        });
                      },
                    ),
                    Text(_hasLimitations ? "Sí" : "No", style: TextStyle(color: Colors.white)),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    Checkbox(
                      value: _termsAccepted,
                      onChanged: (value) {
                        setState(() {
                          _termsAccepted = value ?? false;
                        });
                      },
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          // Aquí puedes navegar a la política de tratamiento de datos
                        },
                        child: Text(
                          "Acepto la Política de Tratamiento de Datos",
                          style: TextStyle(
                            color: Colors.white,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _termsAccepted ? _register : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _termsAccepted ? Colors.purple : Colors.grey,
                  ),
                  child: Text(
                    "Registrarse",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _register() async {
    String name = _nameController.text.trim();
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();
    String age = _ageController.text.trim();
    String height = _heightController.text.trim();
    String weight = _weightController.text.trim();
    bool gender = _isFemale;
    bool limitations = _hasLimitations;

    if (name.isEmpty || email.isEmpty || password.isEmpty || age.isEmpty || height.isEmpty || weight.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Por favor, complete todos los campos."), backgroundColor: Colors.red),
      );
      return;
    }

    if (password.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("La contraseña debe tener al menos 6 caracteres."), backgroundColor: Colors.red),
      );
      return;
    }

    try {
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await FirebaseFirestore.instance.collection('usuarios').doc(userCredential.user!.uid).set({
        'name': name,
        'email': email,
        'password': password,
        'age': int.parse(age),
        'gender': gender,
        'height': int.parse(height),
        'weight': int.parse(weight),
        'limitations': limitations,
        'role': 'cliente',
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Usuario registrado exitosamente."), backgroundColor: Colors.green),
      );
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginScreen()));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error al registrar usuario: $e"), backgroundColor: Colors.red),
      );
    }
  }
}
