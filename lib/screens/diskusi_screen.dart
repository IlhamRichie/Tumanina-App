import 'package:flutter/material.dart';

class DiskusiScreen extends StatelessWidget {
  const DiskusiScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Diskusi',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF004C7E),
      ),
      body: Center(
        child: const Text(
          'Selamat datang di Forum Diskusi!',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
