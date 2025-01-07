import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class PraktekButton extends StatelessWidget {
  const PraktekButton({super.key});

  // URL tujuan
  final String praktekUrl = 'https://deteksi.tumanina.me';

  // Fungsi untuk meluncurkan URL
  Future<void> _launchPraktekUrl() async {
    final Uri url = Uri.parse(praktekUrl); // Konversi string ke Uri
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw 'Could not launch $praktekUrl';
    }
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: _launchPraktekUrl,
      child: const Text("Praktek Gerakan"),
    );
  }
}
