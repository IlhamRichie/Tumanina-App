import 'package:flutter/material.dart';

class ChatInputField extends StatelessWidget {
  final Function(String) onSubmitted;

  const ChatInputField({Key? key, required this.onSubmitted}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextEditingController _controller = TextEditingController();

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
              controller: _controller,
              decoration: const InputDecoration(
                hintText: 'Ketik pesan di sini...',
                border: InputBorder.none,
              ),
              onSubmitted: (value) {
                if (value.isNotEmpty) {
                  onSubmitted(value); // Kirim pesan ke callback
                  _controller.clear(); // Kosongkan teks setelah kirim
                }
              },
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send),
            onPressed: () {
              if (_controller.text.isNotEmpty) {
                onSubmitted(_controller.text); // Kirim pesan ke callback
                _controller.clear(); // Kosongkan teks setelah kirim
              }
            },
          ),
        ],
      ),
    );
  }
}
