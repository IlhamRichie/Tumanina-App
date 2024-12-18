import 'package:flutter/material.dart';

class MengenalSholatScreen extends StatelessWidget {
  const MengenalSholatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mengenal Sholat dan Jenis Sholat', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: const [
            Text(
              'Mengenal Sholat dan Jenis Sholat',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'Sholat adalah ibadah wajib yang harus dilaksanakan oleh umat Muslim. Sholat terbagi menjadi beberapa jenis, seperti:\n\n'
              '1. Sholat Wajib: Sholat lima waktu yang harus dilaksanakan setiap hari (Subuh, Dzuhur, Ashar, Maghrib, dan Isya).\n'
              '2. Sholat Sunnah: Sholat yang dianjurkan untuk dikerjakan tetapi tidak wajib, seperti sholat Dhuha, Tahajud, dan Witir.\n\n'
              'Dengan mengenal jenis-jenis sholat, diharapkan kita dapat lebih memahami pentingnya menjaga sholat dalam kehidupan sehari-hari.',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
