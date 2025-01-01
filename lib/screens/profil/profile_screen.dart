import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../services/api_service.dart';
import '../artikel/artikel_screen.dart';
import '../home_screen.dart';
import '../login_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // Image and username variables
  File? _profileImage;
  final TextEditingController _usernameController = TextEditingController();

  // Picking image from gallery or camera
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    // Set default username (In practice, fetch from your backend)
    _usernameController.text = 'Ilham Rigan';
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
      });
    }
  }

  Future<void> _takePhoto() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
      });
    }
  }

  void _saveProfile() {
    String updatedUsername = _usernameController.text;
    if (updatedUsername.isNotEmpty) {
      ApiService().updateProfile(updatedUsername, _profileImage);

      // Optionally show a message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Profile updated successfully")),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter a valid username")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF2DDCBE),
        elevation: 0.0,
        toolbarHeight: 50,
        centerTitle: true,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(bottom: Radius.circular(30))),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Profile Image Container with a more stylish shadow
            GestureDetector(
              onTap: () {
                _showImagePickerDialog(context);
              },
              child: Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [Colors.teal.shade200, Colors.teal.shade700],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 12,
                      offset: Offset(0, 8),
                    ),
                  ],
                  image: _profileImage == null
                      ? const DecorationImage(
                          image: AssetImage('assets/pp.jpeg'),
                          fit: BoxFit.cover,
                        )
                      : DecorationImage(
                          image: FileImage(_profileImage!),
                          fit: BoxFit.cover,
                        ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Name text with editable field
            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(
                labelText: 'Username',
                border: OutlineInputBorder(),
              ),
              style: TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 20),
            // Save Profile Button
            ElevatedButton(
              onPressed: _saveProfile,
              child: const Text('Simpan Profil'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2DDCBE),
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                textStyle: TextStyle(fontSize: 16),
              ),
            ),
            const SizedBox(height: 30),
            // Divider with modern design
            const Divider(thickness: 1.2, color: Colors.grey, indent: 30, endIndent: 30),
            const SizedBox(height: 20),
            // ListTiles updated for better interaction
            _buildProfileOption(
              icon: Icons.person_outline,
              text: 'Edit Profil',
              onTap: () {
                // Navigate to edit profile page if necessary
              },
            ),
            _buildProfileOption(
              icon: Icons.feedback_outlined,
              text: 'Feedback',
              onTap: () {
                _showFeedbackDialog(context);
              },
            ),
            _buildProfileOption(
              icon: Icons.lock_outline,
              text: 'Ubah Kata Sandi',
              onTap: () {
                // Action to change password
              },
            ),
            _buildProfileOption(
              icon: Icons.exit_to_app,
              text: 'Keluar',
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                );
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildMenuButton(context),
    );
  }

  Widget _buildProfileOption({required IconData icon, required String text, required VoidCallback onTap}) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 24),
      leading: Icon(icon, color: const Color(0xFF004C7E), size: 30),
      title: Text(
        text,
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
      ),
      onTap: onTap,
    );
  }

  void _showFeedbackDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: FeedbackForm(),
          ),
        );
      },
    );
  }

  void _showImagePickerDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Pilih Foto Profil'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Pilih dari Galeri'),
                onTap: () {
                  _pickImage();
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Ambil Foto Baru'),
                onTap: () {
                  _takePhoto();
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMenuButton(BuildContext context) {
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
        currentIndex: 2, // Set current index to 2 for "Profil"
        elevation: 5,
        backgroundColor: Colors.white,
        selectedItemColor: const Color(0xFF004C7E),
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_rounded),
            label: 'Beranda',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.article_rounded),
            label: 'Artikel',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_rounded),
            label: 'Profil',
          ),
        ],
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
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const ProfileScreen()),
            );
          }
        },
      ),
    );
  }
}

class FeedbackForm extends StatefulWidget {
  const FeedbackForm({super.key});

  @override
  _FeedbackFormState createState() => _FeedbackFormState();
}

class _FeedbackFormState extends State<FeedbackForm> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _feedbackController = TextEditingController();

  void _submitFeedback() async {
    final name = _nameController.text;
    final feedback = _feedbackController.text;
    final date = DateTime.now().toIso8601String();

    if (name.isNotEmpty && feedback.isNotEmpty) {
      ApiService().submitFeedback(name, feedback, date);

      // Close the dialog
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill out all fields")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        TextField(
          controller: _nameController,
          decoration: const InputDecoration(labelText: 'Nama'),
        ),
        TextField(
          controller: _feedbackController,
          maxLines: 4,
          decoration: const InputDecoration(labelText: 'Tulis Ulasan Anda'),
        ),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: _submitFeedback,
          child: const Text('Kirim'),
        ),
      ],
    );
  }
}
