import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gym_fitgo/screens/home_screen.dart';
import 'package:gym_fitgo/screens/challenges_screen.dart';
import 'package:gym_fitgo/screens/rutinas_screen.dart';
import 'package:gym_fitgo/screens/gym_suvery_screen.dart';
import 'package:gym_fitgo/widgets/custom_bottom_navbar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  int _currentIndex = 3;
  String name = 'Cargando...';
  int age = 0;
  double weight = 0.0;
  double height = 0.0;
  String email = '';
  String? gender;
  String? limitation;
  String? goal;

  @override
  void initState() {
    super.initState();
    _loadUserEmail();
  }

  Future<void> _loadUserEmail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? storedEmail = prefs.getString('user_email');
    if (storedEmail != null && storedEmail.isNotEmpty) {
      setState(() {
        email = storedEmail;
      });
      _loadUserData();
    }
  }

  Future<void> _loadUserData() async {
    try {
      QuerySnapshot userDoc = await FirebaseFirestore.instance
          .collection('usuarios')
          .where('email', isEqualTo: email)
          .get();

      if (userDoc.docs.isNotEmpty) {
        var data = userDoc.docs.first.data() as Map<String, dynamic>;
        setState(() {
          name = data['name'] ?? 'Sin nombre';
          age = data['age'] != null ? int.tryParse(data['age'].toString()) ?? 0 : 0;
          weight = data['weight'] != null ? double.tryParse(data['weight'].toString()) ?? 0.0 : 0.0;
          height = data['height'] != null ? (double.tryParse(data['height'].toString()) ?? 0.0) / 100 : 0.0;
          gender = data['gender'];
          limitation = data['limitation'];
          goal = data['goal'];
        });
      } else {
        setState(() {
          name = 'No se encontraron datos';
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('No se encontraron datos para este email ($email) en Firestore.')),
        );
      }
    } catch (e) {
      setState(() {
        name = 'Error al cargar';
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al cargar datos: $e')),
      );
    }
  }

  void _onTap(int index) {
    setState(() {
      _currentIndex = index;
    });

    switch (index) {
      case 0:
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => HomeScreen()));
        break;
      case 1:
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => RutinasScreen()));
        break;
      case 2:
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => ChallengesScreen()));
        break;
      case 3:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E1039),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 40.0, bottom: 16.0),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundImage: const AssetImage('assets/avatar_placeholder.png'),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      name,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold),
                    ),
                    const Text(
                      "Nivel: principiante",
                      style: TextStyle(color: Colors.white70, fontSize: 16),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildUserDetail("Edad", age > 0 ? "$age años" : "Cargando..."),
                  _buildUserDetail("Peso", weight > 0 ? "$weight kg" : "Cargando..."),
                  _buildUserDetail("Altura", height > 0 ? "${height.toStringAsFixed(2)} m" : "Cargando..."),
                  _buildUserDetail("Fecha inicio", "03/03/2024"),
                ],
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => GymSurveyScreen(userEmail: email),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF7E57C2),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text("Actualizar", style: TextStyle(color: Colors.white)),
              ),
              const SizedBox(height: 24),
              _buildSection("Retos participación"),
              const SizedBox(height: 16),
              _buildSection("Trofeos"),
            ],
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _currentIndex,
        onTap: _onTap,
      ),
    );
  }

  Widget _buildUserDetail(String title, String value) {
    return Column(
      children: [
        Text(title, style: const TextStyle(color: Colors.white70, fontSize: 14)),
        Text(value,
            style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildSection(String title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildCard("Reto de resistencia", "30 min - 1 hora"),
            _buildCard("Reto mensual", "25 días"),
          ],
        ),
      ],
    );
  }

  Widget _buildCard(String title, String subtitle) {
    return Container(
      width: 150,
      decoration: BoxDecoration(
          color: Colors.white10, borderRadius: BorderRadius.circular(12)),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(subtitle, style: const TextStyle(color: Colors.white70, fontSize: 12)),
        ],
      ),
    );
  }
}