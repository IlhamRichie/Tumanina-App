import 'package:flutter/material.dart';
import 'gerakan_sholat/sholat_screen.dart';
import 'mengenal_sholat_screen.dart';
import 'syarat_sholat_screen.dart';
import '../home_screen.dart';

class BelajarSholatScreen extends StatelessWidget {
  const BelajarSholatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> belajarSholatItems = [
      {
        'title': 'Mengenal Sholat dan Jenis Sholat',
        'icon': Icons.book,
        'action': () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const MengenalSholatScreen(),
            ),
          );
        },
      },
      {
        'title': 'Syarat Sholat',
        'icon': Icons.assignment,
        'action': () {
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
        elevation: 0,
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
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.lightBlue.shade50, Colors.blue.shade100],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: ListView.builder(
          itemCount: belajarSholatItems.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: belajarSholatItems[index]['action'],
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.blue.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          belajarSholatItems[index]['icon'],
                          size: 32,
                          color: Colors.blue,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Text(
                          belajarSholatItems[index]['title'],
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      const Icon(Icons.arrow_forward_ios, color: Colors.grey),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
