import 'package:flutter/material.dart';
import '../../services/api_service.dart';
import '../fitur_login/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FeedbackForm extends StatefulWidget {
  const FeedbackForm({super.key});

  @override
  _FeedbackFormState createState() => _FeedbackFormState();
}

class _FeedbackFormState extends State<FeedbackForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _feedbackController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _nameController.text = prefs.getString('username') ?? 'Tidak ditemukan';
    });
  }

  void _submitFeedback() async {
    final name = _nameController.text.trim();
    final feedback = _feedbackController.text.trim();

    if (_formKey.currentState?.validate() ?? false) {
      try {
        await ApiService().submitFeedback(name, feedback);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Feedback berhasil dikirim"),
            backgroundColor: Color(0xFF2DDCBE),
          ),
        );
        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Gagal mengirim feedback: $e"),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          TextFormField(
            controller: _nameController,
            enabled: false,
            decoration: InputDecoration(
              labelText: 'Nama',
              labelStyle: const TextStyle(color: Color(0xFF004C7E)),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Color(0xFF004C7E)),
              ),
              fillColor: Colors.grey[200],
              filled: true,
            ),
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _feedbackController,
            maxLines: 4,
            decoration: InputDecoration(
              labelText: 'Tulis Ulasan Anda',
              labelStyle: const TextStyle(color: Color(0xFF004C7E)),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Color(0xFF004C7E)),
              ),
              fillColor: Colors.white,
              filled: true,
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Feedback tidak boleh kosong';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          Center(
            child: ElevatedButton(
              onPressed: _submitFeedback,
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: const Color(0xFF2DDCBE),
                padding: const EdgeInsets.symmetric(
                  horizontal: 40,
                  vertical: 15,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: const Text('Kirim', style: TextStyle(fontSize: 16)),
            ),
          ),
        ],
      ),
    );
  }
}
