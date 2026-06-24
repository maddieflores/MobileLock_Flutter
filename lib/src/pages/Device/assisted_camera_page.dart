import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class AssistedCameraPage extends StatefulWidget {
  final Function(String imagePath) onPictureTaken;

  const AssistedCameraPage({Key? key, required this.onPictureTaken}) : super(key: key);

  @override
  _AssistedCameraPageState createState() => _AssistedCameraPageState();
}

class _AssistedCameraPageState extends State<AssistedCameraPage> {
  CameraController? _controller;
  List<CameraDescription>? _cameras;
  bool _isReady = false;
  bool _isProcessingImage = false;
  bool _hasGoodLighting = true;
  Timer? _lightCheckTimer;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    _cameras = await availableCameras();
    if (_cameras != null && _cameras!.isNotEmpty) {
      final backCamera = _cameras!.firstWhere(
        (camera) => camera.lensDirection == CameraLensDirection.back,
        orElse: () => _cameras!.first,
      );

      _controller = CameraController(
        backCamera,
        ResolutionPreset.high,
        enableAudio: false,
        imageFormatGroup: ImageFormatGroup.yuv420,
      );

      await _controller!.initialize();
      if (!mounted) return;

      setState(() {
        _isReady = true;
      });

      // Start image stream to calculate brightness
      _controller!.startImageStream((CameraImage image) {
        if (_isProcessingImage) return;
        _isProcessingImage = true;

        // Calculate average brightness using the Y plane (luminance)
        int totalBrightness = 0;
        final plane = image.planes[0];
        final bytes = plane.bytes;
        
        // Sample pixels to save CPU
        int sampleCount = 0;
        for (int i = 0; i < bytes.length; i += 100) {
          totalBrightness += bytes[i];
          sampleCount++;
        }

        if (sampleCount > 0) {
          final avgBrightness = totalBrightness / sampleCount;
          final isWellLit = avgBrightness > 40; // Umbral empírico de iluminación

          if (_hasGoodLighting != isWellLit) {
            setState(() {
              _hasGoodLighting = isWellLit;
            });
          }
        }

        Future.delayed(const Duration(milliseconds: 500), () {
          if (mounted) _isProcessingImage = false;
        });
      });
    }
  }

  @override
  void dispose() {
    _controller?.stopImageStream();
    _controller?.dispose();
    _lightCheckTimer?.cancel();
    super.dispose();
  }

  Future<void> _takePicture() async {
    if (!_hasGoodLighting || _controller == null || !_controller!.value.isInitialized) return;

    try {
      final XFile file = await _controller!.takePicture();
      widget.onPictureTaken(file.path);
      Navigator.of(context).pop();
    } catch (e) {
      debugPrint("Error tomando foto: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_isReady || _controller == null) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(child: CircularProgressIndicator(color: Colors.cyan)),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Camera Preview
          CameraPreview(_controller!),

          // Silhouette Guide Overlay
          CustomPaint(
            painter: SilhouettePainter(),
            child: Container(),
          ),

          // Illumination Warning
          if (!_hasGoodLighting)
            Positioned(
              top: 100,
              left: 20,
              right: 20,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.redAccent.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.red, width: 2),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.wb_incandescent_outlined, color: Colors.white),
                    SizedBox(width: 8),
                    Text(
                      "Mala iluminación. Busca más luz.",
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),

          // App Bar overlay
          Positioned(
            top: 40,
            left: 10,
            child: IconButton(
              icon: const Icon(Icons.close, color: Colors.white, size: 32),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
          const Positioned(
            top: 50,
            left: 0,
            right: 0,
            child: Center(
              child: Text(
                "Encuadra la parte trasera",
                style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold, shadows: [
                  Shadow(color: Colors.black, blurRadius: 4)
                ]),
              ),
            ),
          ),

          // Capture Button
          Positioned(
            bottom: 40,
            left: 0,
            right: 0,
            child: Center(
              child: GestureDetector(
                onTap: _takePicture,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _hasGoodLighting ? Colors.cyan : Colors.grey.withOpacity(0.5),
                    border: Border.all(color: Colors.white, width: 4),
                    boxShadow: [
                      if (_hasGoodLighting)
                        BoxShadow(color: Colors.cyan.withOpacity(0.5), blurRadius: 20, spreadRadius: 5)
                    ],
                  ),
                  child: Center(
                    child: Icon(
                      _hasGoodLighting ? Icons.camera_alt : Icons.block,
                      color: Colors.white,
                      size: 36,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SilhouettePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black.withOpacity(0.5)
      ..style = PaintingStyle.fill;

    // Draw full semi-transparent overlay
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), paint);

    // Calculate phone silhouette rect
    final width = size.width * 0.7;
    final height = size.height * 0.6;
    final left = (size.width - width) / 2;
    final top = (size.height - height) / 2;

    final phoneRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(left, top, width, height),
      const Radius.circular(30),
    );

    // Cut out the silhouette
    canvas.drawRRect(phoneRect, Paint()..blendMode = BlendMode.clear);

    // Draw the glowing border
    final borderPaint = Paint()
      ..color = Colors.cyan.withOpacity(0.8)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;
    canvas.drawRRect(phoneRect, borderPaint);

    // Draw camera module hint
    final cameraModuleRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(left + 20, top + 20, 60, 60),
      const Radius.circular(15),
    );
    canvas.drawRRect(cameraModuleRect, Paint()..color = Colors.cyan.withOpacity(0.3)..style = PaintingStyle.fill);
    canvas.drawRRect(cameraModuleRect, Paint()..color = Colors.cyan..style = PaintingStyle.stroke..strokeWidth = 2);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
