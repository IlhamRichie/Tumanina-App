import 'package:flutter/material.dart';

class NiatSholatScreen extends StatelessWidget {
  const NiatSholatScreen({super.key});

  // Function to return the corresponding icon for each prayer
  IconData _getPrayerIcon(String prayerName) {
    switch (prayerName) {
      case 'Subuh':
        return Icons.wb_twilight;
      case 'Dzuhur':
        return Icons.wb_sunny;
      case 'Ashar':
        return Icons.cloud;
      case 'Maghrib':
        return Icons.nights_stay;
      case 'Isya':
        return Icons.brightness_3;
      default:
        return Icons.access_time; // Default icon if no match
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> niatSholatItems = [
      {
        'title': 'Niat Sholat Subuh',
        'prayer': 'Subuh',
        'arabic': 'أُصَلِّى فَرْضَ الصُّبْح رَكَعتَيْنِ مُسْتَقْبِلَ الْقِبْلَةِ أَدَاءً لله تَعَالَى',
        'latin': 'Usholli fardhol subhi rok\'ataini mustaqbilal qiblati adaa an (sholat sendiri)/Ma\'muuman (menjadi ma\'mum)/Imaaman (menjadi imam) Lillaahi Ta\'alaa',
        'artinya': 'Saya berniat sholat fardu Subuh dua rakaat menghadap kiblat karena Allah Ta\'ala/Ma\'mum karena Allah Ta\'ala/Imam karena Allah Ta\'ala.'
      },
      {
        'title': 'Niat Sholat Dzuhur',
        'prayer': 'Dzuhur',
        'arabic': 'اُصَلِّيْ فَرْضَ الظُّهْرِ أَرْبَعَ رَكَعاَتٍ مُسْتَقْبِلَ الْقِبْلَةِ أَدَاءً لله تَعَالَى',
        'latin': 'Usholli fardhol zuhri arba\'a roka\'aati mustaqbilal qiblati adaa an (sholat sendiri)/Ma\'muuman (menjadi ma\'mum)/Imaaman (menjadi imam) Lillaahi Ta\'alaa',
        'artinya': 'Saya berniat sholat fardu Zuhur empat rakaat menghadap kiblat karena Allah Ta\'ala/Ma\'mum karena Allah Ta\'ala/Imam karena Allah Ta\'ala.'
      },
      {
        'title': 'Niat Sholat Ashar',
        'prayer': 'Ashar',
        'arabic': 'أُصَلِّى فَرْضَ العَصْرِ أَرْبَعَ رَكَعاَتٍ مُسْتَقْبِلَ الْقِبْلَةِ أَدَاءً لله تَعَالَى',
        'latin': 'Usholli fardhol ashri arba\'a roka\'aati mustaqbilal qiblati adaa an (sholat sendiri)/Ma\'muuman (menjadi ma\'mum)/Imaaman (menjadi imam) Lillaahi Ta\'ala',
        'artinya': 'Saya berniat sholat fardu Asar empat rakaat menghadap kiblat karena Allah Ta\'ala/Ma\'mum karena Allah Ta\'ala/Imam karena Allah Ta\'ala.'
      },
      {
        'title': 'Niat Sholat Maghrib',
        'prayer': 'Maghrib',
        'arabic': 'أُصَلِّى فَرْضَ المَغْرِبِ ثَلاَثَ رَكَعاَتٍ مُسْتَقْبِلَ الْقِبْلَةِ أَدَاءً لله تَعَالَ',
        'latin': 'Usholli fardhol magribi tsalasa rok\'aati mustaqbilal qiblati adaa an (sholat sendiri)/Ma\'muuman (menjadi ma\'mum)/Imaaman (menjadi imam) Lillaahi Ta\'ala',
        'artinya': 'Saya berniat sholat fardu Magrib tiga rakaat menghadap kiblat karena Allah Ta\'ala/Ma\'mum karena Allah Ta\'ala/Imam karena Allah Ta\'ala.'
      },
      {
        'title': 'Niat Sholat Isya',
        'prayer': 'Isya',
        'arabic': 'أُصَلِّى فَرْضَ العِشَاء ِأَرْبَعَ رَكَعاَتٍ مُسْتَقْبِلَ الْقِبْلَةِ أَدَاءً لله تَعَالَى',
        'latin': 'Usholli fardhol \'Isya i arba\'a roka\'aati mustaqbilal qiblati adaa an (sholat sendiri)/Ma\'muuman (menjadi ma\'mum)/Imaaman (menjadi imam) Lillaahi Ta\'alaa',
        'artinya': 'Saya berniat sholat fardu Isya empat rakaat menghadap kiblat karena Allah Ta\'ala/Ma\'mum karena Allah Ta\'ala/Imam karena Allah Ta\'ala.'
      },
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        
        title: const Text(
          'Niat Sholat Wajib',
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
        itemCount: niatSholatItems.length,
        itemBuilder: (context, index) {
          return _NiatSholatCard(
            title: niatSholatItems[index]['title'],
            prayer: niatSholatItems[index]['prayer'],
            arabic: niatSholatItems[index]['arabic'],
            latin: niatSholatItems[index]['latin'],
            artinya: niatSholatItems[index]['artinya'],
            icon: _getPrayerIcon(niatSholatItems[index]['prayer']),
          );
        },
      ),
    );
  }
}

class _NiatSholatCard extends StatelessWidget {
  final String title;
  final String arabic;
  final String latin;
  final String artinya;
  final String prayer;
  final IconData icon;

  const _NiatSholatCard({
    required this.title,
    required this.arabic,
    required this.latin,
    required this.artinya,
    required this.prayer,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      margin: const EdgeInsets.symmetric(vertical: 8),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Color(0xFF2DDCBE),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, size: 32, color: Colors.white),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF004C7E),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              arabic,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                fontFamily: 'Scheherazade',
                color: Color(0xFF004C7E),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              latin,
              style: const TextStyle(
                fontSize: 16,
                fontStyle: FontStyle.italic,
                color: Color(0xFF004C7E),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Artinya: $artinya',
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
