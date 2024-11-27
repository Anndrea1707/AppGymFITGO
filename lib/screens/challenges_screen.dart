import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';  // Para Firestore
import 'package:gym_fitgo/widgets/custom_bottom_navbar.dart'; // Importa la barra de navegación

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

class ChallengesScreen extends StatefulWidget {
  @override
  _ChallengesScreenState createState() => _ChallengesScreenState();
}

class _ChallengesScreenState extends State<ChallengesScreen> {
  // Lista para almacenar los retos recuperados de Firestore
  List<Map<String, dynamic>> challenges = [];

  // Cargar los datos desde Firestore
  Future<void> _fetchChallenges() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    // Obtén la colección "Retos" de Firestore
    QuerySnapshot querySnapshot = await firestore.collection('Retos').get();

    setState(() {
      challenges = querySnapshot.docs.map((doc) {
        return {
          'name': doc['name'],
          'description': doc['description'],
          'duration': doc['duration'],
          'fechaInicio': doc['fechaInicio'],
          'fechaFin': doc['fechaFin'],
          'image': doc['image'],
        };
      }).toList();
    });
  }

  @override
  void initState() {
    super.initState();
    _fetchChallenges(); // Cargar los datos cuando se inicie la pantalla
  }

  @override
  Widget build(BuildContext context) {
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
      body: challenges.isEmpty
          ? const Center(child: CircularProgressIndicator()) // Muestra un indicador de carga
          : ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: challenges.length,
              itemBuilder: (context, index) {
                final challenge = challenges[index];
                final durationInDays = int.tryParse(challenge['duration'] ?? '0') ?? 0;
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
                          challenge['image'],
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
                              challenge['name'],
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Duración: $durationInDays días',
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 14,
                              ),
                            ),
                            Text(
                              'Fecha: ${challenge['fechaFin']}',
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
        currentIndex: 2,
        onTap: (index) {
          // Aquí no necesitas lógica extra, ya está en `CustomBottomNavBar`
        },
      ),
    );
  }
}

class ChallengeDetailScreen extends StatelessWidget {
  final Map<String, dynamic> challenge;

  const ChallengeDetailScreen({Key? key, required this.challenge}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0a0322),
      appBar: AppBar(
        title: Text(challenge['name']),
        backgroundColor: Color(0xFFF5EDE4),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(challenge['image']),
            const SizedBox(height: 20),
            Text('Descripción: ${challenge['description']}', style: TextStyle(color: Colors.white),),
            Text('Duración: ${challenge['duration']} días', style: TextStyle(color: Colors.white),),
            Text('Fecha de inicio: ${challenge['fechaInicio']}', style: TextStyle(color: Colors.white),),
            Text('Fecha de fin: ${challenge['fechaFin']}',
            style: TextStyle(color: Colors.white),
            )
          ],
        ),
      ),
    );
  }
}
