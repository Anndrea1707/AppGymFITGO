import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Importa Firestore
import 'package:gym_fitgo/widgets/custom_bottom_navbar.dart';
import 'exercise_description_screen.dart';

class RutinasScreen extends StatefulWidget {
  @override
  RutinasScreenState createState() => RutinasScreenState();
}

class RutinasScreenState extends State<RutinasScreen> {
  int _selectedIndex = 0; // Índice seleccionado

  // Referencia a la colección de Firestore
  final CollectionReference _routinesCollection =
      FirebaseFirestore.instance.collection('RutinasAdmin');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 21, 2, 34), // Fondo oscuro
      appBar: AppBar(
        backgroundColor: const Color(0xFFF5EDE4),
        title: const Text(
          'Rutina Semanal',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _routinesCollection.snapshots(), // Escuchar cambios en tiempo real
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          var routines = snapshot.data!.docs;

          if (routines.isEmpty) {
            return Center(
              child: Text(
                'No hay rutinas disponibles.',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: routines.length,
            itemBuilder: (context, index) {
              var routineDoc = routines[index];
              var routine = routineDoc.data() as Map<String, dynamic>? ?? {};
              return _buildRoutineCard(routine);
            },
          );
        },
      ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: 1,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }

  Widget _buildRoutineCard(Map<String, dynamic> routine) {
    // Manejo de valores null con valores por defecto
    final day = routine['day']?.toString() ?? 'Sin día';
    final description = routine['description']?.toString() ?? 'Sin descripción';
    final exercises = routine['exercises'] is List
        ? List<String>.from(routine['exercises'].map((e) => e?.toString() ?? 'Sin ejercicio'))
        : ['Sin ejercicios'];
    final image = routine['image']?.toString() ?? 'https://via.placeholder.com/100';

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      color: Colors.grey[850],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(15.0),
              child: Image.network(
                image,
                width: 100,
                height: 100,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Icon(Icons.error, size: 100, color: Colors.white);
                },
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    day,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: const TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ExerciseDescriptionScreen(
                            day: day,
                            description: description,
                            exercises: exercises,
                            image: image,
                          ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 192, 125, 204),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                    ),
                    child: const Text('Ver rutina'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}