import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:gym_fitgo/widgets/custom_bottom_navbar_admin.dart';
import 'package:gym_fitgo/screens/admin_home_screen.dart';
import 'package:gym_fitgo/screens/admin_rutins_screen.dart';
import 'package:gym_fitgo/screens/statistics_screen.dart';

class ChallengesScreenAdmin extends StatefulWidget {
  @override
  _ChallengeScreenState createState() => _ChallengeScreenState();
}

class _ChallengeScreenState extends State<ChallengesScreenAdmin> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String _formatDate(dynamic fecha) {
    if (fecha is String) {
      try {
        final parsedDate = DateFormat('yyyy-MM-dd').parse(fecha);
        return DateFormat('dd/MM/yyyy').format(parsedDate);
      } catch (e) {
        return 'Fecha inválida';
      }
    }
    return 'Fecha no disponible';
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

  void _editChallenge(String challengeId, Map<String, dynamic> updatedChallenge) {
    _firestore.collection('Retos').doc(challengeId).update(updatedChallenge).then((_) {
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

  void _onTap(int index) {
    setState(() {
      _selectIndex = index;
    });
    switch (index) {
      case 0:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => AdminHomeScreen()),
        );
        break;
      case 1:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => AdminRutinsScreen()),
        );
        break;
      case 2:
        break;
      case 3:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => StatisticsScreen()),
        );
        break;
    }
  }

  Future<void> _confirmDelete(String challengeId) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar eliminación'),
        content: const Text('¿Estás seguro de eliminar este reto?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Sí'),
          ),
        ],
      ),
    );

    if (result == true) {
      _deleteChallenge(challengeId);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0a0322),
      appBar: AppBar(
        title: const Text('Retos administrador'),
        backgroundColor: const Color(0xFFF5EDE4),
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
              final challengeData = challenge.data() as Map<String, dynamic>;

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
                        challengeData['image'] ?? 'https://via.placeholder.com/200',
                        width: double.infinity,
                        height: 200,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Icon(Icons.error, size: 200, color: Colors.white);
                        },
                      ),
                    ),
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15.0),
                          gradient: LinearGradient(
                            colors: [
                              Colors.black.withOpacity(0.7),
                              Colors.transparent,
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
                            challengeData['name'] ?? 'Sin nombre',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Duración: ${challengeData['duration'] ?? 'No especificada'}',
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                            ),
                          ),
                          Text(
                            'Fecha de Inicio: ${_formatDate(challengeData['fechaInicio'])}',
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                            ),
                          ),
                          Text(
                            'Fecha de Fin: ${_formatDate(challengeData['fechaFin'])}',
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                            ),
                          ),
                          Text(
                            'Descripción: ${challengeData['description'] ?? 'No disponible'}',
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                            ),
                          ),
                          Text(
                            'Participantes: ${challengeData.containsKey('participants') ? challengeData['participants'] : '0'}',
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
                                  showModalBottomSheet(
                                    context: context,
                                    isScrollControlled: true,
                                    builder: (context) => AddChallengeScreen(
                                      challengeId: challengeId,
                                      challengeData: challengeData,
                                      onAddChallenge: (updatedChallengeData) {
                                        _editChallenge(challengeId, updatedChallengeData);
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
                                onPressed: () => _confirmDelete(challengeId),
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
      bottomNavigationBar: CustomBottomNavbarAdmin(
        currentIndex: _selectIndex,
        onTap: _onTap,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.purple,
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
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
  final _descriptionController = TextEditingController();
  final _participantsController = TextEditingController();
  DateTime? _fechaInicio;
  DateTime? _fechaFin;
  XFile? _selectedImage;
  String? _imageUrl;
  bool _isUploading = false;

  // Configuración de Cloudinary
  final CloudinaryPublic cloudinary = CloudinaryPublic('dycjb5ovf', 'FitgoApp', cache: false);

  @override
  void initState() {
    super.initState();
    if (widget.challengeData != null) {
      _nameController.text = widget.challengeData!['name'] ?? '';
      _durationController.text = widget.challengeData!['duration'] ?? '';
      _descriptionController.text = widget.challengeData!['description'] ?? '';
      _participantsController.text = widget.challengeData!['participants']?.toString() ?? '';
      _imageUrl = widget.challengeData!['image'];

      // Parsear las fechas si existen
      if (widget.challengeData!['fechaInicio'] != null) {
        try {
          _fechaInicio = DateFormat('yyyy-MM-dd').parse(widget.challengeData!['fechaInicio']);
        } catch (e) {
          _fechaInicio = null;
        }
      }
      if (widget.challengeData!['fechaFin'] != null) {
        try {
          _fechaFin = DateFormat('yyyy-MM-dd').parse(widget.challengeData!['fechaFin']);
        } catch (e) {
          _fechaFin = null;
        }
      }
    }
  }

  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        if (isStartDate) {
          _fechaInicio = picked;
        } else {
          _fechaFin = picked;
        }
      });
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _selectedImage = pickedFile;
        _isUploading = true;
      });
      await _uploadImageToCloudinary();
    }
  }

  Future<void> _uploadImageToCloudinary() async {
    if (_selectedImage == null) return;

    try {
      final response = await cloudinary.uploadFile(
        CloudinaryFile.fromFile(_selectedImage!.path, resourceType: CloudinaryResourceType.Image),
      );
      setState(() {
        _imageUrl = response.secureUrl;
        _isUploading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Imagen subida exitosamente')),
      );
    } catch (e) {
      setState(() {
        _isUploading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al subir la imagen: $e')),
      );
    }
  }

  void _saveChallenge() {
    if (_formKey.currentState!.validate() &&
        _fechaInicio != null &&
        _fechaFin != null &&
        _imageUrl != null) {
      if (_fechaFin!.isBefore(_fechaInicio!)) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('La fecha de fin debe ser posterior a la fecha de inicio')),
        );
        return;
      }

      final challengeData = {
        'name': _nameController.text,
        'duration': _durationController.text,
        'image': _imageUrl,
        'fechaInicio': DateFormat('yyyy-MM-dd').format(_fechaInicio!),
        'fechaFin': DateFormat('yyyy-MM-dd').format(_fechaFin!),
        'description': _descriptionController.text.isEmpty ? 'Sin descripción' : _descriptionController.text,
        'participants': int.tryParse(_participantsController.text) ?? 0,
      };

      widget.onAddChallenge(challengeData);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, complete todos los campos')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.challengeId == null ? 'Agregar Reto' : 'Editar Reto'),
        backgroundColor: const Color(0xFFF5EDE4),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
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
                const SizedBox(height: 16),
                TextFormField(
                  controller: _durationController,
                  decoration: const InputDecoration(labelText: 'Duración del reto (días)'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingresa la duración del reto';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _participantsController,
                  decoration: const InputDecoration(labelText: 'Cantidad de participantes'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingresa la cantidad de participantes';
                    }
                    if (int.tryParse(value) == null || int.parse(value) < 0) {
                      return 'Ingresa un número válido';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(labelText: 'Descripción del reto'),
                  maxLines: 4,
                ),
                const SizedBox(height: 16),
                ListTile(
                  title: Text(
                    _fechaInicio == null
                        ? 'Seleccione fecha de inicio'
                        : 'Inicio: ${DateFormat('dd/MM/yyyy').format(_fechaInicio!)}',
                  ),
                  trailing: const Icon(Icons.calendar_today),
                  onTap: () => _selectDate(context, true),
                ),
                const SizedBox(height: 16),
                ListTile(
                  title: Text(
                    _fechaFin == null
                        ? 'Seleccione fecha de fin'
                        : 'Fin: ${DateFormat('dd/MM/yyyy').format(_fechaFin!)}',
                  ),
                  trailing: const Icon(Icons.calendar_today),
                  onTap: () => _selectDate(context, false),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        _imageUrl == null ? 'No se ha seleccionado imagen' : 'Imagen seleccionada',
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    ElevatedButton(
                      onPressed: _isUploading ? null : _pickImage,
                      child: _isUploading
                          ? const CircularProgressIndicator()
                          : const Text('Seleccionar Imagen'),
                    ),
                  ],
                ),
                if (_imageUrl != null) ...[
                  const SizedBox(height: 16),
                  Image.network(
                    _imageUrl!,
                    height: 100,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(Icons.error, size: 100);
                    },
                  ),
                ],
                const SizedBox(height: 16),
                Center(
                  child: ElevatedButton(
                    onPressed: _saveChallenge,
                    child: Text(widget.challengeId == null ? 'Guardar Reto' : 'Actualizar Reto'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _durationController.dispose();
    _descriptionController.dispose();
    _participantsController.dispose();
    super.dispose();
  }
}