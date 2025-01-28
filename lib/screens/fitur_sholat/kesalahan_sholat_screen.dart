import 'package:flutter/material.dart';

class KesalahanSholatScreen extends StatelessWidget {
  const KesalahanSholatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Data kesalahan dalam sholat dari artikel Horizone.co.id
    List<String> kesalahanSholat = [
      "Tidak memahami syarat sah sholat.",
      "Tidak menghadap kiblat dengan benar.",
      "Tidak menutup aurat dengan sempurna.",
      "Tidak tuma'ninah (tenang) dalam sholat.",
      "Terburu-buru dalam mengerjakan sholat.",
      "Tidak membaca Al-Fatihah dengan benar.",
      "Tidak membaca surat setelah Al-Fatihah.",
      "Tidak melakukan rukuk dengan sempurna.",
      "Tidak thuma'ninah dalam rukuk.",
      "Tidak membaca doa rukuk dengan benar.",
      "Tidak melakukan sujud dengan sempurna.",
      "Tidak thuma'ninah dalam sujud.",
      "Tidak membaca doa sujud dengan benar.",
      "Tidak duduk di antara dua sujud dengan benar.",
      "Tidak membaca doa duduk di antara dua sujud.",
      "Tidak melakukan tasyahud awal dengan benar.",
      "Tidak membaca doa tasyahud awal.",
      "Tidak melakukan tasyahud akhir dengan benar.",
      "Tidak membaca doa tasyahud akhir.",
      "Tidak membaca shalawat Nabi dalam tasyahud akhir.",
      "Tidak membaca doa setelah tasyahud akhir.",
      "Tidak mengucapkan salam dengan benar.",
      "Tidak menghadap kiblat saat sholat.",
      "Tidak memperhatikan gerakan imam dalam sholat berjamaah.",
      "Tidak mengikuti imam dengan benar dalam sholat berjamaah.",
      "Tidak menjaga kekhusyukan dalam sholat.",
      "Tidak memperhatikan bacaan sholat.",
      "Tidak memahami makna bacaan sholat.",
      "Tidak menjaga konsentrasi selama sholat.",
      "Tidak mengakhiri sholat dengan salam yang sempurna.",
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Kesalahan dalam Sholat',
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
      body: ListView.builder(
        itemCount: kesalahanSholat.length,
        itemBuilder: (context, index) {
          return _KesalahanSholatCard(
            number: index + 1,
            description: kesalahanSholat[index],
          );
        },
      ),
    );
  }
}

class _KesalahanSholatCard extends StatelessWidget {
  final int number;
  final String description;

  const _KesalahanSholatCard({
    required this.number,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF2DDCBE), Color(0xFF004C7E)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Container(
        margin: const EdgeInsets.all(3), // Gradient border spacing
        padding: const EdgeInsets.all(16), // Inner content padding
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [Color(0xFF2DDCBE), Color(0xFF004C7E)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Text(
                '$number',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                description,
                style: const TextStyle(
                  fontSize: 16,
                  color: Color(0xFF004C7E),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}