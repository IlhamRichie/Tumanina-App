import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:google_fonts/google_fonts.dart';
import 'package:geolocator/geolocator.dart';

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

    // Cek status lokasi
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
      // Mendapatkan posisi pengguna
      Position position = await _getCurrentLocation();
      double latitude = position.latitude;
      double longitude = position.longitude;

      final url = Uri.parse(
        'http://api.aladhan.com/v1/timings?latitude=$latitude&longitude=$longitude&method=4'
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
        if (mounted) {
          setState(() {
            errorMessage = 'Gagal memuat waktu sholat, periksa internet anda';
          });
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          errorMessage = 'Gagal memuat waktu sholat, periksa internet anda';
        });
      }
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
                    fontSize: 18
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            )
          : prayerTimes.isNotEmpty
              ? ListView(
                  padding: const EdgeInsets.all(16),
                  children: prayerTimes.entries.map((entry) {
                    return Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 5,
                      shadowColor: Colors.black.withOpacity(0.2),
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Color(0xFF2DDCBE), Color(0xFF004C7E)],
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
                  }).toList(),
                )
              : const Center(
                  child: CircularProgressIndicator(
                    valueColor:
                        AlwaysStoppedAnimation<Color>(Color(0xFF004C7E)),
                  ),
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
