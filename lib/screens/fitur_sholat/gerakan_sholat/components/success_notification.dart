import 'package:flutter/material.dart';

class SuccessNotification extends StatelessWidget {
  final String message;

  const SuccessNotification({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Gerakan Benar"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(message),
          const SizedBox(height: 20),
          const Text(
            "Lanjutkan ke gerakan berikutnya",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text("Tutup"),
        ),
      ],
    );
  }
}
