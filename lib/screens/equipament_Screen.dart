import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloudinary_public/cloudinary_public.dart';
import 'dart:io';

class EquipmentScreen extends StatefulWidget {
  @override
  _EquipmentScreenState createState() => _EquipmentScreenState();
}

class _EquipmentScreenState extends State<EquipmentScreen> {
  final CloudinaryPublic cloudinary = CloudinaryPublic('dycjb5ovf', 'FitgoApp', cache: false);
  bool _isUploading = false;

  Future<void> _addOrEditEquipment({String? docId, String? nombre, double? peso, String? imageUrl}) async {
    final TextEditingController _nombreController = TextEditingController(text: nombre ?? '');
    final TextEditingController _pesoController = TextEditingController(text: peso?.toString() ?? '');

    // Usamos una variable local para manejar la URL de la imagen dentro del diálogo
    String? _currentImageUrl = imageUrl;
    String? _newImageUrl;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: Text(docId == null ? 'Agregar Equipamiento' : 'Editar Equipamiento'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: _nombreController,
                      decoration: InputDecoration(labelText: 'Nombre'),
                    ),
                    TextField(
                      controller: _pesoController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(labelText: 'Peso (kg)'),
                    ),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            _newImageUrl != null
                                ? 'Nueva imagen seleccionada'
                                : _currentImageUrl != null
                                    ? 'Imagen actual seleccionada'
                                    : 'No se ha seleccionado imagen',
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: _isUploading
                              ? null
                              : () async {
                                  final picker = ImagePicker();
                                  final pickedFile = await picker.pickImage(source: ImageSource.gallery);
                                  if (pickedFile != null) {
                                    setDialogState(() {
                                      _isUploading = true;
                                    });
                                    try {
                                      final response = await cloudinary.uploadFile(
                                        CloudinaryFile.fromFile(pickedFile.path, resourceType: CloudinaryResourceType.Image),
                                      );
                                      setDialogState(() {
                                        _newImageUrl = response.secureUrl;
                                        _currentImageUrl = _newImageUrl; // Actualiza la imagen actual
                                      });
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(content: Text('Imagen subida exitosamente')),
                                      );
                                    } catch (e) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(content: Text('Error al subir imagen: $e')),
                                      );
                                    } finally {
                                      setDialogState(() {
                                        _isUploading = false;
                                      });
                                    }
                                  }
                                },
                          child: _isUploading
                              ? CircularProgressIndicator()
                              : Text('Seleccionar Imagen'),
                        ),
                      ],
                    ),
                    if (_currentImageUrl != null) ...[
                      SizedBox(height: 10),
                      Image.network(
                        _currentImageUrl!,
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
                    if (_nombreController.text.isNotEmpty &&
                        _pesoController.text.isNotEmpty &&
                        (_currentImageUrl != null || _newImageUrl != null)) {
                      try {
                        double peso = double.tryParse(_pesoController.text) ?? -1;
                        if (peso < 0) {
                          throw FormatException('Por favor, ingresa un valor numérico válido para el peso');
                        }
                        if (docId == null) {
                          // Agregar nuevo equipamiento
                          FirebaseFirestore.instance.collection('Equipamiento').add({
                            'nombre': _nombreController.text,
                            'peso': peso,
                            'imagenUrl': _newImageUrl ?? _currentImageUrl,
                          });
                        } else {
                          // Editar equipamiento existente
                          FirebaseFirestore.instance.collection('Equipamiento').doc(docId).update({
                            'nombre': _nombreController.text,
                            'peso': peso,
                            'imagenUrl': _newImageUrl ?? _currentImageUrl,
                          });
                        }
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Equipamiento ${docId == null ? 'agregado' : 'actualizado'} exitosamente',
                            ),
                          ),
                        );
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Error al ${docId == null ? 'agregar' : 'actualizar'} equipamiento: $e',
                            ),
                          ),
                        );
                      }
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Por favor, completa todos los campos')),
                      );
                    }
                  },
                  child: Text(docId == null ? 'Guardar' : 'Actualizar'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> _deleteEquipment(String docId) async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Confirmar eliminación'),
          content: Text('¿Estás seguro de que deseas eliminar este equipamiento?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Cancelar
              },
              child: Text('Cancelar'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.pop(context); // Cierra el diálogo
                try {
                  await FirebaseFirestore.instance.collection('Equipamiento').doc(docId).delete();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Equipamiento eliminado exitosamente')),
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error al eliminar equipamiento: $e')),
                  );
                }
              },
              child: Text('Confirmar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0a0322),
      appBar: AppBar(
        backgroundColor: Color(0xFFF5EDE4),
        elevation: 0,
        automaticallyImplyLeading: true,
        title: Text(
          'Equipamiento',
          style: TextStyle(color: Colors.black),
        ),
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Imagen de introducción
              Stack(
                children: [
                  Container(
                    width: double.infinity,
                    height: 200,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      image: DecorationImage(
                        image: NetworkImage(
                          'https://img.freepik.com/foto-gratis/gimnasio-equipo-ciclismo-indoor_23-2149270210.jpg?uid=R14880236&ga=GA1.1.742260549.1736050892&semt=ais_hybrid&w=740',
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 16,
                    left: 16,
                    child: Text(
                      'Equipamiento del gimnasio',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),

              // Lista de equipamiento
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance.collection('Equipamiento').snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Padding(
                      padding: EdgeInsets.all(20),
                      child: Text(
                        'No hay equipamiento disponible.',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                        textAlign: TextAlign.center,
                      ),
                    );
                  }

                  final equipment = snapshot.data!.docs;

                  return Column(
                    children: equipment.map((doc) {
                      final data = doc.data() as Map<String, dynamic>;
                      return Card(
                        color: Color(0xFFF5EDE4),
                        margin: EdgeInsets.only(bottom: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        elevation: 5,
                        child: ListTile(
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              data['imagenUrl'] ?? '',
                              width: 60,
                              height: 60,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Icon(Icons.broken_image, size: 60, color: Colors.grey);
                              },
                            ),
                          ),
                          title: Text(
                            data['nombre'] ?? 'Sin nombre',
                            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            'Peso: ${data['peso']?.toString() ?? '0'} kg',
                            style: TextStyle(color: Colors.black54),
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: Icon(Icons.edit, color: Colors.black),
                                onPressed: () => _addOrEditEquipment(
                                  docId: doc.id,
                                  nombre: data['nombre'],
                                  peso: data['peso']?.toDouble(),
                                  imageUrl: data['imagenUrl'],
                                ),
                              ),
                              IconButton(
                                icon: Icon(Icons.delete, color: Colors.red),
                                onPressed: () => _deleteEquipment(doc.id),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  );
                },
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addOrEditEquipment(),
        backgroundColor: Color(0xFFF5EDE4),
        child: Icon(Icons.add, color: Colors.black),
      ),
    );
  }
}