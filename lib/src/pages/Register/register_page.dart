import 'package:flutter/material.dart';
// Asegúrate de que la ruta sea correcta según tu estructura de carpetas
import '../Profile/profile_page.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage>
    with SingleTickerProviderStateMixin {
  // --- LÓGICA DE ANIMACIÓN RECUPERADA ---
  late AnimationController _controller;
  late Animation<double> _pulseAnimation;

  // CONTROLADORES
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNamePController = TextEditingController();
  final TextEditingController _lastNameMController = TextEditingController();
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
    _firstNameController.dispose();
    _lastNamePController.dispose();
    _lastNameMController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Usamos el color gris oscuro profundo para consistencia
      backgroundColor: const Color(0xFF101415),
      body: Stack(
        children: [
          // 1. FONDO DE CUADRÍCULA (Pantalla completa)
          Positioned.fill(
            child: IgnorePointer(
              child: CustomPaint(painter: GridPainter()),
            ),
          ),

          SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 50),

                  // 2. LOGO ANIMADO (Recuperado y con pulso)
                  Center(
                    child: ScaleTransition(
                      scale: _pulseAnimation,
                      child: Image.asset(
                        'assets/images/mobilelock-logo.png',
                        height: 90,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) =>
                            const Icon(
                          Icons.shield_outlined,
                          color: Color(0xFF00FFA3),
                          size: 70,
                        ),
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 20),

                  // 3. TÍTULO NEÓN
                  const Text(
                    'MobileLock',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xFF00FFA3),
                      fontSize: 32,
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
                  const Center(
                    child: Text(
                      'Crea tu cuenta AI',
                      style: TextStyle(
                        color: Color(0xFF00FFA3),
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),

                  // 4. FORMULARIO (Sin recuadro, directo sobre el fondo)
                  
                  _buildSectionLabel('NOMBRE COMPLETO'),
                  _buildTextField(
                    _firstNameController,
                    'Nombre(s)',
                    Icons.person_outline,
                  ),
                  const SizedBox(height: 12),
                  _buildTextField(
                    _lastNamePController,
                    'Apellido paterno',
                    Icons.person_outline,
                  ),
                  const SizedBox(height: 12),
                  _buildTextField(
                    _lastNameMController,
                    'Apellido materno',
                    Icons.person_outline,
                  ),

                  const SizedBox(height: 25),

                  _buildSectionLabel('CREDENCIALES'),
                  _buildTextField(
                    _emailController,
                    'tu@dominio.com',
                    Icons.email_outlined,
                  ),
                  const SizedBox(height: 12),
                  _buildPasswordField(),

                  const SizedBox(height: 40),

                  // 5. BOTÓN REGISTRARME (Sólido Neón)
                  Container(
                    height: 55,
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF00FFA3).withOpacity(0.3),
                          blurRadius: 15,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: ElevatedButton(
                      onPressed: () {
                        // Lógica de registro recuperada
                        isLoggedIn = true;
                        currentEmail = _emailController.text;
                        currentName =
                            "${_firstNameController.text} ${_lastNamePController.text} ${_lastNameMController.text}";
                        
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
                        'Registrarme',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          letterSpacing: 1.1,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // 6. VOLVER AL LOGIN
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text(
                      'Ya tengo cuenta',
                      style: TextStyle(
                        color: Colors.white24,
                        fontSize: 13,
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- MANTENEMOS TUS COMPONENTES AUXILIARES ---

  Widget _buildSectionLabel(String text) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(left: 5, bottom: 8),
        child: Text(
          text,
          style: const TextStyle(
            color: Color(0xFF00FFA3),
            fontSize: 10,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.5,
          ),
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
        color: const Color(0xFF1A1F21), // Color surface suave
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: TextField(
        controller: controller,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: const Color(0xFF00FFA3), size: 18),
          hintText: hint,
          hintStyle: const TextStyle(color: Colors.white12, fontSize: 14),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 18),
        ),
      ),
    );
  }

  Widget _buildPasswordField() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1A1F21),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: TextField(
        controller: _passwordController,
        obscureText: _obscureText,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          prefixIcon: const Icon(
            Icons.lock_outline,
            color: Color(0xFF00FFA3),
            size: 18,
          ),
          hintText: 'Contraseña segura',
          hintStyle: const TextStyle(color: Colors.white10),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 18),
          suffixIcon: IconButton(
            icon: Icon(
              _obscureText ? Icons.visibility_off : Icons.visibility,
              color: Colors.white12,
              size: 18,
            ),
            onPressed: () => setState(() => _obscureText = !_obscureText),
          ),
        ),
      ),
    );
  }
}

// Pintor de cuadrícula
class GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.02)
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