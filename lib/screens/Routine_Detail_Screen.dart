import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class RoutineDetailScreen extends StatelessWidget {
  final String routineId; // Solo necesitamos el ID de la rutina

  RoutineDetailScreen({
    required this.routineId,
  });

  String _formatTimer(int seconds) {
    final hours = seconds ~/ 3600;
    final minutes = (seconds ~/ 60) % 60;
    final remainingSeconds = seconds % 60;
    return '${hours}h ${minutes}m ${remainingSeconds}s';
  }

  String _formatDate(dynamic timestamp) {
    if (timestamp is Timestamp) {
      final date = timestamp.toDate();
      return DateFormat('dd/MM/yyyy').format(date);
    } else if (timestamp is DateTime) {
      return DateFormat('dd/MM/yyyy').format(timestamp);
    }
    return 'Fecha no disponible';
  }

  // Método para obtener los datos de los equipamientos desde Firestore
  Future<List<Map<String, dynamic>>> _fetchEquipmentData(List<String> equipmentIds) async {
    if (equipmentIds.isEmpty) {
      return [];
    }

    List<Map<String, dynamic>> equipmentData = [];
    for (String id in equipmentIds) {
      try {
        DocumentSnapshot doc = await FirebaseFirestore.instance
            .collection('Equipamiento')
            .doc(id)
            .get();
        if (doc.exists) {
          equipmentData.add({
            'nombre': doc['nombre']?.toString() ?? 'Sin nombre',
            'imagenUrl': doc['imagenUrl']?.toString() ?? 'https://via.placeholder.com/60',
            'peso': doc['peso']?.toDouble() ?? 0.0,
          });
        }
      } catch (e) {
        print('Error al cargar equipamiento $id: $e');
      }
    }
    return equipmentData;
  }

  // Método para obtener los datos de la rutina desde Firestore
  Future<Map<String, dynamic>> _fetchRoutineData() async {
    try {
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('Rutinas')
          .doc(routineId)
          .get();
      if (doc.exists) {
        return doc.data() as Map<String, dynamic>;
      } else {
        throw Exception('Rutina no encontrada');
      }
    } catch (e) {
      throw Exception('Error al cargar la rutina: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2B192E),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF8E1FF), // Color claro de referencia #f8e1ff
        title: const Text(
          'Detalles de la rutina',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        automaticallyImplyLeading: true,
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _fetchRoutineData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error: ${snapshot.error}',
                style: const TextStyle(color: Colors.white, fontSize: 16),
              ),
            );
          }
          if (!snapshot.hasData) {
            return const Center(
              child: Text(
                'Rutina no encontrada',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            );
          }

          final routineData = snapshot.data!;
          final String day = routineData['name']?.toString() ?? 'Sin día';
          final String description = routineData['description']?.toString() ?? 'Sin descripción';
          final List<Map<String, dynamic>> exercises = List<Map<String, dynamic>>.from(
            routineData['exercises'] ?? [],
          );
          final String userName = routineData['userName']?.toString() ?? 'Sin usuario';
          final dynamic createdAt = routineData['createdAt'];
          final dynamic expirationDate = routineData['expirationDate'];
          final List<String> equipmentIds = List<String>.from(routineData['equipmentIds'] ?? []);

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    day,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Usuario: $userName',
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Descripción:',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Creado: ${_formatDate(createdAt)}',
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        'Vence: ${_formatDate(expirationDate)}',
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Equipamiento:',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  FutureBuilder<List<Map<String, dynamic>>>(
                    future: _fetchEquipmentData(equipmentIds),
                    builder: (context, equipmentSnapshot) {
                      if (equipmentSnapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (equipmentSnapshot.hasError) {
                        return const Text(
                          'Error al cargar equipamiento',
                          style: TextStyle(color: Colors.white70, fontSize: 16),
                        );
                      }
                      final equipmentData = equipmentSnapshot.data ?? [];
                      if (equipmentData.isEmpty) {
                        return const Text(
                          'No requiere equipamiento',
                          style: TextStyle(color: Colors.white70, fontSize: 16),
                        );
                      }
                      return ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: equipmentData.length,
                        itemBuilder: (context, index) {
                          final equipment = equipmentData[index];
                          return Card(
                            margin: const EdgeInsets.symmetric(vertical: 8.0),
                            color: Color(0xFF2B192E),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(10.0),
                                    child: Image.network(
                                      equipment['imagenUrl'],
                                      width: 60,
                                      height: 60,
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error, stackTrace) {
                                        return Icon(Icons.error, size: 60, color: Colors.white);
                                      },
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          equipment['nombre'],
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          'Peso: ${equipment['peso']} kg',
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
                        },
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Ejercicios:',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: exercises.length,
                    itemBuilder: (context, index) {
                      final exercise = exercises[index];
                      final String exerciseImage = exercise['image'] ?? 'https://via.placeholder.com/80';
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 8.0),
                        color: Color(0xFF2B192E),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10.0),
                                child: Image.network(
                                  exerciseImage,
                                  width: 80,
                                  height: 80,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Icon(Icons.error, size: 80, color: Colors.white);
                                  },
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      exercise['name'] ?? 'Sin nombre',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Series: ${exercise['series'] ?? 0}',
                                      style: const TextStyle(
                                        color: Colors.white70,
                                        fontSize: 14,
                                      ),
                                    ),
                                    Text(
                                      'Repeticiones: ${exercise['repetitions'] ?? 0}',
                                      style: const TextStyle(
                                        color: Colors.white70,
                                        fontSize: 14,
                                      ),
                                    ),
                                    Text(
                                      'Tiempo: ${_formatTimer(exercise['timer'] ?? 0)}',
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
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}