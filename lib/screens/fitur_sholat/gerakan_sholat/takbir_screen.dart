import 'package:flutter/material.dart';
import 'gerakan_detail_screen.dart';
import 'ruku_screen.dart';

class TakbirScreen extends StatelessWidget {
  const TakbirScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GerakanDetailScreen(
      title: "Takbiratul Ihram",
      description: "Berdiri tegak mengangkat kedua tangan sejajar dengan telinga sambil membaca takbir. Ini adalah gerakan awal sholat yang menandakan masuknya ke dalam sholat.",
      bacaan: "اَللهُ أَكْبَرُ كَبِيْرًا وَالْحَمْدُ ِللهِ كَثِيْرًا وَسُبْحَانَ اللهِ بُكْرَةً وَأَصِيْلاً. وَجَّهْتُ وَجْهِيَ لِلَّذِيْ فَطَرَالسَّمَاوَاتِ وَاْلأَرْضَ حَنِيْفًا مُسْلِمًا وَمَا أَنَا مِنَ الْمُشْرِكِيْنَ. إِنَّ صَلاَتِيْ وَنُسُكِيْ وَمَحْيَايَ وَمَمَاتِيْ لِلهِ رَبِّ الْعَالَمِيْنَ. لاَشَرِيْكَ لَهُ وَبِذلِكَ أُمِرْتُ وَأَنَا مِنَ الْمُسْلِمِيْنَ \n\n(Allâhu Akbar kabîra wal hamdu lillâhi katsîra, wa subhânallâhi bukratan wa ashîla. Wajjahtu wajhiya lilladzî fatharas samâwâti wal ardha hanîfan muslimaw wa mâ ana minal mushrikîn. Inna shalâtî wa nusukî wa mahyâya wa mamâtî lillâhi Rabbil ‘âlamîn. Lâ syariikalahu wa bidzâlika umirtu wa ana minal muslimîn.)\n\nArtinya: \nAllah Maha Besar dengan sebesar-besarnya. Segala puji yang sebanyak-banyaknya bagi Allah. Maha Suci Allah pada pagi dan petang hari. Aku menghadapkan wajahku kepada Tuhan yang telah menciptakan langit dan bumi dengan segenap kepatuhan dan kepasrahan diri, dan aku bukanlah termasuk orang-orang yang menyekutukan-Nya. Sesungguhnya sholatku, ibadahku, hidup dan matiku hanyalah kepunyaan Allah, Tuhan semesta alam, yang tiada satu pun sekutu bagi-Nya. Dengan semua itulah aku diperintahkan dan aku adalah termasuk orang-orang yang berserah diri (muslim).",
      videoUrl: "https://youtu.be/Z3u7gMBrmag?si=AWuHy4Qy29gGbV-p",
      previousScreen: null,
      nextScreen: const RukuScreen(),
    );
  }
}
