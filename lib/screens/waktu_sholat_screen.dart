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

class WaktuSholatScreen extends StatefulWidget {
  final http.Client client;

  const WaktuSholatScreen({super.key, required this.client});

  @override
  WaktuSholatScreenState createState() => WaktuSholatScreenState();
}

class WaktuSholatScreenState extends State<WaktuSholatScreen> {
  Map<String, String> prayerTimes = {};
  String errorMessage = '';
  bool _isDisposed = false;
  DateTime selectedDate = DateTime.now();
  bool _isOnline = true; // Status koneksi internet
  String hijriDate = ''; // Variabel untuk menyimpan tanggal dan bulan Hijriyah

  bool isFriday(DateTime date) {
    return date.weekday == DateTime.friday;
  }

  @override
  void initState() {
    super.initState();
    _checkInternetConnection(); // Cek koneksi internet saat init
    fetchPrayerTimesWithCache(widget.client, selectedDate);
  }

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }

  // Fungsi untuk mengecek koneksi internet
  Future<void> _checkInternetConnection() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    setState(() {
      _isOnline = connectivityResult != ConnectivityResult.none;
    });
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

  Future<void> fetchPrayerTimesWithCache(
      http.Client client, DateTime date) async {
    setState(() {
      prayerTimes = {}; // Reset data sementara
    });

    try {
      prayerTimes =
          await loadPrayerTimesFromCache(); // Tampilkan cache terlebih dahulu
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

      final response = await client
          .get(url)
          .timeout(const Duration(seconds: 10)); // Timeout handling

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (!_isDisposed && mounted) {
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
    setState(() {
      selectedDate = selectedDate.add(Duration(days: days));
    });
    fetchPrayerTimesWithCache(widget.client, selectedDate);
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
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Waktu Sholat',
          style: GoogleFonts.poppins(
            color: const Color(0xFF004C7E),
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          SizedBox(
            height: 140, // Tinggi container diubah agar lebih lebar
            child: Stack(
              children: [
                ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 40.0), // Padding untuk memberi ruang arrow
                  children: List.generate(5, (index) {
                    final day = selectedDate.add(Duration(
                        days: index - 2)); // Sesuaikan perhitungan tanggal
                    final isToday =
                        day.day == DateTime.now().day; // Cek apakah hari ini
                    return GestureDetector(
                      onTap: () => _changeDate(
                          index - 2), // Sesuaikan perhitungan tanggal
                      child: Container(
                        width: isToday
                            ? 160
                            : 120, // Lebar card hari ini lebih panjang
                        margin: const EdgeInsets.symmetric(horizontal: 8.0),
                        padding: const EdgeInsets.all(12.0),
                        decoration: BoxDecoration(
                          color: isToday
                              ? const Color(0xFF004C7E) // Warna card hari ini
                              : Colors.white, // Warna card kemarin dan besok
                          borderRadius: BorderRadius.circular(12),
                          border: isToday
                              ? null
                              : Border.all(
                                  color:
                                      const Color(0xFF004C7E), // Warna border
                                  width: 2,
                                ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              day.day.toString(),
                              style: GoogleFonts.poppins(
                                color: isToday
                                    ? Colors.white
                                    : Colors.black, // Warna teks
                                fontWeight: FontWeight.bold,
                                fontSize: isToday
                                    ? 20
                                    : 18, // Ukuran teks hari ini lebih besar
                              ),
                            ),
                            Text(
                              [
                                'Minggu',
                                'Senin',
                                'Selasa',
                                'Rabu',
                                'Kamis',
                                'Jumat',
                                'Sabtu'
                              ][day.weekday % 7],
                              style: GoogleFonts.poppins(
                                color: isToday
                                    ? Colors.white70
                                    : Colors.black54, // Warna teks
                                fontSize: isToday
                                    ? 18
                                    : 16, // Ukuran teks hari ini lebih besar
                              ),
                            ),
                            // Tambahkan tanggal dan bulan Hijriyah di sini
                            Text(
                              hijriDate, // Tampilkan tanggal dan bulan Hijriyah
                              style: GoogleFonts.poppins(
                                color: isToday
                                    ? Colors.white70
                                    : Colors.black54, // Warna teks
                                fontSize: 14,
                              ),
                            ),
                            // Tambahkan bulan Masehi di sini
                            Text(
                              DateFormat('MMMM').format(day), // Tampilkan bulan Masehi
                              style: GoogleFonts.poppins(
                                color: isToday
                                    ? Colors.white70
                                    : Colors.black54, // Warna teks
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                ),
                // Icon arrow kiri
                Positioned(
                  left: 0,
                  top: 0,
                  bottom: 0,
                  child: Center(
                    child: IconButton(
                      icon:
                          const Icon(Icons.arrow_back_ios, color: Colors.black),
                      onPressed: () {
                        _changeDate(-1); // Pindah ke tanggal sebelumnya
                      },
                    ),
                  ),
                ),
                // Icon arrow kanan
                Positioned(
                  right: 0,
                  top: 0,
                  bottom: 0,
                  child: Center(
                    child: IconButton(
                      icon: const Icon(Icons.arrow_forward_ios,
                          color: Colors.black),
                      onPressed: () {
                        _changeDate(1); // Pindah ke tanggal berikutnya
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                ...prayerTimes.entries.map((entry) {
                  final prayerName =
                      entry.key == 'Dzuhur' && isFriday(selectedDate)
                          ? 'Dzuhur/Jumat'
                          : entry.key;

                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
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
                          fontSize: 20,
                          color: Colors.white,
                        ),
                      ),
                      trailing: Text(
                        entry.value,
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  );
                }).toList(),
                const SizedBox(height: 20),
                // Sekat di bawah waktu Isya
                const Divider(
                  color: Colors.grey,
                  thickness: 1,
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }
}