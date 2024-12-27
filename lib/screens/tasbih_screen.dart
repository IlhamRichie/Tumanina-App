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
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF9F9F9), // Light modern background
      appBar: AppBar(
        title: const Text(
          'Tasbih Mualaf',
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w600,
            fontSize: 22,
          ),
        ),
        backgroundColor: Color(0xFF004C7E),
        centerTitle: true,
        elevation: 0,
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

class _TasbihScreenState extends State<TasbihScreen> with SingleTickerProviderStateMixin {
  int counter = 0;
  String dropdownValue = 'Tasbih';

  late AnimationController _controller;
  late Animation<double> _rotationAnimation;

  String displayedText = "";
  String displayedLatin = "";

  final Map<String, Map<String, String>> dzikirText = {
    'Tasbih': {
      'arab': "سُبْحَانَ اللَّهِ",
      'latin': "Subhanallah (Maha Suci Allah)",
    },
    'Tahmid': {
      'arab': "الْحَمْدُ لِلَّهِ",
      'latin': "Alhamdulillah (Segala Puji bagi Allah)",
    },
    'Takbir': {
      'arab': "اللَّهُ أَكْبَرُ",
      'latin': "Allahu Akbar (Allah Maha Besar)",
    },
    'Tauhid': {
      'arab': "لَا إِلٰهَ إِلَّا اللَّهُ",
      'latin': "Laa ilaaha illallah (Tiada Tuhan selain Allah)",
    }
  };

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _rotationAnimation = Tween<double>(begin: 0, end: 2 * pi)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    updateDzikirText();
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
      counter = 0;
    });
  }

  void updateDzikirText() {
    setState(() {
      displayedText = dzikirText[dropdownValue]!['arab']!;
      displayedLatin = dzikirText[dropdownValue]!['latin']!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF9F9F9),
      appBar: AppBar(
        title: const Text(
          'Tasbih Online',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w600,
            fontSize: 22,
          ),
        ),
        backgroundColor: Color(0xFF2DDCBE),
        centerTitle: true,
        elevation: 0,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Hitungan: $counter',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF004C7E),
                ),
              ),
              const SizedBox(height: 20),

              // Modernized Dropdown
              Container(
                width: 250,
                padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 1,
                      blurRadius: 5,
                    ),
                  ],
                ),
                child: DropdownButton<String>(
                  value: dropdownValue,
                  isExpanded: true,
                  icon: const Icon(Icons.arrow_drop_down, color: Color(0xFF004C7E)),
                  style: TextStyle(color: Color(0xFF004C7E), fontSize: 18),
                  underline: const SizedBox(),
                  onChanged: (String? newValue) {
                    setState(() {
                      dropdownValue = newValue!;
                      updateDzikirText();
                    });
                  },
                  items: dzikirText.keys
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 40),

              // Animated Tasbih Image with GestureDetector
              GestureDetector(
                onTap: incrementCounter,
                child: AnimatedBuilder(
                  animation: _rotationAnimation,
                  builder: (context, child) {
                    return Transform.rotate(
                      angle: _rotationAnimation.value,
                      child: child,
                    );
                  },
                  child: Image.asset(
                    'assets/tasbih/tasbih3.png',
                    width: 270,
                    height: 270,
                    errorBuilder: (context, error, stackTrace) => const Icon(
                      Icons.error_outline,
                      size: 120,
                      color: Colors.red,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Dzikir Text Display
              if (displayedText.isNotEmpty) ...[
                Text(
                  displayedText,
                  style: const TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF004C7E),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  displayedLatin,
                  style: const TextStyle(
                    fontSize: 18,
                    fontStyle: FontStyle.italic,
                    color: Color(0xFF2DDCBE),
                  ),
                ),
              ],
              const SizedBox(height: 40),

              // Reset Button with Modern Styling
              ElevatedButton(
                onPressed: resetCounter,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF004C7E),
                  padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text(
                  'Reset',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
