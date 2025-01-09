import 'dart:io';
import 'package:Tumanina/screens/fitur_alquran/surat_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

const Map<int, String> latinNames = {
  1: "Al-Fatihah",
  2: "Al-Baqarah",
  3: "Ali 'Imran",
  4: "An-Nisa'",
  5: "Al-Ma'idah",
  6: "Al-An'am",
  7: "Al-A'raf",
  8: "Al-Anfal",
  9: "At-Taubah",
  10: "Yunus",
  11: "Hud",
  12: "Yusuf",
  13: "Ar-Ra'd",
  14: "Ibrahim",
  15: "Al-Hijr",
  16: "An-Nahl",
  17: "Al-Isra'",
  18: "Al-Kahf",
  19: "Maryam",
  20: "Taha",
  21: "Al-Anbiya'",
  22: "Al-Hajj",
  23: "Al-Mu'minun",
  24: "An-Nur",
  25: "Al-Furqan",
  26: "Asy-Syu'ara'",
  27: "An-Naml",
  28: "Al-Qasas",
  29: "Al-Ankabut",
  30: "Ar-Rum",
  31: "Luqman",
  32: "As-Sajdah",
  33: "Al-Ahzab",
  34: "Saba'",
  35: "Fatir",
  36: "Yasin",
  37: "As-Saffat",
  38: "Sad",
  39: "Az-Zumar",
  40: "Ghafir",
  41: "Fussilat",
  42: "Asy-Syura",
  43: "Az-Zukhruf",
  44: "Ad-Dukhan",
  45: "Al-Jasiyah",
  46: "Al-Ahqaf",
  47: "Muhammad",
  48: "Al-Fath",
  49: "Al-Hujurat",
  50: "Qaf",
  51: "Az-Zariyat",
  52: "At-Tur",
  53: "An-Najm",
  54: "Al-Qamar",
  55: "Ar-Rahman",
  56: "Al-Waqi'ah",
  57: "Al-Hadid",
  58: "Al-Mujadalah",
  59: "Al-Hasyr",
  60: "Al-Mumtahanah",
  61: "As-Saff",
  62: "Al-Jumu'ah",
  63: "Al-Munafiqun",
  64: "At-Tagabun",
  65: "At-Talaq",
  66: "At-Tahrim",
  67: "Al-Mulk",
  68: "Al-Qalam",
  69: "Al-Haqqah",
  70: "Al-Ma'arij",
  71: "Nuh",
  72: "Al-Jinn",
  73: "Al-Muzzammil",
  74: "Al-Muddassir",
  75: "Al-Qiyamah",
  76: "Al-Insan",
  77: "Al-Mursalat",
  78: "An-Naba'",
  79: "An-Nazi'at",
  80: "Abasa",
  81: "At-Takwir",
  82: "Al-Infitar",
  83: "Al-Mutaffifin",
  84: "Al-Insyiqaq",
  85: "Al-Buruj",
  86: "At-Tariq",
  87: "Al-A'la",
  88: "Al-Gasyiyah",
  89: "Al-Fajr",
  90: "Al-Balad",
  91: "Asy-Syams",
  92: "Al-Lail",
  93: "Ad-Duha",
  94: "Asy-Syarh",
  95: "At-Tin",
  96: "Al-'Alaq",
  97: "Al-Qadr",
  98: "Al-Bayyinah",
  99: "Az-Zalzalah",
  100: "Al-Adiyat",
  101: "Al-Qari'ah",
  102: "At-Takasur",
  103: "Al-Asr",
  104: "Al-Humazah",
  105: "Al-Fil",
  106: "Quraisy",
  107: "Al-Ma'un",
  108: "Al-Kausar",
  109: "Al-Kafirun",
  110: "An-Nasr",
  111: "Al-Lahab",
  112: "Al-Ikhlas",
  113: "Al-Falaq",
  114: "An-Nas",
};

class AyatAlQuranScreen extends StatefulWidget {
  const AyatAlQuranScreen({super.key});

  @override
  _AyatAlQuranScreenState createState() => _AyatAlQuranScreenState();
}

