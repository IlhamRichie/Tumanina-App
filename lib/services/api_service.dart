import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiService {
  final String baseUrl = "http://127.0.0.1:5000"; // Ganti dengan URL server Flask jika berbeda

  // Fungsi untuk mengirim frame ke endpoint Flask
  Future<Map<String, dynamic>> sendFrame(File imageFile) async {
    try {
      final request = http.MultipartRequest(
        'POST',
        Uri.parse('$baseUrl/detect-movement'),
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
}
