import 'package:flutter/material.dart';
import 'gerakan_detail_screen.dart';
import 'ruku_screen.dart';

class TakbirScreen extends StatelessWidget {
  const TakbirScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GerakanDetailScreen(
      title: "Takbiratul Ihram",
      description: "Angkat kedua tangan sejajar dengan telinga...",
      bacaan: "اَللهُ اَكْبَرْ",
      videoPath: 'assets/videos/takbir.mp4',
      nextScreen: const RukuScreen(),
    );
  }
}
