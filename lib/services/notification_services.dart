import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> initNotifications() async {
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('app_icon');

  const InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
  );

  await flutterLocalNotificationsPlugin.initialize(initializationSettings);
}

Future<void> solicitarPermisoNotificaciones() async {
  // Verifica si el permiso ya ha sido otorgado
  if (await Permission.notification.isGranted) {
    print('Permiso de notificaciones ya otorgado');
    return;
  }

  // Solicita el permiso si no ha sido otorgado
  var status = await Permission.notification.request();
  if (status.isGranted) {
    print('Permiso de notificaciones otorgado');
  } else if (status.isDenied) {
    print('Permiso de notificaciones denegado');
  } else if (status.isPermanentlyDenied) {
    print('Permiso de notificaciones denegado permanentemente');
    // Puedes redirigir al usuario a la configuración de la app para otorgar permisos manualmente
    openAppSettings();
  }
}

Future<void> mostrarNotificacion() async {
  // Solicitar permisos antes de mostrar la notificación
  await solicitarPermisoNotificaciones();

  const AndroidNotificationDetails androidNotificationDetails = 
      AndroidNotificationDetails(
    'your_channel_id', // ID del canal
    'Your Channel Name', // Nombre del canal
    channelDescription: 'Descripción de la notificación', // Descripción del canal
    importance: Importance.high,
    priority: Priority.high, // Importante para la visibilidad
    showWhen: false, // No mostrar el tiempo
  );

  const NotificationDetails notificationDetails = NotificationDetails(
    android: androidNotificationDetails,
  );

  // Crear el canal solo una vez
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(
    const AndroidNotificationChannel(
      'your_channel_id', // ID
      'Your Channel Name', // Nombre visible
      description: 'Descripción de la notificación', // Descripción visible
      importance: Importance.high,
    ),
  );

  await flutterLocalNotificationsPlugin.show(
    1, // ID de la notificación
    'Título de notificación',
    'Esta es una notificación de prueba para nuestra app de gym',
    notificationDetails,
  );
}
