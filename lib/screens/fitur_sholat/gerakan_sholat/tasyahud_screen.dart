import 'package:flutter/material.dart';
import 'gerakan_detail_screen.dart';
import 'duduk_screen.dart';

class TasyahudScreen extends StatelessWidget {
  const TasyahudScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GerakanDetailScreen(
      title: "Tasyahud Akhir",
      description: "Duduklah dengan posisi kaki kanan tegak dan kaki kiri terlipat...",
      bacaan: "اَلتَّحِيَّاتُ ِللهِ...",
      videoPath: 'assets/videos/tasyahud.mp4',
      previousScreen: const DudukScreen(),
      nextScreen: null, // Tidak ada gerakan setelah Tasyahud Akhir
    );
  }
}
