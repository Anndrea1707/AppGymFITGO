import 'dart:async';
import 'package:flutter/material.dart';
import 'package:gym_fitgo/screens/login_screen.dart'; // Asegúrate de ajustar la ruta

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  late AnimationController _logoController;
  late AnimationController _titleController;
  late AnimationController _sloganController;
  late AnimationController _fadeOutController;
  late Animation<double> _logoScaleAnimation;
  late Animation<double> _logoOpacityAnimation;
  late Animation<double> _titleScaleAnimation;
  late Animation<double> _titleOpacityAnimation;
  late Animation<double> _sloganScaleAnimation;
  late Animation<double> _sloganOpacityAnimation;
  late Animation<double> _fadeOutOpacityAnimation;

  @override
  void initState() {
    super.initState();

    // Controlador para la animación del logo
    _logoController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500), // 1.5 segundos para aparecer
    );

    // Animaciones del logo
    _logoScaleAnimation = CurvedAnimation(parent: _logoController, curve: Curves.easeInOut);
    _logoOpacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.easeIn),
    );

    // Controlador para la animación del título
    _titleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500), // 1.5 segundos para aparecer
    );

    // Animaciones del título
    _titleScaleAnimation = CurvedAnimation(parent: _titleController, curve: Curves.easeInOut);
    _titleOpacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _titleController, curve: Curves.easeIn),
    );

    // Controlador para la animación del eslogan
    _sloganController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500), // 1.5 segundos para aparecer
    );

    // Animaciones del eslogan
    _sloganScaleAnimation = CurvedAnimation(parent: _sloganController, curve: Curves.easeInOut);
    _sloganOpacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _sloganController, curve: Curves.easeIn),
    );

    // Controlador para la animación de desaparición
    _fadeOutController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500), // 1.5 segundos para desaparecer
    );

    // Animación de opacidad inversa para la desaparición
    _fadeOutOpacityAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(parent: _fadeOutController, curve: Curves.easeOut),
    );

    // Iniciar la animación del logo primero
    _logoController.forward();

    // Iniciar la animación del título después de 0.5 segundos
    Future.delayed(const Duration(milliseconds: 500), () {
      _titleController.forward();
    });

    // Iniciar la animación del eslogan 0.5 segundos después del título
    Future.delayed(const Duration(milliseconds: 1000), () {
      _sloganController.forward();
    });

    // Iniciar la animación de desaparición 0.5 segundos después del eslogan
    Future.delayed(const Duration(milliseconds: 2500), () {
      _fadeOutController.forward();
    });

    // Redirigir al LoginScreen después de que la animación de desaparición termine
    _fadeOutController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginScreen()),
        );
      }   
    });
  }

  @override
  void dispose() {
    _logoController.dispose();
    _titleController.dispose();
    _sloganController.dispose();
    _fadeOutController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: const Color(0xFFF8E1FF), // Fondo lila claro y sutil
        child: Center(
          child: AnimatedBuilder(
            animation: _fadeOutController,
            builder: (context, child) {
              return Opacity(
                opacity: _fadeOutOpacityAnimation.value,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Animación del logo
                    AnimatedBuilder(
                      animation: _logoController,
                      builder: (context, child) {
                        return Opacity(
                          opacity: _logoOpacityAnimation.value,
                          child: ScaleTransition(
                            scale: _logoScaleAnimation,
                            child: Image.asset(
                              'images/logoGym.png',
                              width: 150,
                              height: 150,
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 20),
                    // Animación del título
                    AnimatedBuilder(
                      animation: _titleController,
                      builder: (context, child) {
                        return Opacity(
                          opacity: _titleOpacityAnimation.value,
                          child: ScaleTransition(
                            scale: _titleScaleAnimation,
                            child: const Text(
                              'Gym FitGo',
                              style: TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF7A0180), // Lila medio para el texto
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 10),
                    // Animación del eslogan
                    AnimatedBuilder(
                      animation: _sloganController,
                      builder: (context, child) {
                        return Opacity(
                          opacity: _sloganOpacityAnimation.value,
                          child: ScaleTransition(
                            scale: _sloganScaleAnimation,
                            child: const Text(
                              '¡Muévete, Entrena, Triunfa!',
                              style: TextStyle(
                                fontSize: 18,
                                fontStyle: FontStyle.italic,
                                color: Color(0xFF7A0180), // Lila medio para el eslogan
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}