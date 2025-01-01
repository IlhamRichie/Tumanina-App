import 'package:flutter/material.dart';

class ChatMessage extends StatelessWidget {
  final String message;
  final bool isSentByMe;

  const ChatMessage({super.key, required this.message, required this.isSentByMe});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment:
            isSentByMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: <Widget>[
          if (!isSentByMe) ...[
            const CircleAvatar(backgroundImage: AssetImage('assets/avatar.png')),
            const SizedBox(width: 8),
          ],
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: isSentByMe ? const Color(0xFF2DDCBE) : Colors.grey[300],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              message,
              style: TextStyle(color: isSentByMe ? Colors.white : Colors.black),
            ),
          ),
        ],
      ),
    );
  }
}
