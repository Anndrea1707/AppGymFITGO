import 'package:flutter/material.dart';
import 'package:gym_fitgo/widgets/custom_bottom_navbar.dart'; // Importa la barra de navegación

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ChallengesScreen(),
    );
  }
}

class ChallengesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> challenges = [
      {
        'titulo': 'Reto de fuerza máxima',
        'duracion': '1-2 horas',
        'fecha': '5 días',
        'imagen':
            'https://images.unsplash.com/photo-1605296867304-46d5465a13f1?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&q=80&w=400',
      },
      {
        'titulo': 'Reto de resistencia',
        'duracion': '30 min - 1 hora',
        'fecha': '5 días',
        'imagen':
            'https://blogscdn.thehut.net/app/uploads/sites/450/2020/08/plancha-abdominal_1593691323_1200x672_acf_cropped.jpg',
      },
      {
        'titulo': 'Reto mensual',
        'duracion': '30 días',
        'fecha': '9 días',
        'imagen':
            'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcR0yMCUJ_iAuyqY5Pbip36lpXGn-_8vmGsl1A&s',
      },
      {
        'titulo': 'Reto dominadas',
        'duracion': '15-30 min',
        'fecha': '5 días',
        'imagen':
            'https://go-fit.es/wp-content/uploads/2022/04/dominadas-2.jpg',
      },
    ];

    return Scaffold(
      backgroundColor: const Color(0xFF0A0322),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF5EDE4),
        title: const Text(
          'Retos del Mes',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: challenges.length,
        itemBuilder: (context, index) {
          final challenge = challenges[index];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8.0),
            color: Colors.transparent,
            elevation: 5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(15.0),
                  child: Image.network(
                    challenge['imagen']!,
                    width: double.infinity,
                    height: 200,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15.0),
                      gradient: LinearGradient(
                        colors: [
                          Colors.black.withOpacity(0.7),
                          Colors.transparent
                        ],
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 16,
                  left: 16,
                  right: 16,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        challenge['titulo']!,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Duración: ${challenge['duracion']}',
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        'Fecha: ${challenge['fecha']}',
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.purple,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ChallengeDetailScreen(
                                challenge: challenge,
                              ),
                            ),
                          );
                        },
                        child: const Text(
                          'Participar',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: 2, // Índice para "Retos"
        onTap: (index) {
          // Aquí no necesitas lógica extra, ya está en `CustomBottomNavBar`
        },
      ),
    );
  }
}

class ChallengeDetailScreen extends StatelessWidget {
  final Map<String, String> challenge;

  const ChallengeDetailScreen({Key? key, required this.challenge})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0322),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF5EDE4),
        title: Text(challenge['titulo']!),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              challenge['imagen']!,
              width: double.infinity,
              height: 250,
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 16),
            Text(
              'Duración: ${challenge['duracion']}',
              style: const TextStyle(color: Colors.white, fontSize: 18),
            ),
            const SizedBox(height: 10),
            Text(
              'Fecha de inicio: ${challenge['fecha']}',
              style: const TextStyle(color: Colors.white, fontSize: 18),
            ),
            const SizedBox(height: 20),
            const Text(
              'Detalles del reto:',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              'Este reto está diseñado para ayudarte a mejorar tu fuerza y resistencia.',
              style: const TextStyle(color: Colors.white70, fontSize: 16),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
              ),
              onPressed: () {
                // Acción al presionar "Empezar reto"
              },
              child: const Text(
                'Empezar reto',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
