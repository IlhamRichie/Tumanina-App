import 'package:flutter/material.dart'; 
import '../../services/api_service.dart';

class EditProfileScreen extends StatefulWidget {
  final String initialUsername;
  final String initialEmail;

  const EditProfileScreen({
    super.key,
    required this.initialUsername,
    required this.initialEmail,
  });

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _usernameController.text = widget.initialUsername;
  }

  void _saveProfile() async {
    String updatedUsername = _usernameController.text.trim();
    String updatedPassword = _passwordController.text.trim();

    if (updatedUsername.isNotEmpty && updatedPassword.isNotEmpty) {
      await ApiService().updateProfile(updatedUsername, null);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text("Profil berhasil diperbarui"),
          backgroundColor: const Color(0xFF2DDCBE),
        ),
      );

      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text("Harap isi semua kolom"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Edit Profil",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF004C7E),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Perbarui Informasi",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF004C7E),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _usernameController,
                decoration: InputDecoration(
                  labelText: "Username",
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
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: "Password",
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
                obscureText: true,
              ),
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: _saveProfile,
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white, backgroundColor: const Color(0xFF2DDCBE),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 40,
                      vertical: 15,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text(
                    "Simpan Perubahan",
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
