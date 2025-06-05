import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gym_fitgo/widgets/custom_bottom_navbar_admin.dart';
import 'package:gym_fitgo/screens/admin_home_screen.dart';
import 'package:gym_fitgo/screens/challenges_screen_admin.dart';
import 'package:gym_fitgo/screens/profile_admin.dart';
import 'package:gym_fitgo/screens/add_routine_screen.dart';
import 'package:gym_fitgo/screens/routine_detail_screen.dart';
import 'package:intl/intl.dart';

class AdminRutinsScreen extends StatefulWidget {
  @override
  RutinasScreenAdminState createState() => RutinasScreenAdminState();
}

class RutinasScreenAdminState extends State<AdminRutinsScreen> {
  int _currentIndex = 1; // Índice 1 corresponde a esta pantalla (Rutinas)

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
        // No hacer nada, ya estamos en AdminRutinsScreen
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
          MaterialPageRoute(builder: (context) => ProfileAdmin()),
        );
        break;
    }
  }

  void _deleteRoutine(String routineId) async {
    bool? confirmDelete = await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Confirmar eliminación', style: TextStyle(color: Colors.black)),
          content: Text('¿Estás seguro de que quieres eliminar esta rutina?', style: TextStyle(color: Colors.black)),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text('Cancelar', style: TextStyle(color: Colors.black)),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text('Eliminar', style: TextStyle(color: Colors.red)),
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
          SnackBar(content: Text('Rutina eliminada con éxito', style: TextStyle(color: Colors.white))),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al eliminar rutina: $e', style: TextStyle(color: Colors.white))),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2B192E),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF8E1FF), // Color claro de referencia #f8e1ff
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
                return Center(child: Text('Error: ${snapshot.error}', style: TextStyle(color: Colors.white)));
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
              backgroundColor: const Color.fromARGB(255, 87, 37, 116), // Color medio #572574
              child: Icon(Icons.add, color: Colors.white), // Ícono blanco para contraste
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
      color: const Color(0xFFF8E1FF), // Color claro de referencia #f8e1ff
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
                    color: Color(0xFF2B192E), // Texto oscuro para fondo claro
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  description,
                  style: const TextStyle(
                    color: Color.fromARGB(255, 43, 25, 46), // Tono más claro para texto secundario
                    fontSize: 14,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(Icons.calendar_today, color: Color.fromARGB(255, 43, 25, 46), size: 16),
                const SizedBox(width: 6),
                Text(
                  'Vence: ${expirationDateValue is Timestamp ? DateFormat('dd/MM/yyyy').format(expirationDateValue.toDate()) : 'Sin fecha'}',
                  style: const TextStyle(
                    color: Color.fromARGB(255, 43, 25, 46),
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
                              routineId: routineId,
                            ),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 87, 37, 116), // Color medio #572574
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                      ),
                      child: const Text(
                        'Ver rutina',
                        style: TextStyle(color: Colors.white), // Texto blanco para contraste
                      ),
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
                        backgroundColor: const Color.fromARGB(255, 87, 37, 116), // Color medio #572574
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                      ),
                      child: const Text(
                        'Editar rutina',
                        style: TextStyle(color: Colors.white), // Texto blanco para contraste
                      ),
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