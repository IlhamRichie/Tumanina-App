import 'package:flutter/material.dart';
import 'gerakan_detail_screen.dart';
import 'duduk_screen.dart';
import 'tahiyat_akhir_screen.dart';

class TahiyatAwwalScreen extends StatelessWidget {
  const TahiyatAwwalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GerakanDetailScreen(
      title: "Tahiyat Awal",
      description: "Duduk bersila di rakaat kedua sholat untuk membaca tahiyat awal. Posisi tangan kanan menggenggam jari kecuali telunjuk yang diangkat.",
      bacaan: "التَّحِيَّاتُ الْمُبَارَكَاتُ الصَّلَوَاتُ الطَّيِّبَاتُ لِلَّهِ السَّلاَمُ عَلَيْكَ أَيُّهَا النَّبِىُّ وَرَحْمَةُ اللَّهِ وَبَرَكَاتُهُ السَّلاَمُ عَلَيْنَا وَعَلَى عِبَادِ اللَّهِ الصَّالِحِينَ أَشْهَدُ أَنْ لاَ إِلَهَ إِلاَّ اللَّهُ وَأَشْهَدُ أَنَّ مُحَمَّدًا رَسُولُ اللَّهِاَ . للَّهُمَّ صَلِّ عَلىَ مُحَمَّدٍ\n\n (At tahiyyaatul mubaarakaatush shalawaatuth thoyyibaatulillaah. As salaamu'alaika ayyuhan nabiyyu wa rahmatullaahi wabarakaatuh, assalaamu'alaina wa'alaa ibaadillaahishaalihiin. asyhaduallaa ilaaha illallaah, wa asyhadu anna muhammad rasuulullaah.\n\nArtinya: Ya Allah, limpahi lah rahmat atas keluarga Nabi Muhammad, seperti rahmat yang Engkau berikan kepada Nabi Ibrahim dan keluarganya. Dan limpahi lah berkah atas Nabi Muhammad beserta para keluarganya, seperti berkah yang Engkau berikan kepada Nabi Ibrahim dan keluarganya, Engkau lah Tuhan yang sangat terpuji lagi sangat mulia diseluruh alam.)",
      videoUrl: "https://youtu.be/UVSTcTMPuqA?si=MRmI20kNw4nGthKr",
      previousScreen: const DudukScreen(),
      nextScreen: const TahiyatAkhirScreen(),
    );
  }
}
