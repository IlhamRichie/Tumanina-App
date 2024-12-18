import 'package:flutter/material.dart';

class ErrorNotification extends StatelessWidget {
  final String errorMessage;

  const ErrorNotification({super.key, required this.errorMessage});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Gerakan Salah"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(errorMessage),
          const SizedBox(height: 20),
          const Text(
            "Perhatikan posisi tubuh dan coba lagi.",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text("Coba Lagi"),
        ),
      ],
    );
  }
}
