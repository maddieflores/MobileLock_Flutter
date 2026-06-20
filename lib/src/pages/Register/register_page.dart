import 'package:flutter/material.dart';
import '../../../services/api_service.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _pulseAnimation;

  final ApiService _apiService = ApiService();

  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNamePController = TextEditingController();
  final TextEditingController _lastNameMController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _obscureText = true;
  bool _isLoading = false;

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
      backgroundColor: const Color(
        0xFF121727,
      ), // Solid slate blue matching Luminous Sentinel
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
                    constraints: const BoxConstraints(maxWidth: 380),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const SizedBox(height: 20),
                        // Pulsing Shield Logo
                        Center(
                          child: ScaleTransition(
                            scale: _pulseAnimation,
                            child: Image.asset(
                              'assets/images/mobilelock-logo.png',
                              height: 95,
                              fit: BoxFit.contain,
                              color: const Color(0xFF00F0FF),
                              colorBlendMode: BlendMode.srcIn,
                              errorBuilder: (context, error, stackTrace) =>
                                  const Icon(
                                    Icons.shield_outlined,
                                    color: Color(0xFF00F0FF),
                                    size: 80,
                                  ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        // Glowing Title
                        const Text(
                          'MOBILELOCK AI',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color(0xFF00F0FF),
                            fontFamily: 'Space Grotesk',
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.5,
                            shadows: [
                              Shadow(color: Color(0xFF00F0FF), blurRadius: 20),
                            ],
                          ),
                        ),
                        const SizedBox(height: 8),
                        const SizedBox(height: 35),
                        // Form Card (Glassmorphism)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 28,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFF1E293B).withValues(
                              alpha: 0.45,
                            ), // Slate neutral background
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.08),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              // Card Title + Online indicator Row
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    'Crear Perfil',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: 'Space Grotesk',
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 30),

                              _buildFormLabel('NOMBRE(S)'),
                              const SizedBox(height: 4),
                              _buildInputField(
                                controller: _firstNameController,
                                hint: 'Ej. Alex',
                              ),
                              const SizedBox(height: 24),

                              // Side-by-side Paterno and Materno
                              Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      children: [
                                        _buildFormLabel('PATERNO'),
                                        const SizedBox(height: 4),
                                        _buildInputField(
                                          controller: _lastNamePController,
                                          hint: 'Apellido',
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      children: [
                                        _buildFormLabel('MATERNO'),
                                        const SizedBox(height: 4),
                                        _buildInputField(
                                          controller: _lastNameMController,
                                          hint: 'Apellido',
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 24),

                              _buildFormLabel('CORREO ELECTRÓNICO'),
                              const SizedBox(height: 4),
                              _buildInputField(
                                controller: _emailController,
                                hint: 'usuario@gmail.com',
                                suffix: const Text(
                                  '@',
                                  style: TextStyle(
                                    color: Colors.white30,
                                    fontSize: 16,
                                    fontFamily: 'Space Grotesk',
                                  ),
                                ),
                              ),
                              const SizedBox(height: 24),

                              _buildFormLabel('CONTRASEÑA'),
                              const SizedBox(height: 4),
                              _buildInputField(
                                controller: _passwordController,
                                hint: '••••••••••••',
                                obscureText: _obscureText,
                                suffix: InkWell(
                                  onTap: () => setState(
                                    () => _obscureText = !_obscureText,
                                  ),
                                  child: Icon(
                                    _obscureText
                                        ? Icons.visibility_off_outlined
                                        : Icons.visibility_outlined,
                                    color: Colors.white30,
                                    size: 18,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 35),

                              _buildSubmitButton(),
                              const SizedBox(height: 25),

                              _buildLoginLink(),
                            ],
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

  Widget _buildFormLabel(String text) {
    return Text(
      text,
      style: TextStyle(
        color: Colors.white.withValues(alpha: 0.6),
        fontFamily: 'Space Grotesk',
        fontSize: 10,
        fontWeight: FontWeight.bold,
        letterSpacing: 1.2,
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String hint,
    Widget? suffix,
    bool obscureText = false,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      style: const TextStyle(color: Colors.white, fontSize: 15),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.white24, fontSize: 14),
        contentPadding: const EdgeInsets.symmetric(vertical: 10),
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.white24, width: 1.0),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Color(0xFF00F0FF), width: 1.5),
        ),
        suffixIcon: suffix,
        suffixIconConstraints: const BoxConstraints(
          minWidth: 24,
          minHeight: 24,
        ),
      ),
    );
  }

  Widget _buildSubmitButton() {
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
        onPressed: _isLoading ? null : _handleRegister,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.white,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
        ),
        child: _isLoading
            ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2.5,
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text(
                    'REGISTRARSE',
                    style: TextStyle(
                      fontFamily: 'Space Grotesk',
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      letterSpacing: 1.5,
                    ),
                  ),
                  SizedBox(width: 8),
                  Icon(Icons.login_rounded, size: 20),
                ],
              ),
      ),
    );
  }

  Widget _buildLoginLink() {
    return GestureDetector(
      onTap: () => Navigator.pop(context),
      child: Center(
        child: RichText(
          text: const TextSpan(
            style: TextStyle(fontFamily: 'Space Grotesk', fontSize: 13),
            children: [
              TextSpan(
                text: 'Ya tengo una cuenta ',
                style: TextStyle(color: Colors.white54),
              ),
              TextSpan(
                text: 'Iniciar sesión',
                style: TextStyle(
                  color: Color(0xFF00F0FF),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _handleRegister() async {
    final firstName = _firstNameController.text.trim();
    final lastNameP = _lastNamePController.text.trim();
    final lastNameM = _lastNameMController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    if (firstName.isEmpty ||
        lastNameP.isEmpty ||
        lastNameM.isEmpty ||
        email.isEmpty ||
        password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Por favor, completa todos los campos"),
          backgroundColor: Colors.amber,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Creando cuenta..."),
        duration: Duration(seconds: 1),
      ),
    );

    final response = await _apiService.register(
      email,
      password,
      firstName,
      lastNameP,
      lastNameM,
    );

    if (!mounted) return;
    setState(() => _isLoading = false);

    if (response != null &&
        (response.statusCode == 200 || response.statusCode == 201)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("¡Cuenta creada con éxito! Inicia sesión."),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Error: ${response?.data ?? 'No se pudo crear la cuenta'}",
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
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
