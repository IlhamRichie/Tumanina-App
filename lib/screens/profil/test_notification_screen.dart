import 'package:flutter/material.dart';
import '/services/notif_service.dart'; // Sesuaikan path-nya

class TestNotificationScreen extends StatelessWidget {
  final NotificationService _notificationService = NotificationService();

  TestNotificationScreen({super.key}) {
    _notificationService.init(); // Inisialisasi layanan notifikasi
  }

  // Fungsi untuk memicu notifikasi dengan suara notifikasi biasa
  void _triggerNotificationSound() async {
    DateTime scheduledTime = DateTime.now().add(Duration(seconds: 1)); // Jadwalkan 1 detik dari sekarang
    String sound = 'notification'; // Suara notifikasi biasa

    await _notificationService.scheduleNotification(
      id: 'notification_sound'.hashCode,
      title: 'Tes Notifikasi',
      body: 'Ini adalah tes notifikasi dengan suara biasa.',
      scheduledTime: scheduledTime,
      sound: sound,
    );
  }

  // Fungsi untuk memicu notifikasi dengan suara adzan
  void _triggerAdhanNotification(String prayerName) async {
    DateTime scheduledTime = DateTime.now().add(Duration(seconds: 1)); // Jadwalkan 1 detik dari sekarang
    String sound = (prayerName == 'Subuh') ? 'adzansubuh' : 'adzan';

    await _notificationService.scheduleNotification(
      id: prayerName.hashCode,
      title: 'Waktu Sholat $prayerName',
      body: 'Waktunya sholat $prayerName!',
      scheduledTime: scheduledTime,
      sound: sound,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Testing Notifikasi & Suara Adzan'),
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Tombol untuk menguji suara notifikasi biasa
            ElevatedButton(
              onPressed: _triggerNotificationSound,
              child: Text('Tes Suara Notifikasi'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              ),
            ),
            SizedBox(height: 20),
            // Tombol untuk menguji suara adzan Subuh
            ElevatedButton(
              onPressed: () => _triggerAdhanNotification('Subuh'),
              child: Text('Tes Suara Adzan Subuh'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              ),
            ),
            SizedBox(height: 20),
            // Tombol untuk menguji suara adzan Dzuhur
            ElevatedButton(
              onPressed: () => _triggerAdhanNotification('Dzuhur'),
              child: Text('Tes Suara Adzan Dzuhur'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              ),
            ),
            SizedBox(height: 20),
            // Tombol untuk menguji suara adzan Maghrib
            ElevatedButton(
              onPressed: () => _triggerAdhanNotification('Maghrib'),
              child: Text('Tes Suara Adzan Maghrib'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              ),
            ),
          ],
        ),
      ),
    );
  }
}