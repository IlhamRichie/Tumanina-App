import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:Tumanina/services/api_service.dart';
import 'package:Tumanina/screens/home_screen.dart';
import 'package:Tumanina/screens/artikel/artikel_screen.dart';
import 'package:Tumanina/screens/profil/profile_screen.dart';

class DiskusiScreen extends StatefulWidget {
  const DiskusiScreen({super.key});

  @override
  State<DiskusiScreen> createState() => _DiskusiScreenState();
}

class _DiskusiScreenState extends State<DiskusiScreen> {
  final ApiService _apiService = ApiService();
  late Future<List<Map<String, dynamic>>> _threads;

  @override
  void initState() {
    super.initState();
    _threads = _apiService.fetchThreads();
  }

  Future<void> _refreshThreads() async {
    setState(() {
      _threads = _apiService.fetchThreads(); // Memuat ulang data thread
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Diskusi',
          style: GoogleFonts.poppins(
            color: const Color(0xFF004C7E),
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        centerTitle: true,
      ),
      body: RefreshIndicator(
        onRefresh: _refreshThreads,
        child: FutureBuilder<List<Map<String, dynamic>>>(
          future: _threads,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return _buildSkeletonList();
            } else if (snapshot.hasError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Gagal memuat diskusi.',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    Container(
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [
                            Color(0xFF004C7E),
                            Color(0xFF2DDCBE),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: OutlinedButton(
                        onPressed: _refreshThreads,
                        style: OutlinedButton.styleFrom(
                          backgroundColor:
                              Colors.white, // Warna background tombol
                          side: BorderSide.none, // Hilangkan border bawaan
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 24.0, vertical: 12.0),
                        ),
                        child: ShaderMask(
                          shaderCallback: (bounds) => const LinearGradient(
                            colors: [
                              Color(0xFF004C7E),
                              Color(0xFF2DDCBE),
                            ],
                          ).createShader(bounds),
                          child: const Text(
                            'Coba Lagi',
                            style: TextStyle(
                              color: Colors.white, // Warna teks default
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              );
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(
                child: Text(
                  'Belum ada diskusi.',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              );
            } else {
              final threads = snapshot.data!;
              return ListView.builder(
                padding: const EdgeInsets.all(16.0),
                itemCount: threads.length,
                itemBuilder: (context, index) {
                  final thread = threads[index];
                  return Card(
                    elevation: 3,
                    margin: const EdgeInsets.only(bottom: 16.0),
                    child: ListTile(
                      title: Text(
                        thread['title'] ?? 'Judul tidak tersedia',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      subtitle: Text(
                        'Oleh: ${thread['author_username'] ?? 'Tidak diketahui'}',
                      ),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DetailThreadScreen(
                              threadId: thread['thread_id'],
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(context),
    );
  }

  Widget _buildSkeletonList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: 6,
      itemBuilder: (context, index) {
        return Card(
          elevation: 3,
          margin: const EdgeInsets.only(bottom: 16.0),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  height: 16.0,
                  color: Colors.grey.shade300,
                ),
                const SizedBox(height: 8.0),
                Container(
                  width: 150.0,
                  height: 16.0,
                  color: Colors.grey.shade300,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildBottomNavigationBar(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: BottomNavigationBar(
        backgroundColor: Colors.white,
        currentIndex: 2,
        onTap: (index) {
          if (index == 0) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const HomeScreen()),
            );
          } else if (index == 1) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const ArtikelScreen()),
            );
          } else if (index == 2) {
            // Tetap di halaman Diskusi
          } else if (index == 3) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const ProfileScreen()),
            );
          }
        },
        selectedItemColor: const Color(0xFF004C7E),
        unselectedItemColor: Colors.grey,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Beranda',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.article),
            label: 'Artikel',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.mark_chat_unread),
            label: 'Diskusi',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profil',
          ),
        ],
      ),
    );
  }
}

class DetailThreadScreen extends StatelessWidget {
  final int threadId;

  const DetailThreadScreen({super.key, required this.threadId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Diskusi'),
      ),
      body: Center(
        child: Text('Detail thread dengan ID: $threadId'),
      ),
    );
  }
}
