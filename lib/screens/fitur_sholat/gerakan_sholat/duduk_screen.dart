import 'package:flutter/material.dart';
import 'gerakan_detail_screen.dart';
import 'sujud_screen.dart';
import 'tasyahud_screen.dart';

class DudukScreen extends StatelessWidget {
  const DudukScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GerakanDetailScreen(
      title: "Duduk di Antara Dua Sujud",
      description: "Duduklah dengan posisi lutut dan ujung kaki menghadap kiblat...",
      bacaan: "رَبِّ اغْفِرْ لِيْ",
      videoPath: 'assets/videos/duduk.mp4',
      previousScreen: const SujudScreen(),
      nextScreen: const TasyahudScreen(),
    );
  }
}
