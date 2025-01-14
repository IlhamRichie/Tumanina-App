import 'package:Tumanina/screens/fitur_sholat/gerakan_sholat/tahiyat_awwal_screen.dart';
import 'package:flutter/material.dart';
import 'gerakan_detail_screen.dart';
import 'sujud_screen.dart';

class DudukScreen extends StatelessWidget {
  const DudukScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GerakanDetailScreen(
      title: "Duduk di antara Dua Sujud",
      description: "رَبِّ اغْفِرْ لِي وَارْحَمْنِي وَاجْبُرْنِي وَارْفَعْنِي وَارْزُقْنِي وَاهْدِنِي وَعَافَنِي وَاعْفُ عَنِّي  \n\nDuduk sejenak setelah sujud pertama dengan posisi tangan di atas paha dan mengucapkan doa pengampunan.",
      bacaan: " \n(Rabbighfir lī warḥamnī wajburnī warfa‘nī warzuqnī wahdinī wa‘āfinī wa‘fu ‘annī)\n\nArtinya: Ya Tuhanku, ampunilah aku, rahmatilah aku, cukupkanlah aku, angkatlah derajatku, berilah aku rezeki, tunjukilah aku, sehatkanlah aku, dan maafkanlah aku.",
      videoUrl: "https://youtu.be/2CprIGVZDDU?si=9at1nH75pJhU4l7M",
      previousScreen: const SujudScreen(),
      nextScreen: const TahiyatAwwalScreen(),
    );
  }
}
