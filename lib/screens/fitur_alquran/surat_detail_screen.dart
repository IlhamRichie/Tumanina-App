import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:audioplayers/audioplayers.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path; // Add prefix here
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SurahDetailScreen extends StatefulWidget {
  final int surahNumber;
  final String surahName;

  const SurahDetailScreen({
    super.key,
    required this.surahNumber,
    required this.surahName,
    int? initialAyat,
  });

  @override
  _SurahDetailScreenState createState() => _SurahDetailScreenState();
}

class _SurahDetailScreenState extends State<SurahDetailScreen> {
  List<dynamic> ayatList = [];
  final AudioPlayer audioPlayer = AudioPlayer();
  String surahAudioUrl = '';
  bool isLoading = true;
  bool isPlaying = false;
  bool hasInternet = true;
  String surahArt = '';
  int surahNumber = 0;
  List<String> bookmarkedAyat = [];

  @override
  void initState() {
    super.initState();
    _checkInternetConnection();
  }

  Future<void> _checkInternetConnection() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      setState(() {
        hasInternet = false;
      });
      _loadCachedData();
    } else {
      fetchSurahDetail();
    }
    loadBookmarks();
  }

  Future<void> fetchSurahDetail() async {
    try {
      final url = Uri.parse('https://equran.id/api/surat/${widget.surahNumber}');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        await _saveDataToFile(json.encode(data), 'surah_${widget.surahNumber}.json');

        setState(() {
          ayatList = data['ayat'];
          surahAudioUrl = data['audio'];
          surahArt = data['arti'];
          surahNumber = data['nomor'];
          isLoading = false;
        });
      } else {
        throw Exception('Gagal memuat detail surah');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      _showErrorSnackbar('Terjadi kesalahan. Mohon coba lagi.');
    }
  }

  Future<void> _loadCachedData() async {
    final String? cachedData = await _loadDataFromFile('surah_${widget.surahNumber}.json');

    if (cachedData != null) {
      final data = json.decode(cachedData);
      if (data['ayat'] != null) {
        setState(() {
          ayatList = data['ayat'];
          surahAudioUrl = data['audio'] ?? '';
          surahArt = data['arti'] ?? '';
          surahNumber = data['nomor'] ?? 0;
          isLoading = false;
        });
      } else {
        _showErrorSnackbar('Data ayat tidak tersedia.');
      }
    } else {
      _showErrorSnackbar('Tidak ada data tersimpan untuk surah ini.');
    }
  }

  Future<File> _saveDataToFile(String data, String fileName) async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File(path.join(directory.path, fileName));
    return file.writeAsString(data);
  }

  Future<String?> _loadDataFromFile(String fileName) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File(path.join(directory.path, fileName));
      if (await file.exists()) {
        return await file.readAsString();
      }
    } catch (e) {
      print("Error reading file: $e");
    }
    return null;
  }

  Future<void> playSurahAudio() async {
    if (surahAudioUrl.isEmpty) {
      _showErrorSnackbar('Audio tersedia saat online.');
      return;
    }

    try {
      await audioPlayer.setSourceUrl(surahAudioUrl);
      await audioPlayer.resume();
      setState(() {
        isPlaying = true;
      });
    } catch (e) {
      _showErrorSnackbar('Gagal memutar audio. Mohon coba lagi.');
    }
  }

  Future<void> pauseSurahAudio() async {
    try {
      await audioPlayer.pause();
      setState(() {
        isPlaying = false;
      });
    } catch (e) {
      _showErrorSnackbar('Gagal menjeda audio. Mohon coba lagi.');
    }
  }

  Future<void> loadBookmarks() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      bookmarkedAyat = prefs.getStringList('bookmarkedAyat') ?? [];
    });
  }

  Future<void> toggleBookmark(String ayatData) async {
    final prefs = await SharedPreferences.getInstance();
    if (bookmarkedAyat.contains(ayatData)) {
      setState(() {
        bookmarkedAyat.remove(ayatData);
      });
    } else {
      setState(() {
        bookmarkedAyat.add(ayatData);
      });
    }
    await prefs.setStringList('bookmarkedAyat', bookmarkedAyat);
  }

  void _showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error_outline, color: Colors.white),
            const SizedBox(width: 8),
            Text(
              message,
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: Colors.white,
              ),
            ),
          ],
        ),
        backgroundColor: const Color(0xFF004C7E),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF004C7E), Color(0xFF2DDCBE)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            widget.surahName,
            style: GoogleFonts.poppins(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Arti: $surahArt',
            style: GoogleFonts.poppins(
              fontSize: 16,
              color: Colors.white70,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Nomor Surat: $surahNumber',
            style: GoogleFonts.poppins(
              fontSize: 16,
              color: Colors.white70,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAyatList() {
    return ListView.builder(
      itemCount: ayatList.length,
      itemBuilder: (context, index) {
        var ayat = ayatList[index];
        String ayatData = '${widget.surahNumber}:${ayat['nomor']}';

        return Container(
          margin: const EdgeInsets.symmetric(vertical: 6.0),
          padding: const EdgeInsets.all(2.0),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF004C7E), Color(0xFF2DDCBE)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Container(
            padding: const EdgeInsets.all(12.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CircleAvatar(
                      backgroundColor: const Color(0xFF2DDCBE),
                      radius: 14,
                      child: Text(
                        '${ayat['nomor']}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        bookmarkedAyat.contains(ayatData)
                            ? Icons.bookmark
                            : Icons.bookmark_border,
                        color: bookmarkedAyat.contains(ayatData)
                            ? const Color(0xFF2DDCBE)
                            : Colors.grey,
                      ),
                      onPressed: () {
                        toggleBookmark(ayatData);
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    ayat['ar'],
                    style: GoogleFonts.amiri(
                      fontSize: 18,
                      color: const Color(0xFF004C7E),
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.right,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  ayat['tr'],
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontStyle: FontStyle.italic,
                    color: Colors.grey[700],
                  ),
                  textAlign: TextAlign.left,
                ),
                const SizedBox(height: 6),
                Text(
                  ayat['idn'],
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    color: Colors.black87,
                  ),
                  textAlign: TextAlign.left,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(widget.surahName, style: GoogleFonts.poppins()),
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
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: _buildHeader(),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton.icon(
                        onPressed: isPlaying ? null : playSurahAudio,
                        icon: const Icon(Icons.play_arrow),
                        label: const Text('Play'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF2DDCBE),
                          foregroundColor: Colors.white,
                        ),
                      ),
                      ElevatedButton.icon(
                        onPressed: isPlaying ? pauseSurahAudio : null,
                        icon: const Icon(Icons.pause),
                        label: const Text('Pause'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              isPlaying ? const Color(0xFF2DDCBE) : Colors.grey,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: _buildAyatList(),
                  ),
                ),
              ],
            ),
    );
  }
}