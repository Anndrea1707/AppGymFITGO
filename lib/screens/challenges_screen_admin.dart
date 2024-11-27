import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:gym_fitgo/widgets/custom_bottom_navbar_admin.dart';

class ChallengesScreenAdmin extends StatefulWidget {
  @override
  _ChallengeScreenState createState() => _ChallengeScreenState();
}

class _ChallengeScreenState extends State<ChallengesScreenAdmin> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String _formatDate(dynamic fecha) {
    if (fecha is String) {
      try {
        // Intenta parsear la fecha como formato 'yyyy-MM-dd'
        final parsedDate = DateFormat('yyyy-MM-dd').parse(fecha);
        return DateFormat('yyyy-MM-dd').format(parsedDate);
      } catch (e) {
        // Si el formato es inválido o no puede ser parseado
        return 'Fecha inválida';
      }
    }
    return ''; // Retorna vacío si no es un String
  }

  void _deleteChallenge(String challengeId) {
    _firestore.collection('Retos').doc(challengeId).delete().then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Reto eliminado exitosamente')),
      );
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al eliminar el reto: $error')),
      );
    });
  }

  void _addNewChallenge(Map<String, dynamic> newChallenge) {
    _firestore.collection('Retos').add(newChallenge).then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Reto agregado exitosamente')),
      );
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al agregar el reto: $error')),
      );
    });
  }

  void _editChallenge(
      String challengeId, Map<String, dynamic> updatedChallenge) {
    _firestore
        .collection('Retos')
        .doc(challengeId)
        .update(updatedChallenge)
        .then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Reto actualizado exitosamente')),
      );
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al actualizar el reto: $error')),
      );
    });
  }

  int _selectIndex = 2;

  // Puedes agregar el método para actualizar el índice si es necesario
  void _onTap(int index) {
    setState(() {
      _selectIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0a0322),
      appBar: AppBar(
        title: const Text('Retos administrador'),
        backgroundColor: Color(0xFFF5EDE4),
        automaticallyImplyLeading: false,
      ),
      body: StreamBuilder(
        stream: _firestore.collection('Retos').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(child: Text('Error al cargar los retos'));
          }

          final challenges = snapshot.data!.docs;

          return ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: challenges.length,
            itemBuilder: (context, index) {
              final challenge = challenges[index];
              final challengeId = challenge.id;

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
                            'Duración: ${challenge['duration']}',
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                            ),
                          ),
                          Text(
                            'Fecha de Inicio: ${_formatDate(challenge['fechaInicio'])}',
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                            ),
                          ),
                          Text(
                            'Fecha de Fin: ${_formatDate(challenge['fechaFin'])}',
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                            ),
                          ),
                          Text(
                            'Descripción: ${challenge['description'] ?? 'No disponible'}', // Muestra la descripción
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.purple,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20.0),
                                  ),
                                ),
                                onPressed: () {
                                  // Extraemos los datos del reto
                                  Map<String, dynamic> challengeData =
                                      challenge.data() as Map<String, dynamic>;

                                  // Llamar al modal de edición
                                  showModalBottomSheet(
                                    context: context,
                                    builder: (context) => AddChallengeScreen(
                                      challengeId: challengeId,
                                      challengeData: challengeData,
                                      onAddChallenge: (updatedChallengeData) {
                                        _editChallenge(
                                            challengeId, updatedChallengeData);
                                        Navigator.pop(context);
                                      },
                                    ),
                                  );
                                },
                                child: const Text(
                                  'Editar Reto',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                              const SizedBox(width: 10),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20.0),
                                  ),
                                ),
                                onPressed: () => _deleteChallenge(challengeId),
                                child: const Text(
                                  'Eliminar Reto',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
      // Aquí se agrega el CustomBottomNavbarAdmin
      bottomNavigationBar: CustomBottomNavbarAdmin(
        currentIndex: _selectIndex,
        onTap: _onTap,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.purple,
        onPressed: () {
          showModalBottomSheet(
            context: context,
            builder: (context) => AddChallengeScreen(
              onAddChallenge: (newChallengeData) {
                _addNewChallenge(newChallengeData);
                Navigator.pop(context);
              },
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class AddChallengeScreen extends StatefulWidget {
  final String? challengeId;
  final Map<String, dynamic>? challengeData;
  final Function(Map<String, dynamic>) onAddChallenge;

  AddChallengeScreen({
    this.challengeId,
    this.challengeData,
    required this.onAddChallenge,
  });

  @override
  _AddChallengeScreenState createState() => _AddChallengeScreenState();
}

class _AddChallengeScreenState extends State<AddChallengeScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _durationController = TextEditingController();
  final _fechaInicioController = TextEditingController();
  final _fechaFinController = TextEditingController();
  final _imageController = TextEditingController();
  final _descriptionController = TextEditingController(); // Nuevo controlador

  @override
  void initState() {
    super.initState();
    if (widget.challengeData != null) {
      _nameController.text = widget.challengeData!['name'] ?? '';
      _durationController.text = widget.challengeData!['duration'] ?? '';
      _imageController.text = widget.challengeData!['image'] ?? ''; // <- Aquí
      _fechaInicioController.text = widget.challengeData!['fechaInicio'] ?? '';
      _fechaFinController.text = widget.challengeData!['fechaFin'] ?? '';
      _descriptionController.text = widget.challengeData!['description'] ??
          ''; // Cargar descripción si existe
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: ListView(
          children: [
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Nombre del reto'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor ingresa un nombre para el reto';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _durationController,
              decoration: const InputDecoration(labelText: 'Duración del reto'),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor ingresa la duración del reto';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _imageController,
              decoration:
                  const InputDecoration(labelText: 'URL de la imagen del reto'),
              keyboardType: TextInputType.url,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor ingresa la URL de la imagen del reto';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _fechaInicioController,
              decoration: const InputDecoration(
                  labelText: 'Fecha de inicio (yyyy-MM-dd)'),
              keyboardType: TextInputType.datetime,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor ingresa la fecha de inicio';
                }
                final isValidDate =
                    RegExp(r'^\d{4}-\d{2}-\d{2}$').hasMatch(value);
                if (!isValidDate) {
                  return 'El formato de la fecha debe ser yyyy-MM-dd';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _fechaFinController, // Se usa el controlador correcto
              decoration:
                  const InputDecoration(labelText: 'Fecha de fin (yyyy-MM-dd)'),
              keyboardType: TextInputType.datetime,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor ingresa la fecha de fin';
                }
                final isValidDate =
                    RegExp(r'^\d{4}-\d{2}-\d{2}$').hasMatch(value);
                if (!isValidDate) {
                  return 'El formato de la fecha debe ser yyyy-MM-dd';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _descriptionController, // Nuevo campo de descripción
              decoration:
                  const InputDecoration(labelText: 'Descripción del reto'),
              maxLines: 4, // Permitir varias líneas
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor ingresa una descripción para el reto';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  final challengeData = {
                    'name': _nameController.text,
                    'duration': _durationController.text,
                    'image': _imageController.text,
                    'fechaInicio': _fechaInicioController.text,
                    'fechaFin': _fechaFinController.text,
                    'description':
                        _descriptionController.text, // Añadir descripción
                  };

                  widget.onAddChallenge(challengeData);
                }
              },
              child: Text(widget.challengeId == null
                  ? 'Agregar Reto'
                  : 'Actualizar Reto'),
            ),
          ],
        ),
      ),
    );
  }
}
