import 'package:flutter/material.dart';
import '../../services/api_service.dart';
import '../home_screen.dart';
import 'package:flutter/gestures.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  bool isPasswordVisible = false;
  bool isChecked = false;

  @override
  void dispose() {
    // Jangan lupa membersihkan controller saat widget dihapus
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  void _showErrorDialog(BuildContext context, String title,
      {String message = "Terjadi kesalahan. Silakan coba lagi."}) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          content: Text(
            message,
            style: const TextStyle(fontSize: 14),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Tutup"),
            ),
          ],
        );
      },
    );
  }

  void _showTerms(BuildContext context, String title) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: Container(
            width: MediaQuery.of(context).size.width * 0.8,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [const Color(0xFF2DDCBE), const Color(0xFF004C7E)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                Expanded(
                  child: SingleChildScrollView(
                    child: Text(
                      title == "Syarat dan Ketentuan"
                          ? """
Syarat dan Ketentuan

1. Pendahuluan
   Selamat datang di aplikasi Tumanina. Dengan menggunakan aplikasi ini, Anda menyetujui untuk mematuhi syarat dan ketentuan yang berlaku.

2. Akses dan Penggunaan Aplikasi
   - Anda bertanggung jawab atas informasi yang Anda masukkan dalam aplikasi.
   - Dilarang menggunakan aplikasi ini untuk aktivitas yang melanggar hukum atau mengganggu pengguna lain.

3. Akun dan Keamanan
   - Anda bertanggung jawab atas kerahasiaan akun Anda, termasuk kata sandi.
   - Kami tidak bertanggung jawab atas kerugian akibat penyalahgunaan akun Anda.

4. Konten Pengguna
   - Semua data yang diunggah pengguna akan dijaga kerahasiaannya sesuai dengan Kebijakan Privasi.
   - Kami berhak menghapus konten yang melanggar ketentuan atau merugikan pihak lain.

5. Perubahan Layanan
   - Kami dapat memperbarui atau menghentikan fitur aplikasi tanpa pemberitahuan sebelumnya.

6. Hak Kekayaan Intelektual
   - Semua konten dalam aplikasi ini, termasuk teks, gambar, dan logo, dilindungi oleh hak kekayaan intelektual.
   - Dilarang menggunakan atau menyalin konten aplikasi tanpa izin tertulis dari pihak pengembang.

7. Hukum yang Berlaku
   Syarat dan Ketentuan ini diatur sesuai dengan hukum yang berlaku di Indonesia.
                      """
                          : """
Kebijakan Privasi

1. Informasi yang Dikumpulkan
   - Kami mengumpulkan informasi pribadi, seperti nama, email, dan data lainnya yang relevan untuk penggunaan aplikasi.
   - Data ini digunakan untuk meningkatkan layanan kami dan memastikan pengalaman pengguna yang optimal.

2. Penggunaan Informasi
   - Informasi pribadi Anda hanya digunakan untuk keperluan internal dan tidak akan dibagikan kepada pihak ketiga tanpa izin Anda.
   - Data dapat digunakan untuk memberikan pengalaman yang lebih personal di aplikasi.

3. Keamanan Data
   - Kami menggunakan teknologi terkini untuk melindungi data Anda dari akses yang tidak sah.
   - Namun, kami tidak dapat menjamin keamanan absolut dari informasi yang Anda berikan.

4. Hak Pengguna
   - Anda berhak mengakses, mengubah, atau menghapus informasi pribadi Anda kapan saja melalui pengaturan akun.
   - Hubungi kami jika Anda memiliki pertanyaan terkait privasi atau permintaan penghapusan data.

5. Penyimpanan Data
   - Data Anda akan disimpan selama akun Anda aktif. Setelah akun dinonaktifkan, data Anda akan dihapus sesuai kebijakan kami.

6. Perubahan Kebijakan
   - Kami dapat memperbarui Kebijakan Privasi ini dari waktu ke waktu. Perubahan akan diberitahukan melalui aplikasi atau email terdaftar Anda.

7. Hubungi Kami
   Jika Anda memiliki pertanyaan atau masalah terkait privasi, hubungi kami melalui email di support@tumanina.com.
                      """,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.white70,
                        height: 1.5,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.blueAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () => Navigator.pop(context),
                    child: const Text("Tutup"),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
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
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: const Row(
                  children: [
                    Icon(Icons.arrow_back, color: Colors.black87),
                    SizedBox(width: 8),
                    Text(
                      "Kembali ke halaman login",
                      style: TextStyle(
                        color: Colors.black87,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              const Text(
                "Daftar Akun Baru",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: "Nama",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF2DDCBE)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Color(0xFF2DDCBE), width: 2.0),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: emailController,
                decoration: const InputDecoration(
                  labelText: "Email",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF2DDCBE)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Color(0xFF2DDCBE), width: 2.0),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: passwordController,
                obscureText: !isPasswordVisible,
                decoration: InputDecoration(
                  labelText: "Kata sandi",
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(16)),
                  ),
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF2DDCBE)),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Color(0xFF2DDCBE), width: 2.0),
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      isPasswordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        isPasswordVisible = !isPasswordVisible;
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: confirmPasswordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: "Konfirmasi kata sandi",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF2DDCBE)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Color(0xFF2DDCBE), width: 2.0),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Checkbox(
                    value: isChecked,
                    onChanged: (value) {
                      setState(() {
                        isChecked = value!;
                      });
                    },
                    activeColor: const Color(0xFF2DDCBE),
                  ),
                  Expanded(
                    child: RichText(
                      text: TextSpan(
                        text:
                            "Dengan ini saya membaca, memahami, dan menyetujui ",
                        style: const TextStyle(
                            color: Colors.black87, fontSize: 12),
                        children: [
                          TextSpan(
                            text: "Syarat dan Ketentuan",
                            style: const TextStyle(
                                color: Color(0xFF004C7E),
                                fontWeight: FontWeight.bold),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                _showTerms(context, "Syarat dan Ketentuan");
                              },
                          ),
                          const TextSpan(text: " serta "),
                          TextSpan(
                            text: "Kebijakan Privasi",
                            style: const TextStyle(
                                color: Color(0xFF004C7E),
                                fontWeight: FontWeight.bold),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                _showTerms(context, "Kebijakan Privasi");
                              },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: isChecked
                      ? () async {
                          // Validasi input
                          if (nameController.text.isEmpty ||
                              emailController.text.isEmpty ||
                              passwordController.text.isEmpty ||
                              confirmPasswordController.text.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Harap isi semua kolom!"),
                                backgroundColor: Colors.red,
                              ),
                            );
                            return;
                          }

                          if (passwordController.text !=
                              confirmPasswordController.text) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Kata sandi tidak cocok!"),
                                backgroundColor: Colors.red,
                              ),
                            );
                            return;
                          }

                          try {
                            final apiService = ApiService();
                            await apiService.register(
                              nameController.text, // Nama pengguna
                              emailController.text, // Email
                              passwordController.text, // Kata sandi
                            );

                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Registrasi berhasil"),
                                backgroundColor: Colors.green,
                              ),
                            );

                            // Navigasi ke layar berikutnya
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const HomeScreen()),
                            );
                          } catch (e) {
                            _showErrorDialog(
                              context,
                              "Registrasi Gagal",
                              message:
                                  "Terjadi kesalahan saat registrasi. Silakan coba lagi nanti.",
                            );
                          }
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2DDCBE),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text("Daftar"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
