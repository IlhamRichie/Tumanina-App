import 'package:flutter/material.dart';
import '../../deteksi_page.dart'; // Import halaman Deteksi

class InstructionPopup extends StatelessWidget {
  const InstructionPopup({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Petunjuk Kamera"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset('assets\pilihGerakan\camerascan.png'), // Gambar posisi kamera
          const SizedBox(height: 10),
          const Text(
            "Posisikan kamera di samping dengan jarak yang cukup agar seluruh tubuh terlihat.",
            textAlign: TextAlign.center,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context); // Tutup dialog
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const Deteksi()), // Navigasi ke halaman Deteksi
            );
          },
          child: const Text("Mengerti"),
        ),
      ],
    );
  }
}
