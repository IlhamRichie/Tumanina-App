import 'package:flutter/material.dart';

class PraktekButton extends StatelessWidget {
  final VoidCallback onPraktek;

  const PraktekButton({super.key, required this.onPraktek});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPraktek,
      child: const Text("Praktek Gerakan"),
    );
  }
}
