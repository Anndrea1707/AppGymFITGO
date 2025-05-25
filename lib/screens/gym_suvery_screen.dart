import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GymSurveyScreen extends StatefulWidget {
  final String userEmail;

  const GymSurveyScreen({required this.userEmail, Key? key}) : super(key: key);

  @override
  _GymSurveyScreenState createState() => _GymSurveyScreenState();
}

class _GymSurveyScreenState extends State<GymSurveyScreen> {
  double _weight = 70;
  double? _height;
  int? _age;
  String? _gender;
  String? _limitation;
  String? _goal;

  @override
  void initState() {
    super.initState();
    _loadExistingData();
  }

  Future<void> _loadExistingData() async {
    try {
      QuerySnapshot userDoc = await FirebaseFirestore.instance
          .collection('usuarios')
          .where('email', isEqualTo: widget.userEmail)
          .get();

      if (userDoc.docs.isNotEmpty) {
        var data = userDoc.docs.first.data() as Map<String, dynamic>;
        setState(() {
          _age = data['age'] != null ? int.tryParse(data['age'].toString()) ?? 0 : null;
          _weight = data['weight'] != null ? double.tryParse(data['weight'].toString()) ?? 70.0 : 70.0;
          _height = data['height'] != null ? (double.tryParse(data['height'].toString()) ?? 0.0) / 100 : null;
          _gender = data['gender'];
          _limitation = data['limitation'];
          _goal = data['goal'];
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error al cargar datos existentes: $e"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _saveData() async {
    try {
      QuerySnapshot userDoc = await FirebaseFirestore.instance
          .collection('usuarios')
          .where('email', isEqualTo: widget.userEmail)
          .get();

      if (userDoc.docs.isNotEmpty) {
        Map<String, dynamic> updatedData = {};

        // Solo agregar campos que hayan sido modificados o seleccionados
        if (_age != null) updatedData['age'] = _age;
        if (_weight != 70 || _weight != (userDoc.docs.first.data() as Map<String, dynamic>)['weight']) updatedData['weight'] = _weight;
        if (_height != null) updatedData['height'] = _height! * 100; // Convertir a cm
        if (_gender != null) updatedData['gender'] = _gender;
        if (_limitation != null) updatedData['limitation'] = _limitation;
        if (_goal != null) updatedData['goal'] = _goal;

        if (updatedData.isNotEmpty) {
          await FirebaseFirestore.instance
              .collection('usuarios')
              .doc(userDoc.docs.first.id)
              .update(updatedData);

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Datos guardados con éxito."),
              backgroundColor: Colors.green,
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("No se modificaron datos."),
              backgroundColor: Colors.grey,
            ),
          );
        }

        // Regresar a la pantalla anterior (ProfileScreen o ProfileAdmin)
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("No se encontró el usuario con el email ${widget.userEmail}."),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error al guardar los datos: $e"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0a0322),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF5EDE4),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Actualiza tus Datos'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          margin: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 5,
                blurRadius: 7,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          padding: const EdgeInsets.all(16),
          child: ListView(
            children: [
              const Text('¿Cuál es tu edad?', style: TextStyle(fontSize: 18)),
              const SizedBox(height: 10),
              DropdownButtonFormField<int>(
                value: _age,
                items: List.generate(100, (index) => index + 18).map((int value) {
                  return DropdownMenuItem<int>(
                    value: value,
                    child: Text('$value años'),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    _age = newValue;
                  });
                },
                decoration: InputDecoration(
                  filled: true,
                  fillColor: const Color.fromARGB(255, 218, 214, 214),
                  contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                ),
                hint: const Text('Selecciona tu edad'),
              ),
              const SizedBox(height: 20),
              const Text('Registra tu peso:', style: TextStyle(fontSize: 18)),
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
              const SizedBox(height: 20),
              const Text('¿Cuánto mides?', style: TextStyle(fontSize: 18)),
              DropdownButtonFormField<double>(
                value: _height,
                items: List.generate(61, (index) => 1.20 + index * 0.01).map((double value) {
                  return DropdownMenuItem<double>(
                    value: value,
                    child: Text('${value.toStringAsFixed(2)} m'),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    _height = newValue;
                  });
                },
                decoration: InputDecoration(
                  filled: true,
                  fillColor: const Color.fromARGB(255, 218, 214, 214),
                  contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                ),
                hint: const Text('Selecciona tu altura'),
              ),
              const SizedBox(height: 20),
              const Text('Género:', style: TextStyle(fontSize: 18)),
              DropdownButtonFormField<String>(
                value: _gender,
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
                  contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                ),
                hint: const Text('Selecciona tu género'),
              ),
              const SizedBox(height: 20),
              const Text('¿Tienes alguna limitación física?', style: TextStyle(fontSize: 18)),
              DropdownButtonFormField<String>(
                value: _limitation,
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
                  contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                ),
                hint: const Text('Selecciona una opción'),
              ),
              const SizedBox(height: 20),
              const Text('¿Qué quieres lograr?', style: TextStyle(fontSize: 18)),
              DropdownButtonFormField<String>(
                value: _goal,
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
                  contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                ),
                hint: const Text('Selecciona tu meta'),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Colors.purpleAccent,
                ),
                onPressed: _saveData,
                child: const Text('Guardar', style: TextStyle(fontSize: 18, color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}