class _AyatAlQuranScreenState extends State<AyatAlQuranScreen> {
  List<Surah> surahList = [];
  List<Surah> filteredSurahList = [];
  String searchQuery = '';
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchSurahList();
  }

  Future<void> fetchSurahList() async {
    try {
      setState(() {
        isLoading = true;
      });

      final url = Uri.parse('https://equran.id/api/surat');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          surahList = data.map((item) => Surah.fromJson(item)).toList();
          filteredSurahList = surahList;
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load surah list');
      }
    } on SocketException {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Mohon periksa koneksi internet Anda.')),
      );
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  void _filterSurahList(String query) {
    setState(() {
      searchQuery = query;
      filteredSurahList = surahList.where((surah) {
        String latinName = latinNames[surah.id] ?? surah.name;
        return latinName.toLowerCase().contains(query.toLowerCase());
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Alquran Digital',
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
      body: isLoading
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(
                    valueColor:
                        AlwaysStoppedAnimation<Color>(Color(0xFF2DDCBE)),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Memuat data...',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF004C7E),
                    ),
                  ),
                ],
              ),
            )
          : surahList.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.wifi_off, size: 100, color: Colors.grey),
                      const SizedBox(height: 20),
                      Text(
                        'Mohon periksa koneksi internet Anda.',
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          color: Colors.grey,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: fetchSurahList,
                        child: const Text('Coba Lagi'),
                      ),
                    ],
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      // Kotak Pencarian
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              const Color(0xFF004C7E),
                              const Color(0xFF2DDCBE)
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 6,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: 'Cari surah...',
                            hintStyle:
                                GoogleFonts.poppins(color: Colors.white70),
                            prefixIcon:
                                const Icon(Icons.search, color: Colors.white),
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 15),
                          ),
                          onChanged: _filterSurahList,
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      // List Surah
                      Expanded(
                        child: ListView.builder(
                          itemCount: filteredSurahList.length,
                          itemBuilder: (context, index) {
                            final surah = filteredSurahList[index];
                            String latinName =
                                latinNames[surah.id] ?? surah.name;

                            return Container(
                              margin:
                                  const EdgeInsets.symmetric(vertical: 10.0),
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [
                                    Color(0xFF004C7E),
                                    Color(0xFF2DDCBE)
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: BorderRadius.circular(16.0),
                              ),
                              child: Container(
                                margin: const EdgeInsets.all(
                                    2.0), // Space between border and content
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(16.0),
                                ),
                                child: Material(
                                  color: Colors.transparent,
                                  borderRadius: BorderRadius.circular(16.0),
                                  child: InkWell(
                                    borderRadius: BorderRadius.circular(16.0),
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              SurahDetailScreen(
                                            surahNumber: surah.id,
                                            surahName: latinName,
                                          ),
                                        ),
                                      );
                                    },
                                    child: ListTile(
                                      contentPadding:
                                          const EdgeInsets.all(10.0),
                                      title: Text(
                                        latinName,
                                        style: GoogleFonts.poppins(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: const Color(0xFF004C7E),
                                        ),
                                      ),
                                      subtitle: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            surah.translation,
                                            style: GoogleFonts.poppins(
                                              fontSize: 16,
                                              fontStyle: FontStyle.italic,
                                              color: const Color(0xFF757575),
                                            ),
                                          ),
                                          Text(
                                            surah.name,
                                            style: GoogleFonts.amiri(
                                              fontSize: 24,
                                              color: const Color(0xFF2DDCBE),
                                            ),
                                          ),
                                        ],
                                      ),
                                      trailing: Stack(
                                        alignment: Alignment.center,
                                        children: [
                                          Icon(
                                            Icons.bookmark,
                                            size: 70,
                                            color: const Color(0xFF004C7E),
                                          ),
                                          Positioned(
                                            top: 10,
                                            child: Text(
                                              '${surah.ayatCount}',
                                              style: GoogleFonts.poppins(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
    );
  }
}

class Surah {
  final int id;
  final String name;
  final String translation;
  final int ayatCount;

  Surah({
    required this.id,
    required this.name,
    required this.translation,
    required this.ayatCount,
  });

  factory Surah.fromJson(Map<String, dynamic> json) {
    return Surah(
      id: json['nomor'],
      name: json['nama'],
      translation: json['arti'],
      ayatCount: json['jumlah_ayat'],
    );
  }
}
