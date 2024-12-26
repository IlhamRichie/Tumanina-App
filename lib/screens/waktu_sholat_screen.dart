import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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

  Future<void> fetchPrayerTimes(http.Client client) async {
    try {
      final url = Uri.parse(
          'http://api.aladhan.com/v1/timingsByCity?city=Tegal&country=Indonesia&method=4');
      final response = await client.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print(data); // Debugging untuk memeriksa data
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
      } else {
        setState(() {
          errorMessage = 'Gagal memuat waktu sholat, periksa internet anda';
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Gagal memuat waktu sholat, periksa internet anda';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Waktu Sholat Tegal'),
        centerTitle: true,
        backgroundColor: const Color(0xFF2DDCBE),
      ),
      body: errorMessage.isNotEmpty
          ? Center(
              child: Text(
                errorMessage,
                style: const TextStyle(color: Colors.red, fontSize: 18),
              ),
            )
          : prayerTimes.isNotEmpty
              ? ListView(
                  padding: const EdgeInsets.all(16),
                  children: prayerTimes.entries.map((entry) {
                    return Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 4,
                      child: ListTile(
                        leading: Icon(
                          _getPrayerIcon(entry.key),
                          color: const Color(0xFF004C7E),
                        ),
                        title: Text(
                          entry.key,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                        trailing: Text(
                          entry.value,
                          style: const TextStyle(
                              fontSize: 16, color: Colors.black54),
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
