import 'dart:async'; 
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'dart:math';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: KiblatScreen(),
    );
  }
}

class KiblatScreen extends StatefulWidget {
  const KiblatScreen({super.key});

  @override
  _KiblatScreenState createState() => _KiblatScreenState();
}

class _KiblatScreenState extends State<KiblatScreen>
    with SingleTickerProviderStateMixin {
  double? _latitude;
  double? _longitude;
  double? _compassDirection;
  double? _kiblatDirection;
  late StreamSubscription<CompassEvent> _compassStreamSubscription;
  OverlayEntry? _infoOverlay;
  bool _isPopupVisible = false;

  @override
  void initState() {
    super.initState();
    _getUserLocation();
    _compassStreamSubscription = FlutterCompass.events!.listen((event) {
      if (mounted) {
        setState(() {
          _compassDirection = (event.heading! + 360) % 360;
        });
      }
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showInfoPopup(context);
    });
  }

  Future<void> _getUserLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.medium);
    if (mounted) {
      setState(() {
        _latitude = position.latitude;
        _longitude = position.longitude;
      });
      _calculateKiblatDirection();
    }
  }

  void _calculateKiblatDirection() {
    if (_latitude != null && _longitude != null) {
      const double kaabaLatitude = 21.4225;
      const double kaabaLongitude = 39.8262;

      double deltaLongitude = kaabaLongitude - _longitude!;
      double y = sin(deltaLongitude * pi / 180) * cos(kaabaLatitude * pi / 180);
      double x = cos(_latitude! * pi / 180) * sin(kaabaLatitude * pi / 180) -
          sin(_latitude! * pi / 180) *
              cos(kaabaLatitude * pi / 180) *
              cos(deltaLongitude * pi / 180);
      double angle = atan2(y, x);

      setState(() {
        _kiblatDirection =
            (angle * 180 / pi + 360) % 360;
      });
    }
  }

  void _showInfoPopup(BuildContext context) {
    if (_isPopupVisible) return;

    _isPopupVisible = true;

    _infoOverlay = OverlayEntry(
      builder: (context) => GestureDetector(
        onTap: () {
          _dismissInfoPopup();
        },
        child: Stack(
          children: [
            Positioned.fill(
              child: Container(
                color: Colors.black.withOpacity(0.5),
              ),
            ),
            AnimatedPositioned(
              duration: const Duration(milliseconds: 100),
              curve: Curves.easeOut,
              top: _isPopupVisible ? MediaQuery.of(context).size.height * 0.15 : -200,
              left: MediaQuery.of(context).size.width * 0.1,
              child: AnimatedOpacity(
                opacity: _isPopupVisible ? 1 : 0,
                duration: const Duration(milliseconds: 500),
                child: Material(
                  color: Colors.transparent,
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.8,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: const [
                        SizedBox(height: 8),
                        Text(
                          'Cocokkan arah derajat kompas dengan arah derajat kiblat.\nJika sudah sesuai, arah kiblat telah ditemukan.',
                          style: TextStyle(fontSize: 14),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );

    Overlay.of(context).insert(_infoOverlay!);

    Future.delayed(const Duration(seconds: 2), _dismissInfoPopup);
  }

  void _dismissInfoPopup() {
    if (!_isPopupVisible) return;

    setState(() {
      _isPopupVisible = false;
    });

    Future.delayed(const Duration(milliseconds: 500), () {
      _infoOverlay?.remove();
      _infoOverlay = null;
    });
  }

  @override
  void dispose() {
    _compassStreamSubscription.cancel();
    _infoOverlay?.remove();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Arah Kiblat',
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
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            color: const Color(0xFF004C7E),
            onPressed: () {
              _showInfoPopup(context);
            },
          ),
        ],
      ),
      body: _latitude == null || _longitude == null
          ? const Center(child: CircularProgressIndicator())
          : _buildCompassScreen(),
    );
  }

  Widget _buildCompassScreen() {
    bool isAligned = false;
    if (_compassDirection != null && _kiblatDirection != null) {
      double diff = (_compassDirection! - _kiblatDirection!).abs();
      if (diff < 5) {
        isAligned = true;
      }
    }

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Center(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Transform.rotate(
                    angle: (_kiblatDirection! - (_compassDirection ?? 0)) *
                        pi /
                        180,
                    child: Image.asset(
                      'assets/kiblat/k.png',
                      width: 500,
                      height: 500,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          if (_compassDirection != null && _kiblatDirection != null)
            Column(
              children: [
                Text(
                  'Arah Kompas: ${_compassDirection!.toStringAsFixed(0)}°',
                  style: TextStyle(
                    fontSize: 18,
                    color: isAligned ? Colors.green : Colors.black,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Arah Kiblat: ${_kiblatDirection!.toStringAsFixed(0)}°',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: isAligned ? Colors.green : Colors.black,
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
