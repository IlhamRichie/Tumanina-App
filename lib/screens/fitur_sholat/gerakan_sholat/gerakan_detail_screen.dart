import 'package:flutter/material.dart';
import 'components/instruction_popup.dart';
import 'sholat_screen.dart';

class GerakanDetailScreen extends StatefulWidget {
  final String title;
  final String description;
  final String bacaan;
  final String videoPath;
  final Widget? nextScreen;
  final Widget? previousScreen;

  const GerakanDetailScreen({
    Key? key,
    required this.title,
    required this.description,
    required this.bacaan,
    required this.videoPath,
    this.nextScreen,
    this.previousScreen,
  }) : super(key: key);

  @override
  _GerakanDetailScreenState createState() => _GerakanDetailScreenState();
}

class _GerakanDetailScreenState extends State<GerakanDetailScreen>
    with TickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _scaleAnimation = Tween<double>(begin: 0.95, end: 1.05).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title,
          style: const TextStyle(color: Color(0xFF004C7E)),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF004C7E)),
          onPressed: () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const SholatScreen()),
              (route) => false,
            );
          },
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white, Color(0xFFFFFFFF)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle("Cara Melakukan Gerakan ${widget.title}"),
            const SizedBox(height: 10),
            _buildSectionContent(widget.description),
            const SizedBox(height: 20),
            _buildSectionTitle("Bacaan ${widget.title}"),
            const SizedBox(height: 10),
            _buildSectionContent(widget.bacaan),
            const Spacer(),
            _buildBottomButtons(context),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Color(0xFF004C7E),
      ),
    );
  }

  Widget _buildSectionContent(String content) {
    return Text(
      content,
      style: const TextStyle(
        fontSize: 16,
        color: Colors.black87,
      ),
    );
  }

  Widget _buildBottomButtons(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ElevatedButton(
          onPressed: () {
            // Logika untuk menampilkan video tutorial
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF2DDCBE),
            minimumSize: const Size.fromHeight(60),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 2,
          ),
          child: const Text(
            "Lihat Video Tutorial",
            style: TextStyle(fontSize: 18, color: Colors.white),
          ),
        ),
        const SizedBox(height: 20),
        AnimatedBuilder(
          animation: _scaleAnimation,
          builder: (context, child) {
            return Transform.scale(
              scale: _scaleAnimation.value,
              child: ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => const InstructionPopup(),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2DDCBE),
                  minimumSize: const Size.fromHeight(60),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 2,
                ),
                child: const Text(
                  "Praktek Gerakan",
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            );
          },
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: widget.previousScreen != null
                    ? () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => widget.previousScreen!),
                        );
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2DDCBE),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 2,
                ),
                child: const Text(
                  "Sebelumnya",
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: ElevatedButton(
                onPressed: widget.nextScreen != null
                    ? () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => widget.nextScreen!),
                        );
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2DDCBE),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 2,
                ),
                child: const Text(
                  "Selanjutnya",
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
