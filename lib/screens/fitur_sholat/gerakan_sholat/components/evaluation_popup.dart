import 'package:flutter/material.dart';

class EvaluationPopup extends StatelessWidget {
  final bool isCorrect;
  final String evaluationText;
  final String userVideoPath;

  const EvaluationPopup({
    super.key,
    required this.isCorrect,
    required this.evaluationText,
    required this.userVideoPath,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(isCorrect ? "Gerakan Benar" : "Gerakan Salah"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(evaluationText),
          if (!isCorrect)
            Row(
              children: [
                Expanded(
                  child: Text("Video Gerakan Anda", textAlign: TextAlign.center),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text("Contoh Gerakan Benar", textAlign: TextAlign.center),
                ),
              ],
            ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: isCorrect ? const Text("Tutup") : const Text("Coba Lagi"),
        ),
      ],
    );
  }
}
