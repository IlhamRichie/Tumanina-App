import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  final Dio _dio = Dio();

  // URL Server Flask
  final String BaseUrl =
      "https://tumanina.me/admin/api"; // Ganti jika URL berbeda
  final String updateProfileEndpoint =
      '/updateProfile'; // Replace with your actual endpoint
  final String deleteAccountEndpoint = '/deleteAccount';

  // URL dan Key API Groq
  final String groqApiKey =
      'yourapikey'; // Ganti dengan API Key Anda
  final String groqBaseUrl = 'https://api.groq.com/openai/v1';
  final String groqModel = 'llama-3.3-70b-versatile';

  // URL API Artikel
  final String artikelBaseUrl =
      'hhttps://artikel-islam.netlify.app/.netlify/functions/api/ms/detail/:id_article';

  String extractErrorMessage(http.Response response) {
    try {
      final body = jsonDecode(response.body);
      if (body is Map<String, dynamic> && body.containsKey('msg')) {
        return body['msg'];
      } else {
        return 'Terjadi kesalahan pada server.';
      }
    } catch (e) {
      return 'Gagal memproses respons dari server.';
    }
  }

  String handleExceptionMessage(Object e, [http.Response? response]) {
    if (response != null && response.body.isNotEmpty) {
      try {
        final body = jsonDecode(response.body);
        if (body is Map<String, dynamic> && body.containsKey('msg')) {
          return body['msg'];
        }
      } catch (_) {
        // Abaikan error parsing
      }
    }

    // Pesan fallback untuk error lain
    String errorMessage = e.toString();
    if (errorMessage.contains("Failed to fetch response")) {
      return "Gagal mendapatkan data dari server. Silakan coba lagi.";
    } else if (errorMessage.contains("Token expired")) {
      return "Sesi Anda telah berakhir. Silakan login ulang.";
    } else if (errorMessage.contains("Connection timed out")) {
      return "Koneksi ke server gagal. Periksa koneksi internet Anda.";
    } else {
      return "Terjadi kesalahan. Silakan coba lagi.";
    }
  }

  // Fungsi Register
  Future<void> register(String username, String email, String password) async {
    final url = Uri.parse('https://api.tumanina.me/register');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'username': username,
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode != 201) {
        throw Exception(extractErrorMessage(response));
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  // Fungsi Login
  Future<void> login(String email, String password) async {
    final url = Uri.parse('https://api.tumanina.me/login');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        // Simpan token ke SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', data['token']);
        await prefs.setString('refresh_token', data['refresh_token']);

        // Ambil data pengguna dari server
        final userResponse = await http.get(
          Uri.parse('https://api.tumanina.me/user'),
          headers: {'Authorization': 'Bearer ${data['token']}'},
        );

        if (userResponse.statusCode == 200) {
          final userData = jsonDecode(userResponse.body);

          // Debug log untuk memastikan data user berhasil diambil
          print('Data User: ${userData.toString()}');

          await prefs.setString('username', userData['username']);
          await prefs.setString('email', userData['email']);
        } else {
          final errorData = jsonDecode(userResponse.body);
          print('Error User Fetch: ${errorData['msg']}');
          throw Exception('Gagal mengambil data pengguna setelah login.');
        }
      } else {
        // Debug log jika login gagal
        print('Login Failed: ${response.body}');
        throw Exception(extractErrorMessage(response));
      }
    } catch (e) {
      // Debug log untuk mengetahui error apa yang terjadi
      print('Login Exception: $e');
      throw Exception(e.toString());
    }
  }

  Future<Map<String, String>> getUserInfo() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) {
      throw Exception('Token tidak ditemukan. Silakan login ulang.');
    }

    final url = Uri.parse('https://api.tumanina.me/user');
    try {
      final response = await http.get(
        url,
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return {
          'username': data['username'] ?? '',
          'email': data['email'] ?? '',
        };
      } else {
        final errorData = jsonDecode(response.body);
        throw Exception(errorData['msg'] ?? 'Gagal mengambil data pengguna');
      }
    } catch (e) {
      throw Exception('Error saat mengambil data pengguna: $e');
    }
  }

  Future<void> refreshUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) {
      throw Exception('Token tidak ditemukan.');
    }

    final url = Uri.parse('https://api.tumanina.me/user');
    try {
      final response = await http.get(
        url,
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        await prefs.setString('username', data['username'] ?? '');
        await prefs.setString('email', data['email'] ?? '');
      } else {
        throw Exception('Gagal memperbarui data pengguna.');
      }
    } catch (e) {
      throw Exception('Error memperbarui data pengguna: $e');
    }
  }

  // Fungsi Update Profil
  Future<void> updateProfile({
    required String username,
    required String email,
    String? oldPassword,
    String? newPassword,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    if (token == null)
      throw Exception("Token tidak ditemukan. Silakan login ulang.");

    final url = Uri.parse('https://api.tumanina.me/user');
    final Map<String, dynamic> payload = {'username': username, 'email': email};

    if (oldPassword != null && newPassword != null) {
      payload['old_password'] = oldPassword;
      payload['new_password'] = newPassword;
    }

    try {
      final response = await http.put(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json'
        },
        body: jsonEncode(payload),
      );

      if (response.statusCode != 200) {
        throw Exception(extractErrorMessage(response));
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  // Fungsi Hapus Akun
  Future<void> deleteAccount() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    if (token == null)
      throw Exception("Token tidak ditemukan. Silakan login ulang.");

    final url = Uri.parse('https://api.tumanina.me/user');
    try {
      final response = await http.delete(
        url,
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode != 200) {
        throw Exception(extractErrorMessage(response));
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  /// Fungsi untuk mengirim frame ke server Flask
  Future<Map<String, dynamic>> sendFrame(File imageFile) async {
    try {
      final request = http.MultipartRequest(
        'POST',
        Uri.parse('$BaseUrl/detect-movement'),
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

  Future<void> submitFeedback(String name, String feedback) async {
    final String baseUrl =
        'https://tumanina.me/sentimen'; // Ganti dengan URL server Anda
    final Uri url = Uri.parse('$baseUrl/add_review');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'name': name,
          'text': feedback, // Ubah ke "text" karena Flask menggunakan key ini
        }),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        print('Feedback submitted successfully: ${responseData['sentiment']}');
      } else {
        print('Failed to submit feedback: ${response.body}');
        throw Exception('Error: ${response.body}');
      }
    } catch (e) {
      print('Error during feedback submission: $e');
      throw e;
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
