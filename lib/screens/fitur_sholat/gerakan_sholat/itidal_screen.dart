import 'package:flutter/material.dart';
import 'gerakan_detail_screen.dart';
import 'ruku_screen.dart';
import 'sujud_screen.dart';

class ItidalScreen extends StatelessWidget {
  const ItidalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GerakanDetailScreen(
      title: "I'tidal",
      description: "Bangkit dari ruku' dengan mengucapkan...",
      bacaan: "سَمِعَ اللهُ لِمَنْ حَمِدَهُ\nSami'allahu liman hamidah",
      videoPath: 'assets/videos/itidal.mp4',
      previousScreen: const RukuScreen(),
      nextScreen: const SujudScreen(),
    );
  }
}
