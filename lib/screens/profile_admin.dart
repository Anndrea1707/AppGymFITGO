import 'package:flutter/material.dart';
import 'package:gym_fitgo/screens/admin_home_screen.dart';
import 'package:gym_fitgo/screens/challenges_screen_admin.dart';
import 'package:gym_fitgo/screens/admin_rutins_screen.dart';
import 'package:gym_fitgo/widgets/custom_bottom_navbar_admin.dart'; // Asegúrate de importar tu CustomBottomNavBar

class ProfileAdmin extends StatefulWidget {
  @override
  _AdminProfileScreenState createState() => _AdminProfileScreenState();
}

class _AdminProfileScreenState extends State<ProfileAdmin> {
  int _currentIndex = 3; // Índice actual para el botón "Perfil"
  String name = 'Juan Pérez';  // Nombre del administrador
  int age = 35;                // Edad del administrador
  double weight = 75.0;        // Peso del administrador
  double height = 1.75;        // Altura del administrador

  @override
  void initState() {
    super.initState();
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
          MaterialPageRoute(builder: (context) => AdminHomeScreen()), // Pantalla Principal
        );
        break;
      case 1:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => AdminRutinsScreen()), // Pantalla Rutinas
        );
        break;
      case 2:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => ChallengesScreenAdmin()), // Pantalla Retos
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
                      backgroundImage: AssetImage('images/admin.jpg'),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      name,  // Nombre del administrador
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "Nivel: Administrador",  // Fijo el nivel de administrador
                      style: TextStyle(
                        color: Colors.white,
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
                  _buildUserDetail("Edad", "$age años"),
                  _buildUserDetail("Peso", "$weight kg"),
                  _buildUserDetail("Altura", "$height m"),
                  _buildUserDetail("Fecha inicio", "01/01/2020"),  // Fecha de inicio fija
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
                child: const Text("Actualizar", style: TextStyle(
                        color: Colors.white,))
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
      bottomNavigationBar: CustomBottomNavbarAdmin(
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
