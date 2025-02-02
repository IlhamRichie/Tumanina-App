import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:google_fonts/google_fonts.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import '/widgets/no_internet.dart'; // Sesuaikan path-nya
import 'package:intl/intl.dart'; // Untuk format tanggal
import 'package:intl/date_symbol_data_local.dart'; // Untuk inisialisasi locale
import 'package:geocoding/geocoding.dart'; // Untuk geocoding
import 'package:timezone/data/latest.dart' as tz;
import '/services/notif_service.dart'; // Import notification service

class WaktuSholatScreen extends StatefulWidget {
  final http.Client client;

  const WaktuSholatScreen({super.key, required this.client});

  @override
  WaktuSholatScreenState createState() => WaktuSholatScreenState();
}

class WaktuSholatScreenState extends State<WaktuSholatScreen> {
  Map<String, String> prayerTimes = {};
  Map<String, int> prayerNotifications = {};
  String errorMessage = '';
  DateTime selectedDate = DateTime.now();
  bool _isOnline = true; // Status koneksi internet
  String hijriDate = ''; // Variabel untuk menyimpan tanggal dan bulan Hijriyah
  String userLocation =
      'Mengambil lokasi...'; // Variabel untuk menyimpan lokasi user
  String nextPrayer = ''; // Variabel untuk menyimpan sholat berikutnya
  Duration timeUntilNextPrayer =
      Duration.zero; // Variabel untuk menyimpan waktu hingga sholat berikutnya
  Timer? _timer; // Timer untuk perhitungan waktu sholat berikutnya
  bool _isLoading = false; // Indikator loading

  final NotificationService _notificationService = NotificationService();

  bool isFriday(DateTime date) {
    return date.weekday == DateTime.friday;
  }

  bool _isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }

  @override
  void initState() {
    super.initState();
    initializeDateFormatting('id_ID', null);
    tz.initializeTimeZones();
    _checkInternetConnection();
    print("📥 Memuat status notifikasi...");
    _loadNotificationStatuses(); // Muat status notifikasi dari SharedPreferences
    _getUserLocation();
    fetchPrayerTimesWithCache(widget.client, selectedDate);
    _notificationService.init();
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (mounted) {
        _calculateNextPrayer();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel(); // Cancel the timer when the widget is disposed
    super.dispose();
  }

  // Fungsi untuk mengambil nilai dari SharedPreferences dengan penanganan error
  int _getIntFromPrefs(SharedPreferences prefs, String key) {
    final value = prefs.get(key);
    if (value is int) {
      return value; // Jika sudah dalam bentuk int, kembalikan langsung
    } else if (value is String) {
      try {
        int intValue = int.parse(value);
        prefs.setInt(key, intValue); // Perbaiki data agar menjadi int
        return intValue;
      } catch (e) {
        prefs.remove(key); // Hapus jika tidak bisa dikonversi ke int
        return 0; // Default ke 0
      }
    } else {
      return 0; // Default jika tidak ada nilai
    }
  }

  // Fungsi untuk toggle notifikasi
  void _toggleNotification(String prayerName) async {
    int newStatus = (prayerNotifications[prayerName]! + 1) % 3;
    setState(() {
      prayerNotifications[prayerName] = newStatus;
    });

    // Simpan status notifikasi ke SharedPreferences
    await _saveNotificationStatus(prayerName, newStatus);

    DateTime prayerTime =
        DateFormat('HH:mm').parse(prayerTimes[prayerName] ?? '00:00');
    DateTime scheduledTime = DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
      prayerTime.hour,
      prayerTime.minute,
    );

    String sound = 'notification'; // Default sound

    if (newStatus == 1) {
      sound = 'notification'; // Notifikasi biasa
      await _notificationService.scheduleNotification(
        id: prayerName.hashCode,
        title: 'Waktu Sholat $prayerName',
        body: 'Sholat $prayerName akan dimulai \ndalam 5 menit.',
        scheduledTime: scheduledTime.subtract(Duration(minutes: 5)),
        sound: sound,
      );
      _showModernSnackbar(
          'Notifikasi $prayerName diaktifkan dalam \n5 menit sebelum waktu sholat.');
    } else if (newStatus == 2) {
      sound = (prayerName == 'Subuh') ? 'adzansubuh' : 'adzan'; // Suara adzan
      await _notificationService.scheduleNotification(
        id: prayerName.hashCode,
        title: 'Waktu Sholat $prayerName',
        body: 'Waktunya sholat $prayerName!',
        scheduledTime: scheduledTime,
        sound: sound,
      );
      _showModernSnackbar(
          'Notifikasi $prayerName diaktifkan pada \nwaktu sholat.');
    } else {
      await _notificationService.cancelNotification(prayerName.hashCode);
      _showModernSnackbar('Notifikasi $prayerName dinonaktifkan.');
    }
  }

  // Fungsi untuk menampilkan Snackbar modern
  void _showModernSnackbar(String message) {
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
        duration: const Duration(seconds: 2),
      ),
    );
  }

  // Fungsi untuk menyimpan status notifikasi
  Future<void> _saveNotificationStatus(String prayerName, int status) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(prayerName, status);
    print("💾 Menyimpan status notifikasi: $prayerName -> $status");
  }

