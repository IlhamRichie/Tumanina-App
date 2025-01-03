import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;

class ApiService {
  final Dio _dio = Dio();

  // URL Server Flask
  final String flaskBaseUrl = "http://127.0.0.1:5000"; // Ganti jika URL berbeda
  final String updateProfileEndpoint =
      '/updateProfile'; // Replace with your actual endpoint

  // URL dan Key API Groq
  final String groqApiKey =
      'yourapikey'; // Ganti dengan API Key Anda
  final String groqBaseUrl = 'https://api.groq.com/openai/v1';
  final String groqModel = 'llama3-groq-8b-8192-tool-use-preview';

  // URL API Artikel
  final String artikelBaseUrl =
      'hhttps://artikel-islam.netlify.app/.netlify/functions/api/ms/detail/:id_article';

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

  Future<void> submitFeedback(String name, String feedback, String date) async {
    final url =
        Uri.parse('$flaskBaseUrl/submit_feedback'); // Update the endpoint

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'name': name,
          'feedback': feedback,
          'date': date,
        }),
      );

      if (response.statusCode == 200) {
        print('Feedback submitted successfully');
      } else {
        throw Exception('Failed to submit feedback');
      }
    } catch (e) {
      print('Error submitting feedback: $e');
    }
  }

  // Method to update profile (username and profile image)
  Future<void> updateProfile(String username, File? profileImage) async {
    try {
      // Prepare the data for the request
      FormData formData = FormData.fromMap({
        'username': username,
        if (profileImage != null)
          'profile_image': await MultipartFile.fromFile(profileImage.path),
      });

      // Send POST request to update profile
      final response = await _dio.post(
        '$flaskBaseUrl$updateProfileEndpoint',
        data: formData,
      );

      // Check for success
      if (response.statusCode == 200) {
        print('Profile updated successfully!');
      } else {
        print('Failed to update profile: ${response.statusCode}');
      }
    } catch (e) {
      print('Error updating profile: $e');
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
            {
              "role": "system",
              "content":
                  "Tumabot: Asisten Islami berbahasa Indonesia. Jawaban selalu Islami, sopan, dan bermanfaat. Jangan pernah membuat respon dengan bahasa inggris. Ini aplikasi Tumanina: Tuntunan Mandiri Niat dan Ibadah"
            },
            {"role": "user", "content": userMessage}
          ],
          "model": groqModel,
          "temperature": 0.6,
          "max_tokens": 1024,
          "top_p": 0.7
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
    } on SocketException {
      return "Maaf, sepertinya Anda sedang offline. Pastikan koneksi internet Anda aktif untuk menggunakan Tumabot.";
    } on Exception catch (e) {
      return "Maaf, terjadi masalah teknis: $e. Silakan coba lagi nanti.";
    }
  }

  /// Fungsi untuk mengambil artikel dari API Artikel
  Future<List<Map<String, dynamic>>> fetchArticles() async {
    final url = Uri.parse(artikelBaseUrl);
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      if (data.containsKey('data') && data['data'] is List) {
        return List<Map<String, dynamic>>.from(data['data']);
      } else {
        throw Exception(
            'Data articles tidak ditemukan atau tidak dalam format yang diharapkan');
      }
    } else {
      throw Exception('Failed to load articles');
    }
  }
}
