import 'package:flutter/material.dart';

class SyaratSholatScreen extends StatelessWidget {
  const SyaratSholatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Syarat Sholat', style: TextStyle(color: Colors.black)),
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
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16.0),
            color: Colors.lightBlue.shade50,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'Syarat-syarat Sholat',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),
                ),
                SizedBox(height: 4),
                Text(
                  'Persiapkan diri Anda dengan memenuhi syarat-syarat berikut sebelum melaksanakan sholat.',
                  style: TextStyle(fontSize: 16, color: Colors.black54),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              children: const [
                _RequirementCard(
                  icon: Icons.clean_hands,
                  title: 'Suci dari hadas',
                  description: 'Pastikan diri Anda suci dari hadas kecil dan besar.',
                ),
                _RequirementCard(
                  icon: Icons.checkroom,
                  title: 'Menutup aurat',
                  description: 'Gunakan pakaian yang sesuai untuk menutup aurat.',
                ),
                _RequirementCard(
                  icon: Icons.cleaning_services,
                  title: 'Suci dari najis',
                  description: 'Badan, pakaian, dan tempat harus bersih dari najis.',
                ),
                _RequirementCard(
                  icon: Icons.access_time,
                  title: 'Masuk waktu sholat',
                  description: 'Pastikan sholat dilakukan pada waktunya.',
                ),
                _RequirementCard(
                  icon: Icons.explore,
                  title: 'Menghadap kiblat',
                  description: 'Arahkan tubuh ke arah Ka\'bah saat melaksanakan sholat.',
                ),
                _RequirementCard(
                  icon: Icons.bookmark_added,
                  title: 'Berniat',
                  description: 'Niatkan hati Anda untuk melakukan sholat dengan ikhlas.',
                ),
              ],
            ),
          ),
        ],
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
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            Icon(icon, size: 40, color: Colors.lightBlue),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: const TextStyle(fontSize: 14, color: Colors.black54),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
