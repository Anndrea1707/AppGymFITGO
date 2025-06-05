import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:gym_fitgo/widgets/custom_bottom_navbar.dart';
import 'package:gym_fitgo/services/notification_services.dart';
import 'package:gym_fitgo/screens/challenges_screen.dart';
import 'package:gym_fitgo/screens/progress_screen.dart';
import 'package:gym_fitgo/screens/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gym_fitgo/services/intelligent_agent_service.dart';
import 'package:gym_fitgo/screens/exercise_description_screen.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:math';
import 'package:gym_fitgo/screens/nutrition_Tips_Screen_client.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  int _selectedIndex = 0;
  String? userName;
  bool _isLoading = true;
  String? _errorMessage;
  final IntelligentAgentService _agentService = IntelligentAgentService();
  Map<String, dynamic>? _recommendations;
  bool _isLoadingRecommendations = true;
  final List<Map<String, dynamic>> _chatMessages = [];
  bool _isChatVisible = false;
  List<String> _currentOptions = [];
  final List<Map<String, String>> _youtubeVideos = [
    {
      'url': 'https://youtu.be/RpFo8NSNqp4',
      'title': 'Rutina para quemar grasa de todo el cuerpo | 30 minutos'
    },
    {
      'url': 'https://youtu.be/0PumJ_Z0MuQ',
      'title': 'RUTINA DE EJERCICIO 20 MINUTOS PARA TONIFICAR TODO EL CUERPO'
    },
    {
      'url': 'https://youtu.be/Mfw3rchYkiM',
      'title': 'TOTAL BODY | Ejercicios para todo el cuerpo'
    },
    {
      'url': 'https://youtu.be/mH_U0KVdSxg',
      'title': '3 cenas fáciles y saludables'
    },
    {
      'url': 'https://youtu.be/WIamWZDpdxw',
      'title': 'Recetas y desayunos ricos y saludables'
    },
    {
      'url': 'https://youtu.be/bgZcOVkEYlM',
      'title': '5 Cenas Altas en Proteína en 5 MIN'
    },
    {
      'url': 'https://youtu.be/Q2TTLUxlNu4',
      'title': 'Reto 100 sentadillas | Piernas y glúteos tonificados'
    },
    {
      'url': 'https://youtu.be/rsgaaXo7htM',
      'title': 'ADELGAZAR RAPIDO EN CASA'
    },
    {
      'url': 'https://youtu.be/KtZsQrYAJ0Y',
      'title': 'RETO 300 SENTADILLAS | Glúteos firmes y piernas definidas'
    },
  ];

  // Mapa para almacenar las fechas de rutinas completadas
  Map<DateTime, List<String>> _completedRoutinesMap = {};

  @override
  void initState() {
    super.initState();
    _fetchUserData();
    solicitarPermisoNotificaciones();
    Future.delayed(Duration(seconds: 10), mostrarNotificacion);
    _loadRecommendations();
    _loadCompletedRoutines(); // Cargar las fechas de rutinas completadas
  }

  Future<void> _fetchUserData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? userEmail = prefs.getString('user_email');

      if (userEmail == null) {
        setState(() {
          _errorMessage =
              'No se encontró el usuario. Por favor, inicia sesión nuevamente.';
          _isLoading = false;
        });
        return;
      }

      final userDoc = await FirebaseFirestore.instance
          .collection('usuarios')
          .where('email', isEqualTo: userEmail)
          .get();

      if (userDoc.docs.isNotEmpty) {
        final userData = userDoc.docs.first.data();
        setState(() {
          userName = userData['name']?.toString() ?? 'Usuario';
          _isLoading = false;
        });
      } else {
        setState(() {
          _errorMessage = 'Usuario no encontrado en la base de datos.';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Error al cargar los datos: $e';
        _isLoading = false;
      });
    }
  }

  // Cargar las fechas de rutinas completadas desde Firestore
  Future<void> _loadCompletedRoutines() async {
    try {
      final userDoc = await FirebaseFirestore.instance
          .collection('usuarios')
          .doc(_agentService.userId)
          .get();

      if (userDoc.exists) {
        final completedRoutines = userDoc.data()?['completedRoutines'] ?? {};
        _completedRoutinesMap.clear();
        completedRoutines.forEach((routineId, dateString) {
          if (dateString is String) {
            try {
              final dateTime = DateTime.parse(dateString).toLocal();
              final normalizedDate =
                  DateTime(dateTime.year, dateTime.month, dateTime.day);
              _completedRoutinesMap[normalizedDate] = [routineId];
            } catch (e) {
              print(
                  'Error parsing date for routine $routineId: $dateString, error: $e');
            }
          }
        });
        print('Completed Routines Map: $_completedRoutinesMap'); // Depuración
        setState(() {}); // Forzar actualización del calendario
      } else {
        print('No user document found for userId: ${_agentService.userId}');
      }
    } catch (e) {
      print('Error loading completed routines: $e');
    }
  }

  Future<void> _loadRecommendations() async {
    if (!mounted)
      return; // Verifica si el widget está montado antes de continuar
    setState(() {
      _isLoadingRecommendations = true;
    });
    await _agentService.initialize();
    final recommendations = await _agentService.getRecommendations();
    if (mounted) {
      // Verifica nuevamente antes de actualizar el estado
      setState(() {
        _recommendations = recommendations;
        _isLoadingRecommendations = false;
        if (_isChatVisible && _chatMessages.isEmpty && userName != null) {
          _startChat();
        }
      });
    }
  }

  void _startChat() {
    if (_isLoadingRecommendations) {
      _addTonyMessage({
        'text': 'Espera un momento, estoy buscando algo especial para ti...'
      });
      return;
    }
    _addTonyMessage({
      'text':
          '¡Hola, $userName! Soy Tony, tu asistente fitness. ¿Qué te gustaría hoy?'
    });
    _updateOptions([
      'Quiero una rutina',
      'Prefiero un reto',
      'Dame una receta',
      'Sugerirme algo'
    ]);
  }

  void _toggleChat() {
    setState(() {
      _isChatVisible = !_isChatVisible;
      if (_isChatVisible && _chatMessages.isEmpty && userName != null) {
        _startChat();
      }
    });
  }

  void _addTonyMessage(Map<String, dynamic> message) {
    setState(() {
      _chatMessages.add({'sender': 'Tony', ...message});
    });
  }

  void _addUserMessage(String message) {
    setState(() {
      _chatMessages.add({'sender': 'Tú', 'text': message});
    });
    _processUserChoice(message);
  }

  void _updateOptions(List<String> options) {
    setState(() {
      _currentOptions = options;
    });
  }

  Future<void> _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      _addTonyMessage({
        'text':
            'Error al abrir el enlace. Verifica tu conexión o permisos: $url'
      });
    }
  }

  void _processUserChoice(String choice) async {
    if (_isLoadingRecommendations) {
      _addTonyMessage({
        'text': 'Espera un momento, estoy buscando algo especial para ti...'
      });
      return;
    }

    final now = DateTime.now();
    final currentDay = _getDayName(now.weekday);
    final userDoc = await FirebaseFirestore.instance
        .collection('usuarios')
        .doc(_agentService.userId)
        .get();
    final completedRoutines = userDoc.data()?['completedRoutines'] ?? {};
    final participatingChallenges =
        userDoc.data()?['participatingChallenges'] ?? [];
    final trainingDays = userDoc.data()?['trainingDays'] ?? [];

    if (choice == 'Quiero una rutina') {
      final routinesSnapshot = await FirebaseFirestore.instance
          .collection('Rutinas')
          .where('userId', isEqualTo: _agentService.userId)
          .get();
      List<Map<String, dynamic>> availableRoutines = routinesSnapshot.docs
          .where((doc) => !completedRoutines.containsKey(doc.id))
          .where((doc) {
            final day =
                _translateDayToEnglish(doc.data()['name'] as String? ?? '');
            return day == currentDay || trainingDays.contains(currentDay);
          })
          .map((doc) => {
                ...doc.data(),
                'id': doc.id,
              })
          .toList();
      if (availableRoutines.isNotEmpty) {
        final routine = availableRoutines[0];
        _addTonyMessage({
          'text': 'Te sugiero "${routine['name']}" para hoy ($currentDay). '
              'Descripción: ${routine['description'] ?? 'Sin descripción'}. '
              'Ejercicios: ${routine['exercises']?.length ?? 0}, '
              'Equipo: ${routine['equipmentIds']?.join(', ') ?? 'Ninguno'}. ¿Te animas?',
          'imageUrl': routine['image'] ?? '',
        });
        _updateOptions(['Sí, quiero hacerla', 'No, prefiero otra cosa']);
      } else {
        final randomVideo =
            _youtubeVideos[Random().nextInt(_youtubeVideos.length)];
        _addTonyMessage({
          'text':
              'No hay rutinas nuevas para hoy ($currentDay). ¿Qué tal este video de fitness?',
          'link': randomVideo['url'],
          'linkText': randomVideo['title'],
        });
        _updateOptions([
          'Ver el video',
          'Prefiero un reto',
          'Dame una receta',
          'Sugerirme algo'
        ]);
      }
    } else if (choice == 'Prefiero un reto') {
      final challengesSnapshot =
          await FirebaseFirestore.instance.collection('Retos').get();
      List<Map<String, dynamic>> availableChallenges = challengesSnapshot.docs
          .where((doc) =>
              !participatingChallenges.any((c) => c['challengeId'] == doc.id))
          .map((doc) => {
                ...doc.data(),
                'id': doc.id,
              })
          .toList();
      if (availableChallenges.isNotEmpty) {
        final challenge = availableChallenges[0];
        _addTonyMessage({
          'text': 'Te propongo "${challenge['name']}". '
              'Descripción: ${challenge['description'] ?? 'Sin descripción'}. '
              'Participantes: ${challenge['participants'] ?? 0}, '
              'Duración: ${challenge['duration'] ?? 'Sin especificar'}. ¿Te unes?',
          'imageUrl': challenge['imageUrl'] ?? '',
        });
        _updateOptions(['Sí, me uno', 'No, prefiero otra cosa']);
      } else {
        final randomVideo =
            _youtubeVideos[Random().nextInt(_youtubeVideos.length)];
        _addTonyMessage({
          'text':
              'Ya estás en todos los retos. ¿Qué tal este video de fitness?',
          'link': randomVideo['url'],
          'linkText': randomVideo['title'],
        });
        _updateOptions([
          'Ver el video',
          'Quiero una rutina',
          'Dame una receta',
          'Sugerirme algo'
        ]);
      }
    } else if (choice == 'Dame una receta') {
      final recipesSnapshot =
          await FirebaseFirestore.instance.collection('recetas').get();
      if (recipesSnapshot.docs.isNotEmpty) {
        final randomIndex = Random().nextInt(recipesSnapshot.docs.length);
        final recipe = recipesSnapshot.docs[randomIndex].data();
        _addTonyMessage({
          'text': 'Te sugiero "${recipe['nombre'] ?? 'Receta sin nombre'}". '
              'Descripción: ${recipe['descripcion'] ?? 'Sin descripción'}. '
              'Proteína: ${recipe['proteina'] ?? 'Sin especificar'}g, '
              'Rating: ${recipe['rating'] ?? 'Sin rating'}. ¿Te interesa?',
          'imageUrl': recipe['imagenUrl1'] ?? '',
        });
        _updateOptions(['Sí, quiero probarla', 'No, prefiero otra cosa']);
      } else {
        final randomVideo =
            _youtubeVideos[Random().nextInt(_youtubeVideos.length)];
        _addTonyMessage({
          'text':
              'No tengo recetas ahora. ¿Qué tal este video de cocina saludable?',
          'link': randomVideo['url'],
          'linkText': randomVideo['title'],
        });
        _updateOptions([
          'Ver el video',
          'Quiero una rutina',
          'Prefiero un reto',
          'Sugerirme algo'
        ]);
      }
    } else if (choice == 'Sugerirme algo') {
      final randomVideo =
          _youtubeVideos[Random().nextInt(_youtubeVideos.length)];
      _addTonyMessage({
        'text': 'Te sugiero este video variado:',
        'link': randomVideo['url'],
        'linkText': randomVideo['title'],
      });
      _updateOptions([
        'Ver el video',
        'Quiero una rutina',
        'Prefiero un reto',
        'Dame una receta'
      ]);
    } else if (choice == 'Sí, quiero hacerla') {
      final routine = _recommendations!['recommendedRoutines'][0];
      final routineId = routine['id'] as String?;
      if (routineId != null) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ExerciseDescriptionScreen(
              day: routine['name']?.toString() ?? 'Día no especificado',
              description: routine['description']?.toString() ??
                  'Descripción no disponible',
              exercises: (routine['exercises'] as List<dynamic>?)
                      ?.cast<Map<String, dynamic>>() ??
                  [],
              equipmentIds:
                  (routine['equipmentIds'] as List<dynamic>?)?.cast<String>() ??
                      [],
              image: routine['image']?.toString(),
              routineId: routineId,
              userId: _agentService.userId,
            ),
          ),
        );
      }
      _addTonyMessage({'text': '¡Perfecto! Disfruta tu rutina.'});
      _updateOptions([
        'Quiero una rutina',
        'Prefiero un reto',
        'Dame una receta',
        'Sugerirme algo'
      ]);
    } else if (choice == 'Sí, me uno') {
      _addTonyMessage(
          {'text': '¡Genial! Te has unido al reto. ¿Qué más quieres hacer?'});
      _updateOptions([
        'Quiero una rutina',
        'Prefiero un reto',
        'Dame una receta',
        'Sugerirme algo'
      ]);
    } else if (choice == 'Sí, quiero probarla') {
      _addTonyMessage({'text': '¡Que la disfrutes! ¿Qué más quieres hacer?'});
      _updateOptions([
        'Quiero una rutina',
        'Prefiero un reto',
        'Dame una receta',
        'Sugerirme algo'
      ]);
    } else if (choice == 'Ver el video') {
      _addTonyMessage({'text': '¡Que lo disfrutes! ¿Qué más quieres hacer?'});
      _updateOptions([
        'Quiero una rutina',
        'Prefiero un reto',
        'Dame una receta',
        'Sugerirme algo'
      ]);
    } else if (choice == 'No, prefiero otra cosa') {
      _addTonyMessage({'text': 'Entendido, ¿qué te gustaría hacer en cambio?'});
      _updateOptions([
        'Quiero una rutina',
        'Prefiero un reto',
        'Dame una receta',
        'Sugerirme algo'
      ]);
    }
  }

  String _getDayName(int weekday) {
    const days = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday'
    ];
    return days[weekday - 1];
  }

  String _translateDayToEnglish(String dayInSpanish) {
    switch (dayInSpanish.toLowerCase()) {
      case 'lunes':
        return 'Monday';
      case 'martes':
        return 'Tuesday';
      case 'miércoles':
      case 'miercoles':
        return 'Wednesday';
      case 'jueves':
        return 'Thursday';
      case 'viernes':
        return 'Friday';
      case 'sábado':
      case 'sabado':
        return 'Saturday';
      case 'domingo':
        return 'Sunday';
      default:
        return dayInSpanish;
    }
  }

  void _onNavBarTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF2b192e),
      appBar: AppBar(
        backgroundColor: Color(0xFFf8e1ff),
        elevation: 0,
        automaticallyImplyLeading: false,
        title: _isLoading
            ? Text(
                'Cargando...',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              )
            : _errorMessage != null
                ? Text(
                    'Error',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  )
                : Text(
                    'Bienvenido, $userName',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
        actions: [
          GestureDetector(
            onTap: () async {
              final prefs = await SharedPreferences.getInstance();
              await prefs.remove('user_email');
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => LoginScreen()),
              );
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset(
                "images/logoGym.png",
                width: 32,
                height: 32,
              ),
            ),
          ),
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _errorMessage != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _errorMessage!,
                        style: TextStyle(color: Colors.white, fontSize: 16),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () async {
                          final prefs = await SharedPreferences.getInstance();
                          await prefs.remove('user_email');
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LoginScreen()),
                          );
                        },
                        child: Text('Volver a iniciar sesión'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF7a0180),
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ],
                  ),
                )
              : Stack(
                  children: [
                    SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: [
                                  _buildCategoryButton('Consejos alimenticios',
                                      Color(0xFF7a0180), () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              NutritionTipsScreen_client()),
                                    );
                                  }),
                                  SizedBox(width: 10),
                                  _buildCategoryButton(
                                      'Retos', Color(0xFF7a0180), () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              ChallengesScreen()),
                                    );
                                  }),
                                ],
                              ),
                            ),
                            SizedBox(height: 20),
                            Stack(
                              children: [
                                Container(
                                  width: double.infinity,
                                  height: 200,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(16),
                                    image: const DecorationImage(
                                      image: AssetImage('images/Tony.png'),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                Positioned(
                                  bottom: 16,
                                  left: 16,
                                  right: 16,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: Colors.black.withOpacity(0.5),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      'Conoce a Tony, tu asistente fitness',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      softWrap: true,
                                      overflow: TextOverflow.visible,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 20),
                            Text(
                              'Programa de entrenamiento',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 18),
                            ),
                            SizedBox(height: 10),
                            _buildFunctionalCalendar(),
                          ],
                        ),
                      ),
                    ),
                    if (_isChatVisible)
                      Positioned(
                        left: 16,
                        right: 16,
                        bottom: 16,
                        child: Container(
                          height: 400,
                          decoration: BoxDecoration(
                            color: Color(0xFFf8e1ff),
                            borderRadius: BorderRadius.circular(15.0),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black26,
                                blurRadius: 10,
                                offset: Offset(0, 5),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Chateando con Tony',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF2b192e),
                                      ),
                                    ),
                                    IconButton(
                                      icon: Icon(Icons.close,
                                          color: Color(0xFF7a0180)),
                                      onPressed: _toggleChat,
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: ListView.builder(
                                  padding: EdgeInsets.all(8.0),
                                  itemCount: _chatMessages.length,
                                  itemBuilder: (context, index) {
                                    final message = _chatMessages[index];
                                    return Align(
                                      alignment: message['sender'] == 'Tony'
                                          ? Alignment.centerLeft
                                          : Alignment.centerRight,
                                      child: Container(
                                        margin:
                                            EdgeInsets.symmetric(vertical: 4.0),
                                        padding: EdgeInsets.all(8.0),
                                        decoration: BoxDecoration(
                                          color: message['sender'] == 'Tony'
                                              ? Color(0xFF7a0180)
                                              : Color(0xFF2b192e),
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              message['text']!,
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                            if (message['imageUrl']
                                                    ?.isNotEmpty ??
                                                false)
                                              Padding(
                                                padding:
                                                    EdgeInsets.only(top: 8.0),
                                                child: Image.network(
                                                  message['imageUrl']!,
                                                  width: 100,
                                                  height: 100,
                                                  fit: BoxFit.cover,
                                                  errorBuilder: (context, error,
                                                      stackTrace) {
                                                    return Text(
                                                      'Imagen no disponible',
                                                      style: TextStyle(
                                                          color: Colors.white),
                                                    );
                                                  },
                                                ),
                                              ),
                                            if (message['link'] != null)
                                              GestureDetector(
                                                onTap: () =>
                                                    _launchUrl(message['link']),
                                                child: Row(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    Icon(
                                                        Icons
                                                            .play_circle_filled,
                                                        color: Colors.red,
                                                        size: 16),
                                                    SizedBox(width: 4),
                                                    Flexible(
                                                      child: Text(
                                                        message['linkText'] ??
                                                            'Toca aquí para ver el video',
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                          decoration:
                                                              TextDecoration
                                                                  .underline,
                                                        ),
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Wrap(
                                  spacing: 8.0,
                                  runSpacing: 8.0,
                                  children: _currentOptions.map((option) {
                                    return ElevatedButton(
                                      onPressed: () {
                                        _addUserMessage(option);
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Color(0xFF7a0180),
                                        foregroundColor: Colors.white,
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 5),
                                      ),
                                      child: Text(option),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    Positioned(
                      top: 16,
                      right: 16,
                      child: FloatingActionButton(
                        onPressed: _toggleChat,
                        backgroundColor: Color(0xFFf8e1ff),
                        child: Icon(
                            _isChatVisible ? Icons.chat_bubble : Icons.chat,
                            size: 26),
                      ),
                    ),
                  ],
                ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _selectedIndex,
        onTap: _onNavBarTapped,
      ),
    );
  }

  Widget _buildCategoryButton(String text, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(text, style: TextStyle(color: Colors.white)),
      ),
    );
  }

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
        setState(() {
          _focusedDay = focusedDay;
        });
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
        markerDecoration: BoxDecoration(
          color: Colors.green,
          shape: BoxShape.circle,
        ),
      ),
      headerStyle: HeaderStyle(
        titleCentered: true,
        formatButtonVisible: false,
        titleTextStyle: TextStyle(color: Colors.white, fontSize: 18),
        leftChevronIcon: Icon(Icons.chevron_left, color: Colors.purple),
        rightChevronIcon: Icon(Icons.chevron_right, color: Colors.purple),
      ),
      calendarBuilders: CalendarBuilders(
        markerBuilder: (context, date, events) {
          final normalizedDate = DateTime(date.year, date.month, date.day);
          if (_completedRoutinesMap.containsKey(normalizedDate)) {
            return Positioned(
              bottom: 4,
              child: Container(
                width: 10, // Tamaño más grande para mayor visibilidad
                height: 10,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.greenAccent, // Color más brillante
                ),
              ),
            );
          }
          return null;
        },
      ),
    );
  }
}
