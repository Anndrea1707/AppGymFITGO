import 'package:flutter/material.dart';
import 'package:gym_fitgo/screens/beginner_routine_screen.dart';
import 'package:gym_fitgo/services/notification_services.dart';

class GymSurveyScreen extends StatefulWidget {
  @override
  _GymSurveyScreenState createState() => _GymSurveyScreenState();
}
// Función para programar la notificación automática
void _scheduleNotification() async {
  await Future.delayed(Duration(seconds: 10)); // Retraso de 10 segundos
  await mostrarNotificacion(); // Llama a la función para mostrar la notificación
}

class _GymSurveyScreenState extends State<GymSurveyScreen> {
  double _weight = 70; // Peso inicial
  String? _gender;
  String? _limitation;
  String? _goal;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0a0322), // Color de fondo personalizado
      appBar: AppBar(
        backgroundColor: const Color(0xFFF5EDE4),
        leading: Icon(Icons.arrow_back, color: Colors.black),
        title: Text('Registra tus Datos'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          margin: EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 5,
                blurRadius: 7,
                offset: Offset(0, 3),
              ),
            ],
          ),
          padding: EdgeInsets.all(16),
          child: ListView(
            children: [
              Text('¿Cuál es tu edad?', style: TextStyle(fontSize: 18)),
              SizedBox(height: 10),
              DropdownButtonFormField<int>(
                items: List.generate(100, (index) => index + 18).map((int value) {
                  return DropdownMenuItem<int>(
                    value: value,
                    child: Text('$value años'),
                  );
                }).toList(),
                onChanged: (newValue) {},
                decoration: InputDecoration(
                  filled: true,
                  fillColor: const Color.fromARGB(255, 218, 214, 214),
                  contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
              SizedBox(height: 20),
              Text('Registra tu peso:', style: TextStyle(fontSize: 18)),
              Slider(
                value: _weight,
                min: 40,
                max: 150,
                divisions: 110,
                label: '${_weight.round()} Kg',
                onChanged: (double value) {
                  setState(() {
                    _weight = value;
                  });
                },
              ),
              SizedBox(height: 20),
              Text('¿Cuánto mides?', style: TextStyle(fontSize: 18)),
              DropdownButtonFormField<double>(
                items: List.generate(61, (index) => 1.20 + index * 0.01).map((double value) {
                  return DropdownMenuItem<double>(
                    value: value,
                    child: Text('${value.toStringAsFixed(2)} m'),
                  );
                }).toList(),
                onChanged: (newValue) {},
                decoration: InputDecoration(
                  filled: true,
                  fillColor: const Color.fromARGB(255, 218, 214, 214),
                  contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
              SizedBox(height: 20),
              Text('Género:', style: TextStyle(fontSize: 18)),
              DropdownButtonFormField<String>(
                items: ['Masculino', 'Femenino', 'Otro'].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    _gender = newValue;
                  });
                },
                decoration: InputDecoration(
                  filled: true,
                  fillColor: const Color.fromARGB(255, 218, 214, 214),
                  contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
              SizedBox(height: 20),
              Text('¿Tienes alguna limitación física?', style: TextStyle(fontSize: 18)),
              DropdownButtonFormField<String>(
                items: ['Sí', 'No'].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    _limitation = newValue;
                  });
                },
                decoration: InputDecoration(
                  filled: true,
                  fillColor: const Color.fromARGB(255, 218, 214, 214),
                  contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
              SizedBox(height: 20),
              Text('¿Qué quieres lograr?', style: TextStyle(fontSize: 18)),
              DropdownButtonFormField<String>(
                items: ['Bajar de peso', 'Ganar masa muscular', 'Mantenerme saludable'].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    _goal = newValue;
                  });
                },
                decoration: InputDecoration(
                  filled: true,
                  fillColor: const Color.fromARGB(255, 218, 214, 214),
                  contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
              SizedBox(height: 30),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Colors.purpleAccent,
                ),
                onPressed: () {
                  // Navegar a la pantalla de éxito
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => BeginnerRoutineScreen()),
                  );
                },
                child: Text('Guardar', style: TextStyle(fontSize: 18, color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Nueva pantalla para mostrar un mensaje de éxito
class SuccessScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 210, 185, 253),
        title: Text('Éxito'),
        centerTitle: true,
      ),
      body: Center(
        child: Text(
          '¡Tus datos han sido guardados con éxito!',
          style: TextStyle(fontSize: 24, color: Colors.black),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
