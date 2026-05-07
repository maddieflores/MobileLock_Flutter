import 'package:flutter/material.dart';
import '../../../services/api_service.dart'; // <--- 1. IMPORTAMOS EL SERVICIO
import '../Profile/profile_page.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _pulseAnimation;

  // <--- 2. INICIALIZAMOS EL SERVICIO
  final ApiService _apiService = ApiService();

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
      backgroundColor: const Color(0xFF101415),
      body: Stack(
        children: [
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
                  const Text(
                    'MobileLock',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xFF00FFA3),
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.5,
                      shadows: [
                        Shadow(color: Color(0xFF00FFA3), blurRadius: 15),
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

                  // <--- 3. BOTÓN CON LÓGICA REAL DE BACKEND
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
                      onPressed: () async {
                        // Mostramos un indicador visual rápido (opcional)
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Creando cuenta..."), duration: Duration(seconds: 1)),
                        );

                        final response = await _apiService.register(
                          _emailController.text.trim(),
                          _passwordController.text,
                          _firstNameController.text.trim(),
                          _lastNamePController.text.trim(),
                          _lastNameMController.text.trim(),
                        );

                        if (mounted) {
                          // 201 significa "Created" en convenciones REST
                          if (response != null && (response.statusCode == 200 || response.statusCode == 201)) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("¡Cuenta creada con éxito! Inicia sesión."),
                                backgroundColor: Colors.green,
                              ),
                            );
                            Navigator.pop(context); // Regresa al Login
                          } else {
                            // Si falla, mostramos el error de Django
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text("Error: ${response?.data ?? 'No se pudo crear la cuenta'}"),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        }
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
        color: const Color(0xFF1A1F21),
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