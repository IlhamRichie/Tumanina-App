import 'package:flutter/material.dart';

class MengenalSholatScreen extends StatelessWidget {
  const MengenalSholatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Mengenal Sholat',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        centerTitle: true,
      ),
      body: Container(
        color: Colors.white, // Set the background color to white
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            children: [
              _GradientBorderCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        _IconCircle(icon: Icons.book),
                        const SizedBox(width: 12),
                        const Text(
                          'Mengenal Sholat',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF004C7E), // Font color updated
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Sholat adalah ibadah wajib yang harus dilaksanakan oleh umat Muslim. Sholat terbagi menjadi beberapa jenis, seperti:',
                      style: TextStyle(
                        fontSize: 16,
                        color: Color(0xFF004C7E), // Font color updated
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              _SholatCard(
                title: 'Sholat Wajib',
                description:
                    'Sholat lima waktu yang harus dilaksanakan setiap hari (Subuh, Dzuhur, Ashar, Maghrib, dan Isya).',
                icon: Icons.timer,
              ),
              _SholatCard(
                title: 'Sholat Sunnah',
                description:
                    'Sholat yang dianjurkan untuk dikerjakan tetapi tidak wajib, seperti sholat Dhuha, Tahajud, dan Witir.',
                icon: Icons.stars,
              ),
              const SizedBox(height: 16),
              _GradientBorderCard(
                child: const Text(
                  'Dengan mengenal jenis-jenis sholat, diharapkan kita dapat lebih memahami pentingnya menjaga sholat dalam kehidupan sehari-hari.',
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0xFF004C7E), // Font color updated
                    fontStyle: FontStyle.italic,
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

class _GradientBorderCard extends StatelessWidget {
  final Widget child;

  const _GradientBorderCard({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF2DDCBE), Color(0xFF004C7E)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Container(
        margin: const EdgeInsets.all(3), // Space for gradient border
        padding: const EdgeInsets.all(16), // Content padding
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: child,
      ),
    );
  }
}

class _SholatCard extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;

  const _SholatCard({
    required this.title,
    required this.description,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return _GradientBorderCard(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _IconCircle(icon: icon),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF004C7E),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF004C7E),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _IconCircle extends StatelessWidget {
  final IconData icon;

  const _IconCircle({required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: [Color(0xFF2DDCBE), Color(0xFF004C7E)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Icon(
        icon,
        size: 32,
        color: Colors.white,
      ),
    );
  }
}
