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

  // Listas de valores permitidos para validación
  final List<int> _validAges = List.generate(100, (index) => index + 18);
  final List<double> _validHeights =
      List.generate(61, (index) => double.parse((1.20 + index * 0.01).toStringAsFixed(2)));
  final List<String> _validGenders = ['Masculino', 'Femenino', 'Otro'];
  final List<String> _validLimitations = ['Sí', 'No'];
  final List<String> _validGoals = ['Bajar de peso', 'Ganar masa muscular', 'Mantenerme saludable'];

  // Colores del diseño basados en la imagen de referencia
  static const Color _darkPurple = Color(0xFF2E2E3D); // Tono oscuro del fondo
  static const Color _lightPurple = Color(0xFF4A4A5A); // Tono claro del fondo
  static const Color _accentPurple = Color(0xFFAB47BC); // Color púrpura para íconos y texto
  static const Color _lightLila = Color(0xFFF8E1FF); // Lila claro para texto

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
        print('Datos del usuario: $data');
        setState(() {
          // Validar edad
          int? parsedAge = data['age'] != null ? int.tryParse(data['age'].toString()) : null;
          _age = parsedAge != null && _validAges.contains(parsedAge) ? parsedAge : null;

          // Peso: mantener el valor predeterminado si no es válido
          _weight = data['weight'] != null
              ? (double.tryParse(data['weight'].toString()) ?? 70.0).clamp(40.0, 150.0)
              : 70.0;

          // Validar altura: convertir a metros y buscar el valor más cercano
          double? parsedHeight = data['height'] != null ? double.tryParse(data['height'].toString()) : null;
          if (parsedHeight != null && parsedHeight >= 120 && parsedHeight <= 180) {
            double heightInMeters = parsedHeight / 100;
            _height = _validHeights.reduce((a, b) =>
                (a - heightInMeters).abs() < (b - heightInMeters).abs() ? a : b);
          } else {
            _height = null;
          }

          // Validar género
          _gender = data['gender'] != null && _validGenders.contains(data['gender'].toString())
              ? data['gender'].toString()
              : null;

          // Validar limitación
          _limitation = data['limitation'] != null &&
                  _validLimitations.contains(data['limitation'].toString())
              ? data['limitation'].toString()
              : null;

          // Validar meta
          _goal = data['goal'] != null && _validGoals.contains(data['goal'].toString())
              ? data['goal'].toString()
              : null;
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
        if (_weight != 70 ||
            _weight != (userDoc.docs.first.data() as Map<String, dynamic>)['weight']) {
          updatedData['weight'] = _weight;
        }
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
            const SnackBar(
              content: Text("Datos guardados con éxito."),
              backgroundColor: Colors.green,
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("No se modificaron datos."),
              backgroundColor: Colors.grey,
            ),
          );
        }

        // Regresar a la pantalla anterior
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
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [_darkPurple, _lightPurple],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 32.0), // Más espacio a los lados
                  children: [
                    _buildAgeField(),
                    const SizedBox(height: 20),
                    _buildWeightField(),
                    const SizedBox(height: 20),
                    _buildHeightField(),
                    const SizedBox(height: 20),
                    _buildGenderField(),
                    const SizedBox(height: 20),
                    _buildLimitationField(),
                    const SizedBox(height: 20),
                    _buildGoalField(),
                    const SizedBox(height: 30),
                    _buildSaveButton(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Construye el encabezado con el título
  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 32), // Más espacio a los lados
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: _accentPurple, size: 30),
            onPressed: () => Navigator.pop(context),
          ),
          const Text(
            'Registra tus Datos',
            style: TextStyle(
              color: _lightLila, // Lila claro para el texto
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 48), // Espacio en lugar del ícono
        ],
      ),
    );
  }

  // Construye el campo de edad
  Widget _buildAgeField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '¿Cuál es tu edad?',
          style: TextStyle(fontSize: 18, color: Colors.white),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Image.asset(
              'images/18-.png', // Ícono sin fondo
              width: 16,
              height: 16,
              color: Colors.white, // Ícono blanco
            ),
            const SizedBox(width: 10),
            Expanded(
              child: DropdownButtonFormField<int>(
                value: _age,
                items: _validAges.map((int value) {
                  return DropdownMenuItem<int>(
                    value: value,
                    child: Text('$value años', style: const TextStyle(color: Colors.white)),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    _age = newValue;
                  });
                },
                decoration: InputDecoration(
                  filled: true,
                  fillColor: _darkPurple,
                  contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                ),
                hint: const Text('Selecciona tu edad', style: TextStyle(color: Colors.white)),
                dropdownColor: _darkPurple,
                iconEnabledColor: _accentPurple,
              ),
            ),
          ],
        ),
      ],
    );
  }

  // Construye el campo de peso
  Widget _buildWeightField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Registra tu peso:',
          style: TextStyle(fontSize: 18, color: Colors.white),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Image.asset(
              'images/escala.png', // Ícono sin fondo
              width: 16,
              height: 16,
              color: Colors.white, // Ícono blanco
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Slider(
                value: _weight,
                min: 40,
                max: 150,
                divisions: 110,
                activeColor: _accentPurple,
                inactiveColor: Colors.grey[400],
                thumbColor: _accentPurple,
                label: '${_weight.round()} Kg',
                onChanged: (double value) {
                  setState(() {
                    _weight = value;
                  });
                },
              ),
            ),
          ],
        ),
        Center(
          child: Text(
            '${_weight.round()} Kg',
            style: const TextStyle(fontSize: 16, color: Colors.white),
          ),
        ),
      ],
    );
  }

  // Construye el campo de altura
  Widget _buildHeightField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '¿Cuánto mides?',
          style: TextStyle(fontSize: 18, color: Colors.white),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Image.asset(
              'images/limite-de-altura.png', // Ícono sin fondo
              width: 16,
              height: 16,
              color: Colors.white, // Ícono blanco
            ),
            const SizedBox(width: 10),
            Expanded(
              child: DropdownButtonFormField<double>(
                value: _height,
                items: _validHeights.map((double value) {
                  return DropdownMenuItem<double>(
                    value: value,
                    child: Text('${value.toStringAsFixed(2)} m',
                        style: const TextStyle(color: Colors.white)),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    _height = newValue;
                  });
                },
                decoration: InputDecoration(
                  filled: true,
                  fillColor: _darkPurple,
                  contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                ),
                hint: const Text('Selecciona tu altura', style: TextStyle(color: Colors.white)),
                dropdownColor: _darkPurple,
                iconEnabledColor: _accentPurple,
              ),
            ),
          ],
        ),
      ],
    );
  }

  // Construye el campo de género
  Widget _buildGenderField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Género:',
          style: TextStyle(fontSize: 18, color: Colors.white),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Image.asset(
              'images/signo-de-genero (1).png', // Ícono sin fondo
              width: 16,
              height: 16,
              color: Colors.white, // Ícono blanco
            ),
            const SizedBox(width: 10),
            Expanded(
              child: DropdownButtonFormField<String>(
                value: _gender,
                items: _validGenders.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value, style: const TextStyle(color: Colors.white)),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    _gender = newValue;
                  });
                },
                decoration: InputDecoration(
                  filled: true,
                  fillColor: _darkPurple,
                  contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                ),
                hint: const Text('Selecciona tu género', style: TextStyle(color: Colors.white)),
                dropdownColor: _darkPurple,
                iconEnabledColor: _accentPurple,
              ),
            ),
          ],
        ),
      ],
    );
  }

  // Construye el campo de limitación
  Widget _buildLimitationField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '¿Tienes alguna limitación física?',
          style: TextStyle(fontSize: 18, color: Colors.white),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Image.asset(
              'images/paciente.png', // Ícono sin fondo
              width: 16,
              height: 16,
              color: Colors.white, // Ícono blanco
            ),
            const SizedBox(width: 10),
            Expanded(
              child: DropdownButtonFormField<String>(
                value: _limitation,
                items: _validLimitations.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value, style: const TextStyle(color: Colors.white)),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    _limitation = newValue;
                  });
                },
                decoration: InputDecoration(
                  filled: true,
                  fillColor: _darkPurple,
                  contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                ),
                hint: const Text('Selecciona una opción', style: TextStyle(color: Colors.white)),
                dropdownColor: _darkPurple,
                iconEnabledColor: _accentPurple,
              ),
            ),
          ],
        ),
      ],
    );
  }

  // Construye el campo de meta
  Widget _buildGoalField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '¿Qué quieres lograr?',
          style: TextStyle(fontSize: 18, color: Colors.white),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Image.asset(
              'images/exito.png', // Ícono sin fondo
              width: 16,
              height: 16,
              color: Colors.white, // Ícono blanco
            ),
            const SizedBox(width: 10),
            Expanded(
              child: DropdownButtonFormField<String>(
                value: _goal,
                items: _validGoals.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value, style: const TextStyle(color: Colors.white)),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    _goal = newValue;
                  });
                },
                decoration: InputDecoration(
                  filled: true,
                  fillColor: _darkPurple,
                  contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                ),
                hint: const Text('Selecciona tu meta', style: TextStyle(color: Colors.white)),
                dropdownColor: _darkPurple,
                iconEnabledColor: _accentPurple,
              ),
            ),
          ],
        ),
      ],
    );
  }

  // Construye el botón de guardar
  Widget _buildSaveButton() {
    bool isEnabled = _age != null &&
        _height != null &&
        _gender != null &&
        _limitation != null &&
        _goal != null;

    return Center(
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: isEnabled ? _saveData : null,
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            elevation: 0, // Sin sombra
            side: const BorderSide(width: 0, color: Colors.transparent), // Sin borde
          ).copyWith(
            backgroundColor: MaterialStateProperty.resolveWith<Color>(
              (states) {
                if (states.contains(MaterialState.disabled)) {
                  return Colors.grey.withOpacity(0.5); // Gris claro sin borde
                }
                return Colors.transparent;
              },
            ),
            foregroundColor: MaterialStateProperty.all(Colors.transparent),
            overlayColor: MaterialStateProperty.resolveWith<Color>(
              (states) {
                if (states.contains(MaterialState.disabled)) {
                  return Colors.transparent; // Eliminar borde gris en desactivado
                }
                return Colors.transparent;
              },
            ),
          ),
          child: Container(
            decoration: BoxDecoration(
              gradient: isEnabled
                  ? const LinearGradient(
                      colors: [_accentPurple, _darkPurple],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    )
                  : null,
              color: isEnabled ? null : Colors.grey.withOpacity(0.5),
              borderRadius: BorderRadius.circular(10.0),
            ),
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: const Center(
              child: Text(
                'Guardar',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}