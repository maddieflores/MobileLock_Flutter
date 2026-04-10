import 'package:flutter/material.dart';

// --- MODELO DE DATOS PARA DISPOSITIVOS ---
// Definido aquí para que sea accesible globalmente en toda la app
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
// Estas variables mantienen los datos vivos mientras la app esté abierta
bool isLoggedIn = false;
String currentEmail = "invitado@mail.com";
String currentName = "Usuario";

// --- LISTA GLOBAL DE DISPOSITIVOS ---
// Aquí se guardarán todos los equipos sin borrarse al navegar
List<DeviceModel> globalDevices = [];

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final String userSince = "Abril 2026";

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
            child: Align(
              alignment: Alignment.topCenter,
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 420),
                child: Column(
                  children: [
                    Expanded(
                      child: !isLoggedIn
                          ? _buildEmptyState()
                          : _buildProfileContent(),
                    ),
                    _buildBottomNav(context),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- INTERFAZ CUANDO NO HAY SESIÓN ---
  Widget _buildEmptyState() {
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
                color: Colors.white.withOpacity(0.02),
                border: Border.all(color: Colors.white.withOpacity(0.05)),
              ),
              child: Icon(
                Icons.lock_person_outlined,
                size: 80,
                color: Colors.white.withOpacity(0.1),
              ),
            ),
            const SizedBox(height: 30),
            const Text(
              'Perfil No Disponible',
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Debes iniciar sesión en MobileLock AI para gestionar tu cuenta.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white.withOpacity(0.4),
                fontSize: 14,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/login'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF00FFA3),
                foregroundColor: Colors.black,
                minimumSize: const Size(200, 55),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              child: const Text(
                'INICIAR SESIÓN',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- INTERFAZ CON SESIÓN ACTIVA ---
  Widget _buildProfileContent() {
    return ListView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      children: [
        _buildHeader(),
        const SizedBox(height: 30),
        _buildSectionHeader('Información General'),
        const SizedBox(height: 15),
        _buildInfoCard(),
        const SizedBox(height: 30),
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
        const SizedBox(height: 30),
        _buildLogoutButton(),
        const SizedBox(height: 40),
      ],
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.03),
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: Colors.white.withOpacity(0.08)),
      ),
      child: Column(
        children: [
          CircleAvatar(
            radius: 40,
            backgroundColor: Colors.black.withOpacity(0.3),
            child: const Icon(Icons.person, color: Color(0xFF00FFA3), size: 50),
          ),
          const SizedBox(height: 15),
          Text(
            currentName,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
              shadows: [Shadow(color: Color(0xFF00FFA3), blurRadius: 10)],
            ),
          ),
          Text(
            currentEmail,
            style: TextStyle(
              color: Colors.white.withOpacity(0.6),
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) => Text(
    title,
    style: const TextStyle(
      color: Colors.white,
      fontSize: 18,
      fontWeight: FontWeight.bold,
    ),
  );

  Widget _buildInfoCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF0E1415),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Column(
        children: [
          _buildInfoItem(
            Icons.calendar_today_outlined,
            'Miembro desde',
            userSince,
          ),
          const Divider(color: Colors.white10, height: 25),
          _buildInfoItem(Icons.security_outlined, 'Nivel de Seguridad', 'Alto'),
        ],
      ),
    );
  }

  Widget _buildInfoItem(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, color: const Color(0xFF00FFA3), size: 18),
        const SizedBox(width: 15),
        Text(
          label,
          style: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 14),
        ),
        const Spacer(),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildActionCard(
    IconData icon,
    String title,
    String subtitle, {
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFF0E1415),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white.withOpacity(0.05)),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1A2426),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: const Color(0xFF00FFA3)),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                      Text(
                        subtitle,
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.4),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: Colors.white.withOpacity(0.2),
                  size: 16,
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
      width: double.infinity,
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
          setState(() {
            isLoggedIn = false;
            currentName = "Usuario";
            currentEmail = "invitado@mail.com";
            // Nota: globalDevices NO se borra aquí para que otros usuarios
            // mantengan sus datos al re-entrar.
          });
          Navigator.pushNamedAndRemoveUntil(
            context,
            '/login',
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
          'Cerrar Sesión',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ),
    );
  }

  Widget _buildBottomNav(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: const Color(0xFF060B0C),
      elevation: 0,
      type: BottomNavigationBarType.fixed,
      currentIndex: 3,
      selectedItemColor: const Color(0xFF00FFA3),
      unselectedItemColor: Colors.white30,
      onTap: (index) {
        if (index == 0) Navigator.pushReplacementNamed(context, '/dashboard');
      },
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: 'Inicio'),
        BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Buscar'),
        BottomNavigationBarItem(
          icon: Icon(Icons.shield_outlined),
          label: 'Seguridad',
        ),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Perfil'),
      ],
    );
  }
}

class GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.03)
      ..strokeWidth = 1.0;
    for (double i = 0; i < size.width; i += 40)
      canvas.drawLine(Offset(i, 0), Offset(i, size.height), paint);
    for (double i = 0; i < size.height; i += 40)
      canvas.drawLine(Offset(0, i), Offset(size.width, i), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
