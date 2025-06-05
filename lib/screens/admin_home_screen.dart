import 'package:flutter/material.dart';
import 'package:gym_fitgo/screens/rect_admin.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:gym_fitgo/widgets/custom_bottom_navbar_admin.dart';
import 'package:gym_fitgo/screens/login_screen.dart';
import 'package:gym_fitgo/screens/users_screen_admin.dart';
import 'package:gym_fitgo/screens/profile_admin.dart';
import 'package:gym_fitgo/screens/challenges_screen_admin.dart';
import 'package:gym_fitgo/screens/admin_rutins_screen.dart';
import 'package:gym_fitgo/screens/equipament_Screen.dart';
import 'package:carousel_slider/carousel_slider.dart';

class AdminHomeScreen extends StatefulWidget {
  @override
  _AdminHomeScreenState createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends State<AdminHomeScreen> {
  int _selectedIndex = 0;
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  // Lista de imágenes para el carrusel
  final List<String> _carouselImages = [
    'images/adminWelcome.jpeg',
    'https://img.freepik.com/foto-gratis/vista-angulo-hombre-musculoso-irreconocible-preparandose-levantar-barra-club-salud_637285-2497.jpg?uid=R14880236&ga=GA1.1.742260549.1736050892&semt=ais_hybrid&w=740',
    'https://img.freepik.com/foto-gratis/mujer-sosteniendo-pesas-cerca-pesas_651396-1617.jpg?uid=R14880236&ga=GA1.1.742260549.1736050892&semt=ais_hybrid&w=740',
    'https://img.freepik.com/vector-gratis/publicacion-facebook-club-deportivo-diseno-plano_23-2150344104.jpg?uid=R14880236&ga=GA1.1.742260549.1736050892&semt=ais_hybrid&w=740',
  ];

  // Controlador para el carrusel
  int _currentCarouselIndex = 0;

  // Función para manejar la navegación de la barra de navegación
  void _onTap(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        // No navegar, ya estamos en AdminHomeScreen
        break;
      case 1:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => AdminRutinsScreen()),
        );
        break;
      case 2:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ChallengesScreenAdmin()),
        );
        break;
      case 3:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ProfileAdmin()),
        );
        break;
    }
  }

  // Interceptar el botón de retroceso
  Future<bool> _onWillPop() async {
    // Retornar false para evitar que el usuario regrese a la pantalla anterior
    return false;
  }

  @override
  void initState() {
    super.initState();
    // Inicia el carrusel automático
    Future.delayed(Duration.zero, () {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: Color(0xFF0a0322),
        appBar: AppBar(
          backgroundColor: Color(0xFFF8E1FF), // Color claro de referencia
          elevation: 0,
          automaticallyImplyLeading: false,
          title: const Text(
            'Bienvenido administrador/a',
            style: TextStyle(
              color: Colors.black,
              fontSize: 20,
            ),
          ),
          centerTitle: true,
          actions: [
            GestureDetector(
              child: Padding(
                padding: const EdgeInsets.only(right: 16.0), // Separar del borde derecho
                child: CircleAvatar(
                  radius: 20,
                  backgroundColor: Color.fromARGB(255, 254, 254, 254), // Fondo claro para resaltar
                  child: Image.asset(
                    "images/logoGym.png", // Logo personalizado
                    width: 32,
                    height: 32,
                  ),
                ),
              ),
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Carrusel de bienvenida
                Stack(
                  children: [
                    CarouselSlider(
                      items: _carouselImages.map((imageUrl) {
                        return Builder(
                          builder: (BuildContext context) {
                            return Container(
                              width: double.infinity,
                              height: 200,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                image: DecorationImage(
                                  image: imageUrl.startsWith('http')
                                      ? NetworkImage(imageUrl)
                                      : AssetImage(imageUrl) as ImageProvider,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            );
                          },
                        );
                      }).toList(),
                      options: CarouselOptions(
                        height: 200,
                        autoPlay: true,
                        autoPlayInterval: Duration(seconds: 3),
                        enlargeCenterPage: true,
                        aspectRatio: 16 / 9,
                        onPageChanged: (index, reason) {
                          setState(() {
                            _currentCarouselIndex = index;
                          });
                        },
                      ),
                    ),
                    Positioned(
                      bottom: 16,
                      left: 16,
                      child: Container(
                        padding: EdgeInsets.all(8),
                        color: Colors.black54,
                        child: Text(
                          '¡Bienvenido Administrador!',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 8,
                      left: 0,
                      right: 0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: _carouselImages.map((url) {
                          int index = _carouselImages.indexOf(url);
                          return Container(
                            width: 8.0,
                            height: 8.0,
                            margin: EdgeInsets.symmetric(horizontal: 4.0),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: _currentCarouselIndex == index
                                  ? Colors.white
                                  : Colors.grey,
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),

                // Botones de funcionalidades
                Text(
                  'Opciones de gestión',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
                SizedBox(height: 10),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => NutritionTipsScreen_admin()),
                    );
                  },
                  icon: Icon(Icons.restaurant, color: Colors.black),
                  label: Text('Recetas'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFF8E1FF),
                    padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 5,
                  ),
                ),
                SizedBox(height: 10),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => UsersScreenAdmin()),
                    );
                  },
                  icon: Icon(Icons.people, color: Colors.black),
                  label: Text('Gestión de Usuarios'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFF8E1FF),
                    padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 5,
                  ),
                ),
                SizedBox(height: 10),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => EquipmentScreen()),
                    );
                  },
                  icon: Icon(Icons.bar_chart, color: Colors.black),
                  label: Text('Equipamiento GYM'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFF8E1FF),
                    padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 5,
                  ),
                ),
                _buildFunctionalCalendar(),
              ],
            ),
          ),
        ),
        bottomNavigationBar: CustomBottomNavbarAdmin(
          currentIndex: _selectedIndex,
          onTap: _onTap,
        ),
      ),
    );
  }

  // Widget para el calendario funcional
  Widget _buildFunctionalCalendar() {
    return TableCalendar(
      firstDay: DateTime.utc(1900, 1, 1),
      lastDay: DateTime.utc(2100, 12, 31),
      focusedDay: _focusedDay,
      calendarFormat: _calendarFormat,
      selectedDayPredicate: (day) {
        return isSameDay(_selectedDay, day);
      },
      onDaySelected: (selectedDay, focusedDay) {
        setState(() {
          _selectedDay = selectedDay;
          _focusedDay = focusedDay;
        });
      },
      onPageChanged: (focusedDay) {
        _focusedDay = focusedDay;
      },
      calendarStyle: CalendarStyle(
        selectedDecoration: BoxDecoration(
          color: Colors.purple,
          shape: BoxShape.circle,
        ),
        todayDecoration: BoxDecoration(
          color: Colors.blue,
          shape: BoxShape.circle,
        ),
        defaultTextStyle: TextStyle(color: Colors.white),
        weekendTextStyle: TextStyle(color: Colors.white),
      ),
      headerStyle: HeaderStyle(
        titleCentered: true,
        formatButtonVisible: false,
        titleTextStyle: TextStyle(color: Colors.white, fontSize: 18),
        leftChevronIcon: Icon(Icons.chevron_left, color: Colors.purple),
        rightChevronIcon: Icon(Icons.chevron_right, color: Colors.purple),
      ),
    );
  }
}