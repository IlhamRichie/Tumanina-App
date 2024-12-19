import 'package:flutter/material.dart';
import 'package:MyApp/screens/fitur_doa/doa_screen.dart';

// Kelas Doa dari file sebelumnya
class DoaDetailScreen extends StatelessWidget {
  final Doa doa;

  DoaDetailScreen({required this.doa});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(doa.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Doa dalam Bahasa Arab:",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            SizedBox(height: 8),
            Text(
              doa.arabic,
              style: TextStyle(fontSize: 24, fontFamily: 'Amiri'), // Pilih font Arab
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16),
            Text(
              "Terjemahan:",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            SizedBox(height: 8),
            Text(
              doa.translation,
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Text(
              "Waktu Membaca Doa:",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            SizedBox(height: 8),
            Text(
              doa.timeToRead,
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
