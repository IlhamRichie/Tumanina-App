import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:google_fonts/google_fonts.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import '/widgets/no_internet.dart'; // Sesuaikan path-nya
import 'package:intl/intl.dart'; // Untuk format tanggal (opsional)

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
  final ScrollController _scrollController =
      ScrollController(); // Controller untuk scroll
  List<Map<String, dynamic>> calendarData =
      []; // Data kalender dari API Aladhan

  // Data statis hari libur (contoh)
  final Map<DateTime, String> _publicHolidays = {
    DateTime(2023, 1, 1): "Tahun Baru Masehi",
    DateTime(2023, 3, 22): "Hari Raya Nyepi",
    DateTime(2023, 4, 7): "Wafat Isa Almasih",
    DateTime(2023, 5, 1): "Hari Buruh Internasional",
    DateTime(2023, 5, 18): "Kenaikan Isa Almasih",
    DateTime(2023, 6, 1): "Hari Lahir Pancasila",
    DateTime(2023, 6, 29): "Hari Raya Idul Fitri",
    DateTime(2023, 8, 17): "Hari Kemerdekaan RI",
    DateTime(2023, 12, 25): "Hari Raya Natal",
  };

  @override
  void initState() {
    super.initState();
    _checkInternetConnection(); // Cek koneksi internet saat init
    fetchPrayerTimesWithCache(widget.client, selectedDate);
    fetchCalendarData(
        selectedDate.month, selectedDate.year); // Ambil data kalender
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToSelectedDate(); // Scroll ke tanggal yang dipilih setelah build selesai
    });
  }

  @override
  void dispose() {
    _isDisposed = true;
    _scrollController.dispose(); // Dispose controller
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

  Future<void> fetchCalendarData(int month, int year) async {
    try {
      Position position = await _getCurrentLocation();
      double latitude = position.latitude;
      double longitude = position.longitude;

      final url = Uri.parse(
        'https://api.aladhan.com/v1/calendar?latitude=$latitude&longitude=$longitude&method=4&month=$month&year=$year',
      );

      final response = await widget.client.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (!_isDisposed && mounted) {
          setState(() {
            calendarData = List<Map<String, dynamic>>.from(data['data']);
          });
        }
      } else {
        setState(() {
          errorMessage = 'Gagal memuat data kalender.';
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Gagal memuat data kalender.';
      });
    }
  }

  void _changeDate(int days) {
    setState(() {
      selectedDate = selectedDate.add(Duration(days: days));
    });
    fetchPrayerTimesWithCache(widget.client, selectedDate);
    fetchCalendarData(
        selectedDate.month, selectedDate.year); // Perbarui data kalender
    _scrollToSelectedDate(); // Scroll ke tanggal yang dipilih
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

  // Daftar nama bulan dalam Bahasa Indonesia
  final List<String> _monthNames = [
    'Januari',
    'Februari',
    'Maret',
    'April',
    'Mei',
    'Juni',
    'Juli',
    'Agustus',
    'September',
    'Oktober',
    'November',
    'Desember',
  ];

  // Fungsi untuk scroll ke tanggal yang dipilih
  void _scrollToSelectedDate() {
    final index = selectedDate.difference(DateTime.now()).inDays +
        2; // Hitung index tanggal yang dipilih
    final offset = index * 136.0; // Lebar card + margin
    _scrollController.animateTo(
      offset,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
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
            height: 120, // Tinggi container diubah agar lebih lebar
            child: Stack(
              children: [
                ListView(
                  controller:
                      _scrollController, // Gunakan controller untuk scroll
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
                                'Min',
                                'Sen',
                                'Sel',
                                'Rab',
                                'Kam',
                                'Jum',
                                'Sab'
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
                            const SizedBox(height: 4),
                            Text(
                              _monthNames[
                                  day.month - 1], // Tampilkan nama bulan
                              style: GoogleFonts.poppins(
                                color: isToday
                                    ? Colors.white70
                                    : Colors.black54, // Warna teks
                                fontSize: isToday
                                    ? 16
                                    : 14, // Ukuran teks hari ini lebih besar
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
                        entry.key,
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
                // Tabel Kalender Masehi dan Hijriah
                Text(
                  'Kalender Masehi dan Hijriah',
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF004C7E),
                  ),
                ),
                const SizedBox(height: 10),
                ...calendarData.map((day) {
                  final gregorianDate = day['date']['gregorian']['date'];
                  final hijriDate = day['date']['hijri']['date'];
                  final date = DateTime.parse(day['date']['gregorian']['date']);
                  final isHoliday = _publicHolidays
                      .containsKey(DateTime(date.year, date.month, date.day));

                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    color: isHoliday
                        ? Colors.red[50]
                        : Colors.white, // Warna latar belakang untuk hari libur
                    child: ListTile(
                      title: Text(
                        'Masehi: $gregorianDate',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          color: isHoliday
                              ? Colors.red
                              : Colors.black87, // Warna teks untuk hari libur
                        ),
                      ),
                      subtitle: Text(
                        'Hijriah: $hijriDate',
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: isHoliday
                              ? Colors.red[700]
                              : Colors.grey, // Warna teks untuk hari libur
                        ),
                      ),
                      trailing: isHoliday
                          ? Text(
                              _publicHolidays[DateTime(
                                      date.year, date.month, date.day)] ??
                                  '',
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                color: Colors.red,
                                fontWeight: FontWeight.bold,
                              ),
                            )
                          : null,
                    ),
                  );
                }).toList(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
