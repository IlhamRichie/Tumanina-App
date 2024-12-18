import 'package:flutter/material.dart';
import 'login_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: CircleAvatar(
                radius: 50,
                backgroundImage: AssetImage('assets/profile_placeholder.png'), // Tambahkan gambar profil placeholder
              ),
            ),
            const SizedBox(height: 20),
            const Center(
              child: Text(
                'Nama Pengguna',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ),
            const SizedBox(height: 5),
            Center(
              child: Text(
                'email@example.com',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
              ),
            ),
            const SizedBox(height: 30),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.person, color: Colors.blue),
              title: const Text('Edit Profil'),
              onTap: () {
                // Aksi untuk mengedit profil
                // Navigator.push(context, MaterialPageRoute(builder: (context) => EditProfileScreen()));
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.lock, color: Colors.blue),
              title: const Text('Ubah Kata Sandi'),
              onTap: () {
                // Aksi untuk mengubah kata sandi
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text('Keluar'),
              onTap: () {
                // Aksi logout, kembali ke layar LoginScreen
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
