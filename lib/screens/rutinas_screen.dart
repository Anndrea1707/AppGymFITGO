import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:gym_fitgo/widgets/custom_bottom_navbar.dart';
import 'exercise_description_screen.dart';

class RutinasScreen extends StatefulWidget {
  @override
  RutinasScreenState createState() => RutinasScreenState();
}

class RutinasScreenState extends State<RutinasScreen> {
  int _selectedIndex = 1;
  String? _userEmail;
  String? _userId;

  final CollectionReference _routinesCollection =
      FirebaseFirestore.instance.collection('Rutinas');

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? email = prefs.getString('user_email');

    print('Email obtenido de SharedPreferences: $email');

    if (email != null) {
      final userDoc = await FirebaseFirestore.instance
          .collection('usuarios')
          .where('email', isEqualTo: email)
          .get();

      if (userDoc.docs.isNotEmpty) {
        setState(() {
          _userEmail = email;
          _userId = userDoc.docs.first.id;
          print('UserId obtenido: $_userId');
        });
      } else {
        print('No se encontró un usuario con el email: $email');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('No se encontró el usuario con este email')),
        );
      }
    } else {
      print('No se encontró el email en SharedPreferences');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No se encontró el email del usuario')),
      );
    }
  }

  void _onNavBarTapped(int index) {
    if (index != _selectedIndex) {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2B192E),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF8E1FF),
        title: const Text(
          'Rutinas de la Semana',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _userId != null
            ? _routinesCollection.where('userId', isEqualTo: _userId).snapshots()
            : const Stream.empty(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            print('Error en StreamBuilder: ${snapshot.error}');
            return Center(child: Text('Error: ${snapshot.error}', style: TextStyle(color: Colors.white)));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data == null) {
            print('No hay datos en el snapshot para userId $_userId');
            return Center(
              child: Text(
                'No hay datos disponibles.',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            );
          }

          var routines = snapshot.data!.docs;

          print('Rutinas encontradas para userId $_userId: ${routines.length}');

          if (routines.isEmpty) {
            return Center(
              child: Text(
                'No hay rutinas disponibles para ti.',
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
              return _buildRoutineCard(routine, routineDoc.id);
            },
          );
        },
      ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _selectedIndex,
        onTap: _onNavBarTapped,
      ),
    );
  }

  Widget _buildRoutineCard(Map<String, dynamic> routine, String routineId) {
    final day = routine['name']?.toString() ?? 'Sin día';
    final description = routine['description']?.toString() ?? 'Sin descripción';
    final exercises = routine['exercises'] is List
        ? List<Map<String, dynamic>>.from(routine['exercises'])
        : <Map<String, dynamic>>[];

    final exerciseCount = exercises.length;

    int totalTimeInSeconds = 0;
    for (var exercise in exercises) {
      final timer = exercise['timer'] as int? ?? 0;
      totalTimeInSeconds += timer;
    }

    final hours = totalTimeInSeconds ~/ 3600;
    final minutes = (totalTimeInSeconds ~/ 60) % 60;
    final seconds = totalTimeInSeconds % 60;
    final totalTimeString = hours > 0
        ? '$hours h $minutes m $seconds s'
        : minutes > 0
            ? '$minutes m $seconds s'
            : '$seconds s';

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      color: const Color(0xFFF8E1FF),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  day,
                  style: const TextStyle(
                    color: Color(0xFF2B192E),
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: const TextStyle(color: Color.fromARGB(255, 43, 25, 46), fontSize: 14),
                ),
                const SizedBox(height: 8),
                Text(
                  'Cantidad de ejercicios: $exerciseCount',
                  style: const TextStyle(color: Color.fromARGB(255, 43, 25, 46), fontSize: 14),
                ),
                const SizedBox(height: 4),
                Text(
                  'Tiempo total: $totalTimeString',
                  style: const TextStyle(color: Color.fromARGB(255, 43, 25, 46), fontSize: 14),
                ),
              ],
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: ElevatedButton(
                onPressed: () async {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ExerciseDescriptionScreen(
                        day: day,
                        description: description,
                        exercises: exercises,
                        equipmentIds: routine['equipmentIds']?.cast<String>() ?? [],
                        image: null,
                        routineId: routineId,
                        userId: _userId,
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF7A0180),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                ),
                child: const Text(
                  'Ver rutina',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}