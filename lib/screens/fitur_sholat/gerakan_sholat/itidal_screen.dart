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
      description: "Berdiri tegak setelah ruku' sambil mengucapkan bacaan i'tidal sebagai bentuk syukur dan pengakuan kebesaran Allah.",
      bacaan: "رَبَّنَا لَكَ الْحَمْدُ مِلْءَ السَّمَوَاتِ وَمِلْءَ الْأَرْضِ وَمِلْءَ مَا شِئْتَ مِنْ شَيْءٍ بَعْدُ \n\n(Robbanaa lakal hamdu mil us samawaati wamil ul ardhi wamil u maa syi’ta min syain ba’du)\n\nArtinya: \nYa Allah tuhan kami, bagimu segala puji sepenuh langit dan bumi, dan sepenuh sesuatu yang engkau kehendaki sesudah itu.",
      videoUrl: "https://youtu.be/OhBq9VDdNRw?si=_a3K0cJKTtmz85lG",
      previousScreen: const RukuScreen(),
      nextScreen: const SujudScreen(),
    );
  }
}
