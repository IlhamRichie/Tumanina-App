import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart'; // Import package url_launcher
import '/services/notif_service.dart'; // Sesuaikan path-nya

class TentangScreen extends StatefulWidget {
  const TentangScreen({super.key});

  @override
  _TentangScreenState createState() => _TentangScreenState();
}

class _TentangScreenState extends State<TentangScreen> {
  final NotificationService _notificationService = NotificationService();
  bool isNotifExpanded = false;
  bool isPrivasiExpanded = false;
  bool isSyaratExpanded = false;
  bool isKontakExpanded = false; // Tambahkan state untuk Kontak Kami
  bool isVersiExpanded = false;

  @override
  void initState() {
    super.initState();
    _notificationService.init(); // Inisialisasi layanan notifikasi
  }

  Future<void> _triggerNotificationSound() async {
    final DateTime scheduledTime =
        DateTime.now().add(const Duration(seconds: 1));
    const String sound = 'notification';
    await _notificationService.scheduleNotification(
      id: 'welcome_notification'.hashCode,
      title: 'Selamat Datang',
      body: 'Tumanina! Tuntunan Mandiri Niat dan Ibadah',
      scheduledTime: scheduledTime,
      sound: sound,
    );
  }

  // Fungsi untuk membuka email
  Future<void> _launchEmail() async {
    const String email = 'tumaninacomp@gmail.com'; // Email tujuan
    const String subject = 'Pertanyaan tentang Aplikasi Tumanina';
    const String body = 'Halo Tim Tumanina,\n\nSaya ingin bertanya tentang...';

    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: email,
      queryParameters: {
        'subject': subject,
        'body': body,
      },
    );

