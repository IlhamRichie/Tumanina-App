import 'package:flutter/material.dart';

class RukunSholatScreen extends StatelessWidget {
  const RukunSholatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Rukun Sholat',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF004C7E), // Matching the theme color
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF2DDCBE), Color(0xFF004C7E)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text(
              '13 Rukun Sholat sesuai Syariat Islam',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            _buildRukunItem('1. Niat'),
            _buildRukunItem('2. Takbiratul Ihram'),
            _buildRukunItem('3. Berdiri Bagi yang Mampu'),
            _buildRukunItem('4. Membaca Surat Al-Fatihah'),
            _buildRukunItem('5. Rukuk'),
            _buildRukunItem('6. I\'tidal'),
            _buildRukunItem('7. Dua Kali Sujud'),
            _buildRukunItem('8. Duduk di Antara Dua Sujud'),
            _buildRukunItem('9. Membaca Tasyahud'),
            _buildRukunItem('10. Duduk Iftirasy'),
            _buildRukunItem('11. Membaca Shalawat Atas Nabi Muhammad SAW'),
            _buildRukunItem('12. Salam'),
            _buildRukunItem('13. Tertib'),
            const SizedBox(height: 20),
            
          ],
        ),
      ),
    );
  }

  Widget _buildRukunItem(String text) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w500,
          color: Colors.white,
        ),
      ),
    );
  }
}
