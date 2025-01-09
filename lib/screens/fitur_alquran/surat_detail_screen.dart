import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:audioplayers/audioplayers.dart';
import 'package:google_fonts/google_fonts.dart';
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

  List<String> bookmarkedAyat = []; // List untuk bookmark

  @override
  void initState() {
    super.initState();
    fetchSurahDetail();
    loadBookmarks();
  }

  Future<void> fetchSurahDetail() async {
    try {
      final url =
          Uri.parse('https://equran.id/api/surat/${widget.surahNumber}');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          ayatList = data['ayat'];
          surahAudioUrl = data['audio'];
          isLoading = false;
        });
      } else {
        throw Exception('Gagal memuat detail surah');
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

  Future<void> playSurahAudio() async {
    if (surahAudioUrl.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Audio tidak tersedia untuk surah ini')),
      );
      return;
    }

    try {
      await audioPlayer.setSourceUrl(surahAudioUrl);
      await audioPlayer.resume();
      setState(() {
        isPlaying = true;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error playing audio: $e')),
      );
    }
  }

  Future<void> pauseSurahAudio() async {
    try {
      await audioPlayer.pause();
      setState(() {
        isPlaying = false;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error pausing audio: $e')),
      );
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
            'Surah Number: ${widget.surahNumber}',
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
          margin: const EdgeInsets.symmetric(vertical: 8.0),
          padding: const EdgeInsets.all(2.0),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF004C7E), Color(0xFF2DDCBE)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.all(16.0),
              title: Text(
                ayat['ar'],
                style: GoogleFonts.amiri(
                  fontSize: 16,
                  color: const Color(0xFF004C7E),
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.right,
              ),
              subtitle: Text(
                ayat['idn'],
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  color: Colors.black87,
                ),
              ),
              leading: CircleAvatar(
                backgroundColor: const Color(0xFF2DDCBE),
                child: Text(
                  '${ayat['nomor']}',
                  style: const TextStyle(color: Colors.white),
                ),
              ),
              trailing: IconButton(
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
