import 'package:flutter/material.dart';
import 'gerakan_detail_screen.dart';
import 'itidal_screen.dart';
import 'duduk_screen.dart';

class SujudScreen extends StatelessWidget {
  const SujudScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GerakanDetailScreen(
      title: "Sujud",
      description: "Letakkan tangan, lutut, dan ujung kaki di lantai...",
      bacaan: "سُبْحَانَ رَبِّىَ الْأَعْلَى وَبِحَمْدِهِ\nSubhaana robbiyal a'la wabihamdih (3x)",
      videoPath: 'assets/videos/sujud.mp4',
      previousScreen: const ItidalScreen(),
      nextScreen: const DudukScreen(),
    );
  }
}
