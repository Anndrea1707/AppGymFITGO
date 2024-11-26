import 'dart:async';
import 'package:flutter/material.dart';
import 'package:gym_fitgo/widgets/custom_bottom_navbar.dart'; // Importa el CustomBottomNavBar

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
  bool isPaused = false; // Controla si el temporizador está en pausa

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
      if (!isPaused) {
        setState(() {
          if (totalTime > 0) {
            totalTime--;
          } else {
            timer.cancel(); // Detener el temporizador al llegar a 0
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
      totalTime = 180; // Reiniciar el temporizador a 3 minutos
    });
    startTimer();
  }

  String formatTime(int totalSeconds) {
    final minutes = totalSeconds ~/ 60;
    final remainingSeconds = totalSeconds % 60;
    return '${minutes.toString().padLeft(1, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0a0322),
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: Text(widget.day),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.description,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  widget.image,
                  width: 300,
                  height: 200,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: Column(
                children: [
                  Text(
                    totalTime > 0 ? formatTime(totalTime) : '¡Terminado!',
                    style: const TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        onPressed: isPaused ? resumeTimer : pauseTimer,
                        icon: Icon(isPaused ? Icons.play_arrow : Icons.pause),
                        color: Colors.white,
                        iconSize: 30,
                      ),
                      const SizedBox(width: 20),
                      IconButton(
                        onPressed: resetTimer,
                        icon: const Icon(Icons.refresh),
                        color: Colors.white,
                        iconSize: 30,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Ejercicios',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: widget.exercises.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(
                      widget.exercises[index],
                      style: const TextStyle(color: Colors.white),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Equipo',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: GridView.count(
                crossAxisCount: 4,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                children: imageUrls.map((url) {
                  return Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        url,
                        fit: BoxFit.cover,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: 1,
        onTap: (index) {},
      ),
    );
  }
}
