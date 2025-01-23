import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '/widgets/no_internet.dart';

class PantauSholatScreen extends StatefulWidget {
  final Function(Map<String, bool>) onUpdate;
  final Map<String, bool> sholatMilestones;
  final Map<String, String> prayerTimes; // Tambahkan ini

  const PantauSholatScreen({
    super.key,
    required this.onUpdate,
    this.sholatMilestones = const {},
    required this.prayerTimes, // Tambahkan ini
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
  Map<String, String> prayerTimes = {};
  bool hasInternet = true;

  @override
  void initState() {
    super.initState();
    fetchPrayerTimes();
    loadProgress();
  }

  Future<void> fetchPrayerTimes() async {
    setState(() {
      isLoading = true;
    });

    try {
      final response = await http.get(Uri.parse(
          'http://api.aladhan.com/v1/timingsByAddress?address=Jakarta,Indonesia'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final timings = data['data']['timings'];
        setState(() {
          prayerTimes = {
            'subuh': timings['Fajr'],
            'dzuhur': timings['Dhuhr'],
            'ashar': timings['Asr'],
            'maghrib': timings['Maghrib'],
            'isya': timings['Isha'],
            'sunrise': timings['Sunrise'],
          };
          hasInternet = true;
        });
      } else {
        throw Exception('Failed to fetch prayer times');
      }
    } catch (e) {
      setState(() {
        hasInternet = false;
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
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

  bool isSubuhValid() {
    final now = DateTime.now();
    final sunriseTime = _getSunriseTime();

    return now.isBefore(sunriseTime);
  }

  DateTime _getPrayerTime(String prayerKey) {
    final now = DateTime.now();
    final prayerTimeString =
        prayerTimes[prayerKey] ?? "06:00"; // Default fallback
    final prayerTimeParts = prayerTimeString.split(':');
    return DateTime(
      now.year,
      now.month,
      now.day,
      int.parse(prayerTimeParts[0]),
      int.parse(prayerTimeParts[1]),
    );
  }

  DateTime _getSunriseTime() {
    final now = DateTime.now();
    final sunriseTimeString =
        prayerTimes['sunrise'] ?? "06:00"; // Default fallback
    final sunriseTimeParts = sunriseTimeString.split(':');
    return DateTime(
      now.year,
      now.month,
      now.day,
      int.parse(sunriseTimeParts[0]),
      int.parse(sunriseTimeParts[1]),
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

  String getNextPrayerInfo(String prayerKey) {
    if (prayerKey == 'subuh') {
      final subuhTime = _getPrayerTime('subuh');
      final sunriseTime = _getSunriseTime();
      return "${subuhTime.hour}:${subuhTime.minute.toString().padLeft(2, '0')} - ${sunriseTime.hour}:${sunriseTime.minute.toString().padLeft(2, '0')}";
    }

    final currentPrayerTime = _getPrayerTime(prayerKey);
    final nextPrayerTime = _getNextPrayerTime(prayerKey);

    return "${currentPrayerTime.hour}:${currentPrayerTime.minute.toString().padLeft(2, '0')} - ${nextPrayerTime.hour}:${nextPrayerTime.minute.toString().padLeft(2, '0')}";
  }

  Future<void> refreshData() async {
    await fetchPrayerTimes();
    await loadProgress();
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
    if (!hasInternet) {
      return NoInternetScreen(
        onRetry: () {
          fetchPrayerTimes();
        },
      );
    }

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
          : RefreshIndicator(
              onRefresh: refreshData,
              color: const Color(0xFF004C7E),
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
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
                            final prayerTimeInfo = getNextPrayerInfo(entry.key);
                            return ListTile(
                              leading: Icon(
                                getPrayerIcon(entry.key),
                                color: isTimeValid(entry.key)
                                    ? const Color(0xFF2DDCBE)
                                    : Colors.grey,
                              ),
                              title: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    entry.key.capitalize(),
                                    style: TextStyle(
                                      color: isTimeValid(entry.key)
                                          ? const Color(0xFF2DDCBE)
                                          : Colors.grey.shade700,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Waktu: $prayerTimeInfo',
                                    style: GoogleFonts.poppins(
                                      fontSize: 14,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
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
                                if (entry.key == 'subuh' && !isSubuhValid()) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                          'Tidak dapat mencentang Subuh setelah waktu matahari terbit!'),
                                    ),
                                  );
                                } else if (isTimeValid(entry.key)) {
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
                    PrayerChart(prayerLog: prayerLog),
                  ],
                ),
              ),
            ),
    );
  }
}

class PrayerChart extends StatelessWidget {
  final List<Map<String, dynamic>> prayerLog;

  const PrayerChart({super.key, required this.prayerLog});

  @override
  Widget build(BuildContext context) {
    List<_ChartData> chartData = prayerLog.map((data) {
      int completedPrayers = data.entries
          .where((entry) => entry.key != 'date' && entry.value == true)
          .length;
      return _ChartData(
        data['date'] as String,
        completedPrayers,
        data,
      );
    }).toList();

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SfCartesianChart(
        primaryXAxis: CategoryAxis(),
        primaryYAxis: NumericAxis(),
        tooltipBehavior: TooltipBehavior(enable: true),
        series: <CartesianSeries<_ChartData, String>>[
          ColumnSeries<_ChartData, String>(
            dataSource: chartData,
            xValueMapper: (_ChartData data, _) => data.date,
            yValueMapper: (_ChartData data, _) => data.completedPrayers,
            dataLabelSettings: const DataLabelSettings(isVisible: true),
            borderRadius: const BorderRadius.all(Radius.circular(5)),
            color: const Color(0xFF004C7E),
            onPointTap: (ChartPointDetails details) {
              if (details.pointIndex != null) {
                _ChartData selectedData = chartData[details.pointIndex!];
                _showPrayerDetails(
                    context, selectedData.date, selectedData.rawData);
              }
            },
          ),
        ],
      ),
    );
  }

  void _showPrayerDetails(
      BuildContext context, String date, Map<String, dynamic> prayerData) {
    List<String> completedPrayers = prayerData.entries
        .where((entry) => entry.key != 'date' && entry.value == true)
        .map((entry) => entry.key.capitalize())
        .toList();

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
          child: Container(
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF2DDCBE), Color(0xFF004C7E)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Container(
              margin: const EdgeInsets.all(3),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Sholat pada $date',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF004C7E),
                    ),
                  ),
                  const SizedBox(height: 12),
                  completedPrayers.isEmpty
                      ? const Text(
                          'Tidak ada sholat yang dikerjakan.',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black54,
                          ),
                        )
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: completedPrayers
                              .map(
                                (prayer) => Text(
                                  '- $prayer',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Colors.black87,
                                  ),
                                ),
                              )
                              .toList(),
                        ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _ChartData {
  final String date;
  final int completedPrayers;
  final Map<String, dynamic> rawData;

  _ChartData(this.date, this.completedPrayers, this.rawData);
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1)}";
  }
}
