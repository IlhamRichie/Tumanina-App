import 'package:flutter/material.dart';
import 'gerakan_detail_screen.dart';
import 'sujud_screen.dart';
import 'tasyahud_screen.dart';

class DudukScreen extends StatelessWidget {
  const DudukScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GerakanDetailScreen(
      title: "Duduk di Antara Dua Sujud",
      description: "Duduklah dengan posisi lutut dan ujung kaki menghadap kiblat...",
      bacaan: "رَبِّ اغْفِرْ لِى وَارْحَمْنِى وَاجْبُرْنِى وَارْزُقْنِى وَارْفَعْنِى\nRobbighfirlii warhamnii wajburnii warfa'nii warzuqnii wahdinii wa'aafinii wa'fu 'annii.",
      videoPath: 'https://youtu.be/Z3u7gMBrmag?si=jIuCHqeKnaJ0O1-d',
      previousScreen: const SujudScreen(),
      nextScreen: const TasyahudScreen(),
    );
  }
}
