import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'screens/intro_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Tumanina',
      theme: ThemeData(
        textTheme: GoogleFonts.poppinsTextTheme(), // Mengatur font global
        primarySwatch: Colors.blue,
      ),
      home: IntroScreen(),
    );
  }
}
