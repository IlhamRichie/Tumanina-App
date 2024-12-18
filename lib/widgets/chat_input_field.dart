import 'package:flutter/material.dart';

class ChatInputField extends StatelessWidget {
  const ChatInputField({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      color: Colors.white,
      child: Row(
        children: <Widget>[
          IconButton(
            icon: const Icon(Icons.sentiment_satisfied_alt),
            onPressed: () {},
          ),
          const Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Ketik pesan di sini...',
                border: InputBorder.none,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.mic),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.send),
            onPressed: () {
              // Tambahkan logika untuk mengirim pesan di sini
            },
          ),
        ],
      ),
    );
  }
}
