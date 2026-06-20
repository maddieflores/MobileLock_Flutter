import '../../../services/api_service.dart';
import '../../../services/auth_storage.dart';
import 'package:flutter/material.dart';
import '../Profile/profile_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {
  final ApiService _apiService = ApiService();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _obscureText = true;
  bool _isLoading = false;

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
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final brandColor = isDark
        ? const Color(0xFF00F0FF)
        : const Color(0xFF0A7E8C);
    final brandShadows = isDark
        ? const [Shadow(color: Color(0xFF00F0FF), blurRadius: 20)]
        : null;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Stack(
        children: [
          // Background Atmospheric Shader Grid
          Positioned.fill(
            child: IgnorePointer(
              child: CustomPaint(
                painter: AtmosphericGridPainter(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.white.withValues(alpha: 0.05)
                      : Colors.black.withValues(alpha: 0.05),
                ),
              ),
            ),
          ),
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 20,
                  ),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 380),
                    // Outer Frame Container (The main border shell)
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 30,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const SizedBox(height: 10),
                          // Pulsing Logo
                          Center(
                            child: ScaleTransition(
                              scale: _pulseAnimation,
                              child: Image.asset(
                                'assets/images/mobilelock-logo.png',
                                height: 95,
                                fit: BoxFit.contain,
                                color: brandColor,
                                colorBlendMode: BlendMode.srcIn,
                                errorBuilder: (context, error, stackTrace) =>
                                    Icon(
                                      Icons.shield_outlined,
                                      color: brandColor,
                                      size: 80,
                                    ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          // Glowing Title (Luminous Sentinel Color)
                          Text(
                            'MOBILELOCK AI',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: brandColor,
                              fontFamily: 'Space Grotesk',
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.5,
                              shadows: brandShadows,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const SizedBox(height: 35),
                          // Inner Form Container (Glassmorphism card)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 28,
                            ),
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.surface,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color:
                                    Theme.of(context).brightness ==
                                        Brightness.dark
                                    ? Colors.white.withValues(alpha: 0.08)
                                    : Colors.black.withValues(alpha: 0.08),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(
                                    alpha:
                                        Theme.of(context).brightness ==
                                            Brightness.dark
                                        ? 0.2
                                        : 0.04,
                                  ),
                                  blurRadius: 15,
                                  offset: const Offset(0, 5),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                _buildFormLabel('CORREO ELECTRÓNICO'),
                                const SizedBox(height: 8),
                                _buildEmailField(),
                                const SizedBox(height: 24),
                                _buildFormLabel('CONTRASEÑA'),
                                const SizedBox(height: 8),
                                _buildPasswordField(),
                                const SizedBox(height: 30),
                                _buildSubmitButton(),
                                const SizedBox(height: 25),
                                _buildForgotPasswordLink(),
                                const SizedBox(height: 16),
                                _buildRegisterLink(),
                              ],
                            ),
                          ),
                          const SizedBox(height: 35),
                        ],
                      ),
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Text(
      text,
      style: TextStyle(
        color: isDark
            ? Colors.white.withValues(alpha: 0.6)
            : const Color(0xFF2C2520).withValues(alpha: 0.6),
        fontFamily: 'Space Grotesk',
        fontSize: 11,
        fontWeight: FontWeight.bold,
        letterSpacing: 1.2,
      ),
    );
  }

  Widget _buildEmailField() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0F172A) : const Color(0xFFFAF8F5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.08)
              : Colors.black.withValues(alpha: 0.08),
        ),
      ),
      child: TextField(
        controller: _emailController,
        style: TextStyle(
          color: isDark ? Colors.white : const Color(0xFF2C2520),
          fontSize: 15,
        ),
        decoration: InputDecoration(
          hintText: 'usuario@gmail.com',
          hintStyle: TextStyle(
            color: isDark
                ? Colors.white.withValues(alpha: 0.2)
                : Colors.black.withValues(alpha: 0.25),
            fontSize: 15,
          ),
          border: InputBorder.none,
          prefixIcon: Icon(
            Icons.alternate_email_rounded,
            color: isDark ? Colors.white30 : const Color(0xFF0A7E8C),
            size: 20,
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
        ),
      ),
    );
  }

  Widget _buildPasswordField() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0F172A) : const Color(0xFFFAF8F5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.08)
              : Colors.black.withValues(alpha: 0.08),
        ),
      ),
      child: TextField(
        controller: _passwordController,
        obscureText: _obscureText,
        style: TextStyle(
          color: isDark ? Colors.white : const Color(0xFF2C2520),
          fontSize: 15,
        ),
        decoration: InputDecoration(
          hintText: '********',
          hintStyle: TextStyle(
            color: isDark
                ? Colors.white.withValues(alpha: 0.2)
                : Colors.black.withValues(alpha: 0.25),
            fontSize: 15,
          ),
          border: InputBorder.none,
          prefixIcon: Icon(
            Icons.lock_outline_rounded,
            color: isDark ? Colors.white30 : const Color(0xFF0A7E8C),
            size: 20,
          ),
          suffixIcon: IconButton(
            icon: Icon(
              _obscureText
                  ? Icons.visibility_outlined
                  : Icons.visibility_off_outlined,
              color: isDark
                  ? Colors.white30
                  : const Color(0xFF2C2520).withValues(alpha: 0.6),
              size: 20,
            ),
            onPressed: () => setState(() => _obscureText = !_obscureText),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
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
          colors: [
            Color(0xFF00F0FF), // Neon Cyan Primary from Luminous Sentinel
            Color(0xFF008AA3),
          ],
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
        onPressed: _isLoading
            ? null
            : () async {
                final email = _emailController.text.trim();
                final password = _passwordController.text.trim();

                if (email.isEmpty || password.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Por favor, rellena todos los campos"),
                    ),
                  );
                  return;
                }

                setState(() => _isLoading = true);

                final response = await _apiService.login(email, password);

                if (mounted) {
                  setState(() => _isLoading = false);
                  if (response != null && response.statusCode == 200) {
                    final token = response.data['access'];
                    await AuthStorage.saveToken(token, email);

                    isLoggedIn = true;
                    globalToken = token;
                    currentEmail = email;

                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      '/dashboard',
                      (route) => false,
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Error: Credenciales incorrectas"),
                      ),
                    );
                  }
                }
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
        child: _isLoading
            ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
            : const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'ACCEDER',
                    style: TextStyle(
                      fontFamily: 'Space Grotesk',
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      letterSpacing: 1.5,
                    ),
                  ),
                  SizedBox(width: 8),
                  Icon(Icons.shield_outlined, size: 20),
                ],
              ),
      ),
    );
  }

  Widget _buildForgotPasswordLink() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Center(
      child: InkWell(
        onTap: () {
          // Password recovery handler placeholder
        },
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          child: Text(
            '¿Olvidaste tu contraseña?',
            style: TextStyle(
              color: isDark ? const Color(0xFF00F0FF) : const Color(0xFF0A7E8C),
              fontFamily: 'Space Grotesk',
              fontWeight: FontWeight.bold,
              fontSize: 13,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRegisterLink() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Center(
      child: GestureDetector(
        onTap: () => Navigator.pushNamed(context, '/register'),
        child: RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            style: const TextStyle(fontSize: 13, fontFamily: 'Space Grotesk'),
            children: [
              TextSpan(
                text: '¿No tienes una cuenta? ',
                style: TextStyle(
                  color: isDark
                      ? Colors.white.withValues(alpha: 0.5)
                      : const Color(0xFF2C2520).withValues(alpha: 0.6),
                ),
              ),
              TextSpan(
                text: 'Crear cuenta nueva',
                style: TextStyle(
                  color: isDark
                      ? const Color(0xFF00F0FF)
                      : const Color(0xFF0A7E8C),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AtmosphericGridPainter extends CustomPainter {
  final Color color;
  AtmosphericGridPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    // Draw dot grid on solid background
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    const double step = 25.0;
    for (double i = 0; i < size.width; i += step) {
      for (double j = 0; j < size.height; j += step) {
        canvas.drawCircle(Offset(i, j), 0.8, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant AtmosphericGridPainter oldDelegate) =>
      oldDelegate.color != color;
}
