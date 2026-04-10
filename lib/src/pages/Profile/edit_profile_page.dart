import 'package:flutter/material.dart';
import 'profile_page.dart'; // IMPORTANTE: Para usar currentName y currentEmail

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
      backgroundColor: const Color(0xFF060B0C),
      body: Stack(
        children: [
          Positioned.fill(
            child: IgnorePointer(child: CustomPaint(painter: GridPainter())),
          ),

          SafeArea(
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
                    // --- ENCABEZADO PERSONALIZADO (FLECHA + TÍTULO JUNTOS) ---
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                            icon: const Icon(
                              Icons.arrow_back,
                              color: Colors.white,
                              size: 28,
                            ),
                            onPressed: () => Navigator.pop(context),
                          ),
                          const SizedBox(width: 15),
                          const Text(
                            'Editar Perfil',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              shadows: [
                                Shadow(
                                  color: Color(0xFF00FFA3),
                                  blurRadius: 10,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    // --- RECUADRO DE DATOS ---
                    Container(
                      constraints: const BoxConstraints(maxWidth: 400),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 25,
                        vertical: 40,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF0A0F10).withOpacity(0.8),
                        borderRadius: BorderRadius.circular(25),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.05),
                        ),
                      ),
                      child: Column(
                        children: [
                          Stack(
                            children: [
                              CircleAvatar(
                                radius: 50,
                                backgroundColor: Colors.black.withOpacity(0.3),
                                child: const Icon(
                                  Icons.person,
                                  color: Color(0xFF00FFA3),
                                  size: 55,
                                ),
                              ),
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: const BoxDecoration(
                                    color: Color(0xFF00FFA3),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.camera_alt,
                                    color: Colors.black,
                                    size: 18,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 40),

                          _buildLabel('Nombre(s)'),
                          _buildTextField(
                            _firstNameController,
                            Icons.person_outline,
                          ),
                          const SizedBox(height: 15),

                          _buildLabel('Apellido Paterno'),
                          _buildTextField(
                            _lastNamePController,
                            Icons.person_outline,
                          ),
                          const SizedBox(height: 15),

                          _buildLabel('Apellido Materno'),
                          _buildTextField(
                            _lastNameMController,
                            Icons.person_outline,
                          ),
                          const SizedBox(height: 15),

                          _buildLabel('Correo electrónico'),
                          _buildTextField(
                            _emailController,
                            Icons.email_outlined,
                          ),

                          const SizedBox(height: 40),

                          // --- BOTÓN GUARDAR (RESTAURADO A SÓLIDO NEÓN IGUAL A LA IMAGEN) ---
                          Container(
                            width: double.infinity,
                            height: 55,
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(
                                    0xFF00FFA3,
                                  ).withOpacity(0.3), // Brillo neón
                                  blurRadius: 15,
                                  offset: const Offset(0, 5),
                                ),
                              ],
                            ),
                            child: ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  currentName =
                                      "${_firstNameController.text} ${_lastNamePController.text} ${_lastNameMController.text}"
                                          .trim();
                                  currentEmail = _emailController.text;
                                });
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Cambios guardados'),
                                  ),
                                );
                                Navigator.pop(context);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(
                                  0xFF00FFA3,
                                ), // Fondo neón sólido
                                foregroundColor: Colors.black, // Texto negro
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                elevation:
                                    0, // Elevación 0 para controlar el brillo con el Container
                              ),
                              child: const Text(
                                'GUARDAR CAMBIOS',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
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
        ],
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(left: 5, bottom: 8),
        child: Text(
          text,
          style: const TextStyle(
            color: Color(0xFF00FFA3),
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, IconData icon) {
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
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 18,
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
