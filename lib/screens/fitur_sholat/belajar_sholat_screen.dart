import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'gerakan_sholat/sholat_screen.dart';
import 'mengenal_sholat_screen.dart';
import 'rukun_sholat_screen.dart';
import 'syarat_sholat_screen.dart';
import 'niat_sholat_screen.dart'; // Add this import statement
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
        'title': 'Niat Sholat Wajib', // New menu item
        'icon': Icons.assignment_turned_in,
        'action': () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  const NiatSholatScreen(), // Navigate to NiatSholatScreen
            ),
          );
        },
      },
      {
        'title': 'Rukun Sholat', // New menu item
        'icon': Icons.check_circle,
        'action': () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  const RukunSholatScreen(), // Navigate to RukunSholatScreen
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
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Belajar Sholat',
          style: GoogleFonts.poppins(
            color: const Color(0xFF004C7E),
            fontWeight: FontWeight.bold,
          ),
        ),
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
      body: ListView.builder(
        itemCount: belajarSholatItems.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: belajarSholatItems[index]['action'],
            child: Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF2DDCBE), Color(0xFF004C7E)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.9),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        belajarSholatItems[index]['icon'],
                        size: 28,
                        color: const Color(0xFF004C7E),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        belajarSholatItems[index]['title'],
                        style: GoogleFonts.poppins(
                          // Apply Poppins font here
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const Icon(Icons.arrow_forward_ios, color: Colors.white),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
