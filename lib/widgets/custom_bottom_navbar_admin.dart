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
      backgroundColor: Color(0xFFF8E1FF), // Fondo claro de referencia
      selectedItemColor: Colors.purple, // Color morado para los ítems seleccionados
      unselectedItemColor: Colors.black, // Color negro para los no seleccionados
      currentIndex: currentIndex, // Controla qué ítem está seleccionado
      onTap: (index) {
        // Llamar al callback onTap para notificar el cambio de índice
        onTap(index);
        // Cambiar la pantalla según el índice del botón presionado
        switch (index) {
          case 0:
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => AdminHomeScreen()), // Pantalla de Principal
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
                  builder: (context) => ChallengesScreenAdmin()), // Pantalla de Retos
            );
            break;
          case 3:
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => ProfileAdmin()), // Pantalla de Perfil
            );
            break;
        }
      },
      items: [
        BottomNavigationBarItem(
          icon: Image.asset(
            "images/gimnasia.png", // Asegúrate de que este archivo exista y esté declarado en pubspec.yaml
            width: 24,
            height: 24,
            color: currentIndex == 0 ? Colors.purple : Colors.black, // Color según el estado
          ),
          label: 'Principal',
        ),
        BottomNavigationBarItem(
          icon: Image.asset(
            "images/rutina-de-ejercicios.png", // Asegúrate de que este archivo exista y esté declarado en pubspec.yaml
            width: 24,
            height: 24,
            color: currentIndex == 1 ? Colors.purple : Colors.black, // Color según el estado
          ),
          label: 'Rutinas',
        ),
        BottomNavigationBarItem(
          icon: Image.asset(
            "images/entrenamiento-de-fuerza.png", // Asegúrate de que este archivo exista y esté declarado en pubspec.yaml
            width: 24,
            height: 24,
            color: currentIndex == 2 ? Colors.purple : Colors.black, // Color según el estado
          ),
          label: 'Retos',
        ),
        BottomNavigationBarItem(
          icon: Image.asset(
            "images/perfil.png", // Asegúrate de que este archivo exista y esté declarado en pubspec.yaml
            width: 24,
            height: 24,
            color: currentIndex == 3 ? Colors.purple : Colors.black, // Color según el estado
          ),
          label: 'Perfil',
        ),
      ],
    );
  }
}