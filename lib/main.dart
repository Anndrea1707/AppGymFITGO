import 'package:flutter/material.dart';
import 'package:gym_fitgo/screens/SplashScreen.dart';
import 'services/notification_services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // Configura Crashlytics para capturar errores de Flutter
  FlutterError.onError = (FlutterErrorDetails details) {
    FirebaseCrashlytics.instance.recordFlutterError(details);
  };

  // Captura errores asíncronos
  PlatformDispatcher.instance.onError = (Object error, StackTrace stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };

  await initNotifications(); // Inicializa las notificaciones
  runApp(MyGymApp());
}

class MyGymApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SplashScreen(),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // Definir el tema global para BottomNavigationBar
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: Color(0xFFF8E1FF), // Fondo claro de referencia
          selectedItemColor: Colors.purple, // Color morado para ítems seleccionados
          unselectedItemColor: Colors.black, // Color negro para ítems no seleccionados
        ),
      ),
    );
  }
}