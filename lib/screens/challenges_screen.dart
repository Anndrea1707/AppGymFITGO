import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gym_fitgo/widgets/custom_bottom_navbar.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  List<Map<String, dynamic>> challenges = [];
  String? _userEmail;

  Future<void> _fetchChallenges() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _userEmail = prefs.getString('user_email');

    FirebaseFirestore firestore = FirebaseFirestore.instance;
    QuerySnapshot querySnapshot = await firestore.collection('Retos').get();

    setState(() {
      challenges = querySnapshot.docs.map((doc) {
        return {
          'id': doc.id,
          'name': doc['name'],
          'description': doc['description'],
          'duration': doc['duration'],
          'fechaInicio': doc['fechaInicio'],
          'fechaFin': doc['fechaFin'],
          'image': doc['image'],
          'participants': doc['participants'] ?? 0,
        };
      }).toList();
    });
  }

  Future<void> _joinChallenge(String challengeId, int currentParticipants) async {
    if (currentParticipants <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No hay plazas disponibles para este reto.')),
      );
      return;
    }

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userEmail = prefs.getString('user_email');
    if (userEmail == null) return;

    try {
      QuerySnapshot userDoc = await FirebaseFirestore.instance
          .collection('usuarios')
          .where('email', isEqualTo: userEmail)
          .get();

      if (userDoc.docs.isNotEmpty) {
        var userData = userDoc.docs.first.data() as Map<String, dynamic>;
        List<dynamic>? participatingChallenges = userData['participatingChallenges'] as List<dynamic>?;

        // Verificar si el usuario ya participa en este reto
        bool alreadyParticipating = false;
        if (participatingChallenges != null) {
          for (var entry in participatingChallenges) {
            if (entry is Map && entry['challengeId'] == challengeId) {
              alreadyParticipating = true;
              break;
            }
          }
        }

        if (alreadyParticipating) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Ya estás participando en este reto.')),
          );
          return;
        }

        // Actualizar el número de participantes en el reto
        await FirebaseFirestore.instance.collection('Retos').doc(challengeId).update({
          'participants': currentParticipants - 1,
        });

        // Agregar el reto al perfil del usuario con la fecha de unión
        final joinDate = DateTime.now().toIso8601String();
        await FirebaseFirestore.instance.collection('usuarios').doc(userDoc.docs.first.id).update({
          'participatingChallenges': FieldValue.arrayUnion([
            {
              'challengeId': challengeId,
              'joinDate': joinDate,
            }
          ]),
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Te has unido al reto con éxito!')),
        );

        _fetchChallenges();
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al unirse al reto: $e')),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchChallenges();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2B192E),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF8E1FF),
        title: const Text(
          'Retos del Mes',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: challenges.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: challenges.length,
              itemBuilder: (context, index) {
                final challenge = challenges[index];
                final durationInDays = int.tryParse(challenge['duration'] ?? '0') ?? 0;
                final participants = challenge['participants'] ?? 0;

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
                          errorBuilder: (context, error, stackTrace) => Container(
                            color: Colors.grey,
                            child: const Center(child: Text('Imagen no disponible')),
                          ),
                        ),
                      ),
                      Positioned.fill(
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15.0),
                            gradient: LinearGradient(
                              colors: [Colors.black.withOpacity(0.7), Colors.transparent],
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
                              'Participantes: $participants',
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 14,
                              ),
                            ),
                            Text(
                              'Fecha fin: ${challenge['fechaFin']}',
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 10),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF7A0180),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                              ),
                              onPressed: () => _joinChallenge(challenge['id'], participants),
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
        onTap: (index) {},
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
      backgroundColor: const Color(0xFF2B192E),
      appBar: AppBar(
        title: Text(challenge['name']),
        backgroundColor: const Color(0xFFF8E1FF),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(challenge['image'], errorBuilder: (context, error, stackTrace) => Container(
              color: Colors.grey,
              child: const Center(child: Text('Imagen no disponible')),
            )),
            const SizedBox(height: 20),
            Text('Descripción: ${challenge['description']}', style: const TextStyle(color: Colors.white)),
            Text('Duración: ${challenge['duration']} días', style: const TextStyle(color: Colors.white)),
            Text('Fecha de inicio: ${challenge['fechaInicio']}', style: const TextStyle(color: Colors.white)),
            Text('Fecha de fin: ${challenge['fechaFin']}', style: const TextStyle(color: Colors.white)),
          ],
        ),
      ),
    );
  }
}