import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gym_fitgo/widgets/custom_bottom_navbar_admin.dart';
import 'package:gym_fitgo/screens/admin_home_screen.dart';
import 'package:gym_fitgo/screens/challenges_screen_admin.dart';
import 'package:gym_fitgo/screens/statistics_screen.dart';
import 'package:gym_fitgo/screens/add_routine_screen.dart';
import 'package:gym_fitgo/screens/routine_detail_screen.dart';
import 'package:intl/intl.dart';

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
        await FirebaseFirestore.instance
            .collection('Rutinas')
            .doc(routineId)
            .delete();
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
      body: Stack(
        children: [
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection('Rutinas').snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }

              var routines = snapshot.data!.docs;

              // Agrupar rutinas por userName
              Map<String, List<Map<String, dynamic>>> groupedRoutines = {};
              for (var doc in routines) {
                var routine = doc.data() as Map<String, dynamic>;
                var userName = routine['userName']?.toString() ?? 'Sin usuario';
                if (!groupedRoutines.containsKey(userName)) {
                  groupedRoutines[userName] = [];
                }
                groupedRoutines[userName]!.add({
                  'routine': routine,
                  'id': doc.id,
                });
              }

              return ListView(
                padding: const EdgeInsets.fromLTRB(16.0, 30.0, 16.0, 16.0),
                children: groupedRoutines.entries.map((entry) {
                  String userName = entry.key;
                  List<Map<String, dynamic>> userRoutines = entry.value;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        userName,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      ...userRoutines.map((routineData) {
                        var routine = routineData['routine'] as Map<String, dynamic>;
                        var routineId = routineData['id'] as String;
                        return _buildRoutineCard(routine, routineId, userName);
                      }).toList(),
                      const SizedBox(height: 20),
                    ],
                  );
                }).toList(),
              );
            },
          ),
          Positioned(
            top: 60.0,
            right: 16.0,
            child: FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddRoutineScreen(),
                  ),
                );
              },
              backgroundColor: Colors.purple[300],
              child: Icon(Icons.add),
              elevation: 6.0,
            ),
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomNavbarAdmin(
        currentIndex: _currentIndex,
        onTap: _onTap,
      ),
    );
  }

  Widget _buildRoutineCard(Map<String, dynamic> routine, String routineId, String userName) {
    // Definir todas las variables de manera explícita
    final String name = routine['name']?.toString() ?? 'Sin día';
    final String description = routine['description']?.toString() ?? 'Sin descripción';
    final List<Map<String, dynamic>> exercisesList = (routine['exercises'] as List<dynamic>?)?.map((e) {
      return e as Map<String, dynamic>;
    }).toList() ?? [];
    final dynamic createdAtValue = routine['createdAt'] ?? Timestamp.now();
    final dynamic expirationDateValue = routine['expirationDate'] ?? Timestamp.now();

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      color: const Color.fromARGB(255, 87, 37, 116),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  description,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(Icons.calendar_today, color: Colors.white70, size: 16),
                const SizedBox(width: 6),
                Text(
                  'Vence: ${expirationDateValue is Timestamp ? DateFormat('dd/MM/yyyy').format(expirationDateValue.toDate()) : 'Sin fecha'}',
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => RoutineDetailScreen(
                              day: name,
                              description: description,
                              exercises: exercisesList,
                              image: '',
                              userName: userName,
                              createdAt: createdAtValue,
                              expirationDate: expirationDateValue,
                            ),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.purple[200],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                      ),
                      child: const Text('Ver rutina'),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AddRoutineScreen(
                              routineId: routineId,
                              routineData: routine,
                            ),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.purple[200],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                      ),
                      child: const Text('Editar rutina'),
                    ),
                  ],
                ),
                IconButton(
                  onPressed: () => _deleteRoutine(routineId),
                  icon: const Icon(Icons.delete, color: Colors.red),
                  tooltip: 'Eliminar rutina',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}