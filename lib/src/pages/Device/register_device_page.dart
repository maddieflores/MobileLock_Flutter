import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:flutter/services.dart';
import '../../../services/api_service.dart';
import '../Profile/profile_page.dart';
import 'scanner_page.dart';

class RegisterDevicePage extends StatefulWidget {
  final Map<String, dynamic>? deviceToEdit;
  const RegisterDevicePage({super.key, this.deviceToEdit});

  @override
  State<RegisterDevicePage> createState() => _RegisterDevicePageState();
}

class _RegisterDevicePageState extends State<RegisterDevicePage> {
  final TextEditingController _brandController = TextEditingController();
  final TextEditingController _modelController = TextEditingController();
  final TextEditingController _imeiController = TextEditingController();
  final TextEditingController _hardwareIdController = TextEditingController();

  XFile? _imageFile;
  final ImagePicker _picker = ImagePicker();
  String? _imeiError;

  @override
  void initState() {
    super.initState();
    _imeiController.addListener(_validateImei);
    if (widget.deviceToEdit != null) {
      final String marcaModeloStr = widget.deviceToEdit!['marca_modelo'] ?? '';
      if (marcaModeloStr.contains(' ')) {
        final int firstSpaceIndex = marcaModeloStr.indexOf(' ');
        _brandController.text = marcaModeloStr.substring(0, firstSpaceIndex).trim();
        _modelController.text = marcaModeloStr.substring(firstSpaceIndex + 1).trim();
      } else {
        _brandController.text = marcaModeloStr;
        _modelController.text = '';
      }
      _imeiController.text = widget.deviceToEdit!['hash_imei'] ?? '';
      _hardwareIdController.text =
          widget.deviceToEdit!['hash_adn_hardware'] ?? '';
    }
  }

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      setState(() {
        _imageFile = image;
      });
    }
  }

  void _validateImei() {
    final text = _imeiController.text.trim();
    if (text.isEmpty) {
      setState(() {
        _imeiError = null;
      });
    } else if (text.length < 15) {
      setState(() {
        _imeiError = 'Faltan dígitos (${text.length}/15)';
      });
    } else {
      setState(() {
        _imeiError = null;
      });
    }
  }

  @override
  void dispose() {
    _brandController.dispose();
    _modelController.dispose();
    _imeiController.dispose();
    _hardwareIdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Stack(
        children: [
          Positioned.fill(child: CustomPaint(painter: GridPainter())),

          SafeArea(
            child: Align(
              alignment: Alignment.topCenter,
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 420),
                child: ListView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 20,
                  ),
                  children: [
                    Container(
                      padding: const EdgeInsets.all(25),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.03),
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.08),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.2),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              IconButton(
                                icon: const Icon(
                                  Icons.arrow_back,
                                  color: Colors.white,
                                ),
                                onPressed: () => Navigator.pop(context),
                              ),
                              Expanded(
                                child: Text(
                                  widget.deviceToEdit != null
                                      ? 'Editar dispositivo'
                                      : 'Registrar dispositivo',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    shadows: [
                                      Shadow(
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.primary,
                                        blurRadius: 15,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 15),
                          Text(
                            'Introduce los detalles técnicos de tu equipo para activar la protección de MobileLock AI.',
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.5),
                              fontSize: 13,
                            ),
                          ),
                          const SizedBox(height: 35),

                          _buildLabel('Marca'),
                          _buildTextField(
                            _brandController,
                            'Ej: Apple, Xiaomi, Samsung',
                            Icons.branding_watermark_rounded,
                          ),

                          const SizedBox(height: 20),

                          _buildLabel('Modelo'),
                          _buildTextField(
                            _modelController,
                            'Ej: iPhone 15 Pro, Redmi 12C',
                            Icons.phone_android_rounded,
                          ),

                          const SizedBox(height: 20),

                          _buildLabel('IMEI'),
                          _buildTextField(
                            _imeiController,
                            '15 dígitos',
                            Icons.fingerprint_rounded,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            maxLength: 15,
                            errorText: _imeiError,
                            onSuffixTap: () async {
                              final code = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const ScannerPage(),
                                ),
                              );
                              if (code != null && code is String) {
                                setState(() {
                                  _imeiController.text = code;
                                });
                              }
                            },
                          ),

                          const SizedBox(height: 20),

                          _buildLabel('Hardware ID'),
                          _buildTextField(
                            _hardwareIdController,
                            'ID único del sistema',
                            Icons.developer_board_rounded,
                          ),

                          const SizedBox(height: 20),

                          _buildLabel('Fotografía del equipo'),
                          GestureDetector(
                            onTap: _pickImage,
                            child: Container(
                              height: 120,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.surface,
                                borderRadius: BorderRadius.circular(15),
                                border: Border.all(
                                  color: Colors.white.withValues(alpha: 0.05),
                                ),
                              ),
                              child: _imageFile != null
                                  ? ClipRRect(
                                      borderRadius: BorderRadius.circular(15),
                                      child: Image.file(
                                        File(_imageFile!.path),
                                        fit: BoxFit.cover,
                                        width: double.infinity,
                                      ),
                                    )
                                  : Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.camera_alt_outlined,
                                          color: Colors.white.withValues(
                                            alpha: 0.3,
                                          ),
                                          size: 30,
                                        ),
                                        const SizedBox(height: 10),
                                        Text(
                                          'Toca para capturar imagen',
                                          style: TextStyle(
                                            color: Colors.white.withValues(
                                              alpha: 0.3,
                                            ),
                                            fontSize: 13,
                                          ),
                                        ),
                                      ],
                                    ),
                            ),
                          ),

                          const SizedBox(height: 40),

                          Row(
                            children: [
                              Expanded(
                                child: _buildSecondaryButton(
                                  'Cancelar',
                                  () => Navigator.pop(context),
                                ),
                              ),
                              const SizedBox(width: 15),
                              Expanded(
                                child: _buildPrimaryButton(
                                  widget.deviceToEdit != null
                                      ? 'Actualizar'
                                      : 'Registrar',
                                  () async {
                                    final marca = _brandController.text.trim();
                                    final modelo = _modelController.text.trim();
                                    final imei = _imeiController.text.trim();
                                    final hw = _hardwareIdController.text.trim();

                                    if (marca.isEmpty ||
                                        modelo.isEmpty ||
                                        imei.isEmpty ||
                                        hw.isEmpty) {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                            'Por favor, completa todos los campos',
                                          ),
                                          backgroundColor: Colors.redAccent,
                                        ),
                                      );
                                      return;
                                    }

                                    // Validar que el IMEI tenga exactamente 15 dígitos numéricos
                                    final imeiRegex = RegExp(r'^\d{15}$');
                                    if (!imeiRegex.hasMatch(imei)) {
                                      setState(() {
                                        _imeiError = imei.isEmpty
                                            ? 'El IMEI no puede estar vacío'
                                            : 'El IMEI debe tener exactamente 15 dígitos';
                                      });
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                            'El IMEI debe tener exactamente 15 dígitos numéricos',
                                          ),
                                          backgroundColor: Colors.redAccent,
                                        ),
                                      );
                                      return;
                                    }

                                    final isEdit = widget.deviceToEdit != null;

                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          isEdit
                                              ? 'Actualizando equipo...'
                                              : 'Registrando equipo...',
                                        ),
                                        duration: const Duration(seconds: 1),
                                      ),
                                    );

                                    final marcaModeloCompleto = "$marca $modelo";
                                    final apiService = ApiService();
                                    final response = isEdit
                                        ? await apiService.updateDevice(
                                            globalToken,
                                            widget
                                                .deviceToEdit!['id_dispositivo'],
                                            marcaModeloCompleto,
                                            imei,
                                            hw,
                                            imagePath: _imageFile?.path,
                                          )
                                        : await apiService.registerDevice(
                                            globalToken,
                                            marcaModeloCompleto,
                                            imei,
                                            hw,
                                            imagePath: _imageFile?.path,
                                          );

                                    if (mounted) {
                                      if (response != null &&
                                          (response.statusCode == 200 ||
                                              response.statusCode == 201)) {
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          SnackBar(
                                            content: Text(
                                              isEdit
                                                  ? '¡Equipo actualizado con éxito!'
                                                  : '¡Equipo registrado con éxito!',
                                            ),
                                            backgroundColor: Colors.green,
                                          ),
                                        );
                                        Navigator.pop(context);
                                      } else {
                                        String mensajeError = isEdit
                                            ? 'No se pudo actualizar el dispositivo'
                                            : 'No se pudo registrar el dispositivo';
                                        if (response?.data != null &&
                                            response?.data is Map) {
                                          mensajeError =
                                              response?.data['detail'] ??
                                              response?.data.toString();
                                        }

                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          SnackBar(
                                            content: Text(mensajeError),
                                            backgroundColor: Colors.redAccent,
                                          ),
                                        );
                                      }
                                    }
                                  },
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 5, bottom: 8),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white70,
          fontSize: 13,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String hint,
    IconData icon, {
    VoidCallback? onSuffixTap,
    TextInputType? keyboardType,
    List<TextInputFormatter>? inputFormatters,
    int? maxLength,
    String? errorText,
  }) {
    final bool hasError = errorText != null;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(
              color: hasError
                  ? Colors.redAccent
                  : Colors.white.withValues(alpha: 0.05),
              width: hasError ? 1.5 : 1.0,
            ),
          ),
          child: TextField(
            controller: controller,
            keyboardType: keyboardType,
            inputFormatters: inputFormatters,
            maxLength: maxLength,
            buildCounter: (
              BuildContext context, {
              required int currentLength,
              required bool isFocused,
              required int? maxLength,
            }) => null,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(
                color: Colors.white.withValues(alpha: 0.2),
                fontSize: 13,
              ),
              prefixIcon: Icon(
                icon,
                color: hasError ? Colors.redAccent : Theme.of(context).colorScheme.primary,
                size: 18,
              ),
              suffixIcon: onSuffixTap != null
                  ? IconButton(
                      icon: const Icon(
                        Icons.qr_code_scanner,
                        color: Color(0xFF00CEE6),
                        size: 20,
                      ),
                      onPressed: onSuffixTap,
                    )
                  : null,
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                vertical: 15,
                horizontal: 10,
              ),
            ),
          ),
        ),
        if (hasError)
          Padding(
            padding: const EdgeInsets.only(left: 10, top: 5),
            child: Text(
              errorText,
              style: const TextStyle(
                color: Colors.redAccent,
                fontSize: 11,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildPrimaryButton(String text, VoidCallback onTap) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF00CEE6).withValues(alpha: 0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF00CEE6),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          elevation: 0,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.check, size: 16),
            const SizedBox(width: 5),
            Text(
              text,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSecondaryButton(String text, VoidCallback onTap) {
    return SizedBox(
      height: 50,
      child: OutlinedButton(
        onPressed: onTap,
        style: OutlinedButton.styleFrom(
          backgroundColor: const Color(0xFF1A2123),
          side: BorderSide(color: Colors.white.withValues(alpha: 0.05)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          foregroundColor: Colors.white,
        ),
        child: Text(
          text,
          style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
        ),
      ),
    );
  }
}

class GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.03)
      ..strokeWidth = 1.0;
    for (double i = 0; i < size.width; i += 40) {
      canvas.drawLine(Offset(i, 0), Offset(i, size.height), paint);
    }
    for (double i = 0; i < size.height; i += 40) {
      canvas.drawLine(Offset(0, i), Offset(size.width, i), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
