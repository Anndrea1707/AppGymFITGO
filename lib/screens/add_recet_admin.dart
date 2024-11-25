import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddRecet extends StatefulWidget {
  @override
  _AddRecetState createState() => _AddRecetState();
}

class _AddRecetState extends State<AddRecet> {
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _descripcionController = TextEditingController();
  final TextEditingController _proteinaController = TextEditingController();
  final TextEditingController _imagenUrlController = TextEditingController();

  // Método para agregar receta a Firestore
  Future<void> _agregarReceta() async {
    if (_nombreController.text.isNotEmpty &&
        _descripcionController.text.isNotEmpty &&
        _proteinaController.text.isNotEmpty &&
        _imagenUrlController.text.isNotEmpty) {
      try {
        await FirebaseFirestore.instance.collection('recetas').add({
          'nombre': _nombreController.text,
          'descripcion': _descripcionController.text,
          'proteina': int.parse(_proteinaController.text),
          'imagenUrl': _imagenUrlController.text,
          'timestamp': FieldValue.serverTimestamp(),
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Receta agregada exitosamente")),
        );
        _nombreController.clear();
        _descripcionController.clear();
        _proteinaController.clear();
        _imagenUrlController.clear();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error al agregar receta: $e")),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Por favor, completa todos los campos")),
      );
    }
  }

  // Método para eliminar receta
  Future<void> _eliminarReceta(String id) async {
    await FirebaseFirestore.instance.collection('recetas').doc(id).delete();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Receta eliminada exitosamente")),
    );
  }

  // Método para construir la lista de recetas
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
              style: TextStyle(color: Colors.black, fontSize: 16),
              textAlign: TextAlign.center,
            ),
          );
        }

        final recetas = snapshot.data!.docs;

        return ListView.builder(
          shrinkWrap: true,
          itemCount: recetas.length,
          itemBuilder: (context, index) {
            final receta = recetas[index];
            final data = receta.data() as Map<String, dynamic>;

            return Card(
              margin: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
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
                title: Text(data['nombre'] ?? 'Sin nombre', style: TextStyle(color: Colors.black)), // Color negro
                subtitle: Text(
                  "${data['descripcion'] ?? 'Sin descripción'}\nProteína: ${data['proteina'] ?? 0}g",
                  style: TextStyle(color: Colors.black), // Color negro
                ),
                trailing: IconButton(
                  icon: Icon(Icons.delete, color: Colors.red),
                  onPressed: () {
                    _eliminarReceta(receta.id);
                  },
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
        title: Text(
          "Agregar Receta",
          style: TextStyle(color: Colors.black), // Texto negro
        ),
        backgroundColor: Color(0xFFF5EDE4), // Beige claro
        iconTheme: IconThemeData(color: Colors.black), // Iconos en color negro
      ),
      body: Container(
        color: Color(0xFF0a0322), // Fondo morado oscuro en toda la pantalla
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Campo para nombre de la receta
                TextField(
                  controller: _nombreController,
                  decoration: InputDecoration(
                    labelText: "Nombre de la receta",
                    labelStyle: TextStyle(color: Colors.white), // Etiqueta blanca
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white), // Borde blanco al enfocar
                    ),
                  ),
                  style: TextStyle(color: Colors.white), // Texto blanco
                ),
                SizedBox(height: 10),
                // Campo para descripción
                TextField(
                  controller: _descripcionController,
                  decoration: InputDecoration(
                    labelText: "Descripción",
                    labelStyle: TextStyle(color: Colors.white), // Etiqueta blanca
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white), // Borde blanco al enfocar
                    ),
                  ),
                  style: TextStyle(color: Colors.white), // Texto blanco
                ),
                SizedBox(height: 10),
                // Campo para gramos de proteína
                TextField(
                  controller: _proteinaController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: "Gramos de proteína",
                    labelStyle: TextStyle(color: Colors.white), // Etiqueta blanca
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white), // Borde blanco al enfocar
                    ),
                  ),
                  style: TextStyle(color: Colors.white), // Texto blanco
                ),
                SizedBox(height: 10),
                // Campo para URL de la imagen
                TextField(
                  controller: _imagenUrlController,
                  decoration: InputDecoration(
                    labelText: "URL de la Imagen",
                    labelStyle: TextStyle(color: Colors.white), // Etiqueta blanca
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white), // Borde blanco al enfocar
                    ),
                  ),
                  style: TextStyle(color: Colors.white), // Texto blanco
                ),
                SizedBox(height: 20),
                
                // Botón de agregar receta con fondo beige claro
                ElevatedButton(
                  onPressed: _agregarReceta,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFF5EDE4), // Fondo beige claro
                  ),
                  child: Text(
                    "Agregar Receta",
                    style: TextStyle(color: Colors.black), // Texto negro
                  ),
                ),
                SizedBox(height: 20),
                Divider(color: Colors.white), // Divider blanco
                Text(
                  "Recetas Agregadas",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                // Recetas agregadas con fondo morado oscuro
                Container(
                  color: Color(0xFF0a0322), // Fondo morado oscuro para el contenedor de recetas
                  child: _buildRecetasList(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
