import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'dart:math';

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
          _compassDirection = event.heading;
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
      const double kaabaLatitude = 21.4225; // Latitude Kaaba
      const double kaabaLongitude = 39.8262; // Longitude Kaaba

      double deltaLongitude = kaabaLongitude - _longitude!;
      double y = sin(deltaLongitude) * cos(kaabaLatitude);
      double x = cos(_latitude!) * sin(kaabaLatitude) -
          sin(_latitude!) * cos(kaabaLatitude) * cos(deltaLongitude);
      double angle = atan2(y, x);

      setState(() {
        _kiblatDirection = (angle * 180 / pi).toDouble();
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
      appBar: AppBar(
        title: const Text('Arah Kiblat'),
        backgroundColor: Colors.green,
      ),
      body: _latitude == null || _longitude == null
          ? const Center(child: CircularProgressIndicator())
          : _buildCompassScreen(),
    );
  }

  Widget _buildCompassScreen() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (_compassDirection != null && _kiblatDirection != null)
            Stack(
              alignment: Alignment.center,
              children: [
                // Gambar Kiblat yang bisa diputar
                Transform.rotate(
                  angle: (_kiblatDirection! - _compassDirection!) * pi / 180,
                  child: Image.asset(
                    'assets/kiblat/compass.png', // Pastikan gambar kiblat ada di folder assets
                    width: 100,
                    height: 100,
                  ),
                ),
                // Teks untuk menunjukkan arah kompas dan Kiblat
                Column(
                  children: [
                    Text(
                      'Arah Kompas: ${_compassDirection!.toStringAsFixed(0)}°',
                      style: const TextStyle(fontSize: 18),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Arah Kiblat: ${_kiblatDirection!.toStringAsFixed(0)}°',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
        ],
      ),
    );
  }
}
