import 'package:flutter/material.dart';

class ChatInputField extends StatelessWidget {
  final Function(String) onSubmitted;

  const ChatInputField({super.key, required this.onSubmitted});

  @override
  Widget build(BuildContext context) {
    final TextEditingController controller = TextEditingController();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      color: Colors.white,
      child: Row(
        children: <Widget>[
          IconButton(
            icon: const Icon(Icons.sentiment_satisfied_alt),
            onPressed: () {},
          ),
          Expanded(
            child: TextField(
              controller: controller,
              decoration: const InputDecoration(
                hintText: 'Ketik pesan di sini...',
                border: InputBorder.none,
              ),
              onSubmitted: (value) {
                if (value.isNotEmpty) {
                  onSubmitted(value); // Kirim pesan ke callback
                  controller.clear(); // Kosongkan teks setelah kirim
                }
              },
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send),
            onPressed: () {
              if (controller.text.isNotEmpty) {
                onSubmitted(controller.text); // Kirim pesan ke callback
                controller.clear(); // Kosongkan teks setelah kirim
              }
            },
          ),
        ],
      ),
    );
  }
}
