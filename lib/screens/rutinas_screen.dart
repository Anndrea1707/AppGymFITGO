import 'package:flutter/material.dart';
import 'package:gym_fitgo/widgets/custom_bottom_navbar.dart';
import 'package:gym_fitgo/services/notification_services.dart';
import 'exercise_description_screen.dart'; // Asegúrate de importar esta pantalla

class RutinasScreen extends StatefulWidget {
  @override
  RutinasScreenState createState() => RutinasScreenState();
}

void _scheduleNotification() async {
  await Future.delayed(Duration(seconds: 10)); // Retraso de 10 segundos
  await mostrarNotificacion(); // Llama a la función para mostrar la notificación
}

class RutinasScreenState extends State<RutinasScreen> {
  int _selectedIndex = 0; // Añadimos el índice seleccionado

  @override
  void initState() {
    super.initState();
  }

  void _onNavBarTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 21, 2, 34), // Fondo oscuro
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 152, 51, 211), // Color beige del AppBar
        title: const Text(
          'Rutina Semanal',
          style: TextStyle(color: Color.fromARGB(255, 248, 247, 247)),
        ),
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: 5, // El número de rutinas
        itemBuilder: (context, index) {
          return _buildRoutineCard(index);
        },
      ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: 1,
        onTap: _onNavBarTapped,
      ),
    );
  }

  Widget _buildRoutineCard(int index) {
    List<Map<String, dynamic>> routines = [
      {
        'day': 'Día 1',
        'description': 'Rutina de piernas y glúteos',
        'buttonText': 'Continuar',
        'exercises': [
          'Flexión de rodilla: 3x20',
          'Prensa de piernas: 3x20',
          'Front squat: 3x20',
          'Squat jump: 3x20'
        ],
        'image': 'https://www.shutterstock.com/image-vector/man-doing-smashbell-training-leg-260nw-2364568263.jpg'
      },
      {
        'day': 'Día 2',
        'description': 'Rutina de espalda y brazos',
        'buttonText': 'Iniciar',
        'exercises': [
          'Dominadas: 3x12',
          'Remo con mancuernas: 3x15',
          'Curl de bíceps: 3x12',
          'Press de hombro: 3x12'
        ],
        'image': 'https://static.vecteezy.com/system/resources/previews/005/178/325/non_2x/woman-doing-overhead-dumbbell-shoulder-press-exercise-flat-illustration-isolated-on-white-background-free-vector.jpg'
      },
      {
        'day': 'Día 3',
        'description': 'Rutina de piernas y cuadriceps',
        'buttonText': 'Iniciar',
        'exercises': [
          'Sentadilla búlgara: 3x12',
          'Extensiones de pierna: 3x15',
          'Peso muerto: 3x15',
          'Lunges: 3x20'
        ],
        'image': 'https://www.shutterstock.com/image-vector/woman-doing-barbell-romanian-deadlifts-600nw-2309715515.jpg'
      },
      {
        'day': 'Día 4',
        'description': 'Rutina de pecho y hombros',
        'buttonText': 'Iniciar',
        'exercises': [
          'Press de banca: 3x12',
          'Aperturas: 3x15',
          'Elevaciones laterales: 3x12',
          'Flexiones: 3x20'
        ],
        'image': 'https://www.shutterstock.com/image-vector/woman-doing-lateral-side-shoulder-600nw-2032680152.jpg'
      },
      {
        'day': 'Día 5',
        'description': 'Rutina de abdomen y core',
        'buttonText': 'Iniciar',
        'exercises': [
          'Plancha: 3x1 min',
          'Crunches: 3x20',
          'Russian twists: 3x20',
          'Levantamiento de piernas: 3x15'
        ],
        'image': 'https://www.shutterstock.com/image-vector/woman-doing-forearm-plank-exercise-260nw-2069690030.jpg'
      },
    ];

    var routine = routines[index];

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      color: Colors.grey[850], // Fondo oscuro para las tarjetas
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            // Imagen a la izquierda
            ClipRRect(
              borderRadius: BorderRadius.circular(15.0),
              child: Image.network(
                routine['image']!,
                width: 100,
                height: 100,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 16),
            // Columna para el texto
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    routine['day']!,
                    style: const TextStyle(
                      color: Color.fromARGB(255, 255, 255, 255),
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    routine['description']!,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 10),
                  // ExpansionTile con color de fondo y bordes redondeados
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.purple, // Color de fondo
                      borderRadius: BorderRadius.circular(12.0), // Bordes redondeados
                    ),
                    child: ExpansionTile(
                      title: const Text(
                        'Ver ejercicios',
                        style: TextStyle(
                          color: Colors.white, // Color del texto
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      children: routine['exercises']!
                          .map<Widget>((exercise) => ListTile(
                                title: Text(exercise),
                                tileColor: const Color.fromARGB(255, 247, 244, 244), // Fondo de los elementos
                              ))
                          .toList(),
                    ),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ExerciseDescriptionScreen(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 192, 125, 204),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                    ),
                    child: Text(routine['buttonText']!),
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
