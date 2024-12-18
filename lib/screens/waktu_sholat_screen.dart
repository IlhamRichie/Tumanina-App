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
  String errorMessage = ''; // Tambahkan variabel untuk menampilkan pesan error

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
        setState(() {
          prayerTimes = {
            'Subuh': data['data']['timings']['Fajr'],
            'Dzuhur': data['data']['timings']['Dhuhr'],
            'Ashar': data['data']['timings']['Asr'],
            'Maghrib': data['data']['timings']['Maghrib'],
            'Isya': data['data']['timings']['Isha'],
          };
          errorMessage = ''; // Hapus pesan error jika berhasil
        });
      } else {
        // Jika API gagal, tampilkan pesan error
        setState(() {
          errorMessage = 'Failed to load prayer times';
        });
      }
    } catch (e) {
      // Tangkap exception dan tampilkan pesan error
      setState(() {
        errorMessage = 'Failed to load prayer times';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Waktu Sholat Tegal'),
        centerTitle: true,
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
                  children: prayerTimes.entries.map((entry) {
                    return Card(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      child: ListTile(
                        title: Text(entry.key),
                        trailing: Text(entry.value),
                      ),
                    );
                  }).toList(),
                )
              : const Center(child: CircularProgressIndicator()),
    );
  }
}
