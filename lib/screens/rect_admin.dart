import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gym_fitgo/screens/add_recet_admin.dart'; // Ajuste en la importación
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class NutritionTipsScreen_admin extends StatefulWidget {
  @override
  NutritionTipsScreenState createState() => NutritionTipsScreenState();
}

class NutritionTipsScreenState extends State<NutritionTipsScreen_admin> {
  Future<void> _updateRating(String recetaId, double rating) async {
    try {
      await FirebaseFirestore.instance.collection('recetas').doc(recetaId).update({
        'rating': rating,
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Calificación actualizada')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al actualizar calificación: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0a0322),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF5EDE4),
        elevation: 0,
        title: const Text(
          'Recetas',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        automaticallyImplyLeading: true, // Habilita la flecha de retroceso
      ),
      body: ListView(
        children: [
          // Search
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 10,
              horizontal: 15,
            ),
            child: Container(
              width: double.infinity,
              height: 50,
              decoration: BoxDecoration(
                color: const Color(0xFFF5EDE4),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  children: [
                    const Icon(
                      CupertinoIcons.search,
                      color: Colors.white,
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: TextFormField(
                          decoration: const InputDecoration(
                            hintText: "Buscar",
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Título de Recetas Agregadas
          const Padding(
            padding: EdgeInsets.only(top: 20, left: 10),
            child: Text(
              "Recetas Agregadas",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Color(0xFFF5EDE4),
              ),
            ),
          ),

          // Recetas desde Firestore
          _buildRecetasList(),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFF5EDE4),
                padding: const EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AddRecet()),
                );
              },
              child: const Text(
                "Agregar Receta",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecetasList() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('recetas').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Padding(
            padding: EdgeInsets.all(20),
            child: Text(
              "No hay recetas disponibles.",
              style: TextStyle(color: Colors.white, fontSize: 16),
              textAlign: TextAlign.center,
            ),
          );
        }

        final recetas = snapshot.data!.docs;

        return Column(
          children: recetas.map((doc) {
            final data = doc.data() as Map<String, dynamic>;

            // Manejo seguro del valor de 'proteina'
            final proteina = data['proteina'] != null
                ? (data['proteina'] is int
                    ? (data['proteina'] as int).toDouble()
                    : (data['proteina'] as double))
                : 0.0;

            // Manejo seguro del valor de 'rating'
            final rating = data['rating']?.toDouble() ?? 0.0;

            return _buildRecetaCard(
              docId: doc.id,
              nombre: data['nombre'] ?? 'Sin nombre',
              descripcion: data['descripcion'] ?? 'Sin descripción',
              proteina: proteina,
              imagenUrl: data['imagenUrl'] ?? '',
              rating: rating,
            );
          }).toList(),
        );
      },
    );
  }

  Widget _buildRecetaCard({
    required String docId,
    required String nombre,
    required String descripcion,
    required double proteina,
    required String imagenUrl,
    required double rating,
  }) {
    return Card(
      color: const Color(0xFFF5EDE4),
      margin: const EdgeInsets.only(bottom: 15, left: 15, right: 15),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 5,
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    imagenUrl,
                    height: 80,
                    width: 80,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => const Icon(
                      Icons.broken_image,
                      size: 80,
                      color: Colors.grey,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        nombre,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        descripcion,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(color: Colors.grey),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        "Pr. ${proteina.toStringAsFixed(1)}g",
                        style: const TextStyle(
                          color: Colors.black87,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 5),
                      // RatingBar debajo de "Proteína"
                      RatingBar.builder(
                        initialRating: rating,
                        minRating: 0,
                        direction: Axis.horizontal,
                        allowHalfRating: true,
                        itemCount: 5,
                        itemSize: 18,
                        itemPadding: const EdgeInsets.symmetric(horizontal: 1.0),
                        itemBuilder: (context, _) => Icon(
                          Icons.star,
                          color: rating > 0 ? Colors.amber : Colors.grey,
                        ),
                        onRatingUpdate: (rating) {
                          _updateRating(docId, rating);
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Ícono del corazón en la parte superior derecha
          const Positioned(
            top: 5,
            right: 5,
            child: Icon(
              Icons.favorite_border,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}