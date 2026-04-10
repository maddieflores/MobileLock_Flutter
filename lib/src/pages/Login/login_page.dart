import 'package:flutter/material.dart';
import '../Profile/profile_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {
  // LÓGICA DE ANIMACIÓN
  late AnimationController _controller;
  late Animation<double> _pulseAnimation;

  // CONTROLADORES
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _obscureText = true;

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
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF060B0C),
      body: Stack(
        children: [
          // Fondo de cuadrícula
          Positioned.fill(
            child: IgnorePointer(child: CustomPaint(painter: GridPainter())),
          ),

          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(
                  horizontal: 25,
                  vertical: 30,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // --- RECUADRO CENTRAL ---
                    Container(
                      constraints: const BoxConstraints(maxWidth: 400),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 25,
                        vertical: 40,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF0A0F10).withOpacity(0.8),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.05),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.5),
                            blurRadius: 20,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          // LOGO ANIMADO
                          ScaleTransition(
                            scale: _pulseAnimation,
                            child: Image.asset(
                              'assets/images/mobilelock-logo.png',
                              height: 90,
                              fit: BoxFit.contain,
                              errorBuilder: (context, error, stackTrace) =>
                                  const Icon(
                                    Icons.shield,
                                    color: Color(0xFF00FFA3),
                                    size: 70,
                                  ),
                            ),
                          ),
                          const SizedBox(height: 25),

                          const Text(
                            'MOBILELOCK AI',
                            style: TextStyle(
                              color: Color(0xFF00FFA3),
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.5,
                              shadows: [
                                Shadow(
                                  color: Color(0xFF00FFA3),
                                  blurRadius: 15,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 45),

                          // CAMPOS DE TEXTO
                          _buildLabel(
                            'Correo electrónico',
                            Icons.email_outlined,
                          ),
                          _buildTextField(
                            _emailController,
                            'jlopez@example.com',
                            false,
                          ),

                          const SizedBox(height: 25),

                          _buildLabel('Contraseña', Icons.lock_outline),
                          _buildTextField(
                            _passwordController,
                            '********',
                            true,
                          ),

                          const SizedBox(height: 35),

                          // BOTÓN ACCEDER
                          Container(
                            width: double.infinity,
                            height: 55,
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
                              onPressed: () {
                                isLoggedIn = true;

                                // CAPTURAMOS EL CORREO DEL TEXTFIELD
                                currentEmail = _emailController.text.isNotEmpty
                                    ? _emailController.text
                                    : "jlopez@example.com";

                                // --- CORRECCIÓN AQUÍ ---
                                // Como en el login no pedimos el nombre,
                                // podemos usar una lógica: Si el correo es el de "Juan", ponemos Juan.
                                // Si no, ponemos un nombre genérico o lo que el usuario escribió en el prefijo del correo.
                                if (currentEmail == "jlopez@example.com") {
                                  currentName = "Juan López";
                                } else if (currentEmail.contains('@')) {
                                  // Esto saca el nombre del correo (ej: de "amador@mail.com" saca "amador")
                                  currentName = currentEmail.split('@')[0];
                                } else {
                                  currentName = "Usuario MobileLock";
                                }

                                Navigator.pushNamedAndRemoveUntil(
                                  context,
                                  '/dashboard',
                                  (route) => false,
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF00FFA3),
                                foregroundColor: Colors.black,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                elevation: 0,
                              ),
                              child: const Text(
                                'ACCEDER',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1.2,
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 15),

                          // BOTÓN CREAR CUENTA
                          OutlinedButton(
                            onPressed: () =>
                                Navigator.pushNamed(context, '/register'),
                            style: OutlinedButton.styleFrom(
                              minimumSize: const Size(double.infinity, 55),
                              side: BorderSide(
                                color: Colors.white.withOpacity(0.1),
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                            ),
                            child: const Text(
                              'Crear cuenta nueva',
                              style: TextStyle(color: Colors.white70),
                            ),
                          ),

                          const SizedBox(height: 25),

                          // VOLVER AL INICIO
                          TextButton(
                            onPressed: () => Navigator.pushNamed(context, '/'),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.arrow_back,
                                  color: Colors.white.withOpacity(0.2),
                                  size: 14,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Volver al inicio',
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.2),
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
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

  Widget _buildLabel(String text, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(left: 5, bottom: 8),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF00FFA3), size: 16),
          const SizedBox(width: 8),
          Text(
            text,
            style: const TextStyle(color: Colors.white60, fontSize: 13),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String hint,
    bool isPassword,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.4),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: TextField(
        controller: controller,
        obscureText: isPassword ? _obscureText : false,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: Colors.white12, fontSize: 14),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 18,
          ),
          suffixIcon: isPassword
              ? IconButton(
                  icon: Icon(
                    _obscureText ? Icons.visibility_off : Icons.visibility,
                    color: Colors.white12,
                    size: 18,
                  ),
                  onPressed: () => setState(() => _obscureText = !_obscureText),
                )
              : null,
        ),
      ),
    );
  }
}

class GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.02)
      ..strokeWidth = 1.0;
    for (double i = 0; i < size.width; i += 40)
      canvas.drawLine(Offset(i, 0), Offset(i, size.height), paint);
    for (double i = 0; i < size.height; i += 40)
      canvas.drawLine(Offset(0, i), Offset(size.width, i), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
