import 'package:flutter/material.dart';
import 'login_screen.dart';

class IntroScreen extends StatefulWidget {
  const IntroScreen({super.key});

  @override
  _IntroScreenState createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Map<String, String>> _introData = [
    {
      "title": "Selamat Datang di Aplikasi",
      "description": "Aplikasi ini membantu Anda dalam ibadah sehari-hari.",
      "image": "assets/splash/splash1.png"
    },
    {
      "title": "Pantau Waktu Sholat",
      "description": "Dapatkan pengingat waktu sholat yang akurat.",
      "image": "assets/splash/splash2.png"
    },
    {
      "title": "Baca Al-Qur'an",
      "description": "Nikmati bacaan Al-Qur'an dan terjemahannya.",
      "image": "assets/splash/splash3.png"
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _currentPage = index;
                });
              },
              itemCount: _introData.length,
              itemBuilder: (context, index) => _buildIntroSlide(
                title: _introData[index]["title"]!,
                description: _introData[index]["description"]!,
                imagePath: _introData[index]["image"]!,
              ),
            ),
          ),
          _buildBottomNavigation()
        ],
      ),
    );
  }

  Widget _buildIntroSlide(
      {required String title,
      required String description,
      required String imagePath}) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(imagePath, height: 250),
          const SizedBox(height: 20),
          Text(
            title,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          Text(
            description,
            style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavigation() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TextButton(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
              );
            },
            child: const Text("Lewati", style: TextStyle(color: Colors.blue)),
          ),
          Row(
            children: List.generate(
              _introData.length,
              (index) => _buildDot(index == _currentPage),
            ),
          ),
          TextButton(
            onPressed: () {
              if (_currentPage == _introData.length - 1) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                );
              } else {
                _pageController.nextPage(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeIn,
                );
              }
            },
            child: Text(
              _currentPage == _introData.length - 1 ? "Mulai" : "Selanjutnya",
              style: const TextStyle(color: Colors.blue),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDot(bool isActive) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(horizontal: 4),
      height: 8,
      width: isActive ? 24 : 8,
      decoration: BoxDecoration(
        color: isActive ? Colors.blue : Colors.grey,
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}
