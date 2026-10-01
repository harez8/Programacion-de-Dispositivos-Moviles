import 'package:flutter/material.dart';
import 'screens/first_screen.dart'; // aqui importo mi otro archivo

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Aula movil',
      home: First_Screen(),
    );
  }
}