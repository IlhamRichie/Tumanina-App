import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'dart:convert';

class PantauSholatScreen extends StatefulWidget {
  final Function(Map<String, bool>) onUpdate; // Menambahkan parameter callback

  const PantauSholatScreen({super.key, required this.onUpdate, required Map<String, bool> sholatMilestones});

  @override
  _PantauSholatScreenState createState() => _PantauSholatScreenState();
}

class _PantauSholatScreenState extends State<PantauSholatScreen> {
  List<Map<String, dynamic>> prayerLog = [];
  Map<String, bool> todayLog = {
    'shubuh': false,
    'dzuhur': false,
    'ashar': false,
    'maghrib': false,
    'isya': false,
  };
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadProgress();
  }

  Future<void> saveProgress() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonLog = json.encode(prayerLog);
    await prefs.setString('prayerLog', jsonLog);
  }

  Future<void> loadProgress() async {
    final prefs = await SharedPreferences.getInstance();
    final String? jsonLog = prefs.getString('prayerLog');
    final today = DateTime.now().toString().split(' ')[0];

    if (jsonLog != null) {
      setState(() {
        prayerLog = List<Map<String, dynamic>>.from(json.decode(jsonLog));
      });

      // Periksa apakah hari ini ada di prayerLog, jika tidak, tambahkan
      final todayEntry = prayerLog.firstWhere(
        (log) => log['date'] == today,
        orElse: () => {
          'date': today,
          'shubuh': false,
          'dzuhur': false,
          'ashar': false,
          'maghrib': false,
          'isya': false,
        },
      );

      setState(() {
        todayLog = {
          'shubuh': todayEntry['shubuh'],
          'dzuhur': todayEntry['dzuhur'],
          'ashar': todayEntry['ashar'],
          'maghrib': todayEntry['maghrib'],
          'isya': todayEntry['isya'],
        };
      });
    } else {
      setState(() {
        prayerLog = [
          {
            'date': today,
            'shubuh': false,
            'dzuhur': false,
            'ashar': false,
            'maghrib': false,
            'isya': false,
          }
        ];
        todayLog = {
          'shubuh': false,
          'dzuhur': false,
          'ashar': false,
          'maghrib': false,
          'isya': false,
        };
      });
    }

    setState(() {
      isLoading = false;
    });
  }

 void updateLog(String prayer, bool value) {
  final today = DateTime.now().toString().split(' ')[0];

  setState(() {
    todayLog[prayer] = value;

    // Perbarui atau tambahkan entri hari ini ke prayerLog
    final todayIndex = prayerLog.indexWhere((log) => log['date'] == today);
    if (todayIndex != -1) {
      prayerLog[todayIndex] = {
        'date': today,
        ...todayLog,
      };
    } else {
      prayerLog.add({
        'date': today,
        ...todayLog,
      });
    }
  });

  // Kirim data kembali ke HomeScreen
  widget.onUpdate({
    'Shubuh': todayLog['shubuh'] ?? false,
    'Dzuhur': todayLog['dzuhur'] ?? false,
    'Ashar': todayLog['ashar'] ?? false,
    'Maghrib': todayLog['maghrib'] ?? false,
    'Isya': todayLog['isya'] ?? false,
  });

  saveProgress(); // Simpan progres
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Pantau Sholat',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        centerTitle: true,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator()) // Indikator loading
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Checklist sholat hari ini
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Checklist Sholat Hari Ini',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        ...todayLog.entries.map((entry) {
                          return CheckboxListTile(
                            title: Text(entry.key.capitalize()),
                            value: entry.value,
                            onChanged: (value) {
                              updateLog(entry.key, value!);
                            },
                          );
                        }),
                      ],
                    ),
                  ),

                  // Grafik log sholat
                  if (prayerLog.isNotEmpty)
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text(
                        'Grafik Sholat Harian',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                  if (prayerLog.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: PrayerChart(prayerLog: prayerLog),
                    ),
                ],
              ),
            ),
    );
  }
}

// Komponen Grafik
class PrayerChart extends StatelessWidget {
  final List<Map<String, dynamic>> prayerLog;

  const PrayerChart({super.key, required this.prayerLog});

  @override
  Widget build(BuildContext context) {
    // Konversi data untuk grafik
    List<_ChartData> chartData = prayerLog.map((data) {
      int completedPrayers = 0;
      if (data['shubuh'] == true) completedPrayers++;
      if (data['dzuhur'] == true) completedPrayers++;
      if (data['ashar'] == true) completedPrayers++;
      if (data['maghrib'] == true) completedPrayers++;
      if (data['isya'] == true) completedPrayers++;
      return _ChartData(data['date'], completedPrayers);
    }).toList();

    return SfCartesianChart(
      primaryXAxis: CategoryAxis(),
      title: ChartTitle(text: 'Jumlah Sholat Harian'),
      series: <ChartSeries>[
        ColumnSeries<_ChartData, String>(
          dataSource: chartData,
          xValueMapper: (_ChartData data, _) => data.date,
          yValueMapper: (_ChartData data, _) => data.completedPrayers,
          dataLabelSettings: const DataLabelSettings(isVisible: true),
        ),
      ],
    );
  }
}


class _ChartData {
  final String date;
  final int completedPrayers;

  _ChartData(this.date, this.completedPrayers);
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1)}";
  }
}
