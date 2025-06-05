import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:just_audio/just_audio.dart';
import 'package:gym_fitgo/screens/rutinas_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// Clase personalizada para manejar audio desde bytes
class CustomAudioSource extends StreamAudioSource {
  final Uint8List bytes;

  CustomAudioSource(this.bytes);

  @override
  Future<StreamAudioResponse> request([int? start, int? end]) async {
    start ??= 0;
    end ??= bytes.length;
    return StreamAudioResponse(
      sourceLength: bytes.length,
      contentLength: end - start,
      offset: start,
      stream: Stream.value(bytes.sublist(start, end)),
      contentType: 'audio/mpeg',
    );
  }
}

class ExerciseTimerScreen extends StatefulWidget {
  final List<Map<String, dynamic>> exercises;
  final String routineId;
  final String? userId;

  const ExerciseTimerScreen({
    required this.exercises,
    required this.routineId,
    this.userId,
  });

  @override
  _ExerciseTimerScreenState createState() => _ExerciseTimerScreenState();
}

class _ExerciseTimerScreenState extends State<ExerciseTimerScreen> with SingleTickerProviderStateMixin {
  int currentExerciseIndex = 0;
  int countdown = 5;
  int exerciseTime = 0;
  int restTime = 10;
  Timer? timer;
  String phase = 'countdown';
  List<String> countdownMessages = ['Preparados', 'Listos', 'Comenzamos'];
  bool isSoundEnabled = true;
  int extraTimeUses = 0;
  late final AudioPlayer _audioPlayer;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  bool isPaused = false;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    )..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _animationController.reverse();
        }
      });
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.5).animate(_animationController);
    if (widget.exercises.isNotEmpty) {
      exerciseTime = widget.exercises[currentExerciseIndex]['timer'] as int? ?? 0;
      startTimer();
    } else {
      setState(() {
        phase = 'completed';
      });
    }
    _audioPlayer.playerStateStream.listen((state) {
      print('Estado del reproductor: $state');
    });
    debugAsset('images/sonidos/Beep.mp3');
    debugAsset('images/sonidos/Applause.mp3');
  }

  Future<void> debugAsset(String path) async {
    try {
      await rootBundle.load(path);
      print('Asset cargado correctamente: $path');
    } catch (e) {
      print('Error al cargar asset $path: $e');
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    _animationController.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted || isPaused) return;

      setState(() {
        if (phase == 'countdown') {
          if (countdown > 0) {
            countdown--;
            if (countdown == 0) {
              phase = 'exercise';
              _animationController.forward();
            }
          }
        } else if (phase == 'exercise') {
          if (exerciseTime > 0) {
            exerciseTime--;
            if (exerciseTime == 5 && isSoundEnabled) {
              playSound('Beep.mp3');
            }
          } else {
            if (currentExerciseIndex < widget.exercises.length - 1) {
              phase = 'rest';
              restTime = 10;
            } else {
              phase = 'completed';
              timer?.cancel();
              if (isSoundEnabled) {
                playSound('Applause.mp3');
              }
              _saveCompletionDate();
              Future.delayed(const Duration(seconds: 2), () {
                if (mounted) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => RutinasScreen()),
                  );
                }
              });
            }
          }
        } else if (phase == 'rest') {
          if (restTime > 0) {
            restTime--;
          } else {
            currentExerciseIndex++;
            exerciseTime = widget.exercises[currentExerciseIndex]['timer'] as int? ?? 0;
            extraTimeUses = 0;
            countdown = 5;
            phase = 'countdown';
          }
        }
      });
    });
  }

  Future<void> _saveCompletionDate() async {
    if (widget.userId == null) return;

    final userDocRef = FirebaseFirestore.instance.collection('usuarios').doc(widget.userId);
    final doc = await userDocRef.get();
    if (doc.exists) {
      final completedRoutines = Map<String, String>.from(doc.data()?['completedRoutines'] ?? {});
      if (!completedRoutines.containsKey(widget.routineId)) {
        completedRoutines[widget.routineId] = DateTime.now().toIso8601String();
        await userDocRef.update({'completedRoutines': completedRoutines});
      }
    }
  }

  Future<void> playSound(String fileName) async {
    try {
      final byteData = await rootBundle.load('images/sonidos/$fileName');
      final buffer = byteData.buffer.asUint8List();
      await _audioPlayer.setAudioSource(CustomAudioSource(buffer));
      await _audioPlayer.play();
      print('Reproduciendo sonido desde bytes: $fileName');
    } catch (e) {
      print('Error al reproducir sonido $fileName: $e');
    }
  }

  void togglePause() {
    setState(() {
      isPaused = !isPaused;
      if (!isPaused) {
        startTimer();
      } else {
        timer?.cancel();
      }
    });
  }

  void addExtraTime() {
    if (phase == 'exercise' && extraTimeUses < 3 && exerciseTime > 0) {
      setState(() {
        exerciseTime += 15;
        extraTimeUses++;
      });
    }
  }

  void goToNextExercise() {
    if (currentExerciseIndex < widget.exercises.length - 1) {
      setState(() {
        currentExerciseIndex++;
        exerciseTime = widget.exercises[currentExerciseIndex]['timer'] as int? ?? 0;
        extraTimeUses = 0;
        phase = 'countdown';
        countdown = 5;
        timer?.cancel();
        startTimer();
      });
    }
  }

  void goToPreviousExercise() {
    if (currentExerciseIndex > 0) {
      setState(() {
        currentExerciseIndex--;
        exerciseTime = widget.exercises[currentExerciseIndex]['timer'] as int? ?? 0;
        extraTimeUses = 0;
        phase = 'countdown';
        countdown = 5;
        timer?.cancel();
        startTimer();
      });
    }
  }

  String getCountdownMessage() {
    if (countdown >= 3) return countdownMessages[0];
    if (countdown >= 1) return countdownMessages[1];
    return countdownMessages[2];
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        timer?.cancel();
        return true;
      },
      child: Scaffold(
        backgroundColor: const Color(0xFF2B192E),
        appBar: AppBar(
          backgroundColor: const Color(0xFFF8E1FF),
          title: const Text(
            'Rutina en Progreso',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () {
              timer?.cancel();
              Navigator.pop(context);
            },
          ),
          elevation: 0,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: Icon(
                      isSoundEnabled ? Icons.volume_up : Icons.volume_off,
                      color: Colors.white,
                      size: 30,
                    ),
                    onPressed: () {
                      setState(() {
                        isSoundEnabled = !isSoundEnabled;
                      });
                    },
                  ),
                ],
              ),
              if (phase == 'countdown' || phase == 'exercise') ...[
                ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Image.network(
                    widget.exercises[currentExerciseIndex]['image']?.toString() ??
                        'https://via.placeholder.com/100',
                    width: 200,
                    height: 200,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        const Icon(Icons.error, size: 100, color: Colors.white),
                  ),
                ),
                const SizedBox(height: 20),
              ],
              if (phase == 'countdown') ...[
                AnimatedBuilder(
                  animation: _scaleAnimation,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: _scaleAnimation.value,
                      child: Text(
                        getCountdownMessage(),
                        style: const TextStyle(
                          fontSize: 30,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 10),
                Text(
                  '$countdown',
                  style: const TextStyle(
                    fontSize: 50,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ] else if (phase == 'exercise') ...[
                Text(
                  'Ejercicio: ${widget.exercises[currentExerciseIndex]['name']?.toString() ?? 'Sin nombre'}',
                  style: const TextStyle(
                    fontSize: 24,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  '$exerciseTime',
                  style: const TextStyle(
                    fontSize: 50,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        const Text(
                          'Repeticiones',
                          style: TextStyle(color: Colors.white70, fontSize: 14),
                        ),
                        Text(
                          widget.exercises[currentExerciseIndex]['repetitions']?.toString() ?? '0',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 20),
                    Column(
                      children: [
                        const Text(
                          'Series',
                          style: TextStyle(color: Colors.white70, fontSize: 14),
                        ),
                        Text(
                          widget.exercises[currentExerciseIndex]['series']?.toString() ?? '0',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: addExtraTime,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: extraTimeUses < 3
                        ? const Color(0xFF7A0180)
                        : Colors.grey,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
                  child: const Text(
                    '+15s',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ] else if (phase == 'rest') ...[
                const Text(
                  'Descanso',
                  style: TextStyle(
                    fontSize: 30,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  '$restTime',
                  style: const TextStyle(
                    fontSize: 50,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ] else if (phase == 'completed') ...[
                const Text(
                  '¡Has terminado la rutina!',
                  style: TextStyle(
                    fontSize: 30,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 30),
                    onPressed: currentExerciseIndex > 0 ? goToPreviousExercise : null,
                  ),
                  const SizedBox(width: 20),
                  ElevatedButton(
                    onPressed: togglePause,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF7A0180),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                    ),
                    child: Text(
                      isPaused ? 'Reanudar' : 'Pausar',
                      style: const TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),
                  const SizedBox(width: 20),
                  IconButton(
                    icon: const Icon(Icons.arrow_forward_ios, color: Colors.white, size: 30),
                    onPressed: currentExerciseIndex < widget.exercises.length - 1
                        ? goToNextExercise
                        : null,
                  ),
                ],
              ),
              if (isPaused) ...[
                const SizedBox(height: 10),
                const Text(
                  'Cronómetro pausado',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white70,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}