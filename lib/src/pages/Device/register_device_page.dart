import 'package:flutter/material.dart';

class RegisterDevicePage extends StatefulWidget {
  const RegisterDevicePage({super.key});

  @override
  State<RegisterDevicePage> createState() => _RegisterDevicePageState();
}

class _RegisterDevicePageState extends State<RegisterDevicePage> {
  final TextEditingController _modelController = TextEditingController();
  final TextEditingController _imeiController = TextEditingController();
  final TextEditingController _hardwareIdController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF060B0C),
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
                    // --- RECUADRO PRINCIPAL (GLASS CONTAINER) ---
                    Container(
                      padding: const EdgeInsets.all(25),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.03), // Fondo cristal
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.08),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // CABECERA DENTRO DEL RECUADRO
                          Row(
                            children: [
                              IconButton(
                                icon: const Icon(
                                  Icons.arrow_back,
                                  color: Colors.white,
                                ),
                                onPressed: () => Navigator.pop(context),
                              ),
                              const Expanded(
                                child: Text(
                                  'Registrar dispositivo',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    shadows: [
                                      Shadow(
                                        color: Color(0xFF00FFA3),
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
                              color: Colors.white.withOpacity(0.5),
                              fontSize: 13,
                            ),
                          ),
                          const SizedBox(height: 35),

                          // FORMULARIO
                          _buildLabel('Marca y modelo'),
                          _buildTextField(
                            _modelController,
                            'Ej: iPhone 15 Pro',
                            Icons.phone_android_rounded,
                          ),

                          const SizedBox(height: 20),

                          _buildLabel('IMEI'),
                          _buildTextField(
                            _imeiController,
                            '15 dígitos',
                            Icons.fingerprint_rounded,
                          ),

                          const SizedBox(height: 20),

                          _buildLabel('Hardware ID'),
                          _buildTextField(
                            _hardwareIdController,
                            'ID único del sistema',
                            Icons.developer_board_rounded,
                          ),

                          const SizedBox(height: 40),

                          // BOTONES
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
                                child: _buildPrimaryButton('Registrar', () {
                                  Navigator.pop(context);
                                }),
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

  // --- WIDGETS DE ESTILO ---

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
    IconData icon,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF0E1415),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: TextField(
        controller: controller,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(
            color: Colors.white.withOpacity(0.2),
            fontSize: 13,
          ),
          prefixIcon: Icon(icon, color: const Color(0xFF00FFA3), size: 18),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            vertical: 15,
            horizontal: 10,
          ),
        ),
      ),
    );
  }

  Widget _buildPrimaryButton(String text, VoidCallback onTap) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF00CEE6).withOpacity(0.3),
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
          side: BorderSide(color: Colors.white.withOpacity(0.05)),
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
      ..color = Colors.white.withOpacity(0.03)
      ..strokeWidth = 1.0;
    for (double i = 0; i < size.width; i += 40)
      canvas.drawLine(Offset(i, 0), Offset(i, size.height), paint);
    for (double i = 0; i < size.height; i += 40)
      canvas.drawLine(Offset(0, i), Offset(size.width, i), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
