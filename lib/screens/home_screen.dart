import 'dart:io';
import 'package:Tumanina/screens/fitur_sholat/belajar_sholat_screen.dart';
import 'package:Tumanina/screens/kiblat_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'artikel/artikel_screen.dart';
import 'fitur_diskusi/diskusi_screen.dart';
import 'pantau_sholat_screen.dart';
import 'fitur_alquran/surat_detail_screen.dart';
import 'waktu_sholat_screen.dart';
import 'chat_screen.dart';
import 'tasbih_screen.dart';
import 'fitur_alquran/ayat_al_quran_screen.dart';
import 'profil/profile_screen.dart';
import 'fitur_doa/doa_screen.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:async';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _username = 'User';
  Map<String, String> prayerTimes = {};
  String nextPrayer = '';
  List articles = [];
  String timeRemaining = '';
  List<Surah> surahList = [];
  bool isLoading = false;
  bool hasInternet = true;
  List<String> bookmarkedAyat = [];
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _validateMilestones();
    fetchPrayerTimes();
    fetchArticles();
    fetchSurahList();
    _loadSholatMilestones();
    _checkAndResetMilestones();
    loadBookmarks(); // Tambahkan ini
    _loadUsername(); // Muat nama pengguna
    _checkLocationPermission();
    print('Internet status: $hasInternet'); // Debugging
    _startTimer();
  }

  // Milestone status untuk setiap sholat
  Map<String, bool> sholatMilestones = {
    'Shubuh': false,
    'Dzuhur': false,
    'Ashar': false,
    'Maghrib': false,
    'Isya': false,
  };

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    setState(() {
      isLoading = false;
      _getReadingHistory(); // Memuat ulang data setiap kali halaman diakses
    });
  }

  @override
  void dispose() {
    _timer?.cancel(); // Hentikan timer saat widget dihapus
    super.dispose();
  }

  Future<void> _checkLocationPermission() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Lokasi tidak aktif, minta pengguna untuk mengaktifkannya
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Izin ditolak, beri tahu pengguna
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Izin ditolak selamanya, beri tahu pengguna
      return;
    }

    // Izin diberikan, lanjutkan untuk mendapatkan lokasi
    fetchPrayerTimes();
  }

  Future<void> _loadUsername() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _username = prefs.getString('username') ?? 'User';
    });
  }

  Future<void> _handleRefresh() async {
    setState(() {
      isLoading = true; // Tampilkan loading saat refresh
    });

    try {
      await Future.wait([
        fetchArticles(), // Muat ulang artikel
        fetchSurahList(), // Muat ulang daftar surah
        fetchPrayerTimes(), // Muat ulang waktu sholat
      ]);

      setState(() {
        isLoading = false; // Sembunyikan loading setelah refresh selesai
      });
    } catch (e) {
      setState(() {
        isLoading = false; // Tetap sembunyikan loading jika ada error
      });
      print('Error saat refresh: $e');
    }
  }

  Future<void> fetchArticles() async {
    setState(() {
      isLoading = true;
      hasInternet = true; // Reset status koneksi
    });

    final url =
        Uri.parse('https://api-berita-indonesia.vercel.app/sindonews/kalam/');
    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          articles = data['data']['posts'];
          isLoading = false;
        });
      } else {
        throw Exception('Gagal memuat artikel');
      }
    } on SocketException {
      setState(() {
        isLoading = false;
        hasInternet = false; // Set status koneksi ke false
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Error: $e');
    }
  }

  Future<List<Surah>> _getReadingHistory() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final List<String> historyData =
          prefs.getStringList('readingHistory') ?? [];

      return historyData.map((item) {
        final Map<String, dynamic> jsonData = json.decode(item);
        return Surah(
          id: jsonData['id'] ?? 0,
          name: jsonData['name'] ?? 'Tidak diketahui',
          translation: jsonData['translation'] ?? 'Terjemahan tidak tersedia',
          ayatCount: jsonData['ayatCount'] ?? 0,
        );
      }).toList();
    } catch (e) {
      print('Error loading reading history: $e');
      return [];
    }
  }

  Future<void> _saveSholatMilestones() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('sholatMilestones', json.encode(sholatMilestones));
  }

  Future<void> _loadSholatMilestones() async {
    final prefs = await SharedPreferences.getInstance();
    final String? milestonesData = prefs.getString('sholatMilestones');

    if (milestonesData != null) {
      setState(() {
        sholatMilestones = Map<String, bool>.from(json.decode(milestonesData));
      });
    } else {
      // Jika belum ada data, inisialisasi dengan nilai default
      setState(() {
        sholatMilestones = {
          'Shubuh': false,
          'Dzuhur': false,
          'Ashar': false,
          'Maghrib': false,
          'Isya': false,
        };
      });
    }
  }

  Future<void> _checkAndResetMilestones() async {
    final prefs = await SharedPreferences.getInstance();
    final String? lastResetDate = prefs.getString('lastResetDate');
    final DateTime now = DateTime.now();

    // Jika belum ada tanggal terakhir reset, simpan tanggal hari ini
    if (lastResetDate == null) {
      await prefs.setString('lastResetDate', now.toIso8601String());
      return;
    }

    // Bandingkan tanggal terakhir reset dengan tanggal sekarang
    final DateTime lastReset = DateTime.parse(lastResetDate);
    if (now.day != lastReset.day) {
      // Jika hari sudah berganti, reset milestones
      setState(() {
        sholatMilestones = {
          'Shubuh': false,
          'Dzuhur': false,
          'Ashar': false,
          'Maghrib': false,
          'Isya': false,
        };
      });

      // Simpan status reset dan tanggal terbaru
      await _saveSholatMilestones();
      await prefs.setString('lastResetDate', now.toIso8601String());
    }
  }

  Future<void> loadBookmarks() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      bookmarkedAyat = prefs.getStringList('bookmarkedAyat') ?? [];
    });
  }

  Future<void> fetchPrayerTimes() async {
    final prefs = await SharedPreferences.getInstance();
    final String? cachedPrayerTimes = prefs.getString('prayerTimes');
    final String? lastFetchDate = prefs.getString('lastFetchDate');

    // Jika data sudah ada dan belum kedaluwarsa (24 jam), gunakan data cache
    if (cachedPrayerTimes != null && lastFetchDate != null) {
      final DateTime now = DateTime.now();
      final DateTime lastFetch = DateTime.parse(lastFetchDate);

      if (now.difference(lastFetch).inHours < 24) {
        setState(() {
          prayerTimes =
              Map<String, String>.from(json.decode(cachedPrayerTimes));
          calculateNextPrayer(); // Perbarui waktu setelah data diperbarui
          isLoading = false;
        });
        return;
      }
    }

    // Jika tidak ada cache atau cache kedaluwarsa, ambil data baru dari API
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      final url = Uri.parse(
          'http://api.aladhan.com/v1/timings/${DateTime.now().toIso8601String().split('T')[0]}?latitude=${position.latitude}&longitude=${position.longitude}&method=4');

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
          calculateNextPrayer(); // Perbarui waktu setelah data diperbarui
          isLoading = false;
        });

        // Simpan data ke cache
        await prefs.setString('prayerTimes', json.encode(prayerTimes));
        await prefs.setString(
            'lastFetchDate', DateTime.now().toIso8601String());
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
    setState(() {
      isLoading = true;
      hasInternet = true; // Reset status koneksi
    });

    try {
      final url = Uri.parse('https://equran.id/api/surat');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          surahList = data.map((item) => Surah.fromJson(item)).toList();
          isLoading = false;
        });
        print('Surah list loaded successfully');
      } else {
        throw Exception('Gagal memuat daftar surah');
      }
    } on SocketException {
      setState(() {
        isLoading = false;
        hasInternet = false; // Set status koneksi ke false
      });
      print('Tidak ada koneksi internet');
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Error: $e');
    }
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          calculateNextPrayer(); // Perbarui waktu setiap detik
        });
      }
    });
  }

  void calculateNextPrayer() {
    final now = DateTime.now();
    DateTime? nextPrayerTime;
    String nextPrayerName = '';
    String currentPrayerName = '';
    DateTime? currentPrayerTime;

    // Iterasi melalui semua waktu sholat
    prayerTimes.forEach((prayer, time) {
      final prayerTimeToday = DateFormat('HH:mm').parse(time);
      final prayerDateTime = DateTime(now.year, now.month, now.day,
          prayerTimeToday.hour, prayerTimeToday.minute);

      // Cek apakah waktu sholat saat ini sedang berlangsung
      if (prayerDateTime.isBefore(now) &&
          (currentPrayerTime == null ||
              prayerDateTime.isAfter(currentPrayerTime!))) {
        currentPrayerTime = prayerDateTime;
        currentPrayerName = prayer;
      }

      // Cek waktu sholat berikutnya
      if (prayerDateTime.isAfter(now) &&
          (nextPrayerTime == null ||
              prayerDateTime.isBefore(nextPrayerTime!))) {
        nextPrayerTime = prayerDateTime;
        nextPrayerName = prayer;
      }
    });

    // Set state untuk waktu sholat saat ini
    setState(() {
      if (currentPrayerTime != null) {
        // Cek khusus untuk Shubuh
        if (currentPrayerName == 'Shubuh' && now.hour >= 7) {
          nextPrayer = 'Shubuh Telah Berlalu';
        } else {
          nextPrayer = 'Saat ini $currentPrayerName';
        }
      } else {
        nextPrayer = 'Tidak ada sholat yang sedang berlangsung';
      }

      // Hitung countdown menuju waktu sholat berikutnya
      if (nextPrayerTime != null) {
        final difference = nextPrayerTime!.difference(now);
        timeRemaining =
            '${difference.inHours} jam ${difference.inMinutes % 60} menit ${difference.inSeconds % 60} detik menuju $nextPrayerName';
      } else {
        timeRemaining = 'Menunggu sholat Shubuh berikutnya hari esok';
      }
    });
  }

  void _validateMilestones() {
    for (var key in sholatMilestones.keys) {
      if (!sholatMilestones.containsKey(key)) {
        sholatMilestones[key] = false;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(255, 255, 255, 0),
        elevation: 0,
        centerTitle: true,
        toolbarHeight: 0,
        actions: const [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Icon(Icons.notifications, color: Color(0xFF2DDCBE)),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _handleRefresh, // Fungsi refresh
        color: Color(0xFF2DDCBE), // Warna spinner (modern hijau terang)
        backgroundColor:
            Color(0xFF004C7E), // Warna latar belakang spinner (biru gelap)
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Assalamu\'alaikum, $_username',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                          color: Color(0xFF004C7E),
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Perdalam Sholat Anda dengan Tumanina',
                        style: TextStyle(
                          color: Color(0xFF2DDCBE),
                          fontSize: 14,
                          letterSpacing: 0.3,
                        ),
                      ),
                    ],
                  ),
                ),
                _buildImageSlider(),
                const SizedBox(height: 10),
                _buildMenuRow(context),
                const SizedBox(height: 10),
                _buildNextPrayerCard(),
                const SizedBox(height: 10),
                _buildPrayerChecklist(sholatMilestones),
                const SizedBox(height: 10),
                _buildSurahBox(),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
      backgroundColor: Colors.white,
    );
  }

  Widget _buildImageSlider() {
    return SizedBox(
      height: 150,
      child: !hasInternet
          ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(Icons.wifi_off, size: 50, color: Colors.grey),
                SizedBox(height: 10),
                Text(
                  'Tidak ada koneksi internet',
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            )
          : isLoading
              ? const Center(
                  child: CircularProgressIndicator(
                    valueColor:
                        AlwaysStoppedAnimation<Color>(Color(0xFF2DDCBE)),
                  ),
                )
              : ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: articles.length,
                  itemBuilder: (context, index) {
                    final article = articles[index];
                    final thumbnail = article['thumbnail'] ?? '';
                    final title = article['title'] ?? 'Judul Tidak Tersedia';

                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ArtikelScreen(),
                          ),
                        );
                      },
                      child: _buildImageCard(thumbnail, title),
                    );
                  },
                ),
    );
  }

  Widget _buildMenuRow(BuildContext context) {
    return Container(
      height: 140,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          _buildMenuItem(context, Icons.book, 'Belajar\nSholat', () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => BelajarSholatScreen(),
              ),
            );
          }),
          _buildMenuItem(context, Icons.check_circle_rounded, 'Pantau\nSholat',
              () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PantauSholatScreen(
                  sholatMilestones: Map<String, bool>.from(sholatMilestones),
                  onUpdate: (updatedMilestones) {
                    setState(() {
                      sholatMilestones = updatedMilestones;
                    });
                    _saveSholatMilestones();
                  },
                  prayerTimes: prayerTimes, // Waktu sholat diteruskan
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
          _buildMenuItem(context, Icons.compass_calibration_rounded, 'Kiblat',
              () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const KiblatScreen()),
            );
          }),
          _buildMenuItem(context, Icons.add_circle_sharp, 'Tasbih', () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const TasbihScreen()),
            );
          }),
          _buildMenuItem(context, Icons.book_rounded, 'Ayat-Ayat\nAl-Qur\'an',
              () {
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: 120, // Slightly wider for better balance
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20), // More rounded corners
            boxShadow: [
              BoxShadow(
                color:
                    const Color(0xFF004C7E).withOpacity(0.10), // Subtle shadow
                blurRadius: 12,
                offset:
                    const Offset(0, 6), // Slightly downwards for better effect
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment:
                CrossAxisAlignment.center, // Center icons and text
            children: [
              Container(
                padding: const EdgeInsets.all(12), // Padding for icon

                child: Icon(icon,
                    size: 40,
                    color: const Color(
                        0xFF2DDCBE)), // Icon size adjusted for a cleaner look
              ),
              const SizedBox(height: 8), // More space between icon and label
              Text(
                label,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 14, // Slightly larger text for readability
                  fontWeight: FontWeight.w600,
                  color: Color(
                      0xFF004C7E), // Darker text color for better contrast
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNextPrayerCard() {
    return Container(
      width: double.infinity, // Set width to full screen width
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [const Color(0xFF2DDCBE), const Color(0xFF004C7E)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Waktu Sholat Saat Ini dengan teks "Sekarang"
          Text(
            nextPrayer.isNotEmpty
                ? nextPrayer // Tampilkan teks sesuai kondisi
                : 'Mengambil data...',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          // Countdown Menuju Waktu Sholat Berikutnya
          Text(
            timeRemaining.isNotEmpty
                ? timeRemaining
                : 'Menghitung waktu sholat...',
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPrayerChecklist(Map<String, bool> sholatMilestones) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Progress Sholat Hari Ini',
            style: TextStyle(
              fontSize: 18,
              color: Color(0xFF004C7E),
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: sholatMilestones.entries.map((entry) {
              return Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: entry.value
                          ? Colors.teal.shade50
                          : Colors.grey.shade50,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      entry.value ? Icons.check_circle : Icons.circle_outlined,
                      color: entry.value ? Colors.teal : Colors.grey,
                      size: 28,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    entry.key,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: entry.value ? Colors.teal : Colors.grey.shade700,
                    ),
                  ),
                ],
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildSurahBox() {
    Map<int, List<int>> bookmarkedData = {};

    for (var item in bookmarkedAyat) {
      final parts = item.split(':');
      if (parts.length == 2) {
        int surahNumber = int.tryParse(parts[0]) ?? 0;
        int ayatNumber = int.tryParse(parts[1]) ?? 0;
        if (surahNumber > 0 && ayatNumber > 0) {
          bookmarkedData[surahNumber] = (bookmarkedData[surahNumber] ?? [])
            ..add(ayatNumber);
        }
      }
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [const Color(0xFF2DDCBE), const Color(0xFF004C7E)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.15),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      height: 300,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Bookmark Surah dan Ayat',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: bookmarkedData.isEmpty
                ? const Center(
                    child: Text(
                      'Belum ada bookmark',
                      style: TextStyle(color: Colors.white),
                    ),
                  )
                : ListView.builder(
                    itemCount: bookmarkedData.keys.length,
                    itemBuilder: (context, index) {
                      final surahNumber = bookmarkedData.keys.elementAt(index);
                      final surah = surahList.firstWhere(
                        (s) => s.id == surahNumber,
                        orElse: () => Surah(
                          id: surahNumber,
                          name: 'Surah Tidak Diketahui',
                          translation: '',
                          ayatCount: 0,
                        ),
                      );
                      final ayatNumbers =
                          bookmarkedData[surahNumber]?.join(', ') ?? '';

                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 5.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        color: Colors.white,
                        child: ListTile(
                          title: Text(
                            surah.name,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF004C7E),
                            ),
                          ),
                          subtitle: Text(
                            'Ayat: $ayatNumbers',
                            style: const TextStyle(
                              color: Color(0xFF2DDCBE),
                            ),
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SurahDetailScreen(
                                  surahNumber: surahNumber,
                                  surahName: surah.name,
                                  initialAyat: bookmarkedData[surahNumber]?[0],
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
    );
  }

  Widget _buildImageCard(String imageUrl, String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Stack(
        children: [
          // Gambar
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              imageUrl,
              width: 250, // Atur lebar gambar sesuai kebutuhan
              height: 150,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                width: 250,
                color: Colors.grey[300],
                child: const Icon(Icons.broken_image, size: 50),
              ),
            ),
          ),
          // Judul di atas gambar
          Positioned(
            bottom: 10, // Posisi teks di bagian bawah gambar
            left: 10,
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
              decoration: BoxDecoration(
                color: const Color(0xFF004C7E)
                    .withOpacity(0.5), // Latar belakang semi-transparan
                borderRadius: BorderRadius.circular(5),
              ),
              child: Text(
                title,
                style: const TextStyle(
                  color: Colors.white, // Warna teks putih
                  fontWeight: FontWeight.bold,
                  fontSize: 10,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  BottomNavigationBar _buildBottomNavigationBar() {
    return BottomNavigationBar(
      currentIndex: 0,
      onTap: (index) {
        if (index == 3) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ProfileScreen()),
          );
        } else if (index == 1) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ArtikelScreen()),
          );
        } else if (index == 2) {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const DiskusiScreen()), // Tambahkan ini
          );
        }
      },
      selectedItemColor: Color(0xFF004C7E), // Warna item terpilih
      unselectedItemColor: Colors.grey, // Warna item yang tidak terpilih
      backgroundColor: Colors.white, // Background untuk navigation bar
      showSelectedLabels: true, // Menampilkan label
      showUnselectedLabels: true, // Menampilkan label tidak terpilih
      elevation: 10, // Menambahkan bayangan untuk efek depth
      type: BottomNavigationBarType
          .fixed, // Menambahkan jenis fixed untuk menghindari efek perubahan ukuran
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Beranda',
          backgroundColor: Color(0xFF004C7E),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.article),
          label: 'Artikel',
          backgroundColor: Color(0xFF004C7E),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.mark_chat_unread),
          label: 'Diskusi',
          backgroundColor: Color(0xFF004C7E), // Warna untuk Diskusi
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Profil',
          backgroundColor: Color(0xFF004C7E),
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
