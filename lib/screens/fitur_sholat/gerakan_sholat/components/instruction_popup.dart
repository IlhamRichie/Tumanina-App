import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class InstructionPopup extends StatelessWidget {
  const InstructionPopup({super.key});

  // URL tujuan
  final String praktekUrl = 'https://f36b-2404-c0-7140-00-f8cd-45ae.ngrok-free.app';

  // Fungsi untuk membuka URL
  Future<void> _launchPraktekUrl(BuildContext context) async {
    final Uri url = Uri.parse(praktekUrl); // Konversi string ke Uri
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      // Tampilkan pesan error jika URL gagal dibuka
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gagal membuka tautan')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Petunjuk Kamera"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset('assets/camera_setup.png'), // Gambar posisi kamera
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
            _launchPraktekUrl(context); // Buka tautan
          },
          child: const Text("Mengerti"),
        ),
      ],
    );
  }
}
