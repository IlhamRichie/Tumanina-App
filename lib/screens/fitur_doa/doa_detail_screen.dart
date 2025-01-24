import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'doa.dart';

class DoaDetailScreen extends StatelessWidget {
  final Doa doa;

  DoaDetailScreen({required this.doa});

  void _shareToWhatsApp(BuildContext context) async {
    final String message = '''
Assalamu'alaikum, berikut doa yang ingin saya bagikan:

🕌 *${doa.title}* 🕌

📖 *Doa dalam Bahasa Arab:*
${doa.arabic}

✍️ *Bacaan Latin:*
${doa.latin}

🌟 *Terjemahan:*
${doa.translation}

⏰ *Waktu Membaca:*
${doa.timeToRead}

__________________

🌟 *Tumanina App* 🌟
Temukan berbagai doa harian, panduan ibadah, dan fitur belajar sholat yang interaktif di satu aplikasi. Tingkatkan ibadah Anda dengan mudah kapan saja dan di mana saja.

📥 Download sekarang di:
🌐 [tumanina.me](https://tumanina.me)
''';

    final String encodedMessage = Uri.encodeComponent(message);
    final Uri whatsappUrl = Uri.parse('whatsapp://send?text=$encodedMessage');

    if (await canLaunchUrl(whatsappUrl)) {
      try {
        await launchUrl(whatsappUrl, mode: LaunchMode.externalApplication);
      } catch (e) {
        debugPrint('Error launching WhatsApp: $e');
        _showErrorSnackbar(context, 'Gagal membuka WhatsApp!');
      }
    } else {
      debugPrint('WhatsApp URL tidak valid atau WhatsApp tidak terinstal.');
      _showErrorSnackbar(context, 'Tidak dapat membuka WhatsApp!');
    }
  }

  void _showErrorSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: const TextStyle(color: Colors.white)),
        backgroundColor: Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          doa.title,
          style: GoogleFonts.poppins(
            color: const Color(0xFF004C7E),
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            ScaffoldMessenger.of(context).clearSnackBars();
            Navigator.pop(context);
          },
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildGradientCard(
                title: "Doa dalam Bahasa Arab:",
                content: doa.arabic,
                isArabic: true,
              ),
              const SizedBox(height: 16),
              _buildGradientCard(
                title: "Bacaan Latin:",
                content: doa.latin,
                isArabic: false,
              ),
              const SizedBox(height: 16),
              _buildGradientCard(
                title: "Terjemahan:",
                content: doa.translation,
                isArabic: false,
              ),
              const SizedBox(height: 16),
              _buildGradientCard(
                title: "Waktu Membaca Doa:",
                content: doa.timeToRead,
                isArabic: false,
              ),
              const SizedBox(height: 32),
              Center(
                child: ElevatedButton(
                  onPressed: () => _shareToWhatsApp(context),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: const Color(0xFF004C7E),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    'Bagikan Doa Ini',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGradientCard({
    required String title,
    required String content,
    required bool isArabic,
  }) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF004C7E), Color(0xFF2DDCBE)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Container(
        padding: const EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF004C7E),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              content,
              style: isArabic
                  ? GoogleFonts.amiri(
                      fontSize: 24,
                      fontWeight: FontWeight.w400,
                      color: Colors.black87,
                    )
                  : GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.normal,
                      color: Colors.black54,
                    ),
              textAlign: isArabic ? TextAlign.center : TextAlign.start,
            ),
          ],
        ),
      ),
    );
  }
}
