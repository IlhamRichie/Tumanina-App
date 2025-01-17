import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vibration/vibration.dart';

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
    },
    'Hasbiyallahu': {
      'arab': "حَسْبِيَ اللَّهُ",
      'latin': "Hasbiyallahu (Cukuplah Allah bagiku)",
    },
    'Istighfar': {
      'arab': "أَسْتَغْفِرُ اللَّهَ",
      'latin': "Astaghfirullah (Aku memohon ampun kepada Allah)",
    },
  };

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
      upperBound: 1.0,
    );
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

    if (counter % 33 == 0 || counter % 99 == 0) {
      Vibration.vibrate(duration: 500);
    }
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
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Tasbih Digital',
          style: GoogleFonts.poppins(
            color: const Color(0xFF004C7E),
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Dropdown Consistent Style
              Container(
                width: 300, // Lebar dropdown
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF2DDCBE), Color(0xFF004C7E)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(30), // Sudut melengkung
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 8,
                      offset: const Offset(0, 4), // Efek bayangan
                    ),
                  ],
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: dropdownValue,
                    isExpanded: true, // Isi dropdown mengikuti lebar container
                    icon:
                        const Icon(Icons.arrow_drop_down, color: Colors.white),
                    dropdownColor:
                        const Color(0xFF004C7E), // Warna latar dropdown
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
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
                ),
              ),
              const SizedBox(height: 20),

              // Counter Display
              Text(
                'Hitungan: $counter',
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF004C7E),
                ),
              ),
              const SizedBox(height: 10),

              // Rotating Image
              AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  return Transform.rotate(
                    angle: _controller.value * 6.28319,
                    child: GestureDetector(
                      onTap: incrementCounter,
                      child: Image.asset(
                        'assets/tasbih/tasbih3.png',
                        width: 270,
                        height: 270,
                        errorBuilder: (context, error, stackTrace) =>
                            const Icon(
                          Icons.error_outline,
                          size: 120,
                          color: Colors.red,
                        ),
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 20),

              // Dzikir Display
              if (displayedText.isNotEmpty) ...[
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20), // Konsisten padding kiri-kanan
                  child: Column(
                    children: [
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
                        textAlign:
                            TextAlign.center, // Atur teks agar rata tengah
                      ),
                    ],
                  ),
                ),
              ],
              const SizedBox(height: 20),

              // Reset Button
              ElevatedButton(
                onPressed: resetCounter,
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                  backgroundColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: Ink(
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF004C7E), Color(0xFF2DDCBE)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 50, vertical: 15),
                    child: const Text(
                      'Reset',
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
