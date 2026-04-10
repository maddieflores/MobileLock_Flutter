import 'package:flutter/material.dart';
// IMPORTANTE: Asegúrate de que la ruta sea correcta para acceder a las variables globales
import '../Profile/profile_page.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage>
    with SingleTickerProviderStateMixin {
  // LÓGICA DE ANIMACIÓN
  late AnimationController _controller;
  late Animation<double> _pulseAnimation;

  // CONTROLADORES del formulario
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNamePController =
      TextEditingController(); // Paterno
  final TextEditingController _lastNameMController =
      TextEditingController(); // Materno
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _obscureText = true;

  @override
  void initState() {
    super.initState();
    // Configuración de la animación de pulso (2 segundos, infinita y reversa)
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    // Variación de escala de 1.0 (tamaño normal) a 1.08 (ligero aumento)
    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.08,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose(); // IMPORTANTE: Liberar el controlador
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
      backgroundColor: const Color(0xFF060B0C),
      body: Stack(
        children: [
          // Fondo de cuadrícula decorativa
          Positioned.fill(
            child: IgnorePointer(child: CustomPaint(painter: GridPainter())),
          ),

          SafeArea(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 400),
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 25,
                    vertical: 30,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // --- TARJETA DE CRISTAL CENTRAL ---
                      Container(
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
                            // --- LOGO ANIMADO DE MobileLock ---
                            ScaleTransition(
                              scale: _pulseAnimation,
                              child: Image.asset(
                                'assets/images/mobilelock-logo.png', // Ruta de tu asset
                                height: 80,
                                fit: BoxFit.contain,
                                errorBuilder: (context, error, stackTrace) =>
                                    const Icon(
                                      Icons.shield_outlined,
                                      color: Color(0xFF00FFA3),
                                      size: 70,
                                    ),
                              ),
                            ),
                            const SizedBox(height: 20),

                            // TÍTULO CON BRILLO NEÓN
                            const Text(
                              'MobileLock',
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
                            const Text(
                              'Crea tu cuenta AI',
                              style: TextStyle(
                                color: Color(0xFF00FFA3),
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 20),

                            // DESCRIPCIÓN PEQUEÑA
                            const Text(
                              'Registra tus datos para proteger y verificar tus dispositivos con seguridad avanzada.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white38,
                                fontSize: 11,
                                height: 1.5,
                              ),
                            ),
                            const SizedBox(height: 35),

                            // SECCIÓN NOMBRE COMPLETO (3 Campos)
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

                            // SECCIÓN CREDENCIALES
                            _buildSectionLabel('CREDENCIALES'),
                            _buildTextField(
                              _emailController,
                              'tu@dominio.com',
                              Icons.email_outlined,
                            ),
                            const SizedBox(height: 12),
                            _buildPasswordField(),

                            const SizedBox(height: 45),

                            // --- BOTÓN REGISTRARME ---
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
                                  currentEmail = _emailController.text;
                                  currentName =
                                      "${_firstNameController.text} ${_lastNamePController.text} ${_lastNameMController.text}";
                                  print(
                                    "Registrando a: $currentName ($currentEmail)",
                                  );
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

                            // BOTÓN "YA TENGO CUENTA" DENTRO DEL RECUADRO
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
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- COMPONENTES VISUALES ---
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
        color: Colors.black.withOpacity(0.4),
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
        color: Colors.black.withOpacity(0.4),
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
    for (double i = 0; i < size.width; i += 40)
      canvas.drawLine(Offset(i, 0), Offset(i, size.height), paint);
    for (double i = 0; i < size.height; i += 40)
      canvas.drawLine(Offset(0, i), Offset(size.width, i), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
