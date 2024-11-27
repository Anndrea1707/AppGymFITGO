import 'package:flutter/material.dart';
import 'package:gym_fitgo/screens/admin_home_screen.dart';
import 'package:gym_fitgo/screens/challenges_screen_admin.dart';
import 'package:gym_fitgo/screens/profile_admin.dart';
import 'package:gym_fitgo/screens/admin_rutins_screen.dart';

class CustomBottomNavbarAdmin extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  CustomBottomNavbarAdmin({
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: Color(0xFFF5EDE4), // Fondo beige
      selectedItemColor:
          Colors.purple, // Color morado para los íconos seleccionados
      unselectedItemColor:
          Colors.black, // Color negro para los no seleccionados
      currentIndex: currentIndex, // Controla qué ítem está seleccionado
      onTap: (index) {
        // Cambiar la pantalla según el índice del botón presionado
        switch (index) {
          case 0:
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      AdminHomeScreen()), // Pantalla de Principal en otro archivo
            );
            break;
          case 1:
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AdminRutinsScreen()),
            );
            break;
          case 2:
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      ChallengesScreenAdmin()), // Pantalla de Retos en otro archivo
            );
            break;
          case 3:
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      ProfileAdmin()), // Pantalla de Perfil en otro archivo
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
