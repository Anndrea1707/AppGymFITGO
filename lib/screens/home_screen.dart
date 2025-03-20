import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:gym_fitgo/widgets/custom_bottom_navbar.dart'; // Importa el archivo de la barra de navegación
import 'package:gym_fitgo/services/notification_services.dart'; // Importa el servicio de notificación
import 'package:gym_fitgo/screens/challenges_screen.dart';
import 'package:gym_fitgo/screens/nutrition_tips_screen.dart';
import 'package:gym_fitgo/screens/progress_screen.dart';
import 'package:gym_fitgo/screens/login_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}


class _HomeScreenState extends State<HomeScreen> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState(); // Asegúrate de que esto esté aquí
    solicitarPermisoNotificaciones(); // Llama a la función de permiso
    Future.delayed(Duration(seconds: 10)); // Retraso de 10 segundos
    mostrarNotificacion();
  }

  void _onNavBarTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0a0322), // Color de fondo personalizado
      appBar: AppBar(
        backgroundColor: Color(0xFFF5EDE4), // Color beige del AppBar
        elevation: 0,
        automaticallyImplyLeading: false, // Elimina la flecha de retroceso
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
              // Lógica para cerrar sesión
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => LoginScreen()),
              );
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0), // Espaciado para la imagen
              child: Image.asset(
                "images/mancuerna.png", // Ruta de la imagen
                width: 32, // Ajusta el tamaño según sea necesario
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
              // Botones de categorías
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildCategoryButton('Consejos alimenticios', Colors.white,
                        () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => NutritionTipsScreen()),
                      );
                    }),
                    SizedBox(width: 10),
                    _buildCategoryButton('Progresos', Colors.white, () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ProgressScreen()),
                      );
                    }),
                    SizedBox(width: 10),
                    _buildCategoryButton('Retos', Colors.white, () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ChallengesScreen()),
                      );
                    }),
                  ],
                ),
              ),
              SizedBox(height: 20),

              // Imagen de las instalaciones
              Stack(
                children: [
                  Container(
                    width: double.infinity,
                    height: 200,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      image: DecorationImage(
                        image: AssetImage('images/gym_install.jpg'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 16,
                    left: 16,
                    child: Text(
                      'Conoce nuestras instalaciones',
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

              // Información del siguiente entrenamiento
              Text(
                'Siguiente entrenamiento',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
              SizedBox(height: 10),
              _buildTrainingInfo('Día 4', 'Piernas', 100, true),
              SizedBox(height: 10),
              _buildTrainingInfo('Día 5', 'Músculos escapula', 50, false),

              SizedBox(height: 20),
              Text(
                'Programa de entrenamiento',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
              SizedBox(height: 10),

              // Calendario funcional
              _buildFunctionalCalendar(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _selectedIndex,
        onTap: _onNavBarTapped,
      ),
    );
  }

  // Widget para los botones de categorías
  Widget _buildCategoryButton(
      String text, Color color, VoidCallback onPressed) {
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

  // Widget para la información de los entrenamientos
  Widget _buildTrainingInfo(
      String day, String muscle, int progress, bool completed) {
    return Row(
      children: [
        CircleAvatar(
          radius: 16,
          backgroundColor: Colors.purple,
          child: Text('$progress%',
              style: TextStyle(color: Colors.white, fontSize: 12)),
        ),
        SizedBox(width: 10),
        Expanded(
          child: Text('$day - $muscle', style: TextStyle(color: Colors.white)),
        ),
        if (completed) Icon(Icons.check_circle, color: Colors.green),
      ],
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
//Me funciona la conexion by:ashly