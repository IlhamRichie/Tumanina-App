import 'package:flutter/material.dart';
import 'itidal_screen.dart';
import 'duduk_screen.dart';
import 'gerakan_detail_screen.dart';

class SujudScreen extends StatelessWidget {
  const SujudScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GerakanDetailScreen(
      title: "Sujud",
      description: "Sujud dilakukan dengan meletakkan dahi, hidung, kedua telapak tangan, kedua lutut, dan ujung jari-jari kaki di lantai. Posisi tubuh harus tenang dan tidak terburu-buru. Sujud adalah momen untuk merendahkan diri di hadapan Allah SWT.",
      bacaan: "سُبْحَانَ رَبِّيَ الأَعْلَى وَبِحَمْدِهِ\n\n(Subhāna Rabbiyal A‘lā wa Bihamdih 3x)\n\nArtinya: Maha Suci Tuhanku Yang Maha Tinggi dan segala puji bagi-Nya.",
      videoUrl: "https://youtu.be/FoOrVllE_CI?si=wSuSK0r3MkOQEjKb",
      previousScreen: const ItidalScreen(),
      nextScreen: const DudukScreen(),
    );
  }
}
