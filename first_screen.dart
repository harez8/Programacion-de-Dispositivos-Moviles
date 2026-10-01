import 'package:flutter/material.dart';

class First_Screen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFAF8FF),
      appBar: AppBar(
        backgroundColor: Color(0xFF6A4CC2),
        leading: Padding(
          padding: EdgeInsets.all(16),
          child: Text('☰', style: TextStyle(color: Colors.white, fontSize: 20)),
        ),
        title: Text(
          'Aula móvil',
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // titulo principal
            Padding(
              padding: EdgeInsets.only(top: 15, bottom: 8),
              child: Text(
                'Flutter: una interfaz hecha de piezas',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2A1B5E),
                ),
              ),
            ),
             Padding(
              padding: EdgeInsets.only(bottom: 25),
              child: Text(
                'Construye aplicaciones hermosas y funcionales, una pieza a la vez.',
                style: TextStyle(fontSize: 15, color: Colors.black54),
              ),
            ),

            // las dos columnas de arriba
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(bottom: 8),
                      child: Text(
                        '¿Qué es?',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF4B2FA0),
                        ),
                      ),
                    ),
                    Text(
                      'Flutter es un framework\nde Google para crear\ninterfaces en múltiples\nplataformas con un\nsolo código.',
                      style: TextStyle(fontSize: 13, color: Colors.black87),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(bottom: 8),
                      child: Text(
                        '¿Cómo se organiza?',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0B5C55),
                        ),
                      ),
                    ),
                    Text(
                      'La interfaz se construye\ncon widgets, que se\ncombinan en una jerarquía\npara formar la pantalla.',
                      style: TextStyle(fontSize: 13, color: Colors.black87),
                    ),
                  ],
                ),
              ],
            ),
              // idea clave
            Padding(
              padding: EdgeInsets.only(top: 30, bottom: 8),
              child: Text(
                'Idea clave',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0B5C55),
                ),
              ),
            ),
            Text(
              'Todo en Flutter es un widget.',
              style: TextStyle(fontSize: 13, color: Colors.black87),
            ),
          ],
        ),
      ),
    );
  }
}
