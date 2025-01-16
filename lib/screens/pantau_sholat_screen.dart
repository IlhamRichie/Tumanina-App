import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'dart:convert';

class PantauSholatScreen extends StatefulWidget {
  final Function(Map<String, bool>) onUpdate;
  final Map<String, String>
      prayerTimes; // Data waktu sholat dari WaktuSholatScreen
  final Map<String, bool> sholatMilestones; // Milestones sholat (bisa kosong)

  const PantauSholatScreen({
    super.key,
    required this.onUpdate,
    required this.prayerTimes,
    this.sholatMilestones = const {}, // Default jika tidak ada data
  });

  @override
  _PantauSholatScreenState createState() => _PantauSholatScreenState();
}

class _PantauSholatScreenState extends State<PantauSholatScreen> {
  Map<String, bool> todayLog = {
    'subuh': false,
    'dzuhur': false,
    'ashar': false,
    'maghrib': false,
    'isya': false,
  };
  List<Map<String, dynamic>> prayerLog = [];
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
        final todayEntry = prayerLog.firstWhere(
          (log) => log['date'] == today,
          orElse: () => {
            'date': today,
            'subuh': false,
            'dzuhur': false,
            'ashar': false,
            'maghrib': false,
            'isya': false,
          },
        );
        todayLog = {
          'subuh': todayEntry['subuh'],
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
            'subuh': false,
            'dzuhur': false,
            'ashar': false,
            'maghrib': false,
            'isya': false,
          }
        ];
      });
    }

    setState(() {
      isLoading = false;
    });
  }

  IconData getPrayerIcon(String prayerKey) {
    switch (prayerKey.toLowerCase()) {
      case 'subuh':
        return Icons.wb_sunny;
      case 'dzuhur':
        return Icons.sunny;
      case 'ashar':
        return Icons.cloud;
      case 'maghrib':
        return Icons.nights_stay;
      case 'isya':
        return Icons.brightness_3;
      default:
        return Icons.circle_outlined;
    }
  }

  bool isTimeValid(String prayerKey) {
    final now = DateTime.now();
    final currentPrayerTime = _getPrayerTime(prayerKey);
    final nextPrayerTime = _getNextPrayerTime(prayerKey);

    return now.isAfter(currentPrayerTime) && now.isBefore(nextPrayerTime);
  }

  DateTime _getPrayerTime(String prayerKey) {
    final now = DateTime.now();
    final prayerTimeString =
        widget.prayerTimes[prayerKey.capitalize()] ?? "00:00";
    final prayerTimeParts = prayerTimeString.split(':');
    return DateTime(
      now.year,
      now.month,
      now.day,
      int.parse(prayerTimeParts[0]),
      int.parse(prayerTimeParts[1]),
    );
  }

  DateTime _getNextPrayerTime(String prayerKey) {
    final prayerOrder = ['subuh', 'dzuhur', 'ashar', 'maghrib', 'isya'];
    final currentIndex = prayerOrder.indexOf(prayerKey);

    if (currentIndex == prayerOrder.length - 1) {
      return _getPrayerTime('subuh').add(const Duration(days: 1));
    }

    final nextPrayerKey = prayerOrder[currentIndex + 1];
    return _getPrayerTime(nextPrayerKey);
  }

  void updateLog(String prayer, bool value) {
    final today = DateTime.now().toString().split(' ')[0];

    setState(() {
      todayLog[prayer] = value;

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

    widget.onUpdate(todayLog);

    saveProgress();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Pantau Sholat',
          style: GoogleFonts.poppins(
            color: const Color(0xFF004C7E),
            fontWeight: FontWeight.bold,
          ),
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
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Pantau Sholat Hari Ini',
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        ...todayLog.entries.map((entry) {
                          return ListTile(
                            leading: Icon(
                              getPrayerIcon(entry.key),
                              color: isTimeValid(entry.key)
                                  ? const Color(0xFF2DDCBE)
                                  : Colors.grey,
                            ),
                            title: Text(
                              entry.key.capitalize(),
                              style: TextStyle(
                                color: isTimeValid(entry.key)
                                    ? const Color(0xFF2DDCBE)
                                    : Colors.grey.shade700,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            trailing: CircleAvatar(
                              backgroundColor: entry.value
                                  ? const Color(0xFF2DDCBE)
                                  : Colors.grey[300],
                              child: Icon(
                                entry.value
                                    ? Icons.check_circle
                                    : Icons.radio_button_unchecked,
                                color: Colors.white,
                              ),
                            ),
                            onTap: () {
                              if (isTimeValid(entry.key)) {
                                updateLog(entry.key, !entry.value);
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                        'Waktu untuk ${entry.key.capitalize()} telah berlalu atau belum waktunya.'),
                                  ),
                                );
                              }
                            },
                          );
                        }).toList(),
                      ],
                    ),
                  ),
                  PrayerChart(prayerLog: prayerLog), // Grafik
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
    List<_ChartData> chartData = prayerLog.where((data) {
      return data['date'] is String;
    }).map((data) {
      int completedPrayers = data.entries
          .where((entry) => entry.key != 'date' && entry.value == true)
          .length;
      return _ChartData(data['date'] as String, completedPrayers);
    }).toList();

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SfCartesianChart(
        primaryXAxis: CategoryAxis(),
        primaryYAxis: NumericAxis(),
        series: <CartesianSeries<_ChartData, String>>[
          ColumnSeries<_ChartData, String>(
            dataSource: chartData,
            xValueMapper: (_ChartData data, _) => data.date,
            yValueMapper: (_ChartData data, _) => data.completedPrayers,
            dataLabelSettings: const DataLabelSettings(isVisible: true),
            borderRadius: const BorderRadius.all(Radius.circular(5)),
            color: const Color(0xFF004C7E),
          ),
        ],
      ),
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
