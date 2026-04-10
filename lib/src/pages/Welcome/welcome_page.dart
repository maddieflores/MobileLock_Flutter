import 'package:flutter/material.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    // 1. Configuramos el controlador de la animación (duración de 2 segundos)
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true); // Esto hace que suba y baje infinitamente

    // 2. Definimos el movimiento (de 0 a 15 píxeles)
    _animation = Tween<double>(
      begin: 0,
      end: 15,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose(); // Importante cerrar el controlador al salir
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF060B0C),
      body: Stack(
        children: [
          Positioned.fill(child: CustomPaint(painter: GridPainter())),
          SafeArea(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 450),
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: Column(
                      children: [
                        const SizedBox(height: 30),

                        // Logo Superior
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 15,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.05),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.white10),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.shield,
                                color: Color(0xFF00FFA3),
                                size: 28,
                              ),
                              const SizedBox(width: 10),
                              const Text(
                                'MobileLock AI',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 50),

                        // --- AQUÍ ESTÁ LA ANIMACIÓN ---
                        AnimatedBuilder(
                          animation: _animation,
                          builder: (context, child) {
                            return Transform.translate(
                              offset: Offset(
                                0,
                                -_animation.value,
                              ), // Mueve la imagen hacia arriba
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  Container(
                                    width: 220,
                                    height: 220,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                          color: const Color(
                                            0xFF00FFA3,
                                          ).withOpacity(0.15),
                                          blurRadius: 100,
                                          spreadRadius: 20,
                                        ),
                                      ],
                                    ),
                                  ),
                                  Image.asset(
                                    'assets/images/phone-mobilelockai.png',
                                    height: 280,
                                    fit: BoxFit.contain,
                                    errorBuilder:
                                        (context, error, stackTrace) =>
                                            const Icon(
                                              Icons.phonelink_lock_rounded,
                                              size: 120,
                                              color: Colors.cyanAccent,
                                            ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),

                        // ------------------------------
                        const SizedBox(height: 40),

                        RichText(
                          textAlign: TextAlign.center,
                          text: const TextSpan(
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              height: 1.2,
                            ),
                            children: [
                              TextSpan(
                                text: 'Haz que los teléfonos\nrobados sean ',
                              ),
                              TextSpan(
                                text: 'inservibles',
                                style: TextStyle(color: Color(0xFF00FFA3)),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 20),

                        const Text(
                          'Protege tu smartphone con identificación de hardware mediante IA y verificación de propiedad con blockchain',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white60,
                            fontSize: 14,
                            height: 1.5,
                          ),
                        ),

                        const SizedBox(height: 40),

                        _buildFeatureCard(
                          Icons.fingerprint_rounded,
                          'IA de identificación',
                          'Huella digital única de hardware',
                        ),
                        _buildFeatureCard(
                          Icons.link_rounded,
                          'Blockchain',
                          'Propiedad verificada en cadena',
                        ),
                        _buildFeatureCard(
                          Icons.security_rounded,
                          'Protección total',
                          'Teléfonos robados inservibles',
                        ),

                        const SizedBox(height: 40),

                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color(
                                        0xFF00FFA3,
                                      ).withOpacity(0.3),
                                      blurRadius: 15,
                                      offset: const Offset(0, 5),
                                    ),
                                  ],
                                ),
                                child: ElevatedButton(
                                  onPressed: () =>
                                      Navigator.pushNamed(context, '/register'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF00FFA3),
                                    foregroundColor: Colors.black,
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 20,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    elevation: 0,
                                  ),
                                  child: const Text(
                                    'Registrar dispositivo',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 15),
                            Expanded(
                              child: OutlinedButton(
                                onPressed: () =>
                                    Navigator.pushNamed(context, '/login'),
                                style: OutlinedButton.styleFrom(
                                  side: const BorderSide(color: Colors.white12),
                                  backgroundColor: Colors.white.withOpacity(
                                    0.02,
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 20,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                ),
                                child: const Text(
                                  'Iniciar sesión',
                                  style: TextStyle(
                                    color: Color(0xFF00FFA3),
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 40),
                      ],
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

  Widget _buildFeatureCard(IconData icon, String title, String subtitle) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 20),
      decoration: BoxDecoration(
        color: const Color(0xFF0E1415),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF1A2426),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: const Color(0xFF00FFA3).withOpacity(0.2),
              ),
            ),
            child: Icon(icon, color: const Color(0xFF00FFA3), size: 30),
          ),
          const SizedBox(height: 15),
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white38, fontSize: 13),
          ),
        ],
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

    const double step = 40.0;
    for (double i = 0; i < size.width; i += step) {
      canvas.drawLine(Offset(i, 0), Offset(i, size.height), paint);
    }
    for (double i = 0; i < size.height; i += step) {
      canvas.drawLine(Offset(0, i), Offset(size.width, i), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
