import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:adhan/adhan.dart';
import 'dart:convert';

class PantauSholatScreen extends StatefulWidget {
  final Function(Map<String, bool>) onUpdate; // Callback function

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

    widget.onUpdate({
      'Shubuh': todayLog['shubuh'] ?? false,
      'Dzuhur': todayLog['dzuhur'] ?? false,
      'Ashar': todayLog['ashar'] ?? false,
      'Maghrib': todayLog['maghrib'] ?? false,
      'Isya': todayLog['isya'] ?? false,
    });

    saveProgress();
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
          ? const Center(
              child: CircularProgressIndicator()) 
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Pantau Sholat Hari Ini',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        ...todayLog.entries.map((entry) {
                          IconData? icon;
                          switch (entry.key) {
                            case 'shubuh':
                              icon = Icons.sunny;
                              break;
                            case 'dzuhur':
                              icon = Icons.access_time;
                              break;
                            case 'ashar':
                              icon = Icons.access_time_filled;
                              break;
                            case 'maghrib':
                              icon = Icons.nights_stay;
                              break;
                            case 'isya':
                              icon = Icons.brightness_2;
                              break;
                          }
                          return CheckboxListTile(
                            title: Row(
                              children: [
                                Icon(icon, color: Colors.teal),
                                const SizedBox(width: 8),
                                Text(entry.key.capitalize(), style: TextStyle(fontSize: 16)),
                              ],
                            ),
                            checkColor: Colors.white,
                            fillColor: MaterialStateProperty.resolveWith((states) {
                              if (states.contains(MaterialState.selected)) {
                                return const Color(0xFF2DDCBE);
                              }
                              return Colors.grey[300];
                            }),
                            value: entry.value,
                            onChanged: (value) {
                              if (value != null) {
                                updateLog(entry.key, value);
                              }
                            },
                          );
                        }),
                      ],
                    ),
                  ),
                  PrayerChart(prayerLog: prayerLog), // This is where the chart is added
                ],
              ),
            ),
    );
  }
}

// Prayer log chart component
class PrayerChart extends StatelessWidget {
  final List<Map<String, dynamic>> prayerLog;

  const PrayerChart({super.key, required this.prayerLog});

  @override
  Widget build(BuildContext context) {
    List<_ChartData> chartData = prayerLog.map((data) {
      int completedPrayers = 0;
      if (data['shubuh'] == true) completedPrayers++;
      if (data['dzuhur'] == true) completedPrayers++;
      if (data['ashar'] == true) completedPrayers++;
      if (data['maghrib'] == true) completedPrayers++;
      if (data['isya'] == true) completedPrayers++;
      return _ChartData(data['date'], completedPrayers);
    }).toList();

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SfCartesianChart(
        primaryXAxis: CategoryAxis(
          majorGridLines: MajorGridLines(width: 0),
          axisLine: AxisLine(width: 0),
        ),
        primaryYAxis: NumericAxis(
          axisLine: AxisLine(width: 0),
          majorTickLines: MajorTickLines(size: 0),
          isVisible: false,
        ),
        title: ChartTitle(
          text: 'Jumlah Sholat Harian',
          textStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.teal),
        ),
        series: <CartesianSeries>[
          ColumnSeries<_ChartData, String>(
            dataSource: chartData,
            xValueMapper: (_ChartData data, _) => data.date,
            yValueMapper: (_ChartData data, _) => data.completedPrayers,
            dataLabelSettings: const DataLabelSettings(isVisible: true),
            borderRadius: BorderRadius.circular(10),
            color: const Color(0xFF4CAF50),
            gradient: LinearGradient(
              colors: [Color(0xFF81C784), Color(0xFF388E3C)],
              stops: [0.0, 1.0],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            trackBorderWidth: 0,
            width: 0.8,
          ),
        ],
        tooltipBehavior: TooltipBehavior(
          enable: true,
          header: 'Sholat Count',
          textStyle: TextStyle(color: Colors.white),
          color: Colors.black.withOpacity(0.7),
        ),
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
