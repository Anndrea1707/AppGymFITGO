import 'dart:async';
import 'package:flutter/material.dart';
import 'package:gym_fitgo/widgets/custom_bottom_navbar.dart';

class ExerciseDescriptionScreen extends StatefulWidget {
  final String day;
  final String description;
  final List<String> exercises;
  final String image;

  ExerciseDescriptionScreen({
    required this.day,
    required this.description,
    required this.exercises,
    required this.image,
  });

  @override
  _ExerciseDescriptionScreenState createState() =>
      _ExerciseDescriptionScreenState();
}

class _ExerciseDescriptionScreenState extends State<ExerciseDescriptionScreen> {
  int totalTime = 180; // Total del temporizador en segundos (3 minutos)
  Timer? timer;
  bool isPaused = false;

  final imageUrls = [
    'https://th.bing.com/th/id/OIP.F_Rc7GjHjNeLhDTc3dA0zAHaHa?rs=1&pid=ImgDetMain',
    'https://th.bing.com/th/id/OIP.47_P1_hFKLu2NnQkWiwSygHaHx?rs=1&pid=ImgDetMain',
    'https://th.bing.com/th?id=OIF.gmBH%2bsN9BPCzeWc79fSKUg&rs=1&pid=ImgDetMain',
    'https://th.bing.com/th/id/OIP.4ghkBAsMXQswvFka3mTC-QHaHa?w=203&h=203&c=7&r=0&o=5&dpr=1.3&pid=1.7',
    'https://th.bing.com/th/id/R.73e073b6941fd0210e0becbe88084e29?rik=5EqV6HvRTVcxOQ&pid=ImgRaw&r=0',
    'https://th.bing.com/th/id/OIP.mHJpg662bcFYj57v2DXUUAAAAA?rs=1&pid=ImgDetMain',
    'https://contents.mediadecathlon.com/p101106/k%2420bcb5f199bd7d65bb57782502244664/sq/Kit+de+pesas+y+barras+de+musculaci+n+Domyos+de+93+kg.jpg',
    'https://th.bing.com/th/id/OIP.AfQaorMnI7_kaKxFP5JlQwHaI_?rs=1&pid=ImgDetMain',
  ];
  @override
  void initState() {
    super.initState();
    startTimer();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!isPaused && mounted) {
        setState(() {
          if (totalTime > 0) {
            totalTime--;
          } else {
            timer.cancel();
            _showCompletionDialog();
          }
        });
      }
    });
  }

  void pauseTimer() {
    setState(() {
      isPaused = true;
    });
  }

  void resumeTimer() {
    setState(() {
      isPaused = false;
    });
  }

  void resetTimer() {
    setState(() {
      totalTime = 180;
      isPaused = false;
    });
    startTimer();
  }

  String formatTime(int totalSeconds) {
    final minutes = totalSeconds ~/ 60;
    final remainingSeconds = totalSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  void _showCompletionDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('¡Completado!'),
        content: Text('Has terminado la rutina de ${widget.day}. ¡Buen trabajo!'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              resetTimer();
            },
            child: Text('Continuar'),
          ),
        ],
      ),
    );
  }

  Map<String, String> exerciseDescriptions = {
    'Flexión de rodilla: 3x20': 'Ponte de pie, flexiona las rodillas lentamente hasta formar un ángulo de 90°, mantén la espalda recta y sube. Repite 20 veces por 3 series.',
    'Prensa de piernas: 3x20': 'Usa una máquina de prensa, coloca los pies a la altura de los hombros, empuja el peso hacia arriba con las piernas y baja controladamente. 20 repeticiones, 3 series.',
    'Front squat: 3x20': 'Sostén una barra frente a los hombros, realiza una sentadilla profunda manteniendo el torso erguido. 20 repeticiones, 3 series.',
    'Squat jump: 3x20': 'Haz una sentadilla y salta explosivamente hacia arriba. Aterriza suavemente y repite. 20 saltos por 3 series.',
    'Dominadas: 3x12': 'Cuelga de una barra con las palmas hacia afuera, sube hasta que la barbilla pase la barra y baja controladamente. 12 repeticiones, 3 series.',
    'Remo con mancuernas: 3x15': 'Inclínate hacia adelante, sostén una mancuerna en cada mano y tira hacia tu cintura, contrayendo la espalda. 15 repeticiones, 3 series.',
    'Curl de bíceps: 3x12': 'Sostén mancuernas con las palmas hacia arriba, flexiona los codos para levantarlas y baja lentamente. 12 repeticiones, 3 series.',
    'Press de hombro: 3x12': 'Sostén mancuernas a la altura de los hombros, empuja hacia arriba y baja con control. 12 repeticiones, 3 series.',
    'Sentadilla búlgara: 3x12': 'Apoya un pie detrás en un banco, baja en sentadilla con la pierna delantera y sube. 12 repeticiones por pierna, 3 series.',
    'Extensiones de pierna: 3x15': 'Usa una máquina de extensiones, extiende las piernas completamente y baja lentamente. 15 repeticiones, 3 series.',
    'Peso muerto: 3x15': 'Con una barra o mancuernas, baja el peso hacia el suelo manteniendo la espalda recta y sube usando las piernas. 15 repeticiones, 3 series.',
    'Lunges: 3x20': 'Da un paso adelante, baja hasta que la rodilla trasera casi toque el suelo y regresa. 20 repeticiones por pierna, 3 series.',
    'Press de banca: 3x12': 'Acostado en un banco, empuja la barra hacia arriba desde el pecho y bájala controladamente. 12 repeticiones, 3 series.',
    'Aperturas: 3x15': 'Acostado, abre los brazos con mancuernas hacia los lados y ciérralos sobre el pecho. 15 repeticiones, 3 series.',
    'Elevaciones laterales: 3x12': 'Sostén mancuernas a los lados, eleva los brazos hasta la altura de los hombros y baja. 12 repeticiones, 3 series.',
    'Flexiones: 3x20': 'Colócate en posición de plancha, baja el pecho al suelo y sube. 20 repeticiones, 3 series.',
    'Plancha: 3x1 min': 'Mantén el cuerpo en línea recta apoyado en antebrazos y pies por 1 minuto por 3 series.',
    'Crunches: 3x20': 'Acostado, sube el torso hacia las rodillas contrayendo el abdomen. 20 repeticiones, 3 series.',
    'Russian twists: 3x20': 'Sentado, gira el torso de lado a lado con un peso en las manos. 20 giros, 3 series.',
    'Levantamiento de piernas: 3x15': 'Acostado, sube las piernas rectas hasta 90° y bájalas sin tocar el suelo. 15 repeticiones, 3 series.',
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0a0322),
      appBar: AppBar(
        backgroundColor: Color(0xFFF5EDE4),
        title: Text(
          widget.day,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              color: Colors.grey[800],
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.description,
                      style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 15),
                    Center(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(
                          widget.image,
                          width: double.infinity,
                          height: 200,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => Icon(Icons.error, size: 100, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Card(
              color: Colors.grey[800],
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text(
                      'Temporizador',
                      style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      totalTime > 0 ? formatTime(totalTime) : '¡Terminado!',
                      style: TextStyle(fontSize: 40, color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: isPaused ? resumeTimer : pauseTimer,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF192125),
                            shape: CircleBorder(),
                            padding: EdgeInsets.all(15),
                          ),
                          child: Icon(isPaused ? Icons.play_arrow : Icons.pause, size: 30, color: Colors.white),
                        ),
                        const SizedBox(width: 20),
                        ElevatedButton(
                          onPressed: resetTimer,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF192125),
                            shape: CircleBorder(),
                            padding: EdgeInsets.all(15),
                          ),
                          child: Icon(Icons.refresh, size: 30, color: Colors.white),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Card(
              color: Colors.grey[800],
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Ejercicios',
                      style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: widget.exercises.length,
                      itemBuilder: (context, index) {
                        final exercise = widget.exercises[index];
                        final description = exerciseDescriptions[exercise] ?? 'Descripción no disponible.';
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Card(
                            color: Colors.grey[700],
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            child: ListTile(
                              leading: Icon(Icons.fitness_center, color: Colors.white),
                              title: Text(exercise, style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500)),
                              subtitle: Text(description, style: TextStyle(color: Colors.white70)),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Card(
              color: Colors.grey[800],
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Equipo Sugerido',
                      style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    GridView.count(
                      shrinkWrap: true,
                      crossAxisCount: 4,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      physics: NeverScrollableScrollPhysics(),
                      children: imageUrls.map((url) {
                        return Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white.withOpacity(0.1),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.network(
                              url,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) => Icon(Icons.error, color: Colors.white),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}