import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  final String baseUrl = "http://159.203.89.57:5000/";
  final String artikelBaseUrl =
      'https://artikel-islam.netlify.app/.netlify/functions/api/ms/detail/:id_article';
  final String groqApiKey =
      'yourapikey';
  final String groqBaseUrl = 'https://api.groq.com/openai/v1';
  final String groqModel = 'llama-3.3-70b-versatile';

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

  Future<bool> isSessionValid() async {
    final prefs = await SharedPreferences.getInstance();
    final loginTimestamp = prefs.getInt('login_timestamp');
    final token = prefs.getString('token');

    if (loginTimestamp == null || token == null) {
      return false; // Selalu return false jika null
    }

    final currentTime = DateTime.now().millisecondsSinceEpoch;
    final thirtyDaysInMillis = 30 * 24 * 60 * 60 * 1000; // 30 hari

    return (currentTime - loginTimestamp) < thirtyDaysInMillis;
  }

  // Fungsi Register
  Future<void> register(String username, String email, String password) async {
    final url = Uri.parse('$baseUrl/register');
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
  // Fungsi Login yang sudah diperbarui
  Future<void> login(String email, String password) async {
    final url = Uri.parse('$baseUrl/login');
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

        // Simpan timestamp login untuk validasi session (Tambahan)
        await prefs.setInt(
            'login_timestamp', DateTime.now().millisecondsSinceEpoch);

        // Ambil data pengguna dari server
        final userResponse = await http.get(
          Uri.parse('$baseUrl/user'),
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

    if (token == null || token.isEmpty) {
      throw Exception('Token tidak ditemukan. Silakan login ulang.');
    }

    final url = Uri.parse('$baseUrl/user');
    try {
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return {
          'username': data['username'] ?? '',
          'email': data['email'] ?? '',
        };
      } else {
        throw Exception(extractErrorMessage(response));
      }
    } catch (e) {
      throw Exception("Error saat mengambil data pengguna: $e");
    }
  }

  Future<void> refreshUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) {
      throw Exception('Token tidak ditemukan.');
    }

    final url = Uri.parse('$baseUrl/user');
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

    if (token == null || token.isEmpty) {
      throw Exception("Token tidak ditemukan. Silakan login ulang.");
    }

    final url = Uri.parse('$baseUrl/user');
    final Map<String, dynamic> payload = {
      'username': username,
      'email': email,
    };

    if (oldPassword != null && newPassword != null) {
      payload['old_password'] = oldPassword;
      payload['new_password'] = newPassword;
    }

    try {
      final response = await http.put(
        url,
        headers: {
          'Authorization': 'Bearer $token', // Pastikan format Bearer benar
          'Content-Type': 'application/json',
        },
        body: jsonEncode(payload),
      );

      if (response.statusCode != 200) {
        throw Exception(extractErrorMessage(response));
      }
    } catch (e) {
      throw Exception("Error saat update profil: $e");
    }
  }

  // Fungsi Hapus Akun
  Future<void> deleteAccount() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null || token.isEmpty) {
      throw Exception("Token tidak ditemukan. Silakan login ulang.");
    }

    final url = Uri.parse('$baseUrl/user');
    try {
      final response = await http.delete(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        await prefs.clear();
        print('Akun berhasil dihapus.');
      } else {
        throw Exception(extractErrorMessage(response));
      }
    } catch (e) {
      throw Exception("Error saat menghapus akun: $e");
    }
  }

  // Fungsi Submit Feedback
  Future<void> submitFeedback(String name, String feedback) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null || token.isEmpty) {
      throw Exception('Token tidak ditemukan. Silakan login ulang.');
    }

    final url = Uri.parse('$baseUrl/sentiment');
    try {
      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'nama': name,
          'review': feedback,
        }),
      );

      if (response.statusCode != 200) {
        throw Exception(extractErrorMessage(response));
      }
    } catch (e) {
      throw Exception("Error saat mengirim feedback: $e");
    }
  }

  // Fungsi Chatbot Groq API
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
        throw Exception(extractErrorMessage(response));
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  // Fungsi Fetch Artikel
  Future<List<Map<String, dynamic>>> fetchArticles() async {
    final url = Uri.parse(artikelBaseUrl);
    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data.containsKey('data') && data['data'] is List) {
          return List<Map<String, dynamic>>.from(data['data']);
        } else {
          throw Exception('Data artikel tidak ditemukan.');
        }
      } else {
        throw Exception(extractErrorMessage(response));
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  // Fungsi Logout
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null || token.isEmpty) {
      throw Exception("Token tidak ditemukan. Silakan login ulang.");
    }

    final url = Uri.parse('$baseUrl/logout');
    try {
      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        await prefs.clear();
        print('Logout berhasil.');
      } else {
        throw Exception(extractErrorMessage(response));
      }
    } catch (e) {
      throw Exception("Error saat logout: $e");
    }
  }

  Future<List<Map<String, dynamic>>> fetchThreads() async {
    final url = Uri.parse('${baseUrl}api/threads');
    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return List<Map<String, dynamic>>.from(data['threads']);
      } else {
        throw Exception(extractErrorMessage(response));
      }
    } catch (e) {
      throw Exception("Error fetching threads: $e");
    }
  }

  Future<void> createThread(String title, String content, int authorId) async {
    final url = Uri.parse('${baseUrl}api/threads');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'title': title,
          'content': content,
          'author_id': authorId,
        }),
      );

      if (response.statusCode != 201) {
        throw Exception(extractErrorMessage(response));
      }
    } catch (e) {
      throw Exception("Error creating thread: $e");
    }
  }

  Future<void> editThread(int threadId, String title, String content) async {
    final url = Uri.parse('${baseUrl}api/threads/$threadId');
    try {
      final response = await http.put(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'title': title, 'content': content}),
      );

      if (response.statusCode != 200) {
        throw Exception(extractErrorMessage(response));
      }
    } catch (e) {
      throw Exception("Error editing thread: $e");
    }
  }

  Future<void> deleteThread(int threadId) async {
    final url = Uri.parse('${baseUrl}api/threads/$threadId');
    try {
      final response = await http.delete(url);

      if (response.statusCode != 200) {
        throw Exception(extractErrorMessage(response));
      }
    } catch (e) {
      throw Exception("Error deleting thread: $e");
    }
  }

  Future<List<Map<String, dynamic>>> fetchComments(int threadId) async {
    final url = Uri.parse('${baseUrl}api/threads/$threadId/comments');
    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return List<Map<String, dynamic>>.from(data['comments']);
      } else {
        throw Exception(extractErrorMessage(response));
      }
    } catch (e) {
      throw Exception("Error fetching comments: $e");
    }
  }

  Future<void> addComment(int threadId, String content, int authorId,
      {int? parentCommentId}) async {
    final url = Uri.parse('${baseUrl}api/threads/$threadId/comments');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'content': content,
          'author_id': authorId,
          'parent_comment_id': parentCommentId,
        }),
      );

      if (response.statusCode != 201) {
        throw Exception(extractErrorMessage(response));
      }
    } catch (e) {
      throw Exception("Error adding comment: $e");
    }
  }

  Future<void> editComment(int commentId, String content) async {
    final url = Uri.parse('${baseUrl}api/comments/$commentId');
    try {
      final response = await http.put(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'content': content}),
      );

      if (response.statusCode != 200) {
        throw Exception(extractErrorMessage(response));
      }
    } catch (e) {
      throw Exception("Error editing comment: $e");
    }
  }

  Future<void> deleteComment(int commentId) async {
    final url = Uri.parse('${baseUrl}api/comments/$commentId');
    try {
      final response = await http.delete(url);

      if (response.statusCode != 200) {
        throw Exception(extractErrorMessage(response));
      }
    } catch (e) {
      throw Exception("Error deleting comment: $e");
    }
  }
}
