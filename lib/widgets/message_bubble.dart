import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget {
  final String content;
  final bool isUser;

  const MessageBubble({super.key, required this.content, required this.isUser});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.all(12.0),
        margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
        decoration: BoxDecoration(
          gradient: isUser
              ? null // Warna solid untuk pengguna
              : const LinearGradient(
                  colors: [Color(0xFF2DDCBE), Color(0xFF004C7E)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
          color: isUser ? Colors.white : null, // Warna solid untuk pengguna
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(12.0),
            topRight: const Radius.circular(12.0),
            bottomLeft: isUser ? const Radius.circular(12.0) : Radius.zero,
            bottomRight: isUser ? Radius.zero : const Radius.circular(12.0),
          ),
        ),
        child: Text(
          content,
          style: TextStyle(
            color: isUser ? const Color(0xFF004C7E) : Colors.white,
          ),
        ),
      ),
    );
  }
}
