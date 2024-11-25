import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gym_fitgo/screens/add_recet_admin.dart';
import 'package:gym_fitgo/widgets/appBar_widget.dart';
import 'package:gym_fitgo/widgets/categories_widget.dart';
import 'package:gym_fitgo/widgets/popular_items_widget.dart';
import 'package:gym_fitgo/widgets/newest_item_widget.dart';
import 'package:gym_fitgo/widgets/custom_bottom_navbar.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class NutritionTipsScreen_admin extends StatefulWidget {
  @override
  NutritionTipsScreenState createState() => NutritionTipsScreenState();
}

class NutritionTipsScreenState extends State<NutritionTipsScreen_admin> {
  int _selectedIndex = 0; // Añadimos el índice seleccionado

  void _onNavBarTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0a0322),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _selectedIndex,
        onTap: _onNavBarTapped,
      ),
      body: ListView(
        children: [
          // Custom App Bar Widget
          AppBarwidget(),

          // Search
          Padding(
            padding: EdgeInsets.symmetric(
              vertical: 10,
              horizontal: 15,
            ),
            child: Container(
              width: double.infinity,
              height: 50,
              decoration: BoxDecoration(
                color: Color(0xFFF5EDE4),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 10,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  children: [
                    Icon(
                      CupertinoIcons.search,
                      color: Colors.white,
                    ),
                    Container(
                      height: 50,
                      width: 300,
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 15),
                        child: TextFormField(
                          decoration: InputDecoration(
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
          Padding(
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
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFF5EDE4), // Beige claro para el fondo
                padding: EdgeInsets.symmetric(
                    vertical: 15), // Mismo tamaño de padding
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10), // Bordes redondeados
                ),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AddRecet()),
                );
              },
              child: Text(
                "Agregar Receta",
                style: TextStyle(
                  fontSize: 16, // Mismo tamaño de letra
                  color: Colors.black, // Letra oscura
                  fontWeight: FontWeight.bold, // Letra en negrita
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

        return Column(
          children: recetas.map((doc) {
            final data = doc.data() as Map<String, dynamic>;

            // Manejo seguro del valor de 'proteina'
            final proteina = data['proteina'] != null
                ? (data['proteina'] is int
                    ? (data['proteina'] as int).toDouble()
                    : (data['proteina'] as double))
                : 0.0;

            return _buildRecetaCard(
              nombre: data['nombre'] ?? 'Sin nombre',
              descripcion: data['descripcion'] ?? 'Sin descripción',
              proteina: proteina,
              imagenUrl: data['imagenUrl'] ?? '',
            );
          }).toList(),
        );
      },
    );
  }

  Widget _buildRecetaCard({
    required String nombre,
    required String descripcion,
    required double proteina,
    required String imagenUrl,
  }) {
    return Card(
      color: Color(0xFFF5EDE4),
      margin: EdgeInsets.only(bottom: 15, left: 15, right: 15),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 5,
      child: Stack(
        children: [
          Padding(
            padding: EdgeInsets.all(10),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    imagenUrl,
                    height: 80,
                    width: 80,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Icon(
                      Icons.broken_image,
                      size: 80,
                      color: Colors.grey,
                    ),
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        nombre,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        descripcion,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(color: Colors.grey),
                      ),
                      SizedBox(height: 5),
                      Text(
                        "Pr. ${proteina.toStringAsFixed(1)}g",
                        style: TextStyle(
                          color: Colors.black87,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 5),
                      
                      // RatingBar debajo de "Proteína"
                      RatingBar.builder(
                        initialRating: 4, // Calificación predeterminada
                        minRating: 1,
                        direction: Axis.horizontal,
                        allowHalfRating: true,
                        itemCount: 5,
                        itemSize: 18, // Tamaño de las estrellas
                        itemPadding: EdgeInsets.symmetric(horizontal: 1.0),
                        itemBuilder: (context, _) => Icon(
                          Icons.star,
                          color: Colors.amber,
                        ),
                        onRatingUpdate: (rating) {
                          print(rating);
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Ícono del corazón en la parte superior derecha
          Positioned(
            top: 5,
            right: 5,
            child: Icon(
              Icons.favorite_border,
              color: Colors.black, // Cambiado a negro
            ),
          ),
        ],
      ),
    );
  }
}
