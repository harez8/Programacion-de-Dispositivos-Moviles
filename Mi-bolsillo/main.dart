import 'package:flutter/material.dart';

import 'screens/home_screen.dart';

void main() {
  runApp(const MiBolsilloApp());
}

/// Widget raíz: no cambia, por eso es StatelessWidget.
class MiBolsilloApp extends StatelessWidget {
  const MiBolsilloApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mi Bolsillo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF1B8A5A)),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}
