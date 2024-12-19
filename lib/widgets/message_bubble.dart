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
        padding: EdgeInsets.all(12.0),
        margin: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
        decoration: BoxDecoration(
          color: isUser ? Colors.white : Color(0xFF004C7E),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(12.0),
            topRight: Radius.circular(12.0),
            bottomLeft: isUser ? Radius.circular(12.0) : Radius.zero,
            bottomRight: isUser ? Radius.zero : Radius.circular(12.0),
          ),
        ),
        child: Text(
          content,
          style: TextStyle(color: isUser ? Color(0xFF004C7E) : Colors.white),
        ),
      ),
    );
  }
}
