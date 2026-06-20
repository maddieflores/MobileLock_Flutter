import 'package:flutter/material.dart';
import '../../widgets/luminous_app_bar.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final TextEditingController _currentPassController = TextEditingController();
  final TextEditingController _newPassController = TextEditingController();
  final TextEditingController _confirmPassController = TextEditingController();

  bool _obscureCurrent = true;
  bool _obscureNew = true;
  bool _obscureConfirm = true;

  @override
  void dispose() {
    _currentPassController.dispose();
    _newPassController.dispose();
    _confirmPassController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Stack(
        children: [
          Positioned.fill(
            child: IgnorePointer(
              child: CustomPaint(
                painter: GridPainter(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.white.withValues(alpha: 0.03)
                      : Colors.black.withValues(alpha: 0.03),
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Column(
                children: [
                  const LuminousAppBar(
                    showBackButton: true,
                    title: 'Seguridad',
                    showThemeToggle: false,
                    showNotifications: false,
                  ),
                  Expanded(
                    child: SafeArea(
                      top: false,
                      bottom: false,
                      child: ListView(
                        physics: const BouncingScrollPhysics(),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
                        ),
                        children: [
                          // --- RECUADRO ESTILO CRISTAL ---
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 25,
                              vertical: 35,
                            ),
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.surface,
                              borderRadius: BorderRadius.circular(20),
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
                                  blurRadius: 20,
                                  spreadRadius: 2,
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // FORMULARIO
                                _buildLabel('Contraseña actual'),
                                _buildPasswordField(
                                  _currentPassController,
                                  _obscureCurrent,
                                  () => setState(
                                    () => _obscureCurrent = !_obscureCurrent,
                                  ),
                                ),
                                const SizedBox(height: 25),

                                _buildLabel('Nueva contraseña'),
                                _buildPasswordField(
                                  _newPassController,
                                  _obscureNew,
                                  () => setState(
                                    () => _obscureNew = !_obscureNew,
                                  ),
                                ),
                                const SizedBox(height: 25),

                                _buildLabel('Confirmar nueva contraseña'),
                                _buildPasswordField(
                                  _confirmPassController,
                                  _obscureConfirm,
                                  () => setState(
                                    () => _obscureConfirm = !_obscureConfirm,
                                  ),
                                ),
                                const SizedBox(height: 45),

                                // BOTÓN ACTUALIZAR
                                Container(
                                  width: double.infinity,
                                  height: 55,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    gradient: const LinearGradient(
                                      colors: [
                                        Color(0xFF00F0FF),
                                        Color(0xFF008AA3),
                                      ],
                                      begin: Alignment.centerLeft,
                                      end: Alignment.centerRight,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: const Color(
                                          0xFF00F0FF,
                                        ).withValues(alpha: 0.35),
                                        blurRadius: 18,
                                        offset: const Offset(0, 6),
                                      ),
                                    ],
                                  ),
                                  child: ElevatedButton(
                                    onPressed: () {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                            'Contraseña actualizada',
                                          ),
                                        ),
                                      );
                                      Navigator.pop(context);
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: const [
                                        Icon(
                                          Icons.shield_outlined,
                                          color: Colors.white,
                                          size: 20,
                                        ),
                                        SizedBox(width: 8),
                                        Text(
                                          'ACTUALIZAR CONTRASEÑA',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                            letterSpacing: 1.0,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 40),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLabel(String text) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.only(left: 0, bottom: 4),
      child: Text(
        text.toUpperCase(),
        style: TextStyle(
          color: isDark
              ? Colors.white.withValues(alpha: 0.6)
              : const Color(0xFF2C2520).withValues(alpha: 0.6),
          fontSize: 11,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.8,
        ),
      ),
    );
  }

  Widget _buildPasswordField(
    TextEditingController controller,
    bool isObscured,
    VoidCallback toggleVisibility,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return TextField(
      controller: controller,
      obscureText: isObscured,
      style: TextStyle(
        color: isDark ? Colors.white : const Color(0xFF2C2520),
        fontSize: 15,
      ),
      decoration: InputDecoration(
        prefixIcon: Icon(
          Icons.lock_outline_rounded,
          color: isDark
              ? Colors.white.withValues(alpha: 0.6)
              : const Color(0xFF0A7E8C),
          size: 20,
        ),
        suffixIcon: IconButton(
          icon: Icon(
            isObscured
                ? Icons.visibility_off_outlined
                : Icons.visibility_outlined,
            color: isDark
                ? Colors.white.withValues(alpha: 0.6)
                : const Color(0xFF2C2520).withValues(alpha: 0.6),
            size: 20,
          ),
          onPressed: toggleVisibility,
        ),
        filled: true,
        fillColor: isDark ? Colors.transparent : const Color(0xFFFAF8F5),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 12,
          horizontal: 12,
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: isDark ? Colors.white24 : const Color(0xFFEFECE3),
            width: 1.0,
          ),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.primary,
            width: 1.5,
          ),
        ),
      ),
    );
  }
}

class GridPainter extends CustomPainter {
  final Color color;
  GridPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
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
