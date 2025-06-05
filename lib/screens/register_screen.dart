import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gym_fitgo/screens/login_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  // Controladores para los campos de texto
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();

  // Variables de estado
  bool _isPasswordVisible = false;
  bool _isFemale = true;
  bool _hasLimitations = false;
  bool _termsAccepted = false;

  // Colores del diseño
  static const Color _darkColor = Color(0xFF2B192E); // Oscuro: #2B192E
  static const Color _mediumColor = Color(0xFF7A0180); // Medio: #7A0180
  static const Color _lightColor = Color(0xFFF8E1FF); // Claro: #F8E1FF

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [_darkColor, _mediumColor],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildContentBox(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Construye el cuadro claro que contiene el formulario
  Widget _buildContentBox() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 20.0),
      child: Container(
        decoration: BoxDecoration(
          color: _lightColor,
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              _buildTitle(),
              const SizedBox(height: 40),
              _buildTextFields(),
              const SizedBox(height: 20),
              _buildGenderSelection(),
              const SizedBox(height: 20),
              _buildHeightField(),
              const SizedBox(height: 20),
              _buildWeightField(),
              const SizedBox(height: 20),
              _buildLimitationsSwitch(),
              const SizedBox(height: 20),
              _buildTermsCheckbox(),
              const SizedBox(height: 20),
              _buildRegisterButton(),
              const SizedBox(height: 20),
              _buildLoginRedirectText(),
            ],
          ),
        ),
      ),
    );
  }

  // Construye el título "Registro"
  Widget _buildTitle() {
    return Text(
      "Registro",
      style: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: _mediumColor,
      ),
    );
  }

  // Construye los campos de texto iniciales (Nombre, Correo, Contraseña, Edad)
  Widget _buildTextFields() {
    return Column(
      children: [
        _buildTextField(
          controller: _nameController,
          icon: Icons.person,
          hintText: "Nombre completo",
        ),
        const SizedBox(height: 20),
        _buildTextField(
          controller: _emailController,
          icon: Icons.email,
          hintText: "Correo electrónico",
        ),
        const SizedBox(height: 20),
        _buildTextField(
          controller: _passwordController,
          icon: Icons.lock,
          hintText: "Contraseña",
          obscureText: !_isPasswordVisible,
          suffixIcon: IconButton(
            icon: Icon(
              _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
              color: _mediumColor,
            ),
            onPressed: () {
              setState(() {
                _isPasswordVisible = !_isPasswordVisible;
              });
            },
          ),
        ),
        const SizedBox(height: 20),
        _buildTextField(
          controller: _ageController,
          icon: Icons.cake,
          hintText: "Edad",
          keyboardType: TextInputType.number,
        ),
      ],
    );
  }

  // Construye un campo de texto genérico
  Widget _buildTextField({
    required TextEditingController controller,
    required IconData icon,
    required String hintText,
    bool obscureText = false,
    TextInputType keyboardType = TextInputType.text,
    Widget? suffixIcon,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      style: const TextStyle(color: Colors.black),
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: _mediumColor),
        hintText: hintText,
        hintStyle: const TextStyle(color: Colors.grey),
        border: UnderlineInputBorder(
          borderSide: BorderSide(color: _mediumColor),
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: _mediumColor),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: _mediumColor, width: 2),
        ),
        suffixIcon: suffixIcon,
      ),
    );
  }

  // Construye la selección de género
  Widget _buildGenderSelection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Género: ",
          style: TextStyle(color: _mediumColor, fontSize: 16),
        ),
        ToggleButtons(
          borderColor: _mediumColor,
          selectedBorderColor: _mediumColor,
          fillColor: _mediumColor,
          selectedColor: Colors.white,
          color: _mediumColor,
          children: const [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text("Mujer"),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
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
    );
  }

  // Construye el campo de altura
  Widget _buildHeightField() {
    return _buildTextField(
      controller: _heightController,
      icon: Icons.height,
      hintText: "Altura (cm)",
      keyboardType: TextInputType.number,
    );
  }

  // Construye el campo de peso
  Widget _buildWeightField() {
    return _buildTextField(
      controller: _weightController,
      icon: Icons.fitness_center,
      hintText: "Peso (kg)",
      keyboardType: TextInputType.number,
    );
  }

  // Construye el interruptor de limitaciones
  Widget _buildLimitationsSwitch() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Limitaciones: ",
          style: TextStyle(color: _mediumColor, fontSize: 16),
        ),
        Switch(
          value: _hasLimitations,
          onChanged: (value) {
            setState(() {
              _hasLimitations = value;
            });
          },
          activeColor: _mediumColor,
          inactiveThumbColor: Colors.grey,
          inactiveTrackColor: Colors.grey[300],
        ),
        Text(
          _hasLimitations ? "Sí" : "No",
          style: TextStyle(color: _mediumColor, fontSize: 16),
        ),
      ],
    );
  }

  // Construye el checkbox de términos
  Widget _buildTermsCheckbox() {
    return Row(
      children: [
        Checkbox(
          value: _termsAccepted,
          onChanged: (value) {
            setState(() {
              _termsAccepted = value ?? false;
            });
          },
          activeColor: _mediumColor,
        ),
        Expanded(
          child: GestureDetector(
            onTap: () {
              // Aquí puedes navegar a la política de tratamiento de datos
            },
            child: Text(
              "Acepto la Política de Tratamiento de Datos",
              style: TextStyle(
                color: _mediumColor,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
        ),
      ],
    );
  }

  // Construye el botón de registro
  Widget _buildRegisterButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _termsAccepted ? _register : null,
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.zero, // Eliminamos el padding del botón para que el Container controle el tamaño
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          elevation: 0, // Sin sombra
          backgroundColor: Colors.transparent, // Siempre transparente
          foregroundColor: Colors.transparent, // Eliminar efectos de superposición
          surfaceTintColor: Colors.transparent, // Eliminar tintes
        ),
        child: Container(
          decoration: BoxDecoration(
            gradient: _termsAccepted
                ? const LinearGradient(
                    colors: [_mediumColor, _darkColor],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  )
                : null,
            color: _termsAccepted ? null : Colors.grey[400], // Gris sólido cuando deshabilitado
            borderRadius: BorderRadius.circular(10.0),
          ),
          padding: const EdgeInsets.symmetric(vertical: 15.0), // Consistente en ambos estados
          alignment: Alignment.center,
          child: const Text(
            "Registrarse",
            style: TextStyle(
              fontSize: 18,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  // Construye el texto para redirigir al login
  Widget _buildLoginRedirectText() {
    return GestureDetector(
      onTap: () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginScreen()),
        );
      },
      child: Center(
        child: Text(
          "¿Ya tienes una cuenta? Inicia sesión",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: _mediumColor,
            decoration: TextDecoration.underline,
          ),
        ),
      ),
    );
  }

  // Función para manejar el registro
  Future<void> _register() async {
    String name = _nameController.text.trim();
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();
    String age = _ageController.text.trim();
    String height = _heightController.text.trim();
    String weight = _weightController.text.trim();
    bool gender = _isFemale;
    bool limitations = _hasLimitations;

    if (name.isEmpty ||
        email.isEmpty ||
        password.isEmpty ||
        age.isEmpty ||
        height.isEmpty ||
        weight.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Por favor, complete todos los campos."),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (password.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("La contraseña debe tener al menos 6 caracteres."),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await FirebaseFirestore.instance
          .collection('usuarios')
          .doc(userCredential.user!.uid)
          .set({
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
        const SnackBar(
          content: Text("Usuario registrado exitosamente."),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error al registrar usuario: $e"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _ageController.dispose();
    _heightController.dispose();
    _weightController.dispose();
    super.dispose();
  }
}