// Fungsi untuk memuat semua status notifikasi dari SharedPreferences
  Future<void> _loadNotificationStatuses() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      prayerNotifications = {
        'Subuh': _getIntFromPrefs(prefs, 'Subuh'),
        'Dzuhur': _getIntFromPrefs(prefs, 'Dzuhur'),
        'Ashar': _getIntFromPrefs(prefs, 'Ashar'),
        'Maghrib': _getIntFromPrefs(prefs, 'Maghrib'),
        'Isya': _getIntFromPrefs(prefs, 'Isya'),
      };
    });
  }

  // Fungsi untuk mengecek koneksi internet
  Future<void> _checkInternetConnection() async {
    try {
      var connectivityResult = await Connectivity().checkConnectivity();
      if (mounted) {
        setState(() {
          _isOnline = connectivityResult != ConnectivityResult.none;
        });
      }
    } catch (e) {
      print("Error checking internet connection: $e");
    }
  }

  // Fungsi untuk mengambil lokasi user
  Future<void> _getUserLocation() async {
    try {
      Position position = await _getCurrentLocation();
      List<Placemark> placemarks =
          await placemarkFromCoordinates(position.latitude, position.longitude);
      if (placemarks.isNotEmpty) {
        Placemark place = placemarks.first;
        if (mounted) {
          setState(() {
            userLocation = place.locality ?? 'Lokasi tidak ditemukan';
          });
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          userLocation = 'Lokasi tidak ditemukan';
        });
      }
    }
  }

  // Fungsi untuk menentukan sholat berikutnya dan hitung mundur
  void _calculateNextPrayer() {
    DateTime now = DateTime.now();

    // Ambil waktu Isya dari prayerTimes, jika null atau kosong gunakan default 12:00
    String isyaTimeStr = prayerTimes['Isya']?.trim() ?? '12:00';
    if (isyaTimeStr.isEmpty) {
      print("⚠️ Warning: Isya time is empty, using default 12:00");
      isyaTimeStr = '12:00';
    }

    DateTime isyaTime;
    try {
      isyaTime = DateFormat('HH:mm').parse(isyaTimeStr);
    } catch (e) {
      print("❌ Error parsing Isya time: $e");
      isyaTime = DateTime(now.year, now.month, now.day, 12, 0);
    }

    DateTime isyaDateTime =
        DateTime(now.year, now.month, now.day, isyaTime.hour, isyaTime.minute);

    if (now.isAfter(isyaDateTime)) {
      // Ambil waktu Subuh dari prayerTimes, jika null atau kosong gunakan default 04:30
      String subuhTimeStr = prayerTimes['Subuh']?.trim() ?? '04:30';
      if (subuhTimeStr.isEmpty) {
        print("⚠️ Warning: Subuh time is empty, using default 04:30");
        subuhTimeStr = '04:30';
      }

      DateTime subuhTime;
      try {
        subuhTime = DateFormat('HH:mm').parse(subuhTimeStr);
      } catch (e) {
        print("❌ Error parsing Subuh time: $e");
        subuhTime = DateTime(now.year, now.month, now.day + 1, 4, 30);
      }

      DateTime subuhDateTime = DateTime(
          now.year, now.month, now.day + 1, subuhTime.hour, subuhTime.minute);

      if (mounted) {
        setState(() {
          nextPrayer = 'Subuh (Besok)';
          timeUntilNextPrayer = subuhDateTime.difference(now);
        });
      }
      return;
    }

    // Jika belum melewati Isya, cari sholat berikutnya hari ini
    for (var entry in prayerTimes.entries) {
      String prayerTimeStr = entry.value.trim();
      if (prayerTimeStr.isEmpty) {
        print("⚠️ Warning: ${entry.key} time is empty, skipping...");
        continue; // Skip jika waktu sholat kosong
      }

      DateTime prayerTime;
      try {
        prayerTime = DateFormat('HH:mm').parse(prayerTimeStr);
      } catch (e) {
        print("❌ Error parsing ${entry.key} time: $e");
        continue; // Skip jika parsing gagal
      }

      DateTime prayerDateTime = DateTime(
          now.year, now.month, now.day, prayerTime.hour, prayerTime.minute);

      if (prayerDateTime.isAfter(now)) {
        if (mounted) {
          setState(() {
            nextPrayer = entry.key;
            timeUntilNextPrayer = prayerDateTime.difference(now);
          });
        }
        break;
      }
    }
  }

  Future<Position> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Location permission denied.');
      }
    }

    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }

  Future<void> savePrayerTimesToCache(Map<String, String> times) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      times.forEach((key, value) {
        prefs.setString(key, value); // Simpan sebagai String
      });
    } catch (e) {
      print("Error saving prayer times to cache: $e");
    }
  }

  Future<Map<String, String>> loadPrayerTimesFromCache() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return {
        'Subuh': prefs.getString('Subuh') ?? '',
        'Dzuhur': prefs.getString('Dzuhur') ?? '',
        'Ashar': prefs.getString('Ashar') ?? '',
        'Maghrib': prefs.getString('Maghrib') ?? '',
        'Isya': prefs.getString('Isya') ?? '',
      };
    } catch (e) {
      print("Error loading prayer times from cache: $e");
      return {};
    }
  }

  Future<void> fetchPrayerTimesWithCache(
      http.Client client, DateTime date) async {
    if (mounted) {
      setState(() {
        _isLoading = true; // Tampilkan indikator loading
      });
    }

    try {
      prayerTimes =
          await loadPrayerTimesFromCache(); // Tampilkan cache terlebih dahulu
      await fetchPrayerTimes(client, date); // Perbarui data dari server
      await savePrayerTimesToCache(prayerTimes); // Simpan ke cache
    } catch (e) {
      debugPrint("Error fetching prayer times: $e");
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false; // Sembunyikan indikator loading
        });
      }
    }
  }

  Future<void> fetchPrayerTimes(http.Client client, DateTime date) async {
    try {
      Position position = await _getCurrentLocation();
      double latitude = position.latitude;
      double longitude = position.longitude;

      // Format the date as DD-MM-YYYY
      final formattedDate = DateFormat('dd-MM-yyyy').format(date);
      print('Formatted Date: $formattedDate'); // Debugging

      final url = Uri.parse(
        'http://api.aladhan.com/v1/timings/$formattedDate?latitude=$latitude&longitude=$longitude&method=4',
      );

      final response = await client
          .get(url)
          .timeout(const Duration(seconds: 10)); // Timeout handling

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (mounted) {
          setState(() {
            prayerTimes = {
              'Subuh': data['data']['timings']['Fajr'],
              'Dzuhur': data['data']['timings']['Dhuhr'],
              'Ashar': data['data']['timings']['Asr'],
              'Maghrib': data['data']['timings']['Maghrib'],
              'Isya': data['data']['timings']['Isha'],
            };
            // Ambil tanggal dan bulan Hijriyah dari API
            final hijriDay = data['data']['date']['hijri']['day'];
            final hijriMonth = data['data']['date']['hijri']['month']['ar'];
            hijriDate = '$hijriDay $hijriMonth'; // Gabungkan tanggal dan bulan
            errorMessage = '';
          });
          _calculateNextPrayer(); // Hitung sholat berikutnya setelah data diperbarui
        }
      } else {
        if (mounted) {
          setState(() {
            errorMessage = 'Gagal memuat waktu sholat, periksa internet Anda.';
          });
        }
      }
    } on TimeoutException {
      if (mounted) {
        setState(() {
          errorMessage = 'Permintaan waktu habis, coba lagi.';
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          errorMessage = 'Gagal memuat waktu sholat, periksa internet Anda.';
        });
      }
    }
  }

  void _changeDate(int days) {
    if (mounted) {
      setState(() {
        selectedDate = selectedDate.add(Duration(days: days));
      });
      fetchPrayerTimesWithCache(widget.client, selectedDate);
    }
  }

  IconData _getPrayerIcon(String prayerName) {
    switch (prayerName) {
      case 'Subuh':
        return Icons.wb_twilight;
      case 'Dzuhur':
        return Icons.wb_sunny;
      case 'Ashar':
        return Icons.cloud;
      case 'Maghrib':
        return Icons.nightlight;
      case 'Isya':
        return Icons.brightness_2;
      default:
        return Icons.access_time;
    }
  }

  IconData _getNotificationIcon(int status) {
    switch (status) {
      case 0:
        return Icons.notifications_off;
      case 1:
        return Icons.notifications;
      case 2:
        return Icons.volume_up;
      default:
        return Icons.notifications_off;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Jika tidak ada koneksi internet, tampilkan NoInternetScreen
    if (!_isOnline) {
      return NoInternetScreen(
        onRetry: () {
          // Fungsi yang akan dijalankan saat tombol "Coba Lagi" ditekan
          _checkInternetConnection(); // Cek koneksi internet lagi
          fetchPrayerTimesWithCache(
              widget.client, selectedDate); // Coba ambil data lagi
        },
      );
    }

    return Scaffold(
      backgroundColor: Color(0xFF003557), // Ubah warna latar belakang Scaffold
      appBar: AppBar(
        title: Text(
          'Waktu Sholat',
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF004C7E),
        elevation: 0,
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator(color: Colors.white))
          : SingleChildScrollView(
              child: Column(
                children: [
                  // Header dengan lokasi dan waktu sholat berikutnya
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(0),
                    height: 170,
                    color: const Color(0xFF004C7E),
                    child: Stack(
                      children: [
                        // Vektor siluet masjid
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Opacity(
                            opacity: 0.3,
                            child: Image.asset(
                              'assets/kiblat/masjid.png',
                              width: 500,
                              height: 250,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        // Konten utama (3 teks)
                        Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              // Lokasi
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.location_on,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    userLocation,
                                    style: GoogleFonts.poppins(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              // Sholat berikutnya
                              Text(
                                'Sholat berikutnya: $nextPrayer',
                                style: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontSize: 14,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 12),
                              // Waktu tersisa
                              Text(
                                'Waktu tersisa: \n${timeUntilNextPrayer.inHours} : ${timeUntilNextPrayer.inMinutes.remainder(60)} : ${timeUntilNextPrayer.inSeconds.remainder(60)}',
                                style: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Slider Tanggal
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 0),
                    height: 140,
                    color: const Color(0xFF003557),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Tombol panah kiri
                        IconButton(
                          icon: Icon(Icons.arrow_left,
                              size: 40, color: Colors.white),
                          onPressed: () => _changeDate(-1),
                        ),
                        // Card tanggal
                        Container(
                          height: 80,
                          width: 230,
                          margin: const EdgeInsets.symmetric(horizontal: 8),
                          decoration: BoxDecoration(
                            color: _isToday(selectedDate)
                                ? Color(0xFF2DDCBE)
                                : Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: _isToday(selectedDate)
                                ? null
                                : Border.all(
                                    color: Color(0xFF004C7E), width: 2),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // Tanggal Masehi
                              Text(
                                DateFormat('EEEE, dd MMMM yyyy', 'id_ID')
                                    .format(selectedDate),
                                style: GoogleFonts.poppins(
                                  color: _isToday(selectedDate)
                                      ? Colors.white
                                      : const Color(0xFF004C7E),
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 8),
                              // Tanggal Hijriah
                              Text(
                                hijriDate,
                                style: GoogleFonts.poppins(
                                  color: _isToday(selectedDate)
                                      ? const Color(0xB3FFFFFF)
                                      : Colors.black54,
                                  fontSize: 16,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                        // Tombol panah kanan
                        IconButton(
                          icon: Icon(Icons.arrow_right,
                              size: 40, color: Colors.white),
                          onPressed: () => _changeDate(1),
                        ),
                      ],
                    ),
                  ),
                  // Daftar waktu sholat
                  ...prayerTimes.entries.map((entry) {
                    final prayerName =
                        entry.key == 'Dzuhur' && isFriday(selectedDate)
                            ? 'Dzuhur/Jumat'
                            : entry.key;

                    return Card(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      color: const Color(0xFF2DDCBE),
                      child: ListTile(
                        leading: Icon(
                          _getPrayerIcon(entry.key),
                          size: 32,
                          color: Colors.white,
                        ),
                        title: Text(
                          prayerName,
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              entry.value,
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                color: Colors.white,
                              ),
                            ),
                            IconButton(
                              iconSize: 30, // Ukuran ikon diperbesar
                              padding: EdgeInsets.only(
                                  left: 16), // Geser ikon ke kanan
                              icon: Icon(
                                _getNotificationIcon(
                                    prayerNotifications[entry.key] ?? 0),
                                color: Colors.white,
                              ),
                              onPressed: () => _toggleNotification(entry.key),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ],
              ),
            ),
    );
  }
}
