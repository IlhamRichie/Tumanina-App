import 'package:flutter/material.dart';

class InstructionPopup extends StatelessWidget {
  const InstructionPopup({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Petunjuk Kamera"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset('assets/camera_setup.png'), // Gambar posisi kamera
          const SizedBox(height: 10),
          const Text(
            "Posisikan kamera di samping dengan jarak yang cukup agar seluruh tubuh terlihat.",
            textAlign: TextAlign.center,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
            // Logika untuk mulai membuka kamera dan praktek gerakan
          },
          child: const Text("Mengerti"),
        ),
      ],
    );
  }
}
