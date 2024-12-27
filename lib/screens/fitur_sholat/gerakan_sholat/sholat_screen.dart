import 'package:flutter/material.dart';
import '../belajar_sholat_screen.dart'; // Import halaman belajar sholat
import 'takbir_screen.dart';
import 'ruku_screen.dart';
import 'itidal_screen.dart';
import 'sujud_screen.dart';
import 'duduk_screen.dart';
import 'tasyahud_screen.dart';

class SholatScreen extends StatelessWidget {
  const SholatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> sholatMovements = [
      {
        'movement': 'Takbiratul Ihram',
        'image': 'assets/pilihGerakan/takbir.png',
        'screen': const TakbirScreen(),
      },
      {
        'movement': 'Ruku\'',
        'image': 'assets/pilihGerakan/ruku.png',
        'screen': const RukuScreen(),
      },
      {
        'movement': 'I\'tidal',
        'image': 'assets/pilihGerakan/itidal.png',
        'screen': const ItidalScreen(),
      },
      {
        'movement': 'Sujud',
        'image': 'assets/pilihGerakan/sujud.png',
        'screen': const SujudScreen(),
      },
      {
        'movement': 'Duduk di Antara Dua Sujud',
        'image': 'assets/pilihGerakan/duduk.png',
        'screen': const DudukScreen(),
      },
      {
        'movement': 'Tasyahud Akhir',
        'image': 'assets/pilihGerakan/tasyahud.png',
        'screen': const TasyahudScreen(),
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Belajar Gerakan Sholat', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const BelajarSholatScreen()),
              (Route<dynamic> route) => false,
            );
          },
        ),
        centerTitle: true,
      ),
      body: Container(
        color: Colors.white, // Set the background color to white
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const TakbirScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(60),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  backgroundColor: const Color(0xFF2DDCBE), // Consistent button color
                  elevation: 2,
                ),
                child: const Text(
                  'Gerakan Sholat dari Awal',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                    fontFamily: 'Roboto',
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 0.8,
                  ),
                  itemCount: sholatMovements.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        final screen = sholatMovements[index]['screen'];
                        if (screen != null) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => screen),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Screen untuk ${sholatMovements[index]['movement']} belum tersedia'),
                            ),
                          );
                        }
                      },
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 4,
                        color: Colors.white, // Set card background to white
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              sholatMovements[index]['image']!,
                              width: 80,
                              height: 80,
                            ),
                            const SizedBox(height: 10),
                            Text(
                              sholatMovements[index]['movement']!,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Color(0xFF004C7E), // Updated text color
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
