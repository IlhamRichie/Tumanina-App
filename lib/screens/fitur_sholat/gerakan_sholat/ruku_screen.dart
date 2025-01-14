import 'package:flutter/material.dart';
import 'gerakan_detail_screen.dart';
import 'takbir_screen.dart';
import 'itidal_screen.dart';

class RukuScreen extends StatelessWidget {
  const RukuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GerakanDetailScreen(
      title: "Ruku'",
      description: "Ruku' dilakukan dengan membungkukkan badan hingga punggung rata, tangan diletakkan di lutut, dan kepala sejajar dengan punggung.",
      bacaan: "سُبْحَانَ رَبِّيْ الْعَظِيْمِ وَبِحَمْدِهِ\n\n (Subhâna Rabbiyal ‘adzîmi wa bihamdihi 3x)\n\n Artinya: Maha Suci Tuhanku Yang Maha Agung, dan dengan memuji pada-Nya Agung.",
      videoUrl: "https://youtu.be/U1eHPW81QYU?si=W4JqymIWiOD1xhuD",
      previousScreen: const TakbirScreen(),
      nextScreen: const ItidalScreen(),
    );
  }
}
