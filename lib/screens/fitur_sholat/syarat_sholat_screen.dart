import 'package:flutter/material.dart';

class SyaratSholatScreen extends StatelessWidget {
  const SyaratSholatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            const Text('Syarat Sholat', style: TextStyle(color: Colors.black)),
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
          child: Column(
            children: [
              _GradientBorderCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Syarat-syarat Sholat',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF004C7E), // Font color updated
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Persiapkan diri Anda dengan memenuhi syarat-syarat berikut sebelum melaksanakan sholat.',
                      style: TextStyle(
                        fontSize: 16,
                        color: Color(0xFF004C7E), // Font color updated
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ListView(
                  children: const [
                    _RequirementCard(
                      icon: Icons.clean_hands,
                      title: 'Suci dari hadas',
                      description:
                          'Pastikan diri Anda suci dari hadas kecil dan besar.',
                    ),
                    _RequirementCard(
                      icon: Icons.checkroom,
                      title: 'Menutup aurat',
                      description:
                          'Gunakan pakaian yang sesuai untuk menutup aurat.',
                    ),
                    _RequirementCard(
                      icon: Icons.cleaning_services,
                      title: 'Suci dari najis',
                      description:
                          'Badan, pakaian, dan tempat harus bersih dari najis.',
                    ),
                    _RequirementCard(
                      icon: Icons.access_time,
                      title: 'Masuk waktu sholat',
                      description: 'Pastikan sholat dilakukan pada waktunya.',
                    ),
                    _RequirementCard(
                      icon: Icons.explore,
                      title: 'Menghadap kiblat',
                      description:
                          'Arahkan tubuh ke arah Ka\'bah saat melaksanakan sholat.',
                    ),
                    _RequirementCard(
                      icon: Icons.bookmark_added,
                      title: 'Berniat',
                      description:
                          'Niatkan hati Anda untuk melakukan sholat dengan ikhlas.',
                    ),
                  ],
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
        margin: const EdgeInsets.all(3), // Space for the gradient border
        padding: const EdgeInsets.all(16), // Inner padding for content
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: child,
      ),
    );
  }
}

class _RequirementCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const _RequirementCard({
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return _GradientBorderCard(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
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
          ),
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
