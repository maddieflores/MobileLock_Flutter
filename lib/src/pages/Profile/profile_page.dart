import 'package:flutter/material.dart';
import '../../../services/api_service.dart';
import '../../../services/auth_storage.dart';
import '../../widgets/luminous_bottom_bar.dart';
import '../../widgets/luminous_app_bar.dart';

// --- MODELO DE DATOS PARA DISPOSITIVOS ---
class DeviceModel {
  final String ownerEmail;
  final String model;
  final String imei;
  final String hardware;

  DeviceModel({
    required this.ownerEmail,
    required this.model,
    required this.imei,
    required this.hardware,
  });
}

// --- VARIABLES GLOBALES DE SESIÓN ---
bool isLoggedIn = false;
String globalToken = "";
String currentEmail = "invitado@mail.com";
String currentName = "Cargando datos...";
String currentPlan = "Cargando plan...";

// --- LISTA GLOBAL DE DISPOSITIVOS ---
List<DeviceModel> globalDevices = [];

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final String userSince = "Abril 2026";
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();

    if (isLoggedIn && globalToken.isNotEmpty) {
      _fetchUserData();
    } else {
      _isLoading = false;
    }
  }

  Future<void> _fetchUserData() async {
    final apiService = ApiService();
    final response = await apiService.getUserProfile(globalToken);

    if (mounted) {
      if (response != null && response.statusCode == 200) {
        setState(() {
          final data = response.data;

          String nombres = data['nombres'] ?? data['first_name'] ?? "";
          String apPaterno =
              data['apellido_paterno'] ?? data['last_name'] ?? "";
          String apMaterno = data['apellido_materno'] ?? "";

          currentName = "$nombres $apPaterno $apMaterno".trim();
          if (currentName.isEmpty) currentName = "Usuario MobileLock";

          currentPlan = data['plan'] ?? "FREE • ACTIVO";
          _isLoading = false;
        });
      } else {
        setState(() {
          currentName = "Usuario MobileLock";
          currentPlan = "FREE • ACTIVO";
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Stack(
        children: [
          // Background atmospheric cyan square grid
          Positioned.fill(
            child: IgnorePointer(
              child: CustomPaint(
                painter: LuminousGridPainter(
                  lineColor: Theme.of(context).brightness == Brightness.dark
                      ? const Color(0xFF00F0FF).withValues(alpha: 0.04)
                      : const Color(0xFF0A7E8C).withValues(alpha: 0.04),
                  dotColor: Theme.of(context).brightness == Brightness.dark
                      ? Colors.white.withValues(alpha: 0.05)
                      : Colors.black.withValues(alpha: 0.04),
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
                  if (isLoggedIn)
                    const LuminousAppBar(
                      title: 'Perfil de Usuario',
                      showLogo: false,
                      showThemeToggle: false,
                    ),
                  Expanded(
                    child: SafeArea(
                      top: !isLoggedIn,
                      bottom: false,
                      child: !isLoggedIn
                          ? _buildEmptyState()
                          : (_isLoading
                                ? _buildLoading()
                                : _buildProfileContent()),
                    ),
                  ),
                  _buildBottomNav(context),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoading() {
    return const Center(
      child: CircularProgressIndicator(color: Color(0xFF00F0FF)),
    );
  }

  Widget _buildEmptyState() {
    final onSurface = Theme.of(context).colorScheme.onSurface;
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: onSurface.withValues(alpha: 0.02),
                border: Border.all(color: onSurface.withValues(alpha: 0.05)),
              ),
              child: Icon(
                Icons.lock_person_outlined,
                size: 80,
                color: onSurface.withValues(alpha: 0.1),
              ),
            ),
            const SizedBox(height: 30),
            Text(
              'Perfil No Disponible',
              style: TextStyle(
                color: onSurface,
                fontFamily: 'Space Grotesk',
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Debes iniciar sesión en MobileLock AI para gestionar tu cuenta.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: onSurface.withValues(alpha: 0.4),
                fontFamily: 'Space Grotesk',
                fontSize: 14,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 40),
            Container(
              height: 55,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                gradient: LinearGradient(
                  colors: [
                    Theme.of(context).colorScheme.primary,
                    Theme.of(context).brightness == Brightness.dark
                        ? const Color(0xFF008AA3)
                        : const Color(0xFF0A7E8C),
                  ],
                ),
              ),
              child: ElevatedButton(
                onPressed: () => Navigator.pushNamed(context, '/login'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  foregroundColor: Colors.white,
                  shadowColor: Colors.transparent,
                  minimumSize: const Size(200, 55),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'INICIAR SESIÓN',
                  style: TextStyle(
                    fontFamily: 'Space Grotesk',
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.0,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileContent() {
    return ListView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
      children: [
        _buildHeader(),
        const SizedBox(height: 35),
        _buildSectionHeader('Información General'),
        const SizedBox(height: 15),
        _buildInfoCard(),
        const SizedBox(height: 35),
        _buildSectionHeader('Ajustes de Cuenta'),
        const SizedBox(height: 15),
        _buildActionCard(
          Icons.manage_accounts_outlined,
          'Editar Perfil',
          'Nombre, correo y más',
          onTap: () => Navigator.pushNamed(context, '/edit_profile'),
        ),
        _buildActionCard(
          Icons.lock_outline_rounded,
          'Cambiar Contraseña',
          'Actualiza tus credenciales',
          onTap: () => Navigator.pushNamed(context, '/change_password'),
        ),
        const SizedBox(height: 35),
        _buildLogoutButton(),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildHeader() {
    final primaryColor = Theme.of(context).colorScheme.primary;
    final onSurface = Theme.of(context).colorScheme.onSurface;
    return Column(
      children: [
        const SizedBox(height: 10),
        Center(
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: primaryColor, width: 1.5),
                  boxShadow: [
                    BoxShadow(
                      color: primaryColor.withValues(alpha: 0.15),
                      blurRadius: 15,
                    ),
                  ],
                ),
                child: Icon(
                  Icons.person_outline_rounded,
                  color: primaryColor,
                  size: 50,
                ),
              ),
              Positioned(
                bottom: -5,
                right: -5,
                child: Container(
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: primaryColor,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check_rounded,
                    color: Colors.white,
                    size: 16,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        Text(
          currentName,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: onSurface,
            fontFamily: 'Space Grotesk',
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          currentEmail,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: onSurface.withValues(alpha: 0.6),
            fontFamily: 'Space Grotesk',
            fontSize: 13,
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }

  Widget _buildSectionHeader(String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        title.toUpperCase(),
        style: TextStyle(
          color: Theme.of(context).colorScheme.primary,
          fontFamily: 'Space Grotesk',
          fontSize: 11,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.5,
        ),
      ),
    );
  }

  Widget _buildInfoCard() {
    final onSurface = Theme.of(context).colorScheme.onSurface;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 22),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Theme.of(context).brightness == Brightness.dark
              ? Colors.white.withValues(alpha: 0.08)
              : Colors.black.withValues(alpha: 0.08),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(
              alpha: Theme.of(context).brightness == Brightness.dark
                  ? 0.2
                  : 0.04,
            ),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(
                Icons.shield_outlined,
                color: onSurface.withValues(alpha: 0.7),
                size: 22,
              ),
              const SizedBox(width: 16),
              Text(
                'Estado del Plan',
                style: TextStyle(
                  color: onSurface,
                  fontFamily: 'Space Grotesk',
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Spacer(),
              Text(
                currentPlan.toUpperCase(),
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontFamily: 'Space Grotesk',
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Divider(
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.white10
                : Colors.black.withValues(alpha: 0.06),
            height: 1,
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              Icon(
                Icons.calendar_today_outlined,
                color: onSurface.withValues(alpha: 0.7),
                size: 20,
              ),
              const SizedBox(width: 16),
              Text(
                'Miembro desde',
                style: TextStyle(
                  color: onSurface,
                  fontFamily: 'Space Grotesk',
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Spacer(),
              Text(
                userSince,
                style: TextStyle(
                  color: onSurface.withValues(alpha: 0.7),
                  fontFamily: 'Space Grotesk',
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionCard(
    IconData icon,
    String title,
    String subtitle, {
    required VoidCallback onTap,
  }) {
    final onSurface = Theme.of(context).colorScheme.onSurface;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Theme.of(context).brightness == Brightness.dark
              ? Colors.white.withValues(alpha: 0.08)
              : Colors.black.withValues(alpha: 0.08),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(
              alpha: Theme.of(context).brightness == Brightness.dark
                  ? 0.2
                  : 0.04,
            ),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Icon(
                  icon,
                  color: Theme.of(context).colorScheme.primary,
                  size: 24,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          color: onSurface,
                          fontFamily: 'Space Grotesk',
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        style: TextStyle(
                          color: onSurface.withValues(alpha: 0.4),
                          fontFamily: 'Space Grotesk',
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.chevron_right_rounded,
                  color: onSurface.withValues(alpha: 0.3),
                  size: 22,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLogoutButton() {
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
        onPressed: () async {
          await AuthStorage.deleteToken();
          if (!mounted) return;
          setState(() {
            isLoggedIn = false;
            globalToken = "";
            currentName = "Usuario";
            currentEmail = "invitado@mail.com";
          });
          Navigator.pushNamedAndRemoveUntil(
            context,
            '/login',
            (route) => false,
          );
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
            Icon(Icons.logout_rounded, size: 20, color: Colors.white),
            SizedBox(width: 8),
            Text(
              'Cerrar Sesión',
              style: TextStyle(
                fontFamily: 'Space Grotesk',
                fontWeight: FontWeight.bold,
                fontSize: 16,
                letterSpacing: 1.0,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNav(BuildContext context) {
    return LuminousBottomBar(
      currentIndex: 3,
      onTap: (index) {
        if (index == 0) {
          Navigator.pop(context);
        } else if (index == 1) {
          Navigator.pushNamed(context, '/register_device');
        } else if (index == 2) {
          Navigator.pop(context, 'show_report');
        }
      },
    );
  }
}

class LuminousGridPainter extends CustomPainter {
  final Color lineColor;
  final Color dotColor;

  LuminousGridPainter({required this.lineColor, required this.dotColor});

  @override
  void paint(Canvas canvas, Size size) {
    final linePaint = Paint()
      ..color = lineColor
      ..strokeWidth = 0.8;
    final dotPaint = Paint()
      ..color = dotColor
      ..style = PaintingStyle.fill;

    const double step = 25.0;
    // Draw cyan lines grid
    for (double i = 0; i < size.width; i += step) {
      canvas.drawLine(Offset(i, 0), Offset(i, size.height), linePaint);
    }
    for (double j = 0; j < size.height; j += step) {
      canvas.drawLine(Offset(0, j), Offset(size.width, j), linePaint);
    }
    // Draw dot grid
    for (double i = 0; i < size.width; i += step) {
      for (double j = 0; j < size.height; j += step) {
        canvas.drawCircle(Offset(i, j), 0.8, dotPaint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
