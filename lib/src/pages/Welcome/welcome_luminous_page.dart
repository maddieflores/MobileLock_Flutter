import 'package:flutter/material.dart';

class WelcomeLuminousPage extends StatefulWidget {
  const WelcomeLuminousPage({super.key});

  @override
  State<WelcomeLuminousPage> createState() => _WelcomeLuminousPageState();
}

class _WelcomeLuminousPageState extends State<WelcomeLuminousPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.08,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(
        0xFF121727,
      ), // Solid slate blue matches Luminous Sentinel
      body: Stack(
        children: [
          // Background Dot Grid
          Positioned.fill(
            child: IgnorePointer(child: CustomPaint(painter: DotGridPainter())),
          ),
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 20,
                  ),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 360),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const SizedBox(height: 40),
                        // Pulsing Shield Logo
                        Center(
                          child: ScaleTransition(
                            scale: _pulseAnimation,
                            child: Image.asset(
                              'assets/images/mobilelock-logo.png',
                              height: 120,
                              fit: BoxFit.contain,
                              color: const Color(0xFF00F0FF), // Tint logo cian
                              colorBlendMode: BlendMode.srcIn,
                              errorBuilder: (context, error, stackTrace) =>
                                  const Icon(
                                    Icons.shield_outlined,
                                    color: Color(0xFF00F0FF),
                                    size: 100,
                                  ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 40),
                        // Glowing Title styled like Login Page
                        const Text(
                          'MOBILELOCK AI',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color(0xFF00F0FF),
                            fontFamily: 'Space Grotesk',
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.8,
                            shadows: [
                              Shadow(color: Color(0xFF00F0FF), blurRadius: 20),
                            ],
                          ),
                        ),
                        const SizedBox(height: 8),
                        const SizedBox(height: 60),
                        // Gradient Action Button "COMENZAR"
                        _buildStartButton(),
                        const SizedBox(height: 60),
                        // Neural Cipher Activation Info Footer
                        const Text(
                          'Protocolo de cifrado neural activado.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white38,
                            fontFamily: 'Space Grotesk',
                            fontSize: 12,
                            fontStyle: FontStyle.italic,
                            letterSpacing: 0.5,
                          ),
                        ),
                        const SizedBox(height: 20),
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

  Widget _buildStartButton() {
    return Container(
      height: 58,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        gradient: const LinearGradient(
          colors: [Color(0xFF00F0FF), Color(0xFF008AA3)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF00F0FF).withValues(alpha: 0.35),
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: () {
          // Navigate to login
          Navigator.pushReplacementNamed(context, '/login');
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.white,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text(
              'COMENZAR',
              style: TextStyle(
                fontFamily: 'Space Grotesk',
                fontWeight: FontWeight.bold,
                fontSize: 16,
                letterSpacing: 1.5,
              ),
            ),
            SizedBox(width: 8),
            Icon(Icons.chevron_right_rounded, size: 24),
          ],
        ),
      ),
    );
  }
}

class DotGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.05)
      ..style = PaintingStyle.fill;

    const double step = 25.0;
    for (double i = 0; i < size.width; i += step) {
      for (double j = 0; j < size.height; j += step) {
        canvas.drawCircle(Offset(i, j), 0.8, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
