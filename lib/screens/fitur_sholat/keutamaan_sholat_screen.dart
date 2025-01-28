import 'package:flutter/material.dart';

class KeutamaanSholatScreen extends StatelessWidget {
  const KeutamaanSholatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Data keutamaan sholat dari artikel Detik.com
    List<Map<String, String>> keutamaanSholat = [
      {
        'title': '1. Penghapus Dosa',
        'description':
            'Sholat lima waktu dapat menghapus dosa-dosa kecil, sebagaimana sabda Rasulullah SAW: "Sholat lima waktu dan Jumat ke Jumat berikutnya adalah penghapus dosa di antara keduanya, selama tidak melakukan dosa besar." (HR. Muslim).',
      },
      {
        'title': '2. Cahaya di Hari Kiamat',
        'description':
            'Orang yang menjaga sholatnya akan mendapatkan cahaya pada hari kiamat. Rasulullah SAW bersabda: "Barangsiapa yang menjaga sholat, maka sholat itu akan menjadi cahaya, bukti, dan keselamatan baginya pada hari kiamat." (HR. Ahmad).',
      },
      {
        'title': '3. Mencegah Perbuatan Keji dan Mungkar',
        'description':
            'Sholat dapat mencegah perbuatan keji dan mungkar. Allah SWT berfirman: "Sesungguhnya sholat itu mencegah dari perbuatan keji dan mungkar." (QS. Al-Ankabut: 45).',
      },
      {
        'title': '4. Mendekatkan Diri kepada Allah',
        'description':
            'Sholat adalah sarana untuk mendekatkan diri kepada Allah SWT. Rasulullah SAW bersabda: "Hamba yang paling dekat dengan Tuhannya adalah ketika ia sedang sujud." (HR. Muslim).',
      },
      {
        'title': '5. Menenangkan Hati',
        'description':
            'Sholat dapat menenangkan hati dan pikiran. Allah SWT berfirman: "Sesungguhnya dengan mengingat Allah, hati menjadi tenang." (QS. Ar-Ra\'d: 28). Sholat adalah bentuk dzikir yang paling utama.',
      },
      {
        'title': '6. Menjaga Kesehatan',
        'description':
            'Gerakan sholat memiliki manfaat bagi kesehatan, seperti melancarkan peredaran darah, melatih otot, dan menjaga kebugaran tubuh.',
      },
      {
        'title': '7. Mendapatkan Pahala yang Besar',
        'description':
            'Setiap gerakan dan bacaan dalam sholat bernilai pahala. Rasulullah SAW bersabda: "Seandainya manusia mengetahui pahala azan dan shaf pertama, mereka akan berebut untuk mendapatkannya." (HR. Bukhari).',
      },
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Keutamaan Sholat',
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
        itemCount: keutamaanSholat.length,
        itemBuilder: (context, index) {
          return _KeutamaanSholatCard(
            title: keutamaanSholat[index]['title']!,
            description: keutamaanSholat[index]['description']!,
          );
        },
      ),
    );
  }
}

class _KeutamaanSholatCard extends StatelessWidget {
  final String title;
  final String description;

  const _KeutamaanSholatCard({
    required this.title,
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
            const SizedBox(height: 8),
            Text(
              description,
              style: const TextStyle(
                fontSize: 16,
                color: Color(0xFF004C7E),
              ),
            ),
          ],
        ),
      ),
    );
  }
}