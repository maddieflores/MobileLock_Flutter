import 'package:flutter/material.dart';
import 'profile_page.dart';
import '../../widgets/luminous_app_bar.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  late TextEditingController _firstNameController;
  late TextEditingController _lastNamePController;
  late TextEditingController _lastNameMController;
  late TextEditingController _emailController;

  @override
  void initState() {
    super.initState();
    List<String> nameParts = currentName.trim().split(' ');
    _firstNameController = TextEditingController(
      text: nameParts.isNotEmpty ? nameParts[0] : "",
    );
    _lastNamePController = TextEditingController(
      text: nameParts.length > 1 ? nameParts[1] : "",
    );
    _lastNameMController = TextEditingController(
      text: nameParts.length > 2 ? nameParts[2] : "",
    );
    _emailController = TextEditingController(text: currentEmail);
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNamePController.dispose();
    _lastNameMController.dispose();
    _emailController.dispose();
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
                      ? Colors.white.withValues(alpha: 0.02)
                      : Colors.black.withValues(alpha: 0.02),
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
                    title: 'Editar Perfil',
                    showThemeToggle: false,
                    showNotifications: false,
                  ),
                  Expanded(
                    child: SafeArea(
                      top: false,
                      bottom: false,
                      child: Center(
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 25,
                            vertical: 20,
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                constraints: const BoxConstraints(
                                  maxWidth: 400,
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 25,
                                  vertical: 40,
                                ),
                                decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.surface,
                                  borderRadius: BorderRadius.circular(30),
                                  border: Border.all(
                                    color:
                                        Theme.of(context).brightness ==
                                            Brightness.dark
                                        ? const Color(0xFF1E293B)
                                        : Colors.black.withValues(alpha: 0.08),
                                    width: 1.5,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withValues(
                                        alpha:
                                            Theme.of(context).brightness ==
                                                Brightness.dark
                                            ? 0.4
                                            : 0.06,
                                      ),
                                      blurRadius: 20,
                                      offset: const Offset(0, 10),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  children: [
                                    Stack(
                                      children: [
                                        Container(
                                          width: 110,
                                          height: 110,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .primary
                                                  .withValues(alpha: 0.2),
                                              width: 1.5,
                                            ),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .primary
                                                    .withValues(alpha: 0.08),
                                                blurRadius: 10,
                                                spreadRadius: 1,
                                              ),
                                            ],
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(4.0),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                gradient: LinearGradient(
                                                  colors: [
                                                    Theme.of(context)
                                                        .colorScheme
                                                        .primary
                                                        .withValues(
                                                          alpha: 0.15,
                                                        ),
                                                    Theme.of(context)
                                                        .colorScheme
                                                        .secondary
                                                        .withValues(
                                                          alpha: 0.05,
                                                        ),
                                                  ],
                                                  begin: Alignment.topLeft,
                                                  end: Alignment.bottomRight,
                                                ),
                                              ),
                                              child: ClipOval(
                                                child: Stack(
                                                  alignment: Alignment.center,
                                                  children: [
                                                    Opacity(
                                                      opacity: 0.3,
                                                      child: Container(
                                                        decoration: BoxDecoration(
                                                          shape:
                                                              BoxShape.circle,
                                                          border: Border.all(
                                                            color:
                                                                Theme.of(
                                                                      context,
                                                                    )
                                                                    .colorScheme
                                                                    .primary,
                                                            width: 1.0,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    Icon(
                                                      Icons
                                                          .person_outline_rounded,
                                                      color: Theme.of(
                                                        context,
                                                      ).colorScheme.primary,
                                                      size: 60,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Positioned(
                                          bottom: 0,
                                          right: 0,
                                          child: Container(
                                            padding: const EdgeInsets.all(7),
                                            decoration: BoxDecoration(
                                              color: Theme.of(
                                                context,
                                              ).colorScheme.primary,
                                              shape: BoxShape.circle,
                                              border: Border.all(
                                                color: Colors.white,
                                                width: 2.0,
                                              ),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .primary
                                                      .withValues(alpha: 0.3),
                                                  blurRadius: 8,
                                                  offset: const Offset(0, 2),
                                                ),
                                              ],
                                            ),
                                            child: const Icon(
                                              Icons.camera_alt,
                                              color: Colors.black,
                                              size: 16,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 40),
                                    _buildLabel('Nombre(s)'),
                                    _buildTextField(
                                      _firstNameController,
                                      Icons.person_outline_rounded,
                                      hintText: 'Usuario',
                                    ),
                                    const SizedBox(height: 20),
                                    _buildLabel('Apellido Paterno'),
                                    _buildTextField(
                                      _lastNamePController,
                                      Icons.person_outline_rounded,
                                      hintText: 'MobileLock',
                                    ),
                                    const SizedBox(height: 20),
                                    _buildLabel('Apellido Materno'),
                                    _buildTextField(
                                      _lastNameMController,
                                      Icons.person_outline_rounded,
                                      hintText: 'Apellido materno',
                                    ),
                                    const SizedBox(height: 20),
                                    _buildLabel('Correo electrónico'),
                                    _buildTextField(
                                      _emailController,
                                      Icons.email_outlined,
                                      hintText: 'gina37@example.com',
                                    ),
                                    const SizedBox(height: 40),
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
                                          setState(() {
                                            currentName =
                                                "${_firstNameController.text} ${_lastNamePController.text} ${_lastNameMController.text}"
                                                    .trim();
                                            currentEmail =
                                                _emailController.text;
                                          });
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            const SnackBar(
                                              content: Text(
                                                'Cambios guardados',
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
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                          ),
                                          elevation: 0,
                                        ),
                                        child: const Text(
                                          'GUARDAR CAMBIOS',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                            letterSpacing: 0.5,
                                          ),
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
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLabel(String text) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(left: 5, bottom: 8),
        child: Text(
          text.toUpperCase(),
          style: TextStyle(
            color: isDark ? const Color(0xFF7A8B99) : const Color(0xFF0A7E8C),
            fontSize: 11,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    IconData icon, {
    String? hintText,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return TextField(
      controller: controller,
      style: TextStyle(
        color: isDark ? Colors.white : const Color(0xFF2C2520),
        fontSize: 15,
        fontWeight: FontWeight.w500,
      ),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(
          color: isDark
              ? Colors.white.withValues(alpha: 0.25)
              : const Color(0xFF2C2520).withValues(alpha: 0.4),
          fontSize: 15,
          fontWeight: FontWeight.w400,
        ),
        prefixIcon: Padding(
          padding: const EdgeInsets.only(left: 4, right: 8),
          child: Icon(
            icon,
            color: isDark ? const Color(0xFF7A8B99) : const Color(0xFF0A7E8C),
            size: 20,
          ),
        ),
        prefixIconConstraints: const BoxConstraints(minWidth: 40, minHeight: 0),
        filled: true,
        fillColor: isDark ? const Color(0xFF0E1621) : const Color(0xFFFAF8F5),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 16,
          horizontal: 16,
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: isDark ? const Color(0xFF2E3A4E) : const Color(0xFFEFECE3),
            width: 1.5,
          ),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(8),
            topRight: Radius.circular(8),
          ),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.primary,
            width: 1.5,
          ),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(8),
            topRight: Radius.circular(8),
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
