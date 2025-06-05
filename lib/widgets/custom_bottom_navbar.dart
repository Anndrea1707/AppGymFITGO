import 'package:flutter/material.dart';
import 'package:gym_fitgo/screens/home_screen.dart';
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
      backgroundColor: Color(0xFFF5EDE4), // Fondo claro
      selectedItemColor: Colors.purple,   // Íconos seleccionados en morado
      unselectedItemColor: Colors.black,  // Íconos no seleccionados en negro
      currentIndex: currentIndex,
      onTap: (index) {
        onTap(index); // Actualiza el índice en el estado padre
        // Navega solo si no estamos en la pantalla actual
        if (index != currentIndex) {
          switch (index) {
            case 0:
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => HomeScreen()),
              );
              break;
            case 1:
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => RutinasScreen()),
              );
              break;
            case 2:
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => ChallengesScreen()),
              );
              break;
            case 3:
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => ProfileScreen()),
              );
              break;
          }
        }
      },
      items: [
        BottomNavigationBarItem(
          icon: Image.asset('images/gimnasia.png', width: 24, height: 24),
          label: 'Principal',
        ),
        BottomNavigationBarItem(
          icon: Image.asset('images/rutina-de-ejercicios.png', width: 24, height: 24),
          label: 'Rutinas',
        ),
        BottomNavigationBarItem(
          icon: Image.asset('images/entrenamiento-de-fuerza.png', width: 24, height: 24),
          label: 'Retos',
        ),
        BottomNavigationBarItem(
          icon: Image.asset('images/perfil.png', width: 24, height: 24),
          label: 'Perfil',
        ),
      ],
    );
  }
}