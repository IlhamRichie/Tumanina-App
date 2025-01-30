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
  String userLocation = 'Mengambil lokasi...'; // Variabel untuk menyimpan lokasi user
  String nextPrayer = ''; // Variabel untuk menyimpan sholat berikutnya
  Duration timeUntilNextPrayer = Duration.zero; // Variabel untuk menyimpan waktu hingga sholat berikutnya
  Timer? _timer; // Timer untuk perhitungan waktu sholat berikutnya

  bool isFriday(DateTime date) {
    return date.weekday == DateTime.friday;
  }

  bool _isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year && date.month == now.month && date.day == now.day;
  }

  @override
  void initState() {
    super.initState();
    initializeDateFormatting('id_ID', null); // Inisialisasi locale Indonesia
    _checkInternetConnection(); // Cek koneksi internet saat init
    fetchPrayerTimesWithCache(widget.client, selectedDate);
    _getUserLocation(); // Ambil lokasi user

    // Timer untuk perhitungan waktu sholat berikutnya
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (mounted) {
        _calculateNextPrayer(); // Perbarui hitung mundur setiap detik
      }
    });

    // Inisialisasi status notifikasi
    prayerNotifications = {
      'Subuh': 0,
      'Dzuhur': 0,
      'Ashar': 0,
      'Maghrib': 0,
      'Isya': 0,
    };
  }

  @override
  void dispose() {
    _timer?.cancel(); // Cancel the timer when the widget is disposed
    super.dispose();
  }

  // Fungsi untuk toggle notifikasi
  void _toggleNotification(String prayerName) {
    if (mounted) {
      setState(() {
        prayerNotifications[prayerName] = (prayerNotifications[prayerName]! + 1) % 3;
      });
    }
  }

  // Fungsi untuk mengecek koneksi internet
  Future<void> _checkInternetConnection() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    if (mounted) {
      setState(() {
        _isOnline = connectivityResult != ConnectivityResult.none;
      });
    }
  }

  // Fungsi untuk mengambil lokasi user
  Future<void> _getUserLocation() async {
    try {
      Position position = await _getCurrentLocation();
      List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);
      if (placemarks.isNotEmpty) {
        Placemark place = placemarks.first;
        if (mounted) {
          setState(() {
            // Hanya menampilkan nama kota (locality)
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
    Map<String, String> sortedPrayerTimes = Map.fromEntries(
      prayerTimes.entries.toList()..sort((a, b) => a.value.compareTo(b.value)),
    );

    // Cek jika waktu saat ini sudah melewati sholat Isya
    DateTime isyaTime = DateFormat('HH:mm').parse(prayerTimes['Isya'] ?? '00:00');
    DateTime isyaDateTime = DateTime(now.year, now.month, now.day, isyaTime.hour, isyaTime.minute);

    if (now.isAfter(isyaDateTime)) {
      // Jika sudah melewati Isya, sholat berikutnya adalah Subuh hari esok
      DateTime subuhTime = DateFormat('HH:mm').parse(prayerTimes['Subuh'] ?? '00:00');
      DateTime subuhDateTime = DateTime(now.year, now.month, now.day + 1, subuhTime.hour, subuhTime.minute);

      if (mounted) {
        setState(() {
          nextPrayer = 'Subuh (Besok)';
          timeUntilNextPrayer = subuhDateTime.difference(now);
        });
      }
      return;
    }

    // Jika belum melewati Isya, cari sholat berikutnya hari ini
    for (var entry in sortedPrayerTimes.entries) {
      DateTime prayerTime = DateFormat('HH:mm').parse(entry.value);
      DateTime prayerDateTime = DateTime(now.year, now.month, now.day, prayerTime.hour, prayerTime.minute);

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
    final prefs = await SharedPreferences.getInstance();
    times.forEach((key, value) {
      prefs.setString(key, value);
    });
  }

  Future<Map<String, String>> loadPrayerTimesFromCache() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'Subuh': prefs.getString('Subuh') ?? '',
      'Dzuhur': prefs.getString('Dzuhur') ?? '',
      'Ashar': prefs.getString('Ashar') ?? '',
      'Maghrib': prefs.getString('Maghrib') ?? '',
      'Isya': prefs.getString('Isya') ?? '',
    };
  }

  Future<void> fetchPrayerTimesWithCache(http.Client client, DateTime date) async {
    if (mounted) {
      setState(() {
        prayerTimes = {}; // Reset data sementara
      });
    }

    try {
      prayerTimes = await loadPrayerTimesFromCache(); // Tampilkan cache terlebih dahulu
      await fetchPrayerTimes(client, date); // Perbarui data dari server
      await savePrayerTimesToCache(prayerTimes); // Simpan ke cache
    } catch (e) {
      debugPrint("Error fetching prayer times: $e");
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

      final response = await client.get(url).timeout(const Duration(seconds: 10)); // Timeout handling

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
          fetchPrayerTimesWithCache(widget.client, selectedDate); // Coba ambil data lagi
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
      body: SingleChildScrollView(
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
                        ),
                        const SizedBox(height: 12),
                        // Waktu tersisa
                        Text(
                          'Waktu tersisa: ${timeUntilNextPrayer.inHours} : ${timeUntilNextPrayer.inMinutes.remainder(60)} : ${timeUntilNextPrayer.inSeconds.remainder(60)}',
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 11,
                          ),
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
                    icon: Icon(Icons.arrow_left, size: 40, color: Colors.white),
                    onPressed: () => _changeDate(-1),
                  ),
                  // Card tanggal
                  Container(
                    height: 80,
                    width: 230,
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(
                      color: _isToday(selectedDate) ? Color(0xFF2DDCBE) : Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: _isToday(selectedDate) ? null : Border.all(color: Color(0xFF004C7E), width: 2),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Tanggal Masehi
                        Text(
                          DateFormat('EEEE, dd MMMM yyyy', 'id_ID').format(selectedDate),
                          style: GoogleFonts.poppins(
                            color: _isToday(selectedDate) ? Colors.white : const Color(0xFF004C7E),
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
                            color: _isToday(selectedDate) ? const Color(0xB3FFFFFF) : Colors.black54,
                            fontSize: 16,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                  // Tombol panah kanan
                  IconButton(
                    icon: Icon(Icons.arrow_right, size: 40, color: Colors.white),
                    onPressed: () => _changeDate(1),
                  ),
                ],
              ),
            ),
            // Daftar waktu sholat
            ...prayerTimes.entries.map((entry) {
              final prayerName = entry.key == 'Dzuhur' && isFriday(selectedDate) ? 'Dzuhur/Jumat' : entry.key;

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
                        padding: EdgeInsets.only(left: 16), // Geser ikon ke kanan
                        icon: Icon(
                          _getNotificationIcon(prayerNotifications[entry.key] ?? 0),
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