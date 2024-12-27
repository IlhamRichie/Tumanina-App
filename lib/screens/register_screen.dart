import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'package:flutter/gestures.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  bool isPasswordVisible = false;
  bool isChecked = false;

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
                  Navigator.pop(context); // Navigate back to login screen
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
                            "Dengan ini saya membaca, memahami, dan menyetujui hal-hal yang tercantum pada ",
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
                          const TextSpan(text: " dan "),
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
                          const TextSpan(text: " yang berlaku."),
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
                      ? () {
                          // Navigate to HomeScreen
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const HomeScreen()),
                          );
                        }
                      : null, // Disable button if checkbox is not checked
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

  void _showTerms(BuildContext context, String title) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: SingleChildScrollView(
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

6. Hukum yang Berlaku 
   Syarat dan Ketentuan ini diatur sesuai dengan hukum yang berlaku di Indonesia.  
          """
                  : """
Kebijakan Privasi

1. Informasi yang Dikumpulkan
   - Kami mengumpulkan informasi pribadi, seperti nama, email, dan data lainnya yang relevan untuk penggunaan aplikasi.  
   - Data akan digunakan untuk meningkatkan layanan kami.  

2. Penggunaan Informasi  
   - Informasi pribadi Anda hanya digunakan untuk keperluan internal dan tidak akan dibagikan kepada pihak ketiga tanpa izin Anda.  
   - Data dapat digunakan untuk memberikan pengalaman yang lebih personal di aplikasi.  

3. Keamanan Data  
   - Kami menggunakan teknologi terkini untuk melindungi data Anda dari akses yang tidak sah.  
   - Namun, kami tidak dapat menjamin keamanan absolut dari informasi yang Anda berikan.  

4. Hak Pengguna 
   - Anda berhak mengakses, mengubah, atau menghapus informasi pribadi Anda kapan saja.  
   - Hubungi kami jika Anda memiliki pertanyaan terkait privasi.  

5. Perubahan Kebijakan  
   - Kami dapat memperbarui Kebijakan Privasi ini dari waktu ke waktu. Perubahan akan diberitahukan melalui aplikasi.  
          """,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Tutup"),
            ),
          ],
        );
      },
    );
  }
}
