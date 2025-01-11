import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'dart:convert';

class PantauSholatScreen extends StatefulWidget {
  final Function(Map<String, bool>) onUpdate;
  final Map<String, String> prayerTimes;

  const PantauSholatScreen({
    Key? key,
    required this.onUpdate,
    required this.prayerTimes,
  }) : super(key: key);

  @override
  _PantauSholatScreenState createState() => _PantauSholatScreenState();
}

class _PantauSholatScreenState extends State<PantauSholatScreen> {
  Map<String, bool> todayLog = {
    'Shubuh': false,
    'Dzuhur': false,
    'Ashar': false,
    'Maghrib': false,
    'Isya': false,
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
    await prefs.setString('prayerLog', json.encode(prayerLog));
  }

  Future<void> loadProgress() async {
    final prefs = await SharedPreferences.getInstance();
    final String? jsonLog = prefs.getString('prayerLog');
    final today = DateTime.now().toString().split(' ')[0];

    if (jsonLog != null) {
      prayerLog = List<Map<String, dynamic>>.from(json.decode(jsonLog));

      final todayEntry = prayerLog.firstWhere(
        (log) => log['date'] == today,
        orElse: () => {
          'date': today,
          'Shubuh': false,
          'Dzuhur': false,
          'Ashar': false,
          'Maghrib': false,
          'Isya': false,
        },
      );

      todayLog = {
        'Shubuh': todayEntry['Shubuh'] ?? false,
        'Dzuhur': todayEntry['Dzuhur'] ?? false,
        'Ashar': todayEntry['Ashar'] ?? false,
        'Maghrib': todayEntry['Maghrib'] ?? false,
        'Isya': todayEntry['Isya'] ?? false,
      };
    } else {
      prayerLog = [
        {
          'date': today,
          'Shubuh': false,
          'Dzuhur': false,
          'Ashar': false,
          'Maghrib': false,
          'Isya': false,
        }
      ];
    }

    setState(() {
      isLoading = false;
    });
  }

  bool isTimeValid(String prayerKey) {
    final now = DateTime.now();
    final prayerTime = _parsePrayerTime(prayerKey);
    final nextPrayerTime = _getNextPrayerTime(prayerKey);
    return now.isAfter(prayerTime) && now.isBefore(nextPrayerTime);
  }

  DateTime _parsePrayerTime(String prayerKey) {
    final now = DateTime.now();
    final timeString = widget.prayerTimes[prayerKey] ?? "00:00";
    final timeParts = timeString.split(':');
    return DateTime(
      now.year,
      now.month,
      now.day,
      int.parse(timeParts[0]),
      int.parse(timeParts[1]),
    );
  }

  DateTime _getNextPrayerTime(String prayerKey) {
    final prayerOrder = ['Shubuh', 'Dzuhur', 'Ashar', 'Maghrib', 'Isya'];
    final currentIndex = prayerOrder.indexOf(prayerKey);

    if (currentIndex == -1) return DateTime.now();

    if (currentIndex == prayerOrder.length - 1) {
      return _parsePrayerTime('Shubuh').add(Duration(days: 1));
    }

    return _parsePrayerTime(prayerOrder[currentIndex + 1]);
  }

  void updateLog(String prayer, bool value) {
    final today = DateTime.now().toString().split(' ')[0];
    setState(() {
      todayLog[prayer] = value;
      final todayIndex = prayerLog.indexWhere((log) => log['date'] == today);
      if (todayIndex != -1) {
        prayerLog[todayIndex] = {'date': today, ...todayLog};
      } else {
        prayerLog.add({'date': today, ...todayLog});
      }
    });
    widget.onUpdate(todayLog);
    saveProgress();
  }

  IconData getPrayerIcon(String prayerKey) {
    switch (prayerKey) {
      case 'Shubuh':
        return Icons.wb_sunny;
      case 'Dzuhur':
        return Icons.sunny;
      case 'Ashar':
        return Icons.cloud;
      case 'Maghrib':
        return Icons.nights_stay;
      case 'Isya':
        return Icons.brightness_3;
      default:
        return Icons.circle_outlined;
    }
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
          icon: const Icon(Icons.arrow_back, color: Color(0xFF004C7E)),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Pantau Sholat Hari Ini',
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        color: const Color(0xFF004C7E),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildPrayerChecklist(),
                    const SizedBox(height: 20),
                    _buildPrayerChart(),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildPrayerChecklist() {
    return Column(
      children: todayLog.entries.map((entry) {
        final isActive = isTimeValid(entry.key);
        return ListTile(
          leading: Icon(
            getPrayerIcon(entry.key),
            color: isActive ? const Color(0xFF2DDCBE) : Colors.grey,
          ),
          title: Text(
            entry.key,
            style: TextStyle(
              color: isActive ? const Color(0xFF2DDCBE) : Colors.grey.shade700,
              fontWeight: FontWeight.w600,
            ),
          ),
          trailing: Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color:
                  entry.value ? const Color(0xFF2DDCBE) : Colors.grey.shade300,
            ),
            child: Icon(
              entry.value ? Icons.check : Icons.close,
              color: Colors.white,
              size: 20,
            ),
          ),
          onTap: isActive
              ? () {
                  updateLog(entry.key, !entry.value);
                }
              : null,
        );
      }).toList(),
    );
  }

  Widget _buildPrayerChart() {
    List<_ChartData> chartData = prayerLog.map((log) {
      final date = log['date'] is String ? log['date'] : 'Unknown';
      int completed = log.entries
          .where((entry) => entry.key != 'date' && entry.value == true)
          .length;

      return _ChartData(date, completed);
    }).toList();

    return SfCartesianChart(
      primaryXAxis: CategoryAxis(),
      primaryYAxis: NumericAxis(),
      series: <CartesianSeries<_ChartData, String>>[
        ColumnSeries<_ChartData, String>(
          dataSource: chartData,
          xValueMapper: (_ChartData data, _) => data.date,
          yValueMapper: (_ChartData data, _) => data.completed,
          gradient: const LinearGradient(
            colors: [Color(0xFF2DDCBE), Color(0xFF004C7E)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
      ],
    );
  }
}

class _ChartData {
  final String date;
  final int completed;

  _ChartData(this.date, this.completed);
}
