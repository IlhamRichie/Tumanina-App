import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  bool _isLoading = false;
  bool _isOldPasswordVisible = false;
  bool _isNewPasswordVisible = false;

  @override
  void initState() {
    super.initState();
    _usernameController.text = widget.initialUsername;
    _emailController.text = widget.initialEmail;
  }

  void _saveProfile() async {
    String updatedUsername = _usernameController.text.trim();
    String updatedEmail = _emailController.text.trim();
    String oldPassword = _oldPasswordController.text.trim();
    String newPassword = _newPasswordController.text.trim();

    if (updatedUsername.isEmpty || updatedEmail.isEmpty) {
      _showSnackBar("Nama pengguna dan Email harus diisi.", Colors.red);
      return;
    }

    if (newPassword.isNotEmpty && oldPassword.isEmpty) {
      _showSnackBar("Password Lama harus diisi jika ingin mengganti Password Baru.", Colors.red);
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      await ApiService().updateProfile(
        username: updatedUsername,
        email: updatedEmail,
        oldPassword: oldPassword.isEmpty ? null : oldPassword,
        newPassword: newPassword.isEmpty ? null : newPassword,
      );

      final userData = await ApiService().getUserInfo();

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('username', userData['username'] ?? 'DefaultUsername');
      await prefs.setString('email', userData['email'] ?? 'DefaultEmail');

      _showSnackBar("Profil berhasil diperbarui.", const Color(0xFF2DDCBE));

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => EditProfileScreen(
            initialUsername: userData['username'] ?? 'DefaultUsername',
            initialEmail: userData['email'] ?? 'DefaultEmail',
          ),
        ),
      );
    } catch (e) {
      _showSnackBar(e.toString(), Colors.red);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
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
      setState(() {
        _isLoading = true;
      });

      try {
        await ApiService().deleteAccount();
        _showSnackBar("Akun berhasil dihapus.", Colors.red);

        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
          (route) => false,
        );
      } catch (e) {
        _showSnackBar(e.toString(), Colors.red);
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
      ),
    );
  }

  InputDecoration _buildInputDecoration({
    required String hintText,
    required IconData icon,
  }) {
    return InputDecoration(
      labelText: hintText,
      labelStyle: const TextStyle(color: Color(0xFF004C7E)),
      prefixIcon: Icon(icon, color: const Color(0xFF004C7E)),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFF004C7E)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color.fromARGB(255, 62, 207, 230)),
      ),
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Edit Profil",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                "Edit Profil",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF004C7E),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                "Perbarui informasi profil Anda",
                style: TextStyle(
                  fontSize: 16,
                  color: Color(0xFF004C7E),
                ),
              ),
              const SizedBox(height: 24),
              TextField(
                controller: _usernameController,
                decoration: _buildInputDecoration(
                  hintText: "Nama Pengguna",
                  icon: Icons.person_outline,
                ),
                style: const TextStyle(color: Colors.black87),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _emailController,
                decoration: _buildInputDecoration(
                  hintText: "Email Pengguna",
                  icon: Icons.email_outlined,
                ),
                style: const TextStyle(color: Colors.black87),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _oldPasswordController,
                decoration: _buildInputDecoration(
                  hintText: "Password Lama",
                  icon: Icons.lock_outline,
                ).copyWith(
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isOldPasswordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: Colors.grey.shade600,
                    ),
                    onPressed: () {
                      setState(() {
                        _isOldPasswordVisible = !_isOldPasswordVisible;
                      });
                    },
                  ),
                ),
                obscureText: !_isOldPasswordVisible,
                style: const TextStyle(color: Colors.black87),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _newPasswordController,
                decoration: _buildInputDecoration(
                  hintText: "Password Baru",
                  icon: Icons.lock_open_outlined,
                ).copyWith(
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isNewPasswordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: Colors.grey.shade600,
                    ),
                    onPressed: () {
                      setState(() {
                        _isNewPasswordVisible = !_isNewPasswordVisible;
                      });
                    },
                  ),
                ),
                obscureText: !_isNewPasswordVisible,
                style: const TextStyle(color: Colors.black87),
              ),

              const SizedBox(height: 24),
              _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                      onPressed: _saveProfile,
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        padding: const EdgeInsets.all(0),
                      ),
                      child: Ink(
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Color(0xFF004C7E), Color(0xFF2DDCBE)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(30)),
                        ),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: 16,
                          ),
                          alignment: Alignment.center,
                          child: const Text(
                            "Simpan Perubahan",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: _deleteAccount,
                style: TextButton.styleFrom(
                  foregroundColor: Colors.red,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text(
                  "Hapus Akun",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
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
