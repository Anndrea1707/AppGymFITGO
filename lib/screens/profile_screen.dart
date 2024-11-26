import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gym_fitgo/screens/home_screen.dart';
import 'package:gym_fitgo/screens/challenges_screen.dart';
import 'package:gym_fitgo/screens/rutinas_screen.dart';
import 'package:gym_fitgo/widgets/custom_bottom_navbar.dart'; // Asegúrate de importar tu CustomBottomNavBar

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  int _currentIndex = 3; // Índice actual para el botón "Perfil"
  String name = '';
  int age = 0;
  double weight = 0;
  double height = 0;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    // Obtén el ID del usuario actual desde Firebase Auth
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      // Busca los datos en la colección "Usuarios"
      DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('Usuarios').doc(user.uid).get();
      
      if (userDoc.exists) {
        // Obtén los datos del usuario
        var data = userDoc.data() as Map<String, dynamic>;
        setState(() {
          name = data['name'] ?? '';
          age = data['age'] ?? 0;
          weight = data['weight']?.toDouble() ?? 0.0;
          height = data['height']?.toDouble() ?? 0.0;
        });
      }
    }
  }

  void _onTap(int index) {
    // Actualiza el índice y navega a la pantalla correspondiente
    setState(() {
      _currentIndex = index;
    });

    switch (index) {
      case 0:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()), // Pantalla Principal
        );
        break;
      case 1:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => RutinasScreen()), // Pantalla Rutinas
        );
        break;
      case 2:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => ChallengesScreen()), // Pantalla Retos
        );
        break;
      case 3:
        // Queda en la pantalla de perfil
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E1039),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Encabezado del perfil
              Padding(
                padding: const EdgeInsets.only(top: 40.0, bottom: 16.0),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundImage: AssetImage('assets/avatar_placeholder.png'),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      name.isEmpty ? "Cargando..." : name,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "Nivel: principiante", // Este valor lo puedes actualizar más tarde
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Detalles personales
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildUserDetail("Edad", age > 0 ? "$age años" : "Cargando..."),
                  _buildUserDetail("Peso", weight > 0 ? "$weight kg" : "Cargando..."),
                  _buildUserDetail("Altura", height > 0 ? "$height m" : "Cargando..."),
                  _buildUserDetail("Fecha inicio", "03/03/2024"), // Este dato es fijo por ahora
                ],
              ),
              const SizedBox(height: 24),

              // Botón actualizar
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF7E57C2),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text("Actualizar"),
              ),
              const SizedBox(height: 24),

              // Calendario de entrenamiento
              Container(
                decoration: BoxDecoration(
                  color: Colors.white10,
                  borderRadius: BorderRadius.circular(16),
                ),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Días entrenamiento",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      children: ["Lunes", "Martes", "Miércoles", "Jueves", "Viernes"]
                          .map((day) => Chip(
                                label: Text(day),
                                backgroundColor: Colors.purple.shade200,
                              ))
                          .toList(),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Retos y Trofeos
              _buildSection("Retos participación"),
              const SizedBox(height: 16),
              _buildSection("Trofeos"),
            ],
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _currentIndex,
        onTap: _onTap,
      ),
    );
  }

  Widget _buildUserDetail(String title, String value) {
    return Column(
      children: [
        Text(
          title,
          style: TextStyle(color: Colors.white70, fontSize: 14),
        ),
        Text(
          value,
          style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildSection(String title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildCard("Reto de resistencia", "30 min - 1 hora"),
            _buildCard("Reto mensual", "25 días"),
          ],
        ),
      ],
    );
  }

  Widget _buildCard(String title, String subtitle) {
    return Container(
      width: 150,
      decoration: BoxDecoration(
        color: Colors.white10,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: TextStyle(
              color: Colors.white70,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
