import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:google_fonts/google_fonts.dart';
import 'package:geolocator/geolocator.dart';
import 'pantau_sholat_screen.dart';

class WaktuSholatScreen extends StatefulWidget {
  final http.Client client;

  const WaktuSholatScreen({super.key, required this.client});

  @override
  WaktuSholatScreenState createState() => WaktuSholatScreenState();
}

class WaktuSholatScreenState extends State<WaktuSholatScreen> {
  Map<String, String> prayerTimes = {};
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    fetchPrayerTimes(widget.client);
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

  Future<void> fetchPrayerTimes(http.Client client) async {
    try {
      Position position = await _getCurrentLocation();
      double latitude = position.latitude;
      double longitude = position.longitude;

      final url = Uri.parse(
        'http://api.aladhan.com/v1/timings?latitude=$latitude&longitude=$longitude&method=4',
      );
      final response = await client.get(url);

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
            errorMessage = '';
          });
        }
      } else {
        setState(() {
          errorMessage = 'Gagal memuat waktu sholat, periksa internet Anda.';
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Gagal memuat waktu sholat, periksa internet Anda.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
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
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        elevation: 0,
      ),
      body: errorMessage.isNotEmpty
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  errorMessage,
                  style: GoogleFonts.poppins(
                    color: Colors.red,
                    fontSize: 18,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            )
          : Column(
              children: [
                Expanded(
                  child: prayerTimes.isNotEmpty
                      ? ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: prayerTimes.entries.length,
                          itemBuilder: (context, index) {
                            final entry = prayerTimes.entries.elementAt(index);
                            return Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              elevation: 5,
                              shadowColor: Colors.black.withOpacity(0.2),
                              child: Container(
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    colors: [
                                      Color(0xFF2DDCBE),
                                      Color(0xFF004C7E)
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: ListTile(
                                  contentPadding: const EdgeInsets.all(16),
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
                              ),
                            );
                          },
                        )
                      : const Center(
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                                Color(0xFF004C7E)),
                          ),
                        ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ElevatedButton(
                    onPressed: () {
                      if (prayerTimes.isNotEmpty) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PantauSholatScreen(
                              prayerTimes: prayerTimes,
                              onUpdate: (log) {
                                print("Log sholat: $log");
                              },
                              sholatMilestones: {},
                            ),
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                                'Waktu sholat belum tersedia. Tunggu sebentar!'),
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF004C7E),
                      padding: const EdgeInsets.symmetric(
                          vertical: 16.0, horizontal: 24.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'Pantau Sholat',
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
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
        return Icons.nights_stay;
      case 'Isya':
        return Icons.brightness_3;
      default:
        return Icons.access_time;
    }
  }
}
