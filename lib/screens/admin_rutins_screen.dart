import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gym_fitgo/widgets/custom_bottom_navbar_admin.dart';
import 'package:gym_fitgo/screens/admin_home_screen.dart';
import 'exercise_description_screen.dart';
import 'package:gym_fitgo/screens/challenges_screen_admin.dart';
import 'package:gym_fitgo/screens/statistics_screen.dart';

class AdminRutinsScreen extends StatefulWidget {
  @override
  RutinasScreenAdminState createState() => RutinasScreenAdminState();
}

class RutinasScreenAdminState extends State<AdminRutinsScreen> {
  int _currentIndex = 1;

  void _onTap(int index) {
    setState(() {
      _currentIndex = index;
    });

    switch (index) {
      case 0:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => AdminHomeScreen()),
        );
        break;
      case 1:
        break;
      case 2:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => ChallengesScreenAdmin()),
        );
        break;
      case 3:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => StatisticsScreen()),
        );
        break;
    }
  }

  // Controladores para el formulario
  final TextEditingController _dayController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _exercisesController = TextEditingController();
  final TextEditingController _imageUrlController = TextEditingController();

  // Referencia a la colección de Firestore
  final CollectionReference _routinesCollection =
      FirebaseFirestore.instance.collection('RutinasAdmin');

  void _addRoutine() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Agregar Nueva Rutina'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _dayController,
                decoration: InputDecoration(labelText: 'Día'),
              ),
              TextField(
                controller: _descriptionController,
                decoration: InputDecoration(labelText: 'Descripción'),
              ),
              TextField(
                controller: _exercisesController,
                decoration: InputDecoration(
                    labelText: 'Ejercicios (separados por coma)'),
              ),
              TextField(
                controller: _imageUrlController,
                decoration: InputDecoration(labelText: 'URL de la imagen'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancelar'),
            ),
            TextButton(
              onPressed: () async {
                try {
                  await _routinesCollection.add({
                    'day': _dayController.text.isEmpty ? 'Sin día' : _dayController.text,
                    'description': _descriptionController.text.isEmpty ? 'Sin descripción' : _descriptionController.text,
                    'exercises': _exercisesController.text.isEmpty
                        ? ['Sin ejercicios']
                        : _exercisesController.text.split(',').map((e) => e.trim()).toList(),
                    'image': _imageUrlController.text.isEmpty
                        ? 'https://via.placeholder.com/100'
                        : _imageUrlController.text,
                  });

                  _dayController.clear();
                  _descriptionController.clear();
                  _exercisesController.clear();
                  _imageUrlController.clear();

                  Navigator.pop(context);

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Rutina agregada con éxito')),
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error al agregar rutina: $e')),
                  );
                }
              },
              child: Text('Agregar'),
            ),
          ],
        );
      },
    );
  }

  void _deleteRoutine(String routineId) async {
    bool? confirmDelete = await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Confirmar eliminación'),
          content: Text('¿Estás seguro de que quieres eliminar esta rutina?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text('Cancelar'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text('Eliminar'),
            ),
          ],
        );
      },
    );

    if (confirmDelete == true) {
      try {
        await _routinesCollection.doc(routineId).delete();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Rutina eliminada con éxito')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al eliminar rutina: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 21, 2, 34),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF5EDE4),
        title: const Text(
          'Rutinas administrador',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _routinesCollection.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          var routines = snapshot.data!.docs;

          return ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: routines.length,
            itemBuilder: (context, index) {
              var routineDoc = routines[index];
              var routine = routineDoc.data() as Map<String, dynamic>? ?? {};
              return _buildRoutineCard(routine, routineDoc.id);
            },
          );
        },
      ),
      bottomNavigationBar: CustomBottomNavbarAdmin(
        currentIndex: _currentIndex,
        onTap: _onTap,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addRoutine,
        backgroundColor: Colors.purple,
        child: Icon(Icons.add),
      ),
    );
  }

  Widget _buildRoutineCard(Map<String, dynamic> routine, String routineId) {
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
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
                      IconButton(
                        onPressed: () => _deleteRoutine(routineId),
                        icon: Icon(Icons.delete, color: Colors.red),
                        tooltip: 'Eliminar rutina',
                      ),
                    ],
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