import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class ApiService {
  // URL Server Flask
  final String flaskBaseUrl = "http://127.0.0.1:5000"; // Ganti jika URL berbeda

  // URL dan Key API Groq
  final String groqApiKey = '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'; // Ganti dengan API Key Anda
  final String groqBaseUrl = 'https://api.groq.com/openai/v1';
  final String groqModel = 'llama3-8b-8192-tool-use-preview';

  /// Fungsi untuk mengirim frame ke server Flask
  Future<Map<String, dynamic>> sendFrame(File imageFile) async {
    try {
      final request = http.MultipartRequest(
        'POST',
        Uri.parse('$flaskBaseUrl/detect-movement'),
      );
      request.files.add(
        await http.MultipartFile.fromPath('frame', imageFile.path),
      );

      final response = await request.send();
      if (response.statusCode == 200) {
        final respStr = await response.stream.bytesToString();
        return json.decode(respStr);
      } else {
        return {'error': 'Failed to detect movement: ${response.statusCode}'};
      }
    } catch (e) {
      return {'error': 'Failed to connect to server: $e'};
    }
  }

  /// Fungsi untuk mengirim pesan ke Groq API
  Future<String> sendMessageToGroqAPI(String userMessage) async {
    final url = Uri.parse('$groqBaseUrl/chat/completions');
    try {
      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $groqApiKey',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          "messages": [
            {"role": "system", "content": "You are a helpful assistant."},
            {"role": "user", "content": userMessage}
          ],
          "model": groqModel,
          "temperature": 0.5,
          "max_tokens": 1024,
          "top_p": 0.65,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['choices'][0]['message']['content'];
      } else {
        throw Exception(
          'Failed to fetch response: ${response.statusCode}, ${response.body}',
        );
      }
    } catch (e) {
      return 'Error: $e';
    }
  }
}