    if (await canLaunchUrl(emailUri)) {
      await launchUrl(emailUri);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gagal membuka aplikasi email.')),
      );
    }
  }

  // Fungsi untuk membuka WhatsApp
  Future<void> _launchWhatsApp() async {
    const String phoneNumber = '6289670916052'; // Nomor telepon tanpa tanda "+" atau "0"
    const String message = 'Halo Tim Tumanina, saya ingin bertanya tentang...';

    final Uri whatsappUri = Uri.parse('https://wa.me/$phoneNumber?text=${Uri.encodeComponent(message)}');

    if (await canLaunchUrl(whatsappUri)) {
      await launchUrl(whatsappUri);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gagal membuka WhatsApp.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tentang Tumanina'),
        backgroundColor: Colors.white,
        foregroundColor: Color(0xFF2DDCBE),
        elevation: 0,
      ),
      backgroundColor: Colors.white,
      body: ListView(
        children: [
          _buildExpandableMenu(
            title: 'Izin Notifikasi',
            icon: Icons.notifications_active,
            isExpanded: isNotifExpanded,
            onTap: () => setState(() => isNotifExpanded = !isNotifExpanded),
            content: _buildNotifContent(),
          ),
          _buildExpandableMenu(
            title: 'Pemberitahuan Privasi',
            icon: Icons.privacy_tip,
            isExpanded: isPrivasiExpanded,
            onTap: () => setState(() => isPrivasiExpanded = !isPrivasiExpanded),
            content: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "1. Pengumpulan Data",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF004C7E),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Kami mengumpulkan data seperti nama, email, dan kata sandi untuk keperluan registrasi dan penggunaan aplikasi.",
                    style: TextStyle(fontSize: 14, color: Colors.black87),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "2. Perlindungan Data",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF004C7E),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Data pengguna disimpan dengan aman dan tidak akan dibagikan kepada pihak ketiga tanpa izin.",
                    style: TextStyle(fontSize: 14, color: Colors.black87),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "3. Hak Pengguna",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF004C7E),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Pengguna memiliki hak untuk mengakses, memperbarui, atau menghapus data pribadi mereka kapan saja.",
                    style: TextStyle(fontSize: 14, color: Colors.black87),
                  ),
                ],
              ),
            ),
          ),
          _buildExpandableMenu(
            title: 'Syarat & Ketentuan',
            icon: Icons.description,
            isExpanded: isSyaratExpanded,
            onTap: () => setState(() => isSyaratExpanded = !isSyaratExpanded),
            content: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "1. Keikhlasan",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF004C7E),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Pengguna diharapkan menggunakan aplikasi ini dengan niat yang ikhlas dan tulus untuk mendekatkan diri kepada Allah SWT.",
                    style: TextStyle(fontSize: 14, color: Colors.black87),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "2. Menjaga Privasi",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF004C7E),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Kami menghormati privasi pengguna. Data yang dikumpulkan hanya digunakan untuk keperluan aplikasi dan tidak akan disalahgunakan.",
                    style: TextStyle(fontSize: 14, color: Colors.black87),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "3. Larangan Penyalahgunaan",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF004C7E),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Pengguna dilarang menggunakan aplikasi ini untuk tujuan yang melanggar syariat Islam atau merugikan orang lain.",
                    style: TextStyle(fontSize: 14, color: Colors.black87),
                  ),
                ],
              ),
            ),
          ),
          _buildExpandableMenu(
            title: 'Kontak Kami',
            icon: Icons.phone,
            isExpanded: isKontakExpanded, // Gunakan state isKontakExpanded
            onTap: () => setState(() => isKontakExpanded = !isKontakExpanded), // Toggle state
            content: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                    leading: Icon(Icons.email, color: Color(0xFF004C7E)),
                    title: Text(
                      'Email:',
                      style: TextStyle(fontSize: 14, color: Colors.black87),
                    ),
                    subtitle: GestureDetector(
                      onTap: _launchEmail, // Buka email
                      child: Text(
                        'tumaninacomp@gmail.com',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.blue, // Warna biru untuk email
                        ),
                      ),
                    ),
                  ),
                  ListTile(
                    leading: Icon(Icons.phone, color: Color(0xFF004C7E)),
                    title: Text(
                      'Telepon:',
                      style: TextStyle(fontSize: 14, color: Colors.black87),
                    ),
                    subtitle: GestureDetector(
                      onTap: _launchWhatsApp, // Buka WhatsApp
                      child: Text(
                        '089670916052',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.blue, // Warna biru untuk nomor telepon
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          _buildExpandableMenu(
            title: 'Versi Aplikasi',
            icon: Icons.info,
            isExpanded: isVersiExpanded,
            onTap: () => setState(() => isVersiExpanded = !isVersiExpanded),
            content: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Text('Saat ini versi aplikasi TUMANINA yaitu Beta 1.0.8'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExpandableMenu({
    required String title,
    required IconData icon,
    required bool isExpanded,
    required VoidCallback onTap,
    required Widget content,
  }) {
    return Column(
      children: [
        ListTile(
          leading: Icon(icon, color: Color(0xFF004C7E)),
          title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          trailing: Icon(
            isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
            color: Colors.black54,
          ),
          onTap: onTap,
        ),
        if (isExpanded) content, // Tampilkan konten jika expanded
        const Divider(),
      ],
    );
  }

  Widget _buildNotifContent() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Cara Mengaktifkan Notifikasi:',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 5),
          const Text('1. Buka Pengaturan/Setting'),
          const Text('2. Ketuk Aplikasi'),
          const Text('3. Ketuk Manajemen Aplikasi'),
          const Text('4. Cari Aplikasi Tumanina'),
          const Text('5. Ketuk Kelola Notifikasi'),
          const Text('6. Izinkan Notifikasi'),
          const Text('7. Klik tombol "Selamat Datang"'),
          const SizedBox(height: 10),
          Center(
            child: ElevatedButton(
              onPressed: _triggerNotificationSound,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2DDCBE),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              ),
              child: const Text('Selamat Datang'),
            ),
          ),
        ],
      ),
    );
  }
}