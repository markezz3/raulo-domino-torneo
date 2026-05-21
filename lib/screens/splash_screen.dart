import 'package:flutter/material.dart';
import 'dart:async';

import 'setup_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  double progress = 0.0;

  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _fadeAnimation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);

    _scaleAnimation = Tween<double>(
      begin: 0.95,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _controller.forward();

    startLoading();
  }

  Future<void> startLoading() async {
    for (int i = 1; i <= 100; i++) {
      await Future.delayed(const Duration(milliseconds: 25));

      setState(() {
        progress = i / 100;
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void goToSetup() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const SetupScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    final screenWidth = size.width;
    final screenHeight = size.height;
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                const Spacer(),

                FadeTransition(
                  opacity: _fadeAnimation,
                  child: ScaleTransition(
                    scale: _scaleAnimation,
                    child: Column(
                      children: [
                        Text(
                          'RAULO DOMINÓ',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: (screenWidth * 0.085).clamp(32.0, 72.0),
                            fontWeight: FontWeight.bold,
                            letterSpacing: 2,
                          ),
                        ),

                        SizedBox(height: 12),

                        Text(
                          'Sistema de Torneos',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: (screenWidth * 0.04).clamp(16.0, 32.0),
                            letterSpacing: 1,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 60),

                SizedBox(
                  width: screenWidth * 0.7,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      LinearProgressIndicator(
                        value: progress,
                        minHeight: 8,
                        borderRadius: BorderRadius.circular(12),
                        backgroundColor: Colors.white12,
                      ),

                      const SizedBox(height: 12),

                      Text(
                        'Cargando... ${(progress * 100).toInt()}%',
                        style: const TextStyle(color: Colors.white70),
                      ),
                    ],
                  ),
                ),

                const Spacer(),

                AnimatedOpacity(
                  opacity: progress >= 1 ? 1 : 0,
                  duration: const Duration(milliseconds: 500),
                  child: SizedBox(
                    width: screenWidth * 0.6,
                    height: screenHeight * 0.065,
                    child: ElevatedButton(
                      onPressed: progress >= 1 ? goToSetup : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: const Text(
                        'COMENZAR',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                const Text(
                  'Versión beta - 0.1.0',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.w400,
                  ),
                ),

                SizedBox(height: screenHeight * 0.07),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
