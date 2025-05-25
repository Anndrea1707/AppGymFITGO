import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloudinary_public/cloudinary_public.dart';
import 'dart:io';

class AddRecet extends StatefulWidget {
  @override
  _AddRecetState createState() => _AddRecetState();
}

class _AddRecetState extends State<AddRecet> {
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _descripcionController = TextEditingController();
  final TextEditingController _proteinaController = TextEditingController();
  File? _selectedImage;
  String? _imageUrl;
  bool _isUploading = false;

  final CloudinaryPublic cloudinary = CloudinaryPublic('dycjb5ovf', 'FitgoApp', cache: false);

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
      await _uploadImage(pickedFile);
    }
  }

  Future<void> _uploadImage(XFile image) async {
    setState(() {
      _isUploading = true;
    });
    try {
      final response = await cloudinary.uploadFile(
        CloudinaryFile.fromFile(image.path, resourceType: CloudinaryResourceType.Image),
      );
      setState(() {
        _imageUrl = response.secureUrl;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Imagen subida exitosamente')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al subir imagen: $e')),
      );
    } finally {
      setState(() {
        _isUploading = false;
      });
    }
  }

  Future<void> _agregarReceta() async {
    if (_nombreController.text.isNotEmpty &&
        _descripcionController.text.isNotEmpty &&
        _proteinaController.text.isNotEmpty &&
        _imageUrl != null) {
      try {
        int proteina = int.tryParse(_proteinaController.text) ?? -1;
        if (proteina < 0) {
          throw FormatException('Por favor, ingresa un valor numérico válido para la proteína');
        }
        await FirebaseFirestore.instance.collection('recetas').add({
          'nombre': _nombreController.text,
          'descripcion': _descripcionController.text,
          'proteina': proteina,
          'imagenUrl': _imageUrl,
          'rating': 0.0,
          'timestamp': FieldValue.serverTimestamp(),
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Receta agregada exitosamente")),
        );
        _nombreController.clear();
        _descripcionController.clear();
        _proteinaController.clear();
        setState(() {
          _selectedImage = null;
          _imageUrl = null;
        });
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error al agregar receta: $e")),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Por favor, completa todos los campos e sube una imagen")),
      );
    }
  }

  Future<void> _eliminarReceta(String id) async {
    await FirebaseFirestore.instance.collection('recetas').doc(id).delete();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Receta eliminada exitosamente")),
    );
  }

  Future<void> _editarReceta(String id, Map<String, dynamic> updatedData) async {
    await FirebaseFirestore.instance.collection('recetas').doc(id).update(updatedData);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Receta actualizada exitosamente")),
    );
  }

  void _showEditDialog(String id, Map<String, dynamic> recetaData) {
    final TextEditingController _editNombreController = TextEditingController(text: recetaData['nombre']);
    final TextEditingController _editDescripcionController = TextEditingController(text: recetaData['descripcion']);
    final TextEditingController _editProteinaController = TextEditingController(text: recetaData['proteina'].toString());
    String? _editImageUrl = recetaData['imagenUrl'];
    String? _newImageUrl;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Editar Receta'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _editNombreController,
                  decoration: InputDecoration(labelText: 'Nombre'),
                ),
                TextField(
                  controller: _editDescripcionController,
                  decoration: InputDecoration(labelText: 'Descripción'),
                ),
                TextField(
                  controller: _editProteinaController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(labelText: 'Proteína (g)'),
                ),
                SizedBox(height: 10),
                Text('Imagen actual:'),
                if (_editImageUrl != null)
                  Image.network(
                    _editImageUrl,
                    height: 100,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Icon(Icons.error);
                    },
                  ),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: _isUploading
                      ? null
                      : () async {
                          final picker = ImagePicker();
                          final pickedFile = await picker.pickImage(source: ImageSource.gallery);
                          if (pickedFile != null) {
                            setState(() {
                              _isUploading = true;
                            });
                            try {
                              final response = await cloudinary.uploadFile(
                                CloudinaryFile.fromFile(pickedFile.path, resourceType: CloudinaryResourceType.Image),
                              );
                              _newImageUrl = response.secureUrl;
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Nueva imagen subida exitosamente')),
                              );
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Error al subir imagen: $e')),
                              );
                            } finally {
                              setState(() {
                                _isUploading = false;
                              });
                            }
                          }
                        },
                  child: _isUploading
                      ? CircularProgressIndicator()
                      : Text('Seleccionar Nueva Imagen'),
                ),
                if (_newImageUrl != null) ...[
                  SizedBox(height: 10),
                  Text('Nueva imagen:'),
                  Image.network(
                    _newImageUrl!,
                    height: 100,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Icon(Icons.error);
                    },
                  ),
                ],
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                if (_editNombreController.text.isNotEmpty &&
                    _editDescripcionController.text.isNotEmpty &&
                    _editProteinaController.text.isNotEmpty &&
                    (_editImageUrl != null || _newImageUrl != null)) {
                  try {
                    int proteina = int.tryParse(_editProteinaController.text) ?? -1;
                    if (proteina < 0) {
                      throw FormatException('Por favor, ingresa un valor numérico válido para la proteína');
                    }
                    final updatedData = {
                      'nombre': _editNombreController.text,
                      'descripcion': _editDescripcionController.text,
                      'proteina': proteina,
                      'imagenUrl': _newImageUrl ?? _editImageUrl,
                      'rating': recetaData['rating'] ?? 0.0,
                    };
                    _editarReceta(id, updatedData);
                    Navigator.pop(context);
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error al actualizar receta: $e')),
                    );
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Por favor, completa todos los campos')),
                  );
                }
              },
              child: Text('Guardar'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildRecetasList() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('recetas').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Padding(
            padding: EdgeInsets.all(20),
            child: Text(
              "No hay recetas disponibles.",
              style: TextStyle(color: Colors.white, fontSize: 16),
              textAlign: TextAlign.center,
            ),
          );
        }

        final recetas = snapshot.data!.docs;

        return ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: recetas.length,
          itemBuilder: (context, index) {
            final receta = recetas[index];
            final data = receta.data() as Map<String, dynamic>;

            return Card(
              margin: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
              color: Color(0xFFF5EDE4),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: ListTile(
                leading: Image.network(
                  data['imagenUrl'] ?? '',
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Icon(Icons.broken_image);
                  },
                ),
                title: Text(data['nombre'] ?? 'Sin nombre', style: TextStyle(color: Colors.black)),
                subtitle: Text(
                  "${data['descripcion'] ?? 'Sin descripción'}\nProteína: ${data['proteina'] ?? 0}g",
                  style: TextStyle(color: Colors.black54),
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.edit, color: Colors.black),
                      onPressed: () => _showEditDialog(receta.id, data),
                    ),
                    IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        _eliminarReceta(receta.id);
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Agregar Receta", style: TextStyle(color: Colors.black)),
        backgroundColor: Color(0xFFF5EDE4),
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Container(
        color: Color(0xFF0a0322),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: _nombreController,
                  decoration: InputDecoration(
                    labelText: "Nombre de la receta",
                    labelStyle: TextStyle(color: Colors.white),
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                  ),
                  style: TextStyle(color: Colors.white),
                ),
                SizedBox(height: 10),
                TextField(
                  controller: _descripcionController,
                  decoration: InputDecoration(
                    labelText: "Descripción",
                    labelStyle: TextStyle(color: Colors.white),
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                  ),
                  style: TextStyle(color: Colors.white),
                ),
                SizedBox(height: 10),
                TextField(
                  controller: _proteinaController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: "Gramos de proteína",
                    labelStyle: TextStyle(color: Colors.white),
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                  ),
                  style: TextStyle(color: Colors.white),
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        _imageUrl != null ? 'Imagen seleccionada' : 'No se ha seleccionado imagen',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: _isUploading ? null : _pickImage,
                      child: _isUploading
                          ? CircularProgressIndicator()
                          : Text('Seleccionar Imagen'),
                    ),
                  ],
                ),
                if (_imageUrl != null) ...[
                  SizedBox(height: 10),
                  Image.network(
                    _imageUrl!,
                    height: 100,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Icon(Icons.error, color: Colors.white);
                    },
                  ),
                ],
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _agregarReceta,
                  style: ElevatedButton.styleFrom(backgroundColor: Color(0xFFF5EDE4)),
                  child: Text("Agregar Receta", style: TextStyle(color: Colors.black)),
                ),
                SizedBox(height: 20),
                Divider(color: Colors.white),
                Text(
                  "Recetas Agregadas",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                _buildRecetasList(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _descripcionController.dispose();
    _proteinaController.dispose();
    super.dispose();
  }
}