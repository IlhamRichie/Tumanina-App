import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class Deteksi extends StatefulWidget {
  const Deteksi({super.key});

  @override
  State<Deteksi> createState() => _DeteksiState();
}

class _DeteksiState extends State<Deteksi> {
  late WebViewController _controller;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.startsWith('https://www.youtube.com/')) {
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse('https://deteksi.tumanina.me'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Deteksi Gerakan"),
      ),
      body: WebViewWidget(controller: _controller),
    );
  }
}
