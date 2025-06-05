import 'package:cloud_firestore/cloud_firestore.dart'; // Importa la biblioteca de Firestore para interactuar con la base de datos
import 'package:shared_preferences/shared_preferences.dart'; // Importa la biblioteca para almacenar datos localmente

class IntelligentAgentService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance; // Instancia de Firestore para acceder a la base de datos
  String? _userId; // Variable para almacenar el ID del usuario, inicializada como nula

  IntelligentAgentService() {
    initialize(); // Constructor que inicia la inicialización del servicio
  }

  Future<void> initialize() async {
    // Método asincrónico para inicializar el servicio y obtener el ID del usuario
    SharedPreferences prefs = await SharedPreferences.getInstance(); // Obtiene la instancia de SharedPreferences para acceder a datos locales
    String? email = prefs.getString('user_email'); // Recupera el email del usuario almacenado localmente
    if (email != null) {
      // Verifica si el email existe
      final userDoc = await _firestore
          .collection('usuarios') // Accede a la colección 'usuarios' en Firestore
          .where('email', isEqualTo: email) // Filtra por el email del usuario
          .get(); // Ejecuta la consulta
      if (userDoc.docs.isNotEmpty) {
        // Verifica si se encontraron documentos
        _userId = userDoc.docs.first.id; // Asigna el ID del primer documento encontrado al usuario
      }
    }
  }

  String? get userId => _userId; // Getter para acceder al ID del usuario

  Future<Map<String, dynamic>> getRecommendations() async {
    // Método asincrónico que devuelve recomendaciones personalizadas para el usuario
    if (_userId == null) {
      // Verifica si el ID del usuario no está inicializado
      await initialize(); // Intenta inicializar nuevamente
      if (_userId == null) {
        // Si sigue sin inicializarse, retorna un mapa con un mensaje de error
        return {
          'message': 'No se pudo identificar al usuario.',
          'recommendedRoutines': [],
          'recommendedChallenges': [],
          'recipes': [],
          'youtubeVideo': null,
        };
      }
    }

    final userDoc = await _firestore.collection('usuarios').doc(_userId).get(); // Obtiene el documento del usuario por su ID
    final completedRoutines = userDoc.data()?['completedRoutines'] ?? {}; // Obtiene las rutinas completadas, o un mapa vacío si no existe
    final participatingChallenges = userDoc.data()?['participatingChallenges'] ?? []; // Obtiene los retos en los que participa, o una lista vacía
    final trainingDays = userDoc.data()?['trainingDays'] ?? []; // Obtiene los días de entrenamiento, o una lista vacía
    DateTime? lastActivity; // Variable para rastrear la última actividad
    for (String dateStr in completedRoutines.values) {
      // Itera sobre las fechas de las rutinas completadas
      DateTime date = DateTime.parse(dateStr); // Convierte la cadena de fecha a DateTime
      if (lastActivity == null || date.isAfter(lastActivity)) lastActivity = date; // Actualiza lastActivity si es más reciente
    }
    for (var challenge in participatingChallenges) {
      // Itera sobre los retos participados
      String? dateStr = challenge['joinDate']; // Obtiene la fecha de unión al reto
      if (dateStr != null) {
        DateTime date = DateTime.parse(dateStr); // Convierte la cadena de fecha a DateTime
        if (lastActivity == null || date.isAfter(lastActivity)) lastActivity = date; // Actualiza lastActivity si es más reciente
      }
    }

    final now = DateTime.now(); // Obtiene la fecha y hora actual
    int daysSinceLastActivity = lastActivity != null ? now.difference(lastActivity).inDays : 30; // Calcula días desde la última actividad
    String currentDay = now.weekday.toString(); // Obtiene el día actual como número (1-7)

    final routinesSnapshot = await _firestore
        .collection('Rutinas') // Accede a la colección 'Rutinas'
        .where('userId', isEqualTo: _userId) // Filtra por el ID del usuario
        .get(); // Ejecuta la consulta
    final challengesSnapshot = await _firestore.collection('Retos').get(); // Obtiene todos los documentos de la colección 'Retos'

    List<Map<String, dynamic>> recommendedRoutines = []; // Lista para almacenar rutinas recomendadas
    List<Map<String, dynamic>> recommendedChallenges = []; // Lista para almacenar retos recomendados
    String? youtubeVideo = null; // Variable para almacenar un enlace de YouTube sugerido

    if (daysSinceLastActivity >= 2) {
      // Si han pasado 2 o más días sin actividad
      recommendedRoutines = routinesSnapshot.docs
          .where((doc) => !completedRoutines.containsKey(doc.id)) // Filtra rutinas no completadas
          .where((doc) => trainingDays.contains(getDayName(now.weekday))) // Filtra por días de entrenamiento
          .map((doc) => {...doc.data() as Map<String, dynamic>, 'id': doc.id}) // Convierte documentos a mapas con ID
          .toList();
      if (recommendedRoutines.isEmpty && completedRoutines.length == routinesSnapshot.docs.length) {
        // Si no hay rutinas disponibles y todas están completadas
        youtubeVideo = 'https://www.youtube.com/watch?v=example_routine'; // Sugiere un video de rutina
      }
    }

    recommendedChallenges = challengesSnapshot.docs
        .where((doc) => !participatingChallenges.any((c) => c['challengeId'] == doc.id)) // Filtra retos no participados
        .map((doc) => {...doc.data() as Map<String, dynamic>, 'id': doc.id}) // Convierte documentos a mapas con ID
        .toList();
    if (recommendedChallenges.isEmpty && participatingChallenges.isNotEmpty) {
      // Si no hay retos disponibles y hay retos participados
      String lastChallengeId = participatingChallenges.last['challengeId']; // Obtiene el ID del último reto
      youtubeVideo = 'https://www.youtube.com/watch?v=example_challenge_$lastChallengeId'; // Sugiere un video relacionado
    }

    return {
      'message': daysSinceLastActivity >= 2 ? '¡Han pasado $daysSinceLastActivity días! Te sugiero algo.' : '¡Buen trabajo! Aquí tienes opciones.',
      'recommendedRoutines': recommendedRoutines,
      'recommendedChallenges': recommendedChallenges,
      'youtubeVideo': youtubeVideo,
    }; // Devuelve un mapa con las recomendaciones
  }

  String getDayName(int weekday) {
    // Método para convertir el número del día (1-7) a su nombre en inglés
    const days = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
    return days[weekday - 1]; // Resta 1 porque weekday empieza en 1 (lunes)
  }
}