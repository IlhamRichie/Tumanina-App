import 'package:flutter/material.dart';
import '../../services/api_service.dart';
import '../fitur_login/login_screen.dart';

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
  final TextEditingController _emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _usernameController.text = widget.initialUsername;
    _emailController.text = widget.initialEmail;
  }

  void _saveProfile() async {
    String updatedUsername = _usernameController.text.trim();
    String updatedEmail = _emailController.text.trim();
    String updatedPassword = _passwordController.text.trim();

    // Validasi email
    if (!_isValidEmail(updatedEmail)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text("Masukkan email yang valid"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (updatedUsername.isNotEmpty && updatedEmail.isNotEmpty) {
      try {
        await ApiService().updateProfile(
          username: updatedUsername,
          email: updatedEmail,
          oldPassword: null,
          newPassword: updatedPassword.isNotEmpty ? updatedPassword : null,
        );

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text("Profil berhasil diperbarui"),
            backgroundColor: const Color(0xFF2DDCBE),
          ),
        );
        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Gagal memperbarui profil: $e"),
            backgroundColor: Colors.red,
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text("Harap isi semua kolom"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

// Fungsi validasi email
  bool _isValidEmail(String email) {
    final emailRegex = RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
    return emailRegex.hasMatch(email);
  }

  void _deleteAccount() async {
    bool? confirmDelete = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            "Konfirmasi Hapus Akun",
            style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
          ),
          content: const Text(
            "Apakah Anda yakin ingin menghapus akun Anda? Tindakan ini tidak dapat dibatalkan.",
            style: TextStyle(color: Colors.black),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text("Batal", style: TextStyle(color: Colors.grey)),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text("Hapus", style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );

    if (confirmDelete == true) {
      await ApiService().deleteAccount();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text("Akun berhasil dihapus"),
          backgroundColor: Colors.red,
        ),
      );

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
        (Route<dynamic> route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFFFFF),
        title: const Text(
          "Edit Profil",
          style:
              TextStyle(color: Color(0xFF004C7E), fontWeight: FontWeight.bold),
        ),
        elevation: 2,
        iconTheme: const IconThemeData(color: Color(0xFF004C7E)),
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
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF004C7E),
                ),
              ),
              const SizedBox(height: 20),
              _buildTextField(
                controller: _usernameController,
                label: "Username",
                icon: Icons.person,
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _passwordController,
                label: "Password",
                icon: Icons.lock,
                isPassword: true,
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _emailController,
                label: "Email",
                icon: Icons.email,
              ),
              const SizedBox(height: 30),
              Center(
                child: Column(
                  children: [
                    _buildGradientButton(
                      text: "Simpan Perubahan",
                      onPressed: _saveProfile,
                      gradient: const LinearGradient(
                        colors: [Color(0xFF004C7E), Color(0xFF2DDCBE)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      textColor: Colors.white,
                    ),
                    const SizedBox(height: 16),
                    _buildOutlinedButton(
                      text: "Hapus Akun",
                      onPressed: _deleteAccount,
                      gradient: const LinearGradient(
                        colors: [Color(0xFF004C7E), Color(0xFF2DDCBE)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      textColor: Colors.red,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool isPassword = false,
  }) {
    return TextField(
      controller: controller,
      obscureText: isPassword,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Color(0xFF004C7E)),
        prefixIcon: Icon(icon, color: const Color(0xFF004C7E)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(
            color: Color(0xFF004C7E),
            width: 1.5,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(
            color: Color(0xFF2DDCBE),
            width: 2.0,
          ),
        ),
        fillColor: Colors.white,
        filled: true,
      ),
    );
  }

  Widget _buildGradientButton({
    required String text,
    required VoidCallback onPressed,
    required LinearGradient gradient,
    required Color textColor,
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(30),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
        child: Text(
          text,
          style: TextStyle(
            color: textColor,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildOutlinedButton({
    required String text,
    required VoidCallback onPressed,
    required LinearGradient gradient,
    required Color textColor,
  }) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        side: BorderSide(
          color: gradient.colors.first,
          width: 2,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: textColor,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
