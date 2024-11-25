import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gym_fitgo/widgets/appBar_widget.dart';
import 'package:gym_fitgo/widgets/categories_widget.dart';
import 'package:gym_fitgo/widgets/custom_bottom_navbar.dart';
import 'package:gym_fitgo/screens/home_screen.dart'; // Asegúrate de importar la pantalla HomeScreen

class NutritionTipsScreen extends StatefulWidget {
  @override
  NutritionTipsScreenState createState() => NutritionTipsScreenState();
}

class NutritionTipsScreenState extends State<NutritionTipsScreen> {
  int _selectedIndex = 0; // Índice seleccionado para la barra de navegación
  final Set<String> _favorites = {}; // Almacena recetas marcadas como favoritas

  @override
  void initState() {
    super.initState();
  }

  void _onNavBarTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // Método para construir las tarjetas de recetas
  Widget _buildRecetasCards() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('recetas').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Padding(
            padding: const EdgeInsets.all(20),
            child: Text(
              "No hay recetas disponibles.",
              style: TextStyle(color: Colors.white, fontSize: 16),
              textAlign: TextAlign.center,
            ),
          );
        }

        final recetas = snapshot.data!.docs;

        return ListView.builder(
          physics: NeverScrollableScrollPhysics(), // Evitar conflictos de scroll
          shrinkWrap: true, // Para adaptarse dentro del ListView principal
          itemCount: recetas.length,
          itemBuilder: (context, index) {
            final receta = recetas[index];
            final data = receta.data() as Map<String, dynamic>;
            final isFavorite = _favorites.contains(receta.id);

            return Card(
              margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              color: Color(0xFFF5EDE4), // Fondo beige claro
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Imagen de la receta
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        image: DecorationImage(
                          image: NetworkImage(data['imagenUrl'] ?? ''),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    SizedBox(width: 10),

                    // Información de la receta
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            data['nombre'] ?? 'Sin nombre',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            data['descripcion'] ?? 'Sin descripción',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[800],
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            "Proteína: ${data['proteina']}g",
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[700],
                            ),
                          ),
                          SizedBox(height: 5),

                          // Rating bar
                          RatingBar.builder(
                            initialRating: data['rating']?.toDouble() ?? 0,
                            minRating: 1,
                            direction: Axis.horizontal,
                            allowHalfRating: true,
                            itemCount: 5,
                            itemSize: 20,
                            itemBuilder: (context, _) => Icon(
                              Icons.star,
                              color: Colors.amber,
                            ),
                            onRatingUpdate: (rating) {
                              // No hacemos nada, solo para mostrar
                            },
                          ),
                        ],
                      ),
                    ),

                    // Icono de favorito
                    IconButton(
                      icon: Icon(
                        isFavorite ? CupertinoIcons.heart_fill : CupertinoIcons.heart,
                        color: isFavorite ? Colors.red : Colors.grey,
                      ),
                      onPressed: () {
                        setState(() {
                          if (isFavorite) {
                            _favorites.remove(receta.id);
                          } else {
                            _favorites.add(receta.id);
                          }
                        });
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
      backgroundColor: Color(0xFF0a0322), // Fondo morado oscuro

      // Barra de navegación inferior
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _selectedIndex,
        onTap: _onNavBarTapped,
      ),
      body: ListView(
        children: [
          // Encabezado con el título y la flecha de regreso
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: Row(
              children: [
                IconButton(
                  icon: Icon(CupertinoIcons.back, color: Colors.white),
                  onPressed: () {
                    // Redirige a la pantalla de inicio
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => HomeScreen()),
                    );
                  },
                ),
                SizedBox(width: 10),
                Text(
                  "Consejos alimenticios",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),

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
                      color: Colors.grey,
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: TextFormField(
                        decoration: InputDecoration(
                          hintText: "Buscar",
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Categoría
          Padding(
            padding: EdgeInsets.only(top: 20, left: 10),
            child: Text(
              "¿Qué tienes en tu cocina?",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Color(0xFFF5EDE4),
              ),
            ),
          ),

          // Categorías Widget
          Categorieswidget(),

          // Recetas desde Firestore
          Padding(
            padding: EdgeInsets.only(top: 20, left: 10),
            child: Text(
              "Recomendados para ti",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Color(0xFFF5EDE4),
              ),
            ),
          ),
          _buildRecetasCards(),
        ],
      ),
    );
  }
}
