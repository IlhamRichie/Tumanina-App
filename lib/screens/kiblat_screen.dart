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

class _KiblatScreenState extends State<KiblatScreen> {
  double? _latitude;
  double? _longitude;
  double? _compassDirection;
  double? _kiblatDirection;
  late StreamSubscription<CompassEvent> _compassStreamSubscription;

  @override
  void initState() {
    super.initState();
    _getUserLocation();
    _compassStreamSubscription = FlutterCompass.events!.listen((event) {
      if (mounted) {
        setState(() {
          // Mengonversi heading kompas dari -180 hingga 180 ke 0 hingga 360
          _compassDirection = (event.heading! + 360) % 360;
        });
      }
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
            (angle * 180 / pi + 360) % 360; // Mengubah sudut menjadi 0-360
      });
    }
  }

  @override
  void dispose() {
    _compassStreamSubscription.cancel();
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
