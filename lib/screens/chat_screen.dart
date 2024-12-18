import 'package:flutter/material.dart';
import 'package:MyApp/widgets/chat_message.dart';
import 'package:MyApp/widgets/chat_input_field.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        title: const Text('ChatBot', style: TextStyle(color: Colors.black)),
        centerTitle: true,
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView(
              children: const <Widget>[
                ChatMessage(
                    message: "Halo, bagaimana kabar kalian?",
                    isSentByMe: false),
                ChatMessage(
                    message: "Baik, terima kasih! Bagaimana denganmu?",
                    isSentByMe: true),
              ],
            ),
          ),
          const ChatInputField(),
        ],
      ),
    );
  }
}
