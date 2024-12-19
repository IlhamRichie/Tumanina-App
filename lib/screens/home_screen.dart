import 'package:MyApp/screens/fitur_sholat/belajar_sholat_screen.dart';
import 'package:MyApp/screens/kiblat_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'pantau_sholat_screen.dart';
import 'surat_detail_screen.dart';
import 'waktu_sholat_screen.dart';
import 'chat_screen.dart';
import 'tasbih_screen.dart';
import 'ayat_al_quran_screen.dart';
import 'login_screen.dart';
import 'profile_screen.dart';
import 'fitur_doa/doa_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Map<String, String> prayerTimes = {};
  String nextPrayer = '';
  String timeRemaining = '';
  List<Surah> surahList = [];
  bool isLoading = false;

  // Milestone status untuk setiap sholat
  Map<String, bool> sholatMilestones = {
    'Shubuh': false,
    'Dzuhur': false,
    'Ashar': false,
    'Maghrib': false,
    'Isya': false,
  };

  @override
  void initState() {
    super.initState();
    fetchPrayerTimes();
    fetchSurahList();
    _loadSholatMilestones();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      showNextPrayerNotification();
    });
  }

  // Fungsi untuk menyimpan milestones ke SharedPreferences
  Future<void> _saveSholatMilestones() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('sholatMilestones', json.encode(sholatMilestones));
  }

  // Fungsi untuk memuat milestones dari SharedPreferences
  Future<void> _loadSholatMilestones() async {
    final prefs = await SharedPreferences.getInstance();
    final String? milestonesData = prefs.getString('sholatMilestones');
    if (milestonesData != null) {
      setState(() {
        sholatMilestones = Map<String, bool>.from(json.decode(milestonesData));
      });
    }
  }

  Future<void> fetchPrayerTimes() async {
    try {
      final url = Uri.parse(
          'http://api.aladhan.com/v1/timingsByCity?city=Tegal&country=Indonesia&method=4');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          prayerTimes = {
            'Shubuh': data['data']['timings']['Fajr'],
            'Dzuhur': data['data']['timings']['Dhuhr'],
            'Ashar': data['data']['timings']['Asr'],
            'Maghrib': data['data']['timings']['Maghrib'],
            'Isya': data['data']['timings']['Isha'],
          };
          calculateNextPrayer();
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load prayer times');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Error: $e');
    }
  }

  Future<void> fetchSurahList() async {
    try {
      final url = Uri.parse('https://equran.id/api/surat');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          surahList = data.map((item) => Surah.fromJson(item)).toList();
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load surah list');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Error: $e');
    }
  }

  void calculateNextPrayer() {
    final now = DateTime.now();
    DateTime? nearestTime;
    String nearestPrayer = '';

    prayerTimes.forEach((prayer, time) {
      final prayerTimeToday = DateFormat('HH:mm').parse(time);
      final prayerDateTime = DateTime(now.year, now.month, now.day,
          prayerTimeToday.hour, prayerTimeToday.minute);

      if (prayerDateTime.isAfter(now) &&
          (nearestTime == null || prayerDateTime.isBefore(nearestTime!))) {
        nearestTime = prayerDateTime;
        nearestPrayer = prayer;
      }
    });

    if (nearestTime != null) {
      setState(() {
        nextPrayer = nearestPrayer;
        final difference = nearestTime!.difference(now);
        timeRemaining =
            '${difference.inHours} jam ${difference.inMinutes % 60} menit Menuju Waktu Sholat';
      });
    }
  }

  void showNextPrayerNotification() {
    if (nextPrayer.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Apakah kamu sudah sholat $nextPrayer?'),
          action: SnackBarAction(
            label: 'Ya',
            onPressed: () {
              setState(() {
                sholatMilestones[nextPrayer] = true;
              });
            },
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tumanina', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.logout, color: Colors.black),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const LoginScreen()),
            );
          },
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Icon(Icons.notifications, color: Colors.black),
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildImageSlider(),
                    const SizedBox(height: 20),
                    const Text(
                      'Assalamu\'alaikum',
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Perdalam Sholat Anda Dengan Tumanina',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                    const SizedBox(height: 20),
                    _buildMenuRow(context),
                    const SizedBox(height: 20),
                    _buildNextPrayerCard(),
                    const SizedBox(height: 20),
                    const Text('Sudah Sholat?', style: TextStyle(fontSize: 18)),
                    const SizedBox(height: 10),
                    _buildPrayerChecklist(
                        sholatMilestones), // Gunakan data disini
                    const SizedBox(height: 20),
                    const Text(
                      'Daftar Surah Al-Qur\'an',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    _buildSurahBox(),
                  ],
                ),
              ),
            ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildImageSlider() {
    return SizedBox(
      height: 150,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          _buildImageCard('assets/assetsHome/image1.png'),
          _buildImageCard('assets/assetsHome/image2.png'),
          _buildImageCard('assets/assetsHome/image3.png'),
        ],
      ),
    );
  }

  Widget _buildMenuRow(BuildContext context) {
  return SingleChildScrollView(
    scrollDirection: Axis.horizontal,
    child: Row(
      children: [
        _buildMenuItem(context, Icons.book, 'Belajar\nSholat', () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const BelajarSholatScreen(),
            ),
          );
        }),
        _buildMenuItem(context, Icons.monitor, 'Pantau\nSholat', () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PantauSholatScreen(
                sholatMilestones: Map<String, bool>.from(sholatMilestones),
                onUpdate: (updatedMilestones) {
                  setState(() {
                    sholatMilestones.addAll(updatedMilestones);
                  });
                },
              ),
            ),
          );
        }),
        _buildMenuItem(context, Icons.access_time, 'Waktu\nSholat', () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => WaktuSholatScreen(client: http.Client()),
            ),
          );
        }),
        _buildMenuItem(context, Icons.chat, 'Chatbot', () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ChatScreen()),
          );
        }),
        _buildMenuItem(context, Icons.chat, 'Kiblat', () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const KiblatScreen()),
          );
        }),
        _buildMenuItem(context, Icons.auto_awesome_mosaic, 'Tasbih', () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const TasbihScreen()),
          );
        }),
        _buildMenuItem(context, Icons.book, 'Ayat-Ayat\nAl-Qur\'an', () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AyatAlQuranScreen(),
            ),
          );
        }),
        _buildMenuItem(context, Icons.calendar_today, 'Doa Harian', () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => DoaScreen()),
          );
        }),
      ],
    ),
  );
}


  Widget _buildMenuItem(
      BuildContext context, IconData icon, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 70, // Tinggi dan lebar tetap untuk lingkaran
              width: 70,
              child: CircleAvatar(
                backgroundColor: Colors.teal.shade100,
                child: Icon(
                  icon,
                  size: 32,
                  color: Colors.teal,
                ),
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: 70, // Lebar tetap untuk teks
              child: Text(
                label,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                maxLines: 2, // Maksimum 2 baris
                overflow: TextOverflow
                    .ellipsis, // Tambahkan ellipsis jika terlalu panjang
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNextPrayerCard() {
    return Card(
      elevation: 4,
      child: ListTile(
        leading: const Icon(Icons.access_time),
        title: Text(nextPrayer.isNotEmpty ? nextPrayer : 'Mengambil data...'),
        subtitle: Text(
            timeRemaining.isNotEmpty ? timeRemaining : 'Menghitung waktu...'),
        trailing:
            nextPrayer.isNotEmpty ? Text(prayerTimes[nextPrayer] ?? '') : null,
      ),
    );
  }

  // Tambahkan metode untuk checklist sholat yang dapat diubah
  Widget _buildPrayerChecklist(Map<String, bool> sholatMilestones) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: sholatMilestones.entries.map((entry) {
        return Column(
          children: [
            Icon(
              entry.value ? Icons.check_circle : Icons.radio_button_unchecked,
              color: entry.value ? Color(0xFF2DDCBE) : Colors.grey,
            ),
            const SizedBox(height: 8),
            Text(
              entry.key,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: entry.value ? Color(0xFF2DDCBE) : Colors.black,
              ),
            ),
          ],
        );
      }).toList(),
    );
  }

  Widget _buildSurahBox() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      height: 250,
      child: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: surahList.length,
              itemBuilder: (context, index) {
                final surah = surahList[index];
                return Card(
                  color: Colors.white,
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 2,
                  child: ListTile(
                    leading: const Icon(Icons.book, color: Colors.teal),
                    title: Text(
                      surah.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.teal,
                      ),
                    ),
                    subtitle: Text(surah.translation),
                    trailing: Text('${surah.ayatCount} Ayat'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SurahDetailScreen(
                            surahNumber: surah.id,
                            surahName: surah.name,
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
    );
  }

  Widget _buildMenuButton(IconData icon, String label,
      {void Function()? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          CircleAvatar(
            radius: 35,
            backgroundColor: Colors.teal.shade100,
            child: Icon(
              icon,
              color: Colors.white,
              size: 32,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImageCard(String imagePath) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: 250,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          image: DecorationImage(
            image: AssetImage(imagePath),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  BottomNavigationBar _buildBottomNavigationBar() {
    return BottomNavigationBar(
      currentIndex: 0,
      onTap: (index) {
        if (index == 2) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ProfileScreen()),
          );
        } else if (index == 1) {
          // Tambahkan aksi untuk Pengaturan jika diperlukan
        }
      },
      items: const [
        BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Beranda',
            backgroundColor: Color(0xFF004C7E)),
        BottomNavigationBarItem(
          icon: Icon(Icons.article),
          label: 'Artikel',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Profil',
        ),
      ],
    );
  }
}

// Kelas Surah
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
