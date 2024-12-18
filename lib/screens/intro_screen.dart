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
      "title": "Selamat Datang di Tumanina",
      "description": "Tumanina membantu Anda dalam ibadah sehari-hari.",
      "image": "assets/splash/1 (7).png"
    },
    {
      "title": "Pantau Waktu Sholat",
      "description": "Dapatkan pengingat waktu sholat yang akurat.",
      "image": "assets/splash/2 (6).png"
    },
    {
      "title": "Baca Al-Qur'an",
      "description": "Nikmati bacaan Al-Qur'an dan terjemahannya.",
      "image": "assets/splash/3 (7).png"
    },
    {
      "title": "Belajar dengan Tumanina",
      "description": "Mulai belajar sholat dengan tumaninah yang dilengkapi AI.",
      "image": "assets/splash/Logo1 1.png"
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

  Widget _buildIntroSlide({
    required String title,
    required String description,
    required String imagePath,
  }) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(imagePath, height: 250),
          const SizedBox(height: 20),
          Text(
            title,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF00263F),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          Text(
            description,
            style: const TextStyle(
              fontSize: 16,
              color: Color(0xFF046AA1),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavigation() {
    return Padding(
      padding: const EdgeInsets.all(64.0),
      child: _currentPage == _introData.length - 1
          ? Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LoginScreen(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2DDCBE),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(32),
                  ),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 64.0, vertical: 12.0),
                ),
                child: const Text(
                  "Mulai",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
              ),
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LoginScreen()),
                    );
                  },
                  child: const Text(
                    "Lewati",
                    style: TextStyle(color: Color(0xFF2DDCBE)),
                  ),
                ),
                Row(
                  children: List.generate(
                    _introData.length,
                    (index) => _buildDot(index == _currentPage),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    _pageController.nextPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeIn,
                    );
                  },
                  child: const Text(
                    "Selanjutnya",
                    style: TextStyle(color: Color(0xFF2DDCBE)),
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildDot(bool isActive) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(horizontal: 3),
      height: 8,
      width: isActive ? 12 : 8,
      decoration: BoxDecoration(
        color: isActive ? const Color(0xFF2DDCBE) : Colors.grey,
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}
