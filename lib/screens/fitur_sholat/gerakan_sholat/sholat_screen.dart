import 'package:flutter/material.dart';
import 'takbir_screen.dart';
import 'ruku_screen.dart';
import 'itidal_screen.dart';
import 'sujud_screen.dart';
import 'duduk_screen.dart';
import 'tahiyat_awwal_screen.dart';
import 'tahiyat_akhir_screen.dart';

class SholatScreen extends StatelessWidget {
  const SholatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> sholatMovements = [
      {"title": "Takbir", "screen": const TakbirScreen(), "image": "assets/pilihGerakan/takbir.png"},
      {"title": "Ruku'", "screen": const RukuScreen(), "image": "assets/pilihGerakan/ruku.png"},
      {"title": "I'tidal", "screen": const ItidalScreen(), "image": "assets/pilihGerakan/itidal.png"},
      {"title": "Sujud", "screen": const SujudScreen(), "image": "assets/pilihGerakan/sujud.png"},
      {"title": "Duduk di Antara Dua Sujud", "screen": const DudukScreen(), "image": "assets/pilihGerakan/duduk.png"},
      {"title": "Tahiyat Awwal", "screen": const TahiyatAwwalScreen(), "image": "assets/pilihGerakan/tahiyat_awwal.png"},
      {"title": "Tahiyat Akhir", "screen": const TahiyatAkhirScreen(), "image": "assets/pilihGerakan/tahiyat_akhir.png"},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Belajar Sholat",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xFF004C7E), // Sesuai tema
        elevation: 0,
        centerTitle: true,
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(16.0),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16.0,
          mainAxisSpacing: 16.0,
          childAspectRatio: 2 / 3,
        ),
        itemCount: sholatMovements.length,
        itemBuilder: (context, index) {
          final movement = sholatMovements[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => movement["screen"]),
              );
            },
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.0),
              ),
              elevation: 6,
              shadowColor: const Color(0xFF004C7E).withOpacity(0.5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(16.0)),
                      child: Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage(movement["image"]),
                            fit: BoxFit.contain,
                          ),
                          color: Colors.grey[200],
                        ),
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 8.0),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF2DDCBE), Color(0xFF004C7E)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: const BorderRadius.vertical(bottom: Radius.circular(16.0)),
                    ),
                    child: Text(
                      movement["title"],
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
