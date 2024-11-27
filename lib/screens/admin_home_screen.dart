import 'package:flutter/material.dart';
import 'package:gym_fitgo/screens/rect_admin.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:gym_fitgo/widgets/custom_bottom_navbar_admin.dart';
import 'package:gym_fitgo/screens/login_screen.dart';
import 'package:gym_fitgo/screens/users_screen_admin.dart';
import 'package:gym_fitgo/screens/statistics_screen.dart'; // Pantalla de estadísticas

class AdminHomeScreen extends StatefulWidget {
  @override
  _AdminHomeScreenState createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends State<AdminHomeScreen> {
  int _selectedIndex = 0;
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  void _onNavBarTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0a0322),
      appBar: AppBar(
        backgroundColor: Color(0xFFF5EDE4),
        elevation: 0,
        automaticallyImplyLeading: false,
        title: TextField(
          decoration: InputDecoration(
            hintText: "Search here ...",
            border: InputBorder.none,
            prefixIcon: Icon(Icons.search),
          ),
        ),
        actions: [
          GestureDetector(
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => LoginScreen()),
              );
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset(
                "images/mancuerna.png",
                width: 32,
                height: 32,
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
              // Imagen de bienvenida
              Stack(
                children: [
                  Container(
                    width: double.infinity,
                    height: 200,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      image: DecorationImage(
                        image: AssetImage('images/adminWelcome.jpeg'), // Imagen personalizada
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 16,
                    left: 16,
                    child: Text(
                      '¡Bienvenido Administrador!',
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

              // Botones de funcionalidades
              Text(
                'Opciones de gestión',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
              SizedBox(height: 10),
              _buildCategoryButton('Recetas', Colors.white, () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => NutritionTipsScreen_admin()),
                );
              }),
              SizedBox(height: 10),
              _buildCategoryButton('Gestión de Usuarios', Colors.white, () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => UsersScreenAdmin()),
                );
              }),
              SizedBox(height: 10),
              _buildCategoryButton('Estadísticas', Colors.white, () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => StatisticsScreen()),
                );
              }),
              _buildFunctionalCalendar(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomNavbarAdmin(
        currentIndex: _selectedIndex,
        onTap: _onNavBarTapped,
      ),
    );
  }

  // Widget para botones de opciones
  Widget _buildCategoryButton(String text, Color color, VoidCallback onPressed) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(text, style: TextStyle(color: Colors.black)),
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
