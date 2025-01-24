import 'package:flutter/material.dart';
import '../../services/api_service.dart';
import '../home_screen.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isPasswordVisible = false;
  bool isLoading = false; // Untuk menampilkan indikator loading

  Widget _buildTextField({
    required String labelText,
    required TextEditingController controller,
    bool isPassword = false,
    void Function()? toggleVisibility,
  }) {
    return TextField(
      controller: controller,
      obscureText: isPassword && !isPasswordVisible,
      decoration: InputDecoration(
        labelText: labelText,
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xFF2DDCBE)),
          borderRadius: BorderRadius.all(Radius.circular(4)),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xFF2DDCBE), width: 2.0),
          borderRadius: BorderRadius.all(Radius.circular(4)),
        ),
        suffixIcon: isPassword
            ? IconButton(
                icon: Icon(
                  isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                ),
                onPressed: toggleVisibility,
              )
            : null,
      ),
      style: const TextStyle(fontSize: 16),
    );
  }

  // Fungsi untuk menampilkan SnackBar dengan style Islami
  void _showSnackbar(String message, {bool isError = true}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              isError ? Icons.error_outline : Icons.check_circle,
              color: Colors.white,
            ),
            const SizedBox(width: 10),
            Text(
              message,
              style: const TextStyle(
                fontSize: 11,
                color: Colors.white,
              ),
            ),
          ],
        ),
        backgroundColor: isError ? const Color(0xFF004C7E) : Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _login() async {
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      _showSnackbar('Email dan kata sandi tidak boleh kosong.');
      return;
    }

    setState(() {
      isLoading = true; // Aktifkan indikator loading
    });

    try {
      await ApiService().login(
        emailController.text.trim(),
        passwordController.text.trim(),
      );

      _showSnackbar('Login berhasil!', isError: false);

      // Navigate ke halaman berikutnya
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    } catch (e) {
      _showSnackbar(e.toString().replaceAll('Exception: ', ''));
    } finally {
      setState(() {
        isLoading = false; // Nonaktifkan indikator loading
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 50),
              Row(
                children: [
                  Image.asset(
                    'assets/logo/Logo1.png', // Logo PNG
                    width: 50,
                    height: 50,
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    'Tumanina',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                    overflow:
                        TextOverflow.ellipsis, // Handle overflow with ellipsis
                  ),
                ],
              ),
              const SizedBox(height: 30),
              const Text(
                'Masuk ke akun Anda',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Masukkan email dan kata sandi Anda untuk masuk',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black54,
                ),
              ),
              const SizedBox(height: 30),
              _buildTextField(
                labelText: 'Email',
                controller: emailController,
              ),
              const SizedBox(height: 20),
              _buildTextField(
                labelText: 'Kata sandi',
                controller: passwordController,
                isPassword: true,
                toggleVisibility: () {
                  setState(() {
                    isPasswordVisible = !isPasswordVisible;
                  });
                },
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed:
                      isLoading ? null : _login, // Disable tombol saat loading
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: const Color(0xFF2DDCBE),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 5,
                  ),
                  child: isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          'Masuk',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const RegisterScreen()),
                    );
                  },
                  child: const Text(
                    'Belum memiliki akun? Daftar',
                    style: TextStyle(
                      color: Color(0xFF004C7E),
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
