import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';

void main() {
  runApp(const RauloDominoApp());
}

class RauloDominoApp extends StatelessWidget {
  const RauloDominoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Raulo Dominó',
      home: SplashScreen(),
    );
  }
}