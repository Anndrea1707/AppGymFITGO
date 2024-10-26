import 'package:flutter/material.dart';
import 'package:gym_fitgo/widgets/custom_bottom_navbar.dart';
import 'package:gym_fitgo/services/notification_services.dart';

class RutinasScreen extends StatefulWidget {
  @override
  RutinasScreenState createState() => RutinasScreenState();
}
// Función para programar la notificación automática
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
      backgroundColor: const Color(0xFF0a0322),
      appBar: AppBar(
        automaticallyImplyLeading: false, // Elimina el botón de "Back"
        centerTitle: true,
        title: const Text(
          'Rutina Semanal',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            _buildRoutineCard(
              'Día 1',
              'Rutina de piernas y glúteos',
              'Continuar',
              [
                'Flexión de rodilla: 3x20',
                'Prensa de piernas: 3x20',
                'Front squat: 3x20',
                'Squat jump: 3x20'
              ],
              'https://www.shutterstock.com/image-vector/man-doing-smashbell-training-leg-260nw-2364568263.jpg',
              widthFactor: 0.9, // Ajusta el ancho del Card aquí
            ),
            _buildRoutineCard(
              'Día 2',
              'Rutina de espalda y brazos',
              'Iniciar',
              [
                'Dominadas: 3x12',
                'Remo con mancuernas: 3x15',
                'Curl de bíceps: 3x12',
                'Press de hombro: 3x12'
              ],
              'https://static.vecteezy.com/system/resources/previews/005/178/325/non_2x/woman-doing-overhead-dumbbell-shoulder-press-exercise-flat-illustration-isolated-on-white-background-free-vector.jpg',
              widthFactor: 0.9, // Ajusta el ancho del Card aquí
            ),
            _buildRoutineCard(
              'Día 3',
              'Rutina de piernas y cuadriceps',
              'Iniciar',
              [
                'Sentadilla búlgara: 3x12',
                'Extensiones de pierna: 3x15',
                'Peso muerto: 3x15',
                'Lunges: 3x20'
              ],
              'https://www.shutterstock.com/image-vector/woman-doing-barbell-romanian-deadlifts-600nw-2309715515.jpg',
              widthFactor: 0.9, // Ajusta el ancho del Card aquí
            ),
            _buildRoutineCard(
              'Día 4',
              'Rutina de pecho y hombros',
              'Iniciar',
              [
                'Press de banca: 3x12',
                'Aperturas: 3x15',
                'Elevaciones laterales: 3x12',
                'Flexiones: 3x20'
              ],
              'https://www.shutterstock.com/image-vector/woman-doing-lateral-side-shoulder-600nw-2032680152.jpg',
              widthFactor: 0.9, // Ajusta el ancho del Card aquí
            ),
            _buildRoutineCard(
              'Día 5',
              'Rutina de abdomen y core',
              'Iniciar',
              [
                'Plancha: 3x1 min',
                'Crunches: 3x20',
                'Russian twists: 3x20',
                'Levantamiento de piernas: 3x15'
              ],
              'https://www.shutterstock.com/image-vector/woman-doing-forearm-plank-exercise-260nw-2069690030.jpg',
              widthFactor: 0.9, // Ajusta el ancho del Card aquí
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _selectedIndex,
        onTap: _onNavBarTapped, // Rutinas será la segunda pestaña
      ),
    );
  }

  Widget _buildRoutineCard(String day, String description, String buttonText,
      List<String> exercises, String imageUrl,
      {required double widthFactor}) {
    return FractionallySizedBox(
      widthFactor: widthFactor, // El ancho lo ajustas aquí
      child: Card(
        color: Colors.deepPurple[50],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        margin: const EdgeInsets.only(bottom: 16.0),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Imagen a la izquierda
              ClipRRect(
                borderRadius: BorderRadius.circular(10), // Bordes redondeados
                child: Image.network(
                  imageUrl,
                  width: 100, // Ancho fijo para la imagen
                  height: 100, // Alto fijo para la imagen
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(
                  width: 16), // Espacio entre la imagen y el contenido
              // Columna con el contenido del texto
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CircularProgressIndicator(
                          value: 0.45, // Progreso fijo (ajustable)
                          backgroundColor: Colors.grey[300],
                          color: Colors.deepPurple,
                        ),
                        const SizedBox(width: 16),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              day,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                            Text(description),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    // Lista de ejercicios desplegable
                    ExpansionTile(
                      title: const Text('Ver ejercicios'),
                      children: exercises.map((exercise) {
                        return ListTile(
                          title: Text(exercise),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 10),
                    // Botón para iniciar rutina
                    ElevatedButton(
                      onPressed: () {
                        // Acciones de los botones
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.purpleAccent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(buttonText),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
