import 'package:flutter/material.dart';
import 'package:gym_fitgo/screens/home_screen.dart';
import 'package:gym_fitgo/services/notification_services.dart';

class BeginnerRoutineScreen extends StatefulWidget {
  const BeginnerRoutineScreen({super.key});

  @override
  State<BeginnerRoutineScreen> createState() => _BeginnerRoutineScreenState();
}
// Función para programar la notificación automática
void _scheduleNotification() async {
  await Future.delayed(Duration(seconds: 10)); // Retraso de 10 segundos
  await mostrarNotificacion(); // Llama a la función para mostrar la notificación
}

class _BeginnerRoutineScreenState extends State<BeginnerRoutineScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0a0322), // Fondo oscuro
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false, // Eliminar el botón de retroceso
        title: const Text(
          'Rutina recomendada del Mes',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              color: const Color(0xFF0A0322), // Color oscuro para el contenedor
              child: Text(
                'Entrenamiento full body - 50 min',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView(
                children: [
                  _buildRoutineCard(
                    'Salto de lazo',
                    'Después de estirar el cuerpo iniciaremos con saltar lazo por aproximadamente 10 min',
                    'https://st2.depositphotos.com/1041725/43852/v/1600/depositphotos_438526678-stock-illustration-girl-skipping-rope-illustration-vector.jpg',
                  ),
                  _buildRoutineCard(
                    'Sentadilla con salto',
                    'Luego, haremos una sentadilla sencilla sin peso, manteniendo la espalda recta bajando hasta la altura de la rodilla dando un pequeño salto al subir 3x15 repeticiones',
                    'https://media.istockphoto.com/id/1306353165/es/vector/joven-afroamericana-mujer-en-ropa-deportiva-haciendo-sentadillas-en-la-alfombra.jpg?s=612x612&w=0&k=20&c=fT7aKUWYw0rqVYn54i7zo6-RHsEFAl_MrY0voH33l8w=',
                  ),
                  _buildRoutineCard(
                    'Abdominales',
                    'Nos acostaremos en el piso con las rodillas dobladas hacia arriba,  nos pondremos las manos en la cien y levantaremos el cuerpo haciendo fuerza en el abdomen 3x15 repeticiones',
                    'https://www.shutterstock.com/image-vector/woman-doing-crunches-gym-belly-600nw-1234348741.jpg',
                  ),
                  _buildRoutineCard(
                    'Flexiones de pecho',
                    'Nos acostaremos en el piso boca arriba, podremos nuestras manos a lo ancho de nuestros hombros y empujaremos el piso levantandonos 3x15 repeticiones',
                    'https://media.istockphoto.com/id/578104104/es/vector/paso-a-la-instrucci%C3%B3n-en-push-up.jpg?s=612x612&w=0&k=20&c=RNxtdjWZVPjCdk6dBd4wlgNVX7qB6cPFoakeb1Mux8c=',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Navegar a la pantalla de finalización
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HomeScreen()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purpleAccent, // Color del botón
                padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 32.0),
              ),
              child: const Text(
                'Finalizada',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRoutineCard(String title, String description, String imageUrl) {
    return Card(
      color: const Color(0xFF1A1A2E), // Fondo oscuro para las tarjetas
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      margin: const EdgeInsets.only(bottom: 16.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            // Ícono o imagen a la izquierda
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                imageUrl,
                width: 60,  // Ajustamos el ancho de la imagen
                height: 60, // Ajustamos la altura de la imagen
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 16),
            // Texto a la derecha
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    description,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
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

// Pantalla de finalización
class CompletionScreen extends StatelessWidget {
  const CompletionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0322),
      appBar: AppBar(
        title: const Text('Rutina Finalizada'),
        backgroundColor: Colors.deepPurple,
      ),
      body: Center(
        child: const Text(
          '¡Felicidades! Has completado la rutina.',
          style: TextStyle(color: Colors.white, fontSize: 24),
        ),
      ),
    );
  }
}
