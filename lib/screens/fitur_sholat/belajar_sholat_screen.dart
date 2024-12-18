import 'package:flutter/material.dart';
import 'gerakan_sholat/sholat_screen.dart';
import 'syarat_sholat_screen.dart'; // Import halaman syarat sholat
import '../home_screen.dart'; // Import halaman syarat sholat

class BelajarSholatScreen extends StatelessWidget {
  const BelajarSholatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> belajarSholatItems = [
      {
        'title': 'Mengenal Sholat dan Jenis Sholat',
        'icon': Icons.book,
        'action': () {
          // Aksi untuk item ini
        },
      },
      {
        'title': 'Syarat Sholat',
        'icon': Icons.assignment,
        'action': () {
          // Navigasi ke halaman Syarat Sholat
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const SyaratSholatScreen(),
            ),
          );
        },
      },
      {
        'title': 'Gerakan dan Bacaan Sholat',
        'icon': Icons.directions_walk,
        'action': () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const SholatScreen(),
            ),
          );
        },
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Belajar Sholat', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const HomeScreen()),
              (Route<dynamic> route) => false,
            );
          },
        ),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: belajarSholatItems.length,
        itemBuilder: (context, index) {
          return Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            margin: const EdgeInsets.all(8.0),
            child: ListTile(
              leading: Icon(belajarSholatItems[index]['icon'], color: Colors.blue),
              title: Text(belajarSholatItems[index]['title']),
              onTap: belajarSholatItems[index]['action'],
            ),
          );
        },
      ),
    );
  }
}
