import 'package:flutter/material.dart';
import 'gerakan_detail_screen.dart';
import 'tahiyat_awwal_screen.dart';

class TahiyatAkhirScreen extends StatelessWidget {
  const TahiyatAkhirScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GerakanDetailScreen(
      title: "Tahiyat Akhir",
      description: "Duduk dengan tenang di akhir sholat sambil membaca tahiyat akhir, dilanjutkan dengan shalawat dan salam.",
      bacaan: "التَّحِيَّاتُ الْمُبَارَكَاتُ الصَّلَوَاتُ الطَّيِّبَاتُ لِلَّهِ السَّلاَمُ عَلَيْكَ أَيُّهَا النَّبِىُّ وَرَحْمَةُ اللَّهِ وَبَرَكَاتُهُ السَّلاَمُ عَلَيْنَا وَعَلَى عِبَادِ اللَّهِ الصَّالِحِينَ , أَشْهَدُ أَنْ لاَ إِلَهَ إِلاَّ اللَّهُ وَأَشْهَدُ أَنَّ مُحَمَّدًا عَبْدُهُ وَرَسُولُهُ , اللَّهُمَّ صَلِّ عَلَى مُحَمَّدٍ ، وَعَلَى آلِ مُحَمَّدٍوَعَلَى آلِ مُحَمَّدٍ ، كَمَا صَلَّيْتَ عَلَى إِبْرَاهِيمَ وَعَلَى آلِ إِبْرَاهِيمَ ، إِنَّكَ حَمِيدٌ مَجِيدٌ ، اللَّهُمَّ بَارِكْ عَلَى مُحَمَّدٍ ، وَعَلَى آلِ مُحَمَّدٍ ، كَمَا بَارَكْتَ عَلَى إِبْرَاهِيمَ ، وَعَلَى آلِ إِبْرَاهِيمَ ، إِنَّكَ حَمِيدٌ مَجِيدٌ\n\n(At tahiyyaatul mubaarakaatush shalawaatuth thoyyibaatulillaah. As salaamu'alaika ayyuhan nabiyyu wa rahmatullaahi wabarakaatuh, assalaamu'alaina wa'alaa ibaadillaahishaalihiin. asyhaduallaa ilaaha illallaah, wa asyhadu anna muhammad rasuulullaah.Aallaahumma shalli'alaa muhammad, wa'alaa aali muhammad. kamaa shallaita alaa ibraahiim wa alaa aali ibraahiim. Wabaarik'alaa muhammad wa alaa aali muhammad. kamaa baarakta alaa ibraahiim wa alaa aali ibraahiim, fil'aalamiina innaka hamiidum majiid.)\n\nArtinya: Ya Allah, limpahi lah rahmat atas keluarga Nabi Muhammad, seperti rahmat yang Engkau berikan kepada Nabi Ibrahim dan keluarganya. Dan limpahi lah berkah atas Nabi Muhammad beserta para keluarganya, seperti berkah yang Engkau berikan kepada Nabi Ibrahim dan keluarganya, Engkau lah Tuhan yang sangat terpuji lagi sangat mulia diseluruh alam",
      videoUrl: "https://youtu.be/U6HmKI6vTtI?si=xadSaYWKcRdi0xyC",
      previousScreen: const TahiyatAwwalScreen(),
      nextScreen: null,
    );
  }
}
