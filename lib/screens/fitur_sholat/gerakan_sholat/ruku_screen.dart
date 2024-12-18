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
      description: "Bungkukkan badan dengan posisi tangan di lutut...",
      bacaan: "سُبْحَانَ رَبِّيَ الْعَظِيْمِ",
      videoPath: 'assets/videos/ruku.mp4',
      previousScreen: const TakbirScreen(),
      nextScreen: const ItidalScreen(),
    );
  }
}
