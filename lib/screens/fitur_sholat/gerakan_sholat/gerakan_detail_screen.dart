import 'package:flutter/material.dart';
import 'components/instruction_popup.dart';
import 'sholat_screen.dart';

class GerakanDetailScreen extends StatelessWidget {
  final String title;
  final String description;
  final String bacaan;
  final String videoPath;
  final Widget? nextScreen;
  final Widget? previousScreen;

  const GerakanDetailScreen({
    super.key,
    required this.title,
    required this.description,
    required this.bacaan,
    required this.videoPath,
    this.nextScreen,
    this.previousScreen,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const SholatScreen()),
              (Route<dynamic> route) => false,
            );
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Cara Melakukan Gerakan $title",
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(description),
            const SizedBox(height: 20),
            Text(
              "Bacaan $title",
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(bacaan, style: const TextStyle(fontSize: 24)),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Logika untuk menampilkan video tutorial
              },
              child: const Text("Lihat Video Tutorial"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) => const InstructionPopup(),
                );
              },
              child: const Text("Praktek Gerakan"),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: previousScreen != null
                      ? () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => previousScreen!),
                          );
                        }
                      : null,
                  child: const Text("Sebelumnya"),
                ),
                ElevatedButton(
                  onPressed: nextScreen != null
                      ? () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => nextScreen!),
                          );
                        }
                      : null,
                  child: const Text("Selanjutnya"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
