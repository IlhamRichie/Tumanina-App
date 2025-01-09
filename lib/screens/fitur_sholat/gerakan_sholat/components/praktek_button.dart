import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../deteksi_page.dart'; // Import halaman Deteksi

class PraktekButton extends StatelessWidget {
  const PraktekButton({super.key});

  // URL untuk praktek gerakan
  final String praktekUrl = 'https://deteksi.tumanina.me';

  // URL untuk video tutorial
  final String tutorialUrl =
      'https://youtube.com/playlist?list=PL-NWtF90B_9DYpjHPCZa6YRegVUu4CrtT&si=AMArDuF57EmjXz3j';

  // Fungsi untuk meluncurkan URL
  Future<void> _launchUrl(String url) async {
    final Uri uri = Uri.parse(url); // Konversi string ke Uri
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: () => _launchUrl(praktekUrl),
          child: const Text("Praktek Gerakan"),
        ),
        ElevatedButton(
          onPressed: () => _launchUrl(tutorialUrl),
          child: const Text("Lihat Video Tutorial"),
        ),
      ],
    );
  }
}
