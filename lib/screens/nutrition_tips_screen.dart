import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gym_fitgo/widgets/appBar_widget.dart';
import 'package:gym_fitgo/widgets/categories_widget.dart';
import 'package:gym_fitgo/widgets/popular_items_widget.dart';
import 'package:gym_fitgo/widgets/newest_item_widget.dart';
import 'package:gym_fitgo/widgets/custom_bottom_navbar.dart';
import 'package:gym_fitgo/services/notification_services.dart';

class NutritionTipsScreen extends StatefulWidget {
  @override
  NutritionTipsScreenState createState() => NutritionTipsScreenState();
}
// Función para programar la notificación automática
void _scheduleNotification() async {
  await Future.delayed(Duration(seconds: 10)); // Retraso de 10 segundos
  await mostrarNotificacion(); // Llama a la función para mostrar la notificación
}
class NutritionTipsScreenState extends State<NutritionTipsScreen> {
  int _selectedIndex = 0; // Añadimos el índice seleccionado

  @override
  void initState() {
    super.initState();
  }

  void _onNavBarTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0a0322),

      // Barra de navegación inferior
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _selectedIndex,
        onTap: _onNavBarTapped, // Rutinas será la segunda pestaña
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

          // Título de Populares
          Padding(
            padding: EdgeInsets.only(top: 20, left: 10),
            child: Text(
              "Populares",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Color(0xFFF5EDE4),
              ),
            ),
          ),

          // Populares Items Widget
          PopularItemsWidget(),

          // Título de Desayunos
          Padding(
            padding: EdgeInsets.only(top: 20, left: 10),
            child: Text(
              "Desayunos para ti",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Color(0xFFF5EDE4),
              ),
            ),
          ),

          // Newest Item Widget
          NewestItemWidget(),
        ],
      ),
    );
  }
}
