import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vibration/vibration.dart'; // Import vibration package

class TasbihScreen extends StatefulWidget {
  const TasbihScreen({super.key});

  @override
  _TasbihScreenState createState() => _TasbihScreenState();
}

class _TasbihScreenState extends State<TasbihScreen> {
  int counter = 0;
  String dropdownValue = 'Tasbih';

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

  void incrementCounter() {
    setState(() {
      counter++;
    });

    // Trigger vibration only if counter reaches 33 or 99
    if (counter == 33 || counter == 66 || counter == 99) {
      Vibration.vibrate(duration: 500); // Vibration for 500ms
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
              // Modernized and extended Dropdown
              Container(
                width: 300, // Increased width of the dropdown
                padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 8,
                      offset: Offset(0, 3), // Shadow position
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
              const SizedBox(height: 20),

              Text(
                'Hitungan: $counter',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF004C7E),
                ),
              ),
              const SizedBox(height: 10),

              // Image with rotation animation
              TweenAnimationBuilder(
                tween: Tween<double>(begin: 0, end: counter % 2 == 0 ? 360.0 : 0),
                duration: Duration(milliseconds: 500),
                builder: (context, double angle, child) {
                  return Transform.rotate(
                    angle: angle * 3.1415927 / 360,
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
              const SizedBox(height: 20),

              // Gradient Reset Button
              ElevatedButton(
                onPressed: resetCounter,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15), backgroundColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ), // Make the button background transparent
                  shadowColor: Colors.transparent, // Remove shadow
                ),
                child: Ink(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF004C7E), Color(0xFF2DDCBE)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
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
