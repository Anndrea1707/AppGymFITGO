import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class AddRoutineScreen extends StatefulWidget {
  final String? routineId;
  final Map<String, dynamic>? routineData;

  AddRoutineScreen({
    this.routineId,
    this.routineData,
  });

  @override
  _AddRoutineScreenState createState() => _AddRoutineScreenState();
}

class _AddRoutineScreenState extends State<AddRoutineScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _selectedDay;
  DateTime? _selectedExpirationDate;
  String? _selectedUserId;
  final TextEditingController _descriptionController = TextEditingController();
  List<Map<String, dynamic>> _exercises = [];
  final CloudinaryPublic cloudinary = CloudinaryPublic('dycjb5ovf', 'FitgoApp', cache: false);

  // Lista de días de la semana
  final List<String> _days = [
    'Lunes', 'Martes', 'Miércoles', 'Jueves', 'Viernes', 'Sábado', 'Domingo'
  ];

  // Obtener usuarios con role: cliente
  List<Map<String, dynamic>> _users = [];

  @override
  void initState() {
    super.initState();
    _fetchUsers();
    if (widget.routineData != null) {
      // Precargar datos si estamos editando
      _selectedDay = widget.routineData!['name']?.toString();
      _descriptionController.text = widget.routineData!['description']?.toString() ?? '';
      _selectedUserId = widget.routineData!['userId']?.toString();
      _exercises = List<Map<String, dynamic>>.from(
        (widget.routineData!['exercises'] as List<dynamic>?)?.map((e) => e as Map<String, dynamic>) ?? [],
      );
      if (widget.routineData!['expirationDate'] != null) {
        _selectedExpirationDate = (widget.routineData!['expirationDate'] as Timestamp).toDate();
      }
    }
  }

  void _fetchUsers() async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('usuarios')
          .where('role', isEqualTo: 'cliente')
          .get();
      setState(() {
        _users = snapshot.docs.map((doc) => {
              'id': doc.id,
              'name': doc['name']?.toString() ?? 'Sin nombre',
            }).toList();
      });
      if (_users.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('No se encontraron usuarios con role: cliente')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al cargar usuarios: $e')),
      );
    }
  }

  Future<String?> _uploadImage(XFile image) async {
    try {
      final response = await cloudinary.uploadFile(
        CloudinaryFile.fromFile(image.path, resourceType: CloudinaryResourceType.Image),
      );
      return response.secureUrl;
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al subir imagen: $e')),
      );
      return null;
    }
  }

  void _addExercise({Map<String, dynamic>? existingExercise, int? editIndex}) {
    final TextEditingController _exerciseNameController = TextEditingController();
    final TextEditingController _seriesController = TextEditingController();
    final TextEditingController _repetitionsController = TextEditingController();
    int _selectedHours = 0;
    int _selectedMinutes = 0;
    int _selectedSeconds = 0;
    XFile? _selectedImage;
    String? _existingImageUrl;

    if (existingExercise != null) {
      _exerciseNameController.text = existingExercise['name'] ?? '';
      _seriesController.text = existingExercise['series']?.toString() ?? '';
      _repetitionsController.text = existingExercise['repetitions']?.toString() ?? '';
      _existingImageUrl = existingExercise['image'];
      final timer = existingExercise['timer'] ?? 0;
      _selectedHours = timer ~/ 3600;
      _selectedMinutes = (timer ~/ 60) % 60;
      _selectedSeconds = timer % 60;
    }

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: Text(existingExercise == null ? 'Agregar Ejercicio' : 'Editar Ejercicio'),
              backgroundColor: Theme.of(context).dialogBackgroundColor,
              content: SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxHeight: 450),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextFormField(
                        controller: _exerciseNameController,
                        decoration: InputDecoration(labelText: 'Nombre del ejercicio'),
                        validator: (value) => value?.isEmpty ?? true ? 'Requerido' : null,
                      ),
                      TextFormField(
                        controller: _seriesController,
                        decoration: InputDecoration(labelText: 'Series'),
                        keyboardType: TextInputType.number,
                        validator: (value) => value?.isEmpty ?? true ? 'Requerido' : null,
                      ),
                      TextFormField(
                        controller: _repetitionsController,
                        decoration: InputDecoration(labelText: 'Repeticiones'),
                        keyboardType: TextInputType.number,
                        validator: (value) => value?.isEmpty ?? true ? 'Requerido' : null,
                      ),
                      SizedBox(height: 15),
                      Text(
                        'Tiempo del ejercicio',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 5),
                      SizedBox(
                        height: 100,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              child: CupertinoPicker(
                                itemExtent: 32,
                                onSelectedItemChanged: (index) {
                                  setDialogState(() {
                                    _selectedHours = index;
                                  });
                                },
                                children: List.generate(24, (index) {
                                  return Center(
                                    child: Text(
                                      index.toString().padLeft(2, '0'),
                                      style: TextStyle(fontSize: 20, color: Colors.black),
                                    ),
                                  );
                                }),
                                backgroundColor: Theme.of(context).dialogBackgroundColor,
                                diameterRatio: 1.0,
                                scrollController: FixedExtentScrollController(initialItem: _selectedHours),
                              ),
                            ),
                            SizedBox(width: 8),
                            Expanded(
                              child: CupertinoPicker(
                                itemExtent: 32,
                                onSelectedItemChanged: (index) {
                                  setDialogState(() {
                                    _selectedMinutes = index;
                                  });
                                },
                                children: List.generate(60, (index) {
                                  return Center(
                                    child: Text(
                                      index.toString().padLeft(2, '0'),
                                      style: TextStyle(fontSize: 20, color: Colors.black),
                                    ),
                                  );
                                }),
                                backgroundColor: Theme.of(context).dialogBackgroundColor,
                                diameterRatio: 1.0,
                                scrollController: FixedExtentScrollController(initialItem: _selectedMinutes),
                              ),
                            ),
                            SizedBox(width: 8),
                            Expanded(
                              child: CupertinoPicker(
                                itemExtent: 32,
                                onSelectedItemChanged: (index) {
                                  setDialogState(() {
                                    _selectedSeconds = index;
                                  });
                                },
                                children: List.generate(60, (index) {
                                  return Center(
                                    child: Text(
                                      index.toString().padLeft(2, '0'),
                                      style: TextStyle(fontSize: 20, color: Colors.black),
                                    ),
                                  );
                                }),
                                backgroundColor: Theme.of(context).dialogBackgroundColor,
                                diameterRatio: 1.0,
                                scrollController: FixedExtentScrollController(initialItem: _selectedSeconds),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              _existingImageUrl != null
                                  ? 'Imagen existente'
                                  : _selectedImage == null
                                      ? 'No se ha seleccionado imagen'
                                      : 'Imagen seleccionada',
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () async {
                              final picker = ImagePicker();
                              final XFile? image = await picker.pickImage(source: ImageSource.gallery);
                              if (image != null) {
                                setDialogState(() {
                                  _selectedImage = image;
                                  _existingImageUrl = null; // Resetear imagen existente si se selecciona una nueva
                                });
                              }
                            },
                            child: Text('Seleccionar Imagen'),
                          ),
                        ],
                      ),
                      if (_existingImageUrl != null) ...[
                        SizedBox(height: 8),
                        Image.network(
                          _existingImageUrl!,
                          height: 80,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Icon(Icons.error, size: 80);
                          },
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('Cancelar'),
                ),
                TextButton(
                  onPressed: () async {
                    if (_exerciseNameController.text.isEmpty ||
                        _seriesController.text.isEmpty ||
                        _repetitionsController.text.isEmpty ||
                        (_selectedImage == null && _existingImageUrl == null)) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Todos los campos son obligatorios')),
                      );
                      return;
                    }

                    final series = int.tryParse(_seriesController.text) ?? 0;
                    final repetitions = int.tryParse(_repetitionsController.text) ?? 0;
                    final timer = (_selectedHours * 3600) + (_selectedMinutes * 60) + _selectedSeconds;
                    String? imageUrl = _existingImageUrl;
                    if (_selectedImage != null) {
                      imageUrl = await _uploadImage(_selectedImage!);
                    }
                    if (imageUrl != null) {
                      final exerciseData = {
                        'name': _exerciseNameController.text,
                        'image': imageUrl,
                        'series': series,
                        'repetitions': repetitions,
                        'timer': timer,
                      };
                      setState(() {
                        if (editIndex != null) {
                          _exercises[editIndex] = exerciseData;
                        } else {
                          _exercises.add(exerciseData);
                        }
                      });
                      Navigator.pop(context);
                    }
                  },
                  child: Text(existingExercise == null ? 'Agregar' : 'Actualizar'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _saveRoutine() async {
    if (_formKey.currentState!.validate() &&
        _selectedDay != null &&
        _selectedUserId != null &&
        _selectedExpirationDate != null &&
        _exercises.isNotEmpty) {
      try {
        final routineData = {
          'name': _selectedDay,
          'description': _descriptionController.text.isEmpty ? 'Sin descripción' : _descriptionController.text,
          'exercises': _exercises,
          'userId': _selectedUserId,
          'userName': _users.firstWhere((user) => user['id'] == _selectedUserId)['name'],
          'expirationDate': Timestamp.fromDate(_selectedExpirationDate!),
          'createdAt': widget.routineData != null
              ? widget.routineData!['createdAt']
              : Timestamp.now(),
        };

        if (widget.routineId != null) {
          // Actualizar rutina existente
          await FirebaseFirestore.instance
              .collection('Rutinas')
              .doc(widget.routineId)
              .update(routineData);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Rutina actualizada con éxito')),
          );
        } else {
          // Crear nueva rutina
          await FirebaseFirestore.instance.collection('Rutinas').add(routineData);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Rutina agregada con éxito')),
          );
        }

        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al guardar rutina: $e')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Por favor, complete todos los campos')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.routineId == null ? 'Agregar Rutina' : 'Editar Rutina'),
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
                DropdownButtonFormField<String>(
                  value: _selectedDay,
                  hint: Text('Seleccione el día'),
                  items: _days.map((day) {
                    return DropdownMenuItem<String>(
                      value: day,
                      child: Text(day),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedDay = value;
                    });
                  },
                  validator: (value) => value == null ? 'Seleccione un día' : null,
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _descriptionController,
                  decoration: InputDecoration(labelText: 'Descripción'),
                ),
                SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: _selectedUserId,
                  hint: Text('Seleccione un usuario'),
                  items: _users.map((user) {
                    return DropdownMenuItem<String>(
                      value: user['id'],
                      child: Text(user['name']),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedUserId = value;
                    });
                  },
                  validator: (value) => value == null ? 'Seleccione un usuario' : null,
                ),
                SizedBox(height: 16),
                ListTile(
                  title: Text(_selectedExpirationDate == null
                      ? 'Seleccione fecha de vencimiento'
                      : 'Vence: ${DateFormat('dd/MM/yyyy').format(_selectedExpirationDate!)}'),
                  trailing: Icon(Icons.calendar_today),
                  onTap: () async {
                    final pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime(2100),
                    );
                    if (pickedDate != null) {
                      setState(() {
                        _selectedExpirationDate = pickedDate;
                      });
                    }
                  },
                ),
                SizedBox(height: 16),
                ..._exercises.asMap().entries.map((entry) {
                  int idx = entry.key;
                  Map<String, dynamic> exercise = entry.value;
                  final hours = (exercise['timer'] ~/ 3600);
                  final minutes = (exercise['timer'] ~/ 60) % 60;
                  final seconds = exercise['timer'] % 60;
                  return Card(
                    child: ListTile(
                      title: Text(exercise['name'] ?? 'Ejercicio ${idx + 1}'),
                      subtitle: Text(
                          'Series: ${exercise['series']}, Repeticiones: ${exercise['repetitions']}, Tiempo: $hours h $minutes m $seconds s'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.edit, color: Colors.blue),
                            onPressed: () {
                              _addExercise(existingExercise: exercise, editIndex: idx);
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              setState(() {
                                _exercises.removeAt(idx);
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
                ElevatedButton(
                  onPressed: () => _addExercise(),
                  child: Text('Agregar Ejercicio'),
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _saveRoutine,
                  child: Text(widget.routineId == null ? 'Guardar Rutina' : 'Actualizar Rutina'),
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
    _descriptionController.dispose();
    super.dispose();
  }
}