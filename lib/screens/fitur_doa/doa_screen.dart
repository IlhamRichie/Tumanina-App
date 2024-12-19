import 'package:MyApp/screens/fitur_doa/doa_detail_screen.dart';
import 'package:flutter/material.dart';

// Data Doa
class Doa {
  final String title;
  final String arabic;
  final String translation;
  final String timeToRead;

  Doa(
      {required this.title,
      required this.arabic,
      required this.translation,
      required this.timeToRead});
}

class DoaScreen extends StatelessWidget {
  // Daftar doa sehari-hari
  final List<Doa> doaList = [
    Doa(
      title: "Doa Sebelum Tidur",
      arabic: "بِسْمِكَ اللهم أَمُوتُ وَأَحْيَا",
      translation: "Dengan nama-Mu Ya Allah, aku mati dan aku hidup.",
      timeToRead: "Sebelum tidur",
    ),
    Doa(
      title: "Doa Bangun Tidur",
      arabic:
          "الحَمْدُ لِلّهِ الَّذِي أَحْيَانَا بَعْدَ مَا أَمَاتَنَا وَإِلَيْهِ النُّشُورُ",
      translation:
          "Segala puji bagi Allah yang telah menghidupkan kami setelah mematikan kami, dan kepada-Nya kami kembali.",
      timeToRead: "Setelah bangun tidur",
    ),
    Doa(
      title: "Doa Masuk WC",
      arabic:
          "بِسْمِ اللّهِ اللّهُمَّ إِنِّي أَعُوذُ بِكَ مِنَ الْخُبُثِ وَالْخَبَائِثِ",
      translation:
          "Dengan nama Allah, Ya Allah, aku berlindung kepada-Mu dari keburukan dan keburukan makhluk-Mu.",
      timeToRead: "Sebelum masuk WC",
    ),
    Doa(
      title: "Doa Keluar WC",
      arabic: "غُفْرَانَكَ",
      translation: "Ampunan-Mu ya Allah.",
      timeToRead: "Setelah keluar WC",
    ),
    Doa(
      title: "Doa Sebelum Makan",
      arabic: "بِسْمِ اللّهِ وَعَلَىٰ بَرَكَةِ اللّهِ",
      translation: "Dengan nama Allah dan atas berkah Allah.",
      timeToRead: "Sebelum makan",
    ),
    Doa(
      title: "Doa Sesudah Makan",
      arabic:
          "الحَمْدُ لِلّهِ الَّذِي أَطْعَمَنَا وَسَقَانَا وَجَعَلَنَا مُسْلِمِينَ",
      translation:
          "Segala puji bagi Allah yang telah memberi makan dan minum kami, serta menjadikan kami sebagai umat Islam.",
      timeToRead: "Sesudah makan",
    ),
    Doa(
      title: "Doa Perjalanan",
      arabic:
          "اللّهُ أكْبَرُ اللّهُ أكْبَرُ اللّهُ أكْبَرُ سُبْحَانَ الَّذِي سَخَّرَ لَنَا هَذَا وَمَا كُنَّا لَهُ مُقْرِنِينَ",
      translation:
          "Allah Maha Besar, Allah Maha Besar, Allah Maha Besar. Maha Suci Allah yang telah menundukkan bagi kami kendaraan ini, padahal kami sebelumnya tidak mampu mengendalikannya.",
      timeToRead: "Sebelum berpergian",
    ),
    Doa(
      title: "Doa Saat Hujan",
      arabic: "اللّهُمَّ صَيِّبًا نَافِعًا",
      translation: "Ya Allah, turunkan hujan yang bermanfaat.",
      timeToRead: "Saat hujan turun",
    ),
    Doa(
      title: "Doa Masuk Rumah",
      arabic:
          "بِسْمِ اللّهِ وَلَجْنَا وَبِسْمِ اللّهِ خَرَجْنَا وَعَلَى اللّهِ رَبِّنَا تَوَكَّلْنَا",
      translation:
          "Dengan nama Allah kami masuk dan dengan nama Allah kami keluar, dan hanya kepada Allah, Tuhan kami, kami bertawakal.",
      timeToRead: "Saat masuk rumah",
    ),
    Doa(
      title: "Doa Ketika Mendengar Azan",
      arabic:
          "اللّهُمَّ رَبَّ هَذِهِ الدَّعْوَةِ التَّامَّةِ وَالصَّلَاةِ الْقَائِمَةِ آتِ مُحَمَّدًا الْوَسِيلَةَ وَالْفَضِيلَةَ وَابْعَثْهُ مَقَامًا مَّحْمُودًا الَّذِي وَعَدتَّهُ",
      translation:
          "Ya Allah, Tuhan pemilik seruan yang sempurna ini dan shalat yang didirikan, berikanlah kepada Nabi Muhammad wasilah dan keutamaan, serta tempat yang terpuji yang telah Engkau janjikan padanya.",
      timeToRead: "Ketika mendengar azan",
    ),
    Doa(
      title: "Doa Ketika Sakit",
      arabic:
          "اللّهُمَّ رَبَّ النَّاسِ أَذْهِبْ الْبَاسَ اشْفِهِ أَنْتَ الشَّافِي لَا شِفَاءَ إِلَّا شِفَاؤُكَ شِفَاءً لَا يُغَادِرُ سَقَمًا",
      translation:
          "Ya Allah, Tuhan seluruh umat manusia, hilangkan penyakit ini, sembuhkanlah dia, Engkaulah yang Maha Penyembuh, tidak ada kesembuhan kecuali kesembuhan dari-Mu, kesembuhan yang tidak meninggalkan penyakit.",
      timeToRead: "Saat sakit",
    ),
    Doa(
      title: "Doa Untuk Anak",
      arabic:
          "رَبِّ هَبْ لِي مِن لَّدُنكَ ذُرِّيَّةً طَيِّبَةً إِنَّكَ سَمِيعُ الدُّعَاء",
      translation:
          "Ya Tuhanku, anugerahkanlah kepadaku keturunan yang baik, sesungguhnya Engkau Maha Mendengar doa.",
      timeToRead: "Untuk anak",
    ),
    Doa(
      title: "Doa Untuk Orang Tua",
      arabic:
          "رَبِّ اغْفِرْ لِي وَلِوَالِدَيَّ وَلِلْمُؤْمِنِينَ يَوْمَ يَقُومُ الْحِسَاب",
      translation:
          "Ya Tuhanku, ampunilah aku, kedua orang tuaku, dan orang-orang yang beriman pada hari terjadinya perhitungan amal.",
      timeToRead: "Untuk orang tua",
    ),
    Doa(
      title: "Doa Untuk Meminta Rizki",
      arabic:
          "اللّهُمَّ إِنِّي أَسْأَلُكَ رَحْمَتَكَ وَالْفَجْرَ وَالْخَيْرَ وَالْعَافِيَةَ وَالْغِنَى وَالرَّحْمَةَ",
      translation:
          "Ya Allah, aku memohon rahmat-Mu, keberkahan, kebaikan, kesehatan, kekayaan, dan kasih sayang.",
      timeToRead: "Saat membutuhkan rizki",
    ),
    Doa(
      title: "Doa Agar Terhindar Dari Fitnah",
      arabic:
          "اللّهُمَّ إِنَّا نَعُوذُ بِكَ مِنْ فِتْنَةِ الدُّنْيَا وَمَا فِيهَا وَمِنْ فِتْنَةِ الْمَسِيحِ الدَّجَّالِ",
      translation:
          "Ya Allah, kami berlindung kepada-Mu dari fitnah dunia dan segala isinya serta dari fitnah Dajjal.",
      timeToRead: "Untuk menghindari fitnah",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Doa Sehari-hari')),
      body: ListView.builder(
        itemCount: doaList.length,
        itemBuilder: (context, index) {
          final doa = doaList[index];
          return ListTile(
            title: Text(doa.title),
            onTap: () {
              // Arahkan ke layar detail doa
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DoaDetailScreen(doa: doa),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
