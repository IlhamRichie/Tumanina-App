import 'package:Tumanina/screens/fitur_doa/doa_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DoaDetailScreen extends StatelessWidget {
  final Doa doa;

  DoaDetailScreen({required this.doa});

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
              // Arabic Doa
              Text(
                "Doa dalam Bahasa Arab:",
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF2DDCBE),
                ),
              ),
              SizedBox(height: 8),
              Text(
                doa.arabic,
                style: GoogleFonts.amiri(
                  fontSize: 32,
                  fontWeight: FontWeight.w400,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 16),

              // Latin Bacaan
              Text(
                "Bacaan Latin:",
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF2DDCBE),
                ),
              ),
              SizedBox(height: 8),
              Text(
                doa.latin,
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontStyle: FontStyle.italic,
                  color: Colors.black54,
                ),
              ),
              SizedBox(height: 16),

              // Translation
              Text(
                "Terjemahan:",
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF2DDCBE),
                ),
              ),
              SizedBox(height: 8),
              Text(
                doa.translation,
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 16),

              // Waktu Membaca Doa
              Text(
                "Waktu Membaca Doa:",
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF2DDCBE),
                ),
              ),
              SizedBox(height: 8),
              Text(
                doa.timeToRead,
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 32),

              // Gradient Button (centered)
              Center(
                child: Container(
                  width: double.infinity,
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    gradient: LinearGradient(
                      colors: [
                        const Color(0xFF004C7E),
                        const Color(0xFF2DDCBE)
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: TextButton(
                    onPressed: () {
                      // Optional: Define an action, like bookmarking or sharing
                    },
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 14.0),
                    ),
                    child: Text(
                      'Simpan Doa Ini',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
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
}
