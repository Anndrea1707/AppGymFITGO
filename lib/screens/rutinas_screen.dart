import 'package:flutter/material.dart';
import 'package:gym_fitgo/widgets/custom_bottom_navbar.dart';
import 'exercise_description_screen.dart'; // Asegúrate de importar esta pantalla

class RutinasScreen extends StatefulWidget {
  @override
  RutinasScreenState createState() => RutinasScreenState();
}

class RutinasScreenState extends State<RutinasScreen> {
  int _selectedIndex = 0; // Índice seleccionado

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 21, 2, 34), // Fondo oscuro
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 152, 51, 211),
        title: const Text(
          'Rutina Semanal',
          style: TextStyle(color: Color.fromARGB(255, 248, 247, 247)),
        ),
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: 5, // Número de rutinas
        itemBuilder: (context, index) {
          return _buildRoutineCard(index);
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

  Widget _buildRoutineCard(int index) {
    List<Map<String, dynamic>> routines = [
      {
        'day': 'Día 1',
        'description': 'Rutina de piernas y glúteos',
        'exercises': [
          'Flexión de rodilla: 3x20',
          'Prensa de piernas: 3x20',
          'Front squat: 3x20',
          'Squat jump: 3x20'
        ],
        'image': 'https://homeworkouts.org/wp-content/uploads/anim-dumbbell-deadlifts.gif'
      },
      {
        'day': 'Día 2',
        'description': 'Rutina de espalda y brazos',
        'exercises': [
          'Dominadas: 3x12',
          'Remo con mancuernas: 3x15',
          'Curl de bíceps: 3x12',
          'Press de hombro: 3x12'
        ],
        'image': 'https://www.fitundattraktiv.de/wp-content/uploads/2017/09/latziehen_enger_griff-neutrales_griffstueck.gif'
      },
      {
        'day': 'Día 3',
        'description': 'Rutina de piernas y cuadriceps',
        'exercises': [
          'Sentadilla búlgara: 3x12',
          'Extensiones de pierna: 3x15',
          'Peso muerto: 3x15',
          'Lunges: 3x20'
        ],
        'image': 'https://liftmanual.com/wp-content/uploads/2023/04/squat-mobility.gif'
      },
      {
        'day': 'Día 4',
        'description': 'Rutina de pecho y hombros',
        'exercises': [
          'Press de banca: 3x12',
          'Aperturas: 3x15',
          'Elevaciones laterales: 3x12',
          'Flexiones: 3x20'
        ],
        'image': 'https://i.pinimg.com/originals/8b/d3/74/8bd3745dca0749b912b08b0d4bca3833.gif'
      },
      {
        'day': 'Día 5',
        'description': 'Rutina de abdomen y core',
        'exercises': [
          'Plancha: 3x1 min',
          'Crunches: 3x20',
          'Russian twists: 3x20',
          'Levantamiento de piernas: 3x15'
        ],
        'image': 'https://fitliferegime.com/wp-content/uploads/2024/06/Hanging-Knee-Raise.gif'
      },
    ];

    var routine = routines[index];

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
                routine['image'],
                width: 100,
                height: 100,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    routine['day'],
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    routine['description'],
                    style: const TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ExerciseDescriptionScreen(
                            day: routine['day'],
                            description: routine['description'],
                            exercises: routine['exercises'],
                            image: routine['image'],
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
