import 'package:flutter/material.dart';
import 'package:gym_fitgo/screens/home_screen.dart'; // Importar pantallas desde archivos separados
import 'package:gym_fitgo/screens/challenges_screen.dart';
import 'package:gym_fitgo/screens/profile_screen.dart';
import 'package:gym_fitgo/screens/rutinas_screen.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  CustomBottomNavBar({
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: Color(0xFFF5EDE4), // Fondo beige
      selectedItemColor: Colors.purple,   // Color morado para los íconos seleccionados
      unselectedItemColor: Colors.black,  // Color negro para los no seleccionados
      currentIndex: currentIndex,         // Controla qué ítem está seleccionado
      onTap: (index) {
        // Cambiar la pantalla según el índice del botón presionado
        switch (index) {
          case 0:
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => HomeScreen()), // Pantalla de Principal en otro archivo
            );
            break;
          case 1:
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => RutinasScreen()), // Pantalla de Rutinas en otro archivo
            );
            break;
          case 2:
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ChallengesScreen()), // Pantalla de Retos en otro archivo
            );
            break;
          case 3:
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ProfileScreen()), // Pantalla de Perfil en otro archivo
            );
            break;
        }
      },
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Principal',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.fitness_center),
          label: 'Rutinas',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.flag),
          label: 'Retos',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Perfil',
        ),
      ],
    );
  }
}
