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
        backgroundColor: Color(0xFF004C7E),
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
      appBar: AppBar(
        title: const Text('Tasbih Online'),
        backgroundColor: Color(0xFF2DDCBE),
      ),
      body: Center(
        // Membuat konten tetap di tengah
        child: SingleChildScrollView(
          // Menghindari overflow jika layar kecil
          child: Column(
            mainAxisAlignment:
                MainAxisAlignment.center, // Konten di tengah secara vertikal
            crossAxisAlignment:
                CrossAxisAlignment.center, // Konten di tengah secara horizontal
            mainAxisSize: MainAxisSize.min, // Ukuran column mengikuti konten
            children: [
              // Hitungan
              Text(
                'Hitungan: $counter',
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF004C7E),
                ),
              ),
              const SizedBox(height: 20),

              // Dropdown untuk memilih dzikir
              DropdownButton<String>(
                value: dropdownValue,
                icon: const Icon(Icons.arrow_drop_down),
                elevation: 16,
                style: const TextStyle(color: Color(0xFF004C7E), fontSize: 18),
                underline: Container(
                  height: 2,
                  color: Colors.greenAccent,
                ),
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
              const SizedBox(height: 40),

              // Gambar Tasbih untuk menghitung
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

              // Teks Dzikir berdasarkan pilihan dropdown
              if (displayedText.isNotEmpty) ...[
                Text(
                  displayedText,
                  style: const TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
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

              // Tombol Reset
              ElevatedButton(
                onPressed: resetCounter,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF004C7E),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
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
