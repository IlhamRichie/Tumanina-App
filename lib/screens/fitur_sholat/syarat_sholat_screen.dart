import 'package:flutter/material.dart';

class SyaratSholatScreen extends StatelessWidget {
  const SyaratSholatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Syarat Sholat', style: TextStyle(color: Colors.black)),
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
              'Syarat-syarat Sholat:',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              '1. Suci dari hadas kecil dan besar.\n'
              '2. Menutup aurat.\n'
              '3. Suci badan, pakaian, dan tempat dari najis.\n'
              '4. Masuk waktu sholat.\n'
              '5. Menghadap kiblat.\n'
              '6. Berniat.',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
