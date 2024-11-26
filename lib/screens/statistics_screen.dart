import 'package:flutter/material.dart';

class StatisticsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0a0322),
      appBar: AppBar(
        backgroundColor: Color(0xFFF5EDE4),
        elevation: 0,
        automaticallyImplyLeading: true,
        title: Text(
          'Estadísticas',
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
                        image: AssetImage('images/gymStatis.jpg'), // Imagen personalizada
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 16,
                    left: 16,
                    child: Text(
                      'Estadísticas del gimnasio',
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

              // Encabezado de sección
              Text(
                'Datos destacados',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
              SizedBox(height: 10),

              // Gráfico 1
              _buildStatisticItem(
                context,
                'Valores cuota',
                'images/precios.png',
              ),
              SizedBox(height: 20),

              // Gráfico 2
              _buildStatisticItem(
                context,
                'Distribución de edades',
                'images/edades.png',
              ),
              SizedBox(height: 20),

              // Gráfico 3
              _buildStatisticItem(
                context,
                'Disciplinas más populares',
                'images/disciplinas.png',
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  // Widget para cada gráfica o estadística
  Widget _buildStatisticItem(BuildContext context, String title, String imagePath) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
        SizedBox(height: 10),
        Container(
          height: 200,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            image: DecorationImage(
              image: AssetImage(imagePath), // Ruta de la imagen
              fit: BoxFit.cover,
            ),
          ),
        ),
      ],
    );
  }
}
