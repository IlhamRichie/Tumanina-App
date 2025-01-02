import 'package:flutter/material.dart';
import 'package:Tumanina/screens/fitur_doa/doa_detail_screen.dart';
import 'package:google_fonts/google_fonts.dart';

// Data Doa
class Doa {
  final String title;
  final String arabic;
  final String latin;
  final String translation;
  final String timeToRead;

  Doa(
      {required this.title,
      required this.arabic,
      required this.latin,
      required this.translation,
      required this.timeToRead});
}

class DoaScreen extends StatelessWidget {
  // Daftar doa sehari-hari
  final List<Doa> doaList = [
    Doa(
      title: "Doa Sebelum Tidur",
      arabic: "بِسْمِكَ اللّٰهُمَّ أَمُوتُ وَأَحْيَا",
      latin: "Bismika Allahumma amutu wa ahya",
      translation: "Dengan nama-Mu, ya Allah, aku mati dan aku hidup.",
      timeToRead: "Sebelum tidur",
    ),
    Doa(
      title: "Doa Bangun Tidur",
      arabic:
          "الحَمْدُ لِلّٰهِ الَّذِي أَحْيَانَا بَعْدَ مَا أَمَاتَنَا وَإِلَيْهِ النُّشُورُ",
      latin:
          "Alhamdu lillahi alladzi ahyana ba'da ma amatana wa ilaihin nushur",
      translation:
          "Segala puji bagi Allah yang telah menghidupkan kami setelah mematikan kami, dan hanya kepada-Nya kami akan kembali.",
      timeToRead: "Setelah bangun tidur",
    ),
    Doa(
      title: "Doa Masuk WC",
      arabic: "اللّٰهُمَّ إِنِّي أَعُوذُ بِكَ مِنَ الْخُبْثِ وَالْخَبَائِثِ",
      latin: "Allahumma inni a'udzu bika minal khubutsi wal khaba'its",
      translation:
          "Ya Allah, aku berlindung kepada-Mu dari kejahatan makhluk jin dan setan.",
      timeToRead: "Saat masuk WC",
    ),
    Doa(
      title: "Doa Keluar WC",
      arabic: "غُفْرَانَكَ",
      latin: "Ghufranaka",
      translation: "Aku memohon ampunan-Mu ya Allah.",
      timeToRead: "Saat keluar WC",
    ),
    Doa(
      title: "Doa Sebelum Makan",
      arabic:
          "اَللّٰهُمَّ بَارِكْ لَنَا فِيْمَا رَزَقْتَنَا وَقِنَا عَذَابَ النَّارِ",
      latin: "Allahumma baarik lanaa fiimaa rozaqtanaa wa qinaa 'adzaa bannaar",
      translation: "Dengan nama Allah, dan atas nama-Mu kami makan.",
      timeToRead: "Sebelum makan",
    ),
    Doa(
      title: "Doa Sesudah Makan",
      arabic:
          "الحَمْدُ لِلّٰهِ الَّذِي أَطْعَمَنَا وَسَقَانَا وَجَعَلَنَا مِنَ المُسْلِمِينَ",
      latin:
          "Alhamdu lillahi alladzi ath'amana wa saqana wa ja'alna minal muslimin",
      translation:
          "Segala puji bagi Allah yang telah memberi makan dan minum kepada kami, serta menjadikan kami sebagai orang-orang Muslim.",
      timeToRead: "Sesudah makan",
    ),
    Doa(
      title: "Doa Ketika Hujan Turun",
      arabic: "اللّٰهُمَّ صَيِّبًا نَافِعًا",
      latin: "Allahumma shayyiban nafi'an",
      translation: "Ya Allah, turunkanlah hujan yang bermanfaat.",
      timeToRead: "Saat hujan turun",
    ),
    Doa(
      title: "Doa Ketika Ada Petir",
      arabic:
          "سُبْحَانَ الَّذِي يُسَبِّحُ الرَّعْدُ بِحَمْدِهِ وَالْمَلَائِكَةُ مِنْ خِيفَتِهِ",
      latin:
          "Subhanalladzi yusabbihur ra'du bihamdihi wal malaikatu min khifatihi",
      translation:
          "Maha Suci Allah yang guruh bertasbih dengan memuji-Nya, begitu pula para malaikat karena takut kepada-Nya.",
      timeToRead: "Saat mendengar petir",
    ),
    Doa(
      title: "Doa Ketika Hendak Bepergian",
      arabic:
          "اللّٰهُمَّ إِنَّا نَسْأَلُكَ فِي سَفَرِنَا هٰذَا البِرَّ وَالتَّقْوَىٰ وَمِنَ العَمَلِ مَا تَرْضَىٰ",
      latin:
          "Allahumma inna nas'aluka fi safarina hadzal birra wat-taqwa wa minal 'amali ma tardha",
      translation:
          "Ya Allah, kami memohon kepada-Mu kebaikan dan ketakwaan dalam perjalanan ini, serta amal yang Engkau ridai.",
      timeToRead: "Saat hendak bepergian",
    ),
    Doa(
      title: "Doa Ketika Sampai di Tujuan",
      arabic:
          "اللّٰهُمَّ أَنْزِلْنِي مُنْزَلًا مُبَارَكًا وَأَنْتَ خَيْرُ المُنْزِلِينَ",
      latin: "Allahumma anzilni munzalan mubarakan wa anta khairul munzilin",
      translation:
          "Ya Allah, turunkan aku di tempat yang penuh berkah, dan Engkau adalah sebaik-baik pemberi tempat.",
      timeToRead: "Saat sampai di tujuan",
    ),
    Doa(
      title: "Doa Sebelum Belajar",
      arabic: "رَبِّ زِدْنِي عِلْمًا وَارْزُقْنِي فَهْمًا",
      latin: "Rabbi zidni 'ilman warzuqni fahman",
      translation:
          "Ya Tuhanku, tambahkanlah aku ilmu, dan berilah aku pemahaman.",
      timeToRead: "Sebelum belajar",
    ),
    Doa(
      title: "Doa Sesudah Belajar",
      arabic:
          "اللّٰهُمَّ انْفَعْنِي بِمَا عَلَّمْتَنِي وَعَلِّمْنِي مَا يَنْفَعُنِي وَزِدْنِي عِلْمًا",
      latin:
          "Allahumma anfa'ni bima 'allamtani wa 'allimni ma yanfa'uni wa zidni 'ilman",
      translation:
          "Ya Allah, manfaatkanlah ilmu yang telah Engkau ajarkan kepadaku, ajarkanlah aku ilmu yang bermanfaat, dan tambahkanlah aku ilmu.",
      timeToRead: "Sesudah belajar",
    ),
    Doa(
      title: "Doa Ketika Menyusui",
      arabic: "اللّٰهُمَّ اجْعَلْنِي وَذُرِّيَتِي مِنَ الصَّالِحِينَ",
      latin: "Allahumma aj'alni wa dzurriyati minash shalihin",
      translation:
          "Ya Allah, jadikanlah aku dan keturunanku termasuk golongan orang-orang yang saleh.",
      timeToRead: "Saat menyusui",
    ),
    Doa(
      title: "Doa Ketika Menggendong Anak",
      arabic:
          "رَبَّنَا هَبْ لَنَا مِنْ أَزْوَاجِنَا وَذُرِّيَاتِنَا قُرَّةَ أَعْيُنٍ وَاجْعَلْنَا لِلْمُتَّقِينَ إِمَامًا",
      latin:
          "Rabbana hablana min azwajina wa dzurriyatina qurrata a'yunin waj'alna lil muttaqina imama",
      translation:
          "Ya Tuhan kami, anugerahkanlah kepada kami pasangan dan keturunan sebagai penyejuk hati kami, dan jadikanlah kami pemimpin bagi orang-orang yang bertakwa.",
      timeToRead: "Saat menggendong anak",
    ),
    Doa(
      title: "Doa Ketika Akan Tidur Siang",
      arabic:
          "اللّٰهُمَّ اجْعَلْ نَوْمَنَا رَاحَةً لِبَدَنِنَا وَقُوَّةً لِعَمَلِنَا",
      latin:
          "Allahumma aj'al naumana rahatan libadanina wa quwwatan li'amalina",
      translation:
          "Ya Allah, jadikanlah tidur siang kami sebagai istirahat untuk badan kami dan kekuatan untuk amal kami.",
      timeToRead: "Saat akan tidur siang",
    ),
    Doa(
      title: "Doa Ketika Masuk Masjid",
      arabic: "اللّهُمَّ افْتَحْ لِي أَبْوَابَ رَحْمَتِكَ",
      latin: "Allahummaftah lii abwaaba rahmatika.",
      translation: "Ya Allah, bukakanlah untukku pintu-pintu rahmat-Mu.",
      timeToRead: "Saat masuk masjid",
    ),
    Doa(
      title: "Doa Ketika Keluar Masjid",
      arabic: "اللّهُمَّ إِنِّي أَسْأَلُكَ مِنْ فَضْلِكَ",
      latin: "Allahumma innii as-aluka min fadhlika.",
      translation:
          "Ya Allah, sesungguhnya aku memohon kepada-Mu keutamaan dari-Mu.",
      timeToRead: "Saat keluar masjid",
    ),
    Doa(
      title: "Doa Ketika Memakai Pakaian Baru",
      arabic:
          "اللّهُمَّ لَكَ الْحَمْدُ كَمَا كَسَوْتَنِيهِ أَسْأَلُكَ خَيْرَهُ وَخَيْرَ مَا صُنِعَ لَهُ وَأَعُوذُ بِكَ مِنْ شَرِّهِ وَشَرِّ مَا صُنِعَ لَهُ",
      latin:
          "Allahumma lakal hamdu kama kasautaniihi as-aluka khairahu wa khaira ma shuni’a lahu wa a’udzu bika min syarrihi wa syarri ma shuni’a lahu.",
      translation:
          "Ya Allah, segala puji hanya untuk-Mu sebagaimana Engkau telah memakaikan pakaian ini kepadaku. Aku memohon kebaikannya dan kebaikan dari apa yang dibuat untuknya, serta aku berlindung kepada-Mu dari kejelekannya dan kejelekan dari apa yang dibuat untuknya.",
      timeToRead: "Saat memakai pakaian baru",
    ),
    Doa(
      title: "Doa Ketika Bercermin",
      arabic: "اللّهُمَّ كَمَا أَحْسَنْتَ خَلْقِي فَحَسِّنْ خُلُقِي",
      latin: "Allahumma kamaa ahsanta kholqii fahassin khuluqii.",
      translation:
          "Ya Allah, sebagaimana Engkau telah memperindah kejadianku, maka perindahlah akhlakku.",
      timeToRead: "Saat bercermin",
    ),
    Doa(
      title: "Doa Ketika Mendengar Petir",
      arabic:
          "سُبْحَانَ الَّذِي يُسَبِّحُ الرَّعْدُ بِحَمْدِهِ وَالْمَلَائِكَةُ مِنْ خِيفَتِهِ",
      latin:
          "Subhaanal ladzi yusabbihur ra’du bihamdihi wal malaa-ikatu min khifatihi.",
      translation:
          "Maha Suci Allah yang petir bertasbih dengan memuji-Nya, begitu pula para malaikat karena takut kepada-Nya.",
      timeToRead: "Ketika mendengar petir",
    ),
    Doa(
      title: "Doa Ketika Melihat Hilal",
      arabic:
          "اللّهُمَّ أَهِلَّهُ عَلَيْنَا بِالْأَمْنِ وَالْإِيمَانِ وَالسَّلَامَةِ وَالإِسْلاَمِ وَالتَّوْفِيقِ لِمَا تُحِبُّ وَتَرْضَى",
      latin:
          "Allahumma ahillahu ‘alaynaa bil amni wal iimaan, wassalaamati wal islaam, wat tawfiiqi limaa tuhibbu wa tardhaa.",
      translation:
          "Ya Allah, munculkanlah hilal kepada kami dengan keamanan, iman, keselamatan, Islam, dan taufik kepada apa yang Engkau cintai dan ridhai.",
      timeToRead: "Saat melihat hilal",
    ),
    Doa(
      title: "Doa Ketika Bersin",
      arabic: "الحَمْدُ لِلّهِ",
      latin: "Alhamdulillah.",
      translation: "Segala puji bagi Allah.",
      timeToRead: "Setelah bersin",
    ),
    Doa(
      title: "Doa Ketika Mendengar Orang Bersin",
      arabic: "يَرْحَمُكَ اللَّهُ",
      latin: "Yarhamukallah.",
      translation: "Semoga Allah merahmatimu.",
      timeToRead: "Ketika mendengar orang bersin",
    ),
    Doa(
      title: "Doa Ketika Melihat Orang Sakit",
      arabic:
          "الحَمْدُ لِلّهِ الَّذِي عَافَانِي مِمَّا ابْتَلَاكَ بِهِ وَفَضَّلَنِي عَلَى كَثِيرٍ مِمَّنْ خَلَقَ تَفْضِيلًا",
      latin:
          "Alhamdulillahil ladzi ‘aafaani mimmaab talaaka bihi wa fadh-dholanii ‘ala katsiirin mimman kholaq tafdhiilaa.",
      translation:
          "Segala puji bagi Allah yang telah menyelamatkan aku dari apa yang menimpamu dan yang telah memberikan keutamaan kepadaku atas kebanyakan makhluk-Nya.",
      timeToRead: "Ketika melihat orang sakit",
    ),
    Doa(
      title: "Doa Ketika Melihat Orang Mendapat Musibah",
      arabic:
          "إِنَّا لِلَّهِ وَإِنَّا إِلَيْهِ رَاجِعُونَ، اللّهُمَّ أْجُرْنِي فِي مُصِيبَتِي وَاخْلُفْ لِي خَيْرًا مِنْهَا",
      latin:
          "Innalillahi wa inna ilaihi raaji’uun, Allahumma ajurnii fii mushiibatii wakhluf lii khairan minhaa.",
      translation:
          "Sesungguhnya kami milik Allah dan kepada-Nya kami kembali. Ya Allah, berilah aku ganjaran dalam musibahku ini dan gantikanlah untukku yang lebih baik darinya.",
      timeToRead: "Ketika melihat orang mendapat musibah",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Doa Sehari-hari',
          style: GoogleFonts.poppins(
            color: const Color(0xFF004C7E),
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
          itemCount: doaList.length,
          itemBuilder: (context, index) {
            final doa = doaList[index];
            return Container(
              margin: const EdgeInsets.symmetric(vertical: 5.0),
              decoration: BoxDecoration(
                // Apply gradient border here
                border: Border.all(
                  width: 2.0,
                  color: Colors
                      .transparent, // transparent to make it a border effect
                ),
                borderRadius: BorderRadius.circular(16.0),
                gradient: LinearGradient(
                  colors: [Color(0xFF004C7E), Color(0xFF2DDCBE)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Container(
                decoration: BoxDecoration(
                  color:
                      Colors.white, // Set the background color inside the card
                  borderRadius: BorderRadius.circular(16.0),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(16),
                  title: Text(
                    doa.title,
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF004C7E),
                    ),
                  ),
                  subtitle: Text(
                    doa.timeToRead,
                    style: GoogleFonts.poppins(
                      color: Colors.grey,
                    ),
                  ),
                  trailing: Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: Colors.teal,
                  ),
                  onTap: () {
                    // Navigate to the Doa Detail Screen
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DoaDetailScreen(doa: doa),
                      ),
                    );
                  },
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
