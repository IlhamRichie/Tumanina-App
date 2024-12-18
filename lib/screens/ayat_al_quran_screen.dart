import 'package:MyApp/screens/surat_detail_screen.dart';
import 'package:flutter/material.dart';
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
      appBar: AppBar(
        title: const Text('Daftar Surah Al-Quran'),
        backgroundColor: Colors.teal,
        centerTitle: true,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  TextField(
                    decoration: const InputDecoration(
                      hintText: 'Search surah...',
                      prefixIcon: Icon(Icons.search),
                    ),
                    onChanged: _filterSurahList,
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: filteredSurahList.length,
                      itemBuilder: (context, index) {
                        var surah = filteredSurahList[index];
                        String latinName = latinNames[surah.id] ?? surah.name;
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 8.0),
                          child: ListTile(
                            contentPadding: const EdgeInsets.all(16.0),
                            title: Text(
                              latinName, // Nama surah dalam tulisan latin
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  surah.translation, // Terjemahan surah
                                  style: const TextStyle(
                                      fontSize: 16, fontStyle: FontStyle.italic),
                                ),
                                Text(
                                  surah.name, // Nama Arab
                                  style: const TextStyle(
                                      fontSize: 14, color: Colors.grey),
                                ),
                              ],
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => SurahDetailScreen(
                                    surahNumber: surah.id,
                                    surahName: latinName,
                                  ),
                                ),
                              );
                            },
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
