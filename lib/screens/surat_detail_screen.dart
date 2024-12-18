import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:audioplayers/audioplayers.dart';

class SurahDetailScreen extends StatefulWidget {
  final int surahNumber;
  final String surahName;

  const SurahDetailScreen({
    super.key,
    required this.surahNumber,
    required this.surahName,
  });

  @override
  _SurahDetailScreenState createState() => _SurahDetailScreenState();
}

class _SurahDetailScreenState extends State<SurahDetailScreen> {
  List<dynamic> ayatList = [];
  final AudioPlayer audioPlayer = AudioPlayer();
  String surahAudioUrl = '';
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchSurahDetail();
  }

  Future<void> fetchSurahDetail() async {
    try {
      final url = Uri.parse('https://equran.id/api/surat/${widget.surahNumber}');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          ayatList = data['ayat']; // Ambil daftar ayat
          surahAudioUrl = data['audio']; // Ambil URL audio surah
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
      await audioPlayer.play(UrlSource(surahAudioUrl));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error playing audio: $e')),
      );
    }
  }

  Widget _buildAyatList() {
    return ListView.builder(
      itemCount: ayatList.length,
      itemBuilder: (context, index) {
        var ayat = ayatList[index];
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8.0),
          child: ListTile(
            contentPadding: const EdgeInsets.all(16.0),
            title: Text(
              ayat['ar'], // Ayat dalam bahasa Arab
              style: const TextStyle(fontSize: 20, color: Colors.teal),
              textAlign: TextAlign.right,
            ),
            subtitle: Text(
              ayat['idn'], // Terjemahan
              style: const TextStyle(fontSize: 16, color: Colors.black87),
            ),
            leading: Text(
              '${ayat['nomor']}', // Nomor ayat
              style: const TextStyle(color: Colors.grey),
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
      appBar: AppBar(
        title: Text(widget.surahName),
        backgroundColor: Colors.teal,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ElevatedButton.icon(
                    onPressed: () => playSurahAudio(),
                    icon: const Icon(Icons.play_arrow),
                    label: const Text('Play Surah Audio'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
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
