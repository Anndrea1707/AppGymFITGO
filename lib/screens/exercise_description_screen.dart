import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gym_fitgo/screens/exercise_timer_screen.dart';

class ExerciseDescriptionScreen extends StatefulWidget {
  final String day;
  final String description;
  final List<Map<String, dynamic>> exercises;
  final List<String> equipmentIds;
  final String? image;
  final String routineId;
  final String? userId;

  const ExerciseDescriptionScreen({
    required this.day,
    required this.description,
    required this.exercises,
    required this.equipmentIds,
    this.image,
    required this.routineId,
    this.userId,
  });

  @override
  _ExerciseDescriptionScreenState createState() => _ExerciseDescriptionScreenState();
}

class _ExerciseDescriptionScreenState extends State<ExerciseDescriptionScreen> {
  List<Map<String, dynamic>> equipments = [];

  @override
  void initState() {
    super.initState();
    _fetchEquipments();
  }

  Future<void> _fetchEquipments() async {
    if (widget.equipmentIds.isEmpty) return;

    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('Equipamiento')
          .where(FieldPath.documentId, whereIn: widget.equipmentIds)
          .get();

      setState(() {
        equipments = snapshot.docs.map((doc) {
          final data = doc.data();
          return {
            'id': doc.id,
            'nombre': data['nombre']?.toString() ?? 'Sin nombre',
            'imagenUrl': data['imagenUrl']?.toString() ?? 'https://via.placeholder.com/100',
            'peso': data['peso']?.toDouble() ?? 0.0,
          };
        }).toList();
      });
    } catch (e) {
      print('Error al cargar equipamientos: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al cargar equipamientos: $e')),
      );
    }
  }

  String formatExerciseTime(int totalSeconds) {
    final hours = totalSeconds ~/ 3600;
    final minutes = (totalSeconds ~/ 60) % 60;
    final seconds = totalSeconds % 60;
    if (hours > 0) {
      return '$hours h $minutes m $seconds s';
    } else if (minutes > 0) {
      return '$minutes m $seconds s';
    } else {
      return '$seconds s';
    }
  }

  Future<void> _startRoutine() async {
    if (widget.userId == null) return;

    final userDoc = await FirebaseFirestore.instance
        .collection('usuarios')
        .doc(widget.userId)
        .get();

    if (userDoc.exists) {
      final completedRoutines = userDoc.data()?['completedRoutines'] ?? {};
      final completionDateRaw = completedRoutines[widget.routineId];
      String? completionDate;

      if (completionDateRaw != null) {
        try {
          DateTime parsedDate = DateTime.parse(completionDateRaw);
          completionDate = "${parsedDate.day}/${parsedDate.month}/${parsedDate.year}";
        } catch (e) {
          completionDate = 'Fecha inválida';
        }
      }

      if (completionDate != null) {
        bool? confirm = await showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Rutina ya completada'),
              content: Text('Ya realizaste esta rutina el $completionDate. ¿Deseas repetirla?'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: const Text('Cancelar'),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context, true),
                  child: const Text('Repetir'),
                ),
              ],
            );
          },
        );

        if (confirm == true) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ExerciseTimerScreen(
                exercises: widget.exercises,
                routineId: widget.routineId,
                userId: widget.userId,
              ),
            ),
          );
        }
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ExerciseTimerScreen(
              exercises: widget.exercises,
              routineId: widget.routineId,
              userId: widget.userId,
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2B192E),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF8E1FF),
        title: Text(
          widget.day,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              color: const Color(0xFFF8E1FF),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.description,
                      style: const TextStyle(
                          fontSize: 18,
                          color: Color(0xFF2B192E),
                          fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Card(
              color: const Color(0xFFF8E1FF),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Ejercicios',
                      style: TextStyle(
                          fontSize: 20,
                          color: Color(0xFF2B192E),
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: widget.exercises.length,
                      itemBuilder: (context, index) {
                        final exercise = widget.exercises[index];
                        final name = exercise['name']?.toString() ?? 'Sin nombre';
                        final image = exercise['image']?.toString() ?? 'https://via.placeholder.com/100';
                        final timer = exercise['timer'] as int? ?? 0;
                        final repetitions = exercise['repetitions']?.toString() ?? '0';
                        final series = exercise['series']?.toString() ?? '0';

                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Card(
                            color: const Color(0xFFF8E1FF),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Image.network(
                                      image,
                                      width: 60,
                                      height: 60,
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error, stackTrace) =>
                                          const Icon(Icons.error, size: 60, color: Color(0xFF2B192E)),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          name,
                                          style: const TextStyle(
                                              color: Color(0xFF2B192E),
                                              fontWeight: FontWeight.w500,
                                              fontSize: 16),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          'Tiempo: ${formatExerciseTime(timer)}',
                                          style: const TextStyle(
                                              color: Color.fromARGB(255, 43, 25, 46), fontSize: 14),
                                        ),
                                        Text(
                                          'Repeticiones: $repetitions',
                                          style: const TextStyle(
                                              color: Color.fromARGB(255, 43, 25, 46), fontSize: 14),
                                        ),
                                        Text(
                                          'Series: $series',
                                          style: const TextStyle(
                                              color: Color.fromARGB(255, 43, 25, 46), fontSize: 14),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Card(
              color: const Color(0xFFF8E1FF),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Equipo Sugerido',
                      style: TextStyle(
                          fontSize: 20,
                          color: Color(0xFF2B192E),
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    if (equipments.isEmpty)
                      const Text(
                        'No hay equipamiento asignado.',
                        style: TextStyle(color: Color.fromARGB(255, 43, 25, 46), fontSize: 16),
                      )
                    else
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                          childAspectRatio: 1.0,
                        ),
                        itemCount: equipments.length,
                        itemBuilder: (context, index) {
                          final equipment = equipments[index];
                          return Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: const Color(0xFF7A0180).withOpacity(0.2),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.network(
                                    equipment['imagenUrl'],
                                    width: 80,
                                    height: 80,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) =>
                                        const Icon(Icons.error, color: Color(0xFF2B192E)),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  equipment['nombre'],
                                  style: const TextStyle(color: Color(0xFF2B192E), fontSize: 14),
                                  textAlign: TextAlign.center,
                                ),
                                Text(
                                  'Peso: ${equipment['peso']} kg',
                                  style: const TextStyle(color: Color.fromARGB(255, 43, 25, 46), fontSize: 12),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Si inicia la rutina y la detiene, deberá iniciar de nuevo.',
              style: TextStyle(color: Colors.white70, fontSize: 14),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Center(
              child: ElevatedButton(
                onPressed: _startRoutine,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF7A0180),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                ),
                child: const Text(
                  'Iniciar',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}