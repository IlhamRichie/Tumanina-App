import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false, // Menghilangkan banner debug
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tasbih Mualaf'),
        backgroundColor: Colors.green.shade700,
      ),
      body: Center(
        child: IconButton(
          icon: const Icon(Icons.arrow_forward, size: 40, color: Colors.white),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const TasbihScreen()),
            );
          },
        ),
      ),
    );
  }
}

class TasbihScreen extends StatefulWidget {
  const TasbihScreen({super.key});

  @override
  _TasbihScreenState createState() => _TasbihScreenState();
}

class _TasbihScreenState extends State<TasbihScreen>
    with SingleTickerProviderStateMixin {
  int counter = 0;
  late AnimationController _controller;
  late Animation<double> _rotationAnimation;

  String displayedText = "";
  String displayedLatin = "";

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _rotationAnimation = Tween<double>(begin: 0, end: 2 * pi)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void incrementCounter() {
    setState(() {
      counter++;
    });
    _controller.forward(from: 0);
  }

  void resetCounter() {
    setState(() {
      if (counter > 0) counter = 0;
      displayedText = "";
      displayedLatin = "";
    });
  }

  void showText(String type) {
    setState(() {
      if (type == "tasbih") {
        displayedText = "سُبْحَانَ اللَّهِ";
        displayedLatin = "Subhanallah (Maha Suci Allah)";
      } else if (type == "tahmid") {
        displayedText = "الْحَمْدُ لِلَّهِ";
        displayedLatin = "Alhamdulillah (Segala Puji bagi Allah)";
      } else if (type == "takbir") {
        displayedText = "اللَّهُ أَكْبَرُ";
        displayedLatin = "Allahu Akbar (Allah Maha Besar)";
      }
    });
  }

  Widget _buildButton(String label, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.green.shade600,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      ),
      child: Text(
        label,
        style: const TextStyle(fontSize: 18, color: Colors.white),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tasbih Online'),
        backgroundColor: Colors.green.shade700,
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Hitungan: $counter',
              style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
            const SizedBox(height: 20),
            AnimatedBuilder(
              animation: _rotationAnimation,
              builder: (context, child) {
                return Transform.rotate(
                  angle: (_rotationAnimation.value / (33)) * 2 * pi,
                  child: child,
                );
              },
              child: Image.asset(
                'assets/tasbih/tasbih_bead.png',
                width: 120,
                height: 120,
                errorBuilder: (context, error, stackTrace) => const Icon(
                  Icons.error_outline,
                  size: 120,
                  color: Colors.red,
                ),
              ),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: incrementCounter,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green.shade800,
                shape: const CircleBorder(),
                padding: const EdgeInsets.all(20),
              ),
              child: const Icon(Icons.add, size: 40, color: Colors.white),
            ),
            const SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildButton('Tasbih', () => showText("tasbih")),
                _buildButton('Tahmid', () => showText("tahmid")),
                _buildButton('Takbir', () => showText("takbir")),
              ],
            ),
            const SizedBox(height: 40),
            if (displayedText.isNotEmpty) ...[
              Text(
                displayedText,
                style: const TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                displayedLatin,
                style: const TextStyle(
                  fontSize: 18,
                  fontStyle: FontStyle.italic,
                  color: Colors.grey,
                ),
              ),
            ],
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: resetCounter,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
              ),
              child: const Text(
                'Reset',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
