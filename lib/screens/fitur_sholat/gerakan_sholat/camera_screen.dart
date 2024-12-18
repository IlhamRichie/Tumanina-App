import 'dart:io';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'dart:async';
import '../../../services/api_service.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  CameraController? _controller;
  late List<CameraDescription> cameras;
  bool isDetecting = false;
  final ApiService apiService = ApiService();

  @override
  void initState() {
    super.initState();
    initializeCamera();
  }

  Future<void> initializeCamera() async {
    cameras = await availableCameras();
    _controller = CameraController(cameras[0], ResolutionPreset.medium);
    await _controller?.initialize();
    startFrameCapture();
  }

  void startFrameCapture() {
    Timer.periodic(const Duration(milliseconds: 200), (timer) async {
      if (!mounted) return;
      if (isDetecting) return;

      isDetecting = true;

      try {
        // Ambil gambar dari kamera tanpa menentukan filePath
        final XFile file = await _controller!.takePicture();

        // Ubah XFile ke File untuk dikirim ke API Flask
        File imageFile = File(file.path);

        // Kirim gambar ke API Flask
        final result = await apiService.sendFrame(imageFile);

        // Tampilkan hasil deteksi (contoh: print di console)
        print(result);

      } catch (e) {
        print("Error capturing frame: $e");
      } finally {
        isDetecting = false;
      }

    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_controller!.value.isInitialized) {
      return const Center(child: CircularProgressIndicator());
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text("Deteksi Gerakan"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: CameraPreview(_controller!),
    );
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }
}
