import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:Tumanina/screens/fitur_doa/doa.dart';
import 'package:Tumanina/screens/fitur_doa/doa_detail_screen.dart';

class DoaScreen extends StatelessWidget {
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
    Doa(
      title: "Doa Ketika Mendengar Kabar Gembira",
      arabic: "الحَمْدُ لِلّهِ الَّذِي بِنِعْمَتِهِ تَتِمُّ الصَّالِحَاتُ",
      latin: "Alhamdulillahil ladzi bini’matihi tatimmus shalihat",
      translation:
          "Segala puji bagi Allah yang dengan nikmat-Nya sempurnalah segala kebaikan.",
      timeToRead: "Ketika mendengar kabar gembira",
    ),
    Doa(
      title: "Doa Ketika Terkejut atau Takjub",
      arabic: "سُبْحَانَ اللّٰهِ",
      latin: "Subhanallah",
      translation: "Maha Suci Allah.",
      timeToRead: "Saat terkejut atau takjub",
    ),
    Doa(
      title: "Doa Ketika Menghadapi Kesulitan",
      arabic: "حَسْبُنَا اللّهُ وَنِعْمَ الْوَكِيلُ",
      latin: "Hasbunallahu wa ni’mal wakil",
      translation:
          "Cukuplah Allah menjadi penolong kami, dan Dia sebaik-baik pelindung.",
      timeToRead: "Ketika menghadapi kesulitan",
    ),
    Doa(
      title: "Doa Ketika Memulai Pekerjaan",
      arabic: "اللّٰهُمَّ أَعِنِّي عَلَىٰ عَمَلِي وَبَارِكْ فِيهِ",
      latin: "Allahumma a’inni ‘ala ‘amali wa barik fihi",
      translation:
          "Ya Allah, bantulah aku dalam pekerjaanku dan berkahilah di dalamnya.",
      timeToRead: "Saat memulai pekerjaan",
    ),
    Doa(
      title: "Doa Ketika Terkena Penyakit",
      arabic:
          "اللّٰهُمَّ رَبَّ النَّاسِ أَذْهِبِ الْبَأْسَ اشْفِ أَنْتَ الشَّافِي لَا شِفَاءَ إِلَّا شِفَاؤُكَ شِفَاءً لَا يُغَادِرُ سَقَمًا",
      latin:
          "Allahumma rabban-naas adzhibil ba’sa, isyfi antas-syafi laa syifa-a illa syifa-uka, syifa-an laa yughadiru saqama.",
      translation:
          "Ya Allah, Tuhan seluruh manusia, hilangkanlah penyakit ini, sembuhkanlah, Engkau Maha Penyembuh. Tidak ada kesembuhan kecuali kesembuhan dari-Mu, kesembuhan yang tidak menyisakan rasa sakit.",
      timeToRead: "Ketika terkena penyakit",
    ),
    Doa(
      title: "Doa Ketika Mendengar Kabar Duka",
      arabic: "إِنَّا لِلَّهِ وَإِنَّا إِلَيْهِ رَاجِعُونَ",
      latin: "Innalillahi wa inna ilaihi raji’un",
      translation:
          "Sesungguhnya kami adalah milik Allah, dan kepada-Nya kami kembali.",
      timeToRead: "Ketika mendengar kabar duka",
    ),
    Doa(
      title: "Doa Memohon Kesabaran",
      arabic: "رَبَّنَا أَفْرِغْ عَلَيْنَا صَبْرًا وَتَوَفَّنَا مُسْلِمِينَ",
      latin: "Rabbana afrigh ‘alayna sabran wa tawaffana muslimin",
      translation:
          "Ya Tuhan kami, limpahkanlah kesabaran kepada kami dan wafatkanlah kami dalam keadaan Islam.",
      timeToRead: "Saat memohon kesabaran",
    ),
    Doa(
      title: "Doa Sebelum Wudhu",
      arabic: "بِسْمِ اللّهِ",
      latin: "Bismillah",
      translation: "Dengan nama Allah.",
      timeToRead: "Sebelum wudhu",
    ),
    Doa(
      title: "Doa Setelah Wudhu",
      arabic:
          "أَشْهَدُ أَنْ لَا إِلٰهَ إِلَّا اللّٰهُ وَحْدَهُ لَا شَرِيكَ لَهُ وَأَشْهَدُ أَنَّ مُحَمَّدًا عَبْدُهُ وَرَسُولُهُ",
      latin:
          "Asyhadu an laa ilaaha illallah, wahdahu laa syarikalah, wa asyhadu anna Muhammadan abduhu wa rasuluh",
      translation:
          "Aku bersaksi bahwa tidak ada Tuhan selain Allah, yang tidak ada sekutu bagi-Nya. Dan aku bersaksi bahwa Muhammad adalah hamba dan Rasul-Nya.",
      timeToRead: "Setelah wudhu",
    ),
    Doa(
      title: "Doa Ketika Akan Sholat",
      arabic: "اللّٰهُمَّ اجْعَلْ قَلْبِي خَاشِعًا فِيْ صَلَاتِيْ",
      latin: "Allahumma aj’al qalbi khashian fi shalati",
      translation: "Ya Allah, jadikanlah hatiku khusyuk dalam sholatku.",
      timeToRead: "Sebelum sholat",
    ),
    Doa(
      title: "Doa Memohon Kemudahan",
      arabic:
          "اللّهُمَّ لَا سَهْلَ إِلَّا مَا جَعَلْتَهُ سَهْلًا وَأَنْتَ تَجْعَلُ الحَزْنَ إِذَا شِئْتَ سَهْلًا",
      latin:
          "Allahumma laa sahla illa ma ja’altahu sahlan, wa anta taj’alul hazna idza syi’ta sahlan.",
      translation:
          "Ya Allah, tidak ada kemudahan kecuali apa yang Engkau mudahkan. Dan Engkau dapat menjadikan kesulitan itu mudah jika Engkau kehendaki.",
      timeToRead: "Saat memohon kemudahan",
    ),
    Doa(
      title: "Doa Ketika Mendapat Kesedihan",
      arabic: "اللّٰهُمَّ إِنِّي أَعُوذُ بِكَ مِنَ الْهَمِّ وَالْحُزْنِ",
      latin: "Allahumma inni a’udzu bika minal hammi wal hazan",
      translation:
          "Ya Allah, aku berlindung kepada-Mu dari rasa sedih dan duka.",
      timeToRead: "Ketika merasa sedih",
    )
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
        elevation: 0,
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
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DoaDetailScreen(doa: doa),
                  ),
                );
              },
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 8.0),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF004C7E), Color(0xFF2DDCBE)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16.0),
                ),
                padding: const EdgeInsets.all(3.0), // Ketebalan border
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white, // Warna latar dalam
                    borderRadius: BorderRadius.circular(14.0),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16),
                    title: Text(
                      doa.title,
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF004C7E),
                      ),
                    ),
                    subtitle: Text(
                      doa.timeToRead,
                      style: GoogleFonts.poppins(
                        color: Colors.grey,
                      ),
                    ),
                    trailing: const Icon(
                      Icons.arrow_forward_ios,
                      size: 16,
                      color: Colors.teal,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
