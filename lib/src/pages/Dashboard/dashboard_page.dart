import 'package:flutter/material.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF060B0C),
      body: Stack(
        children: [
          // 1. Fondo decorativo de cuadrícula
          Positioned.fill(child: CustomPaint(painter: GridPainter())),

          SafeArea(
            child: Align(
              alignment: Alignment.topCenter,
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 420),
                child: Column(
                  children: [
                    // Contenido principal con Scroll
                    Expanded(
                      child: ListView(
                        physics: const BouncingScrollPhysics(),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 20,
                        ),
                        children: [
                          // --- RECUADRO SUPERIOR (CABECERA) ---
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.03),
                              borderRadius: BorderRadius.circular(25),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.08),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Bienvenido de nuevo',
                                      style: TextStyle(
                                        color: Colors.white.withOpacity(0.5),
                                        fontSize: 13,
                                      ),
                                    ),
                                    const Text(
                                      'Mi Panel',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 26,
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
                                _buildNotificationIcon(),
                              ],
                            ),
                          ),

                          const SizedBox(height: 20),

                          // CARD: ESTADO DE VINCULACIÓN
                          _buildEmptyDeviceCard(),

                          const SizedBox(height: 30),

                          // --- SECCIÓN: MIS DISPOSITIVOS ---
                          _buildSectionHeader(
                            'Gestión de Equipos',
                            'Ver todos',
                          ),
                          const SizedBox(height: 15),
                          _buildDeviceAccessCard(),

                          const SizedBox(height: 30),

                          // --- SECCIÓN: ACCIONES RÁPIDAS (COMPLETA) ---
                          _buildSectionHeader(
                            'Acciones rápidas',
                            'Acceso inmediato',
                          ),
                          const SizedBox(height: 15),
                          _buildActionCard(
                            Icons.qr_code_scanner_rounded,
                            'Escanear',
                            'Revisa estado y sello del dispositivo',
                          ),
                          _buildActionCard(
                            Icons.report_problem_outlined,
                            'Reportar robo',
                            'Bloquea y avisa con un toque',
                            isWarning: true,
                          ),
                          _buildActionCard(
                            Icons.verified_user_rounded,
                            'Verificar',
                            'Confirma identidad y certificado',
                          ),
                          _buildActionCard(
                            Icons.storefront_outlined,
                            'Mercado',
                            'Explora equipos verificados',
                          ),

                          const SizedBox(height: 30),

                          // --- SECCIÓN: ACTIVIDAD RECIENTE ---
                          _buildSectionHeader('Actividad reciente', ''),
                          const SizedBox(height: 15),

                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: const Color(0xFF0E1415),
                              borderRadius: BorderRadius.circular(25),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.05),
                              ),
                            ),
                            child: Column(
                              children: [
                                _buildActivityItem(
                                  'Total de dispositivos registrados: 0',
                                  'Actualizado ahora',
                                ),
                                const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 12),
                                  child: Divider(
                                    color: Colors.white10,
                                    height: 1,
                                  ),
                                ),
                                _buildActivityItem(
                                  'Aún no tienes dispositivos registrados',
                                  'Sistema',
                                ),
                                const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 12),
                                  child: Divider(
                                    color: Colors.white10,
                                    height: 1,
                                  ),
                                ),
                                _buildActivityItem(
                                  'Sesión segura iniciada',
                                  'Hace unos minutos',
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 40),
                        ],
                      ),
                    ),

                    // Barra de navegación fija
                    _buildBottomNav(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- WIDGETS DE APOYO ---

  Widget _buildDeviceAccessCard() {
    return InkWell(
      onTap: () => Navigator.pushNamed(context, '/devices'),
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: const Color(0xFF0E1415),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFF00FFA3).withOpacity(0.2)),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF00FFA3).withOpacity(0.05),
              blurRadius: 15,
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFF00FFA3).withOpacity(0.1),
                borderRadius: BorderRadius.circular(15),
              ),
              child: const Icon(
                Icons.phonelink_setup_rounded,
                color: Color(0xFF00FFA3),
              ),
            ),
            const SizedBox(width: 15),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Mis Dispositivos',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    'Gestiona tus equipos vinculados',
                    style: TextStyle(color: Colors.white54, fontSize: 12),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios_rounded,
              color: Color(0xFF00FFA3),
              size: 16,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationIcon() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF0E1415),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: const Icon(
        Icons.notifications_none_rounded,
        color: Color(0xFF00FFA3),
      ),
    );
  }

  Widget _buildEmptyDeviceCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(30),
      decoration: BoxDecoration(
        color: const Color(0xFF0E1415),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.03),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.phonelink_erase_rounded,
              color: Colors.white.withOpacity(0.2),
              size: 40,
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Sin dispositivos vinculados',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Vincula tu smartphone para empezar a protegerlo con MobileLock AI',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white.withOpacity(0.4),
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 25),
          ElevatedButton(
            // --- CONEXIÓN AQUÍ: Navega a la página de registro ---
            onPressed: () => Navigator.pushNamed(context, '/register_device'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF00FFA3),
              foregroundColor: Colors.black,
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              elevation: 0,
            ),
            child: const Text(
              'Vincular ahora',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, String sub) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        if (sub.isNotEmpty)
          Text(
            sub,
            style: TextStyle(
              color: Colors.white.withOpacity(0.3),
              fontSize: 11,
            ),
          ),
      ],
    );
  }

  Widget _buildActionCard(
    IconData icon,
    String title,
    String subtitle, {
    bool isWarning = false,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
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
              color: isWarning
                  ? Colors.redAccent.withOpacity(0.1)
                  : const Color(0xFF1A2426),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: isWarning ? Colors.redAccent : const Color(0xFF00FFA3),
            ),
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
        ],
      ),
    );
  }

  Widget _buildActivityItem(String title, String subtitle) {
    return Row(
      children: [
        const Icon(
          Icons.access_time_rounded,
          color: Color(0xFF00FFA3),
          size: 18,
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
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                subtitle,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.3),
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBottomNav() {
    return Container(
      color: const Color(0xFF060B0C),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: Container(
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(color: Colors.white.withOpacity(0.05)),
              ),
            ),
            child: BottomNavigationBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              type: BottomNavigationBarType.fixed,
              currentIndex: _selectedIndex,
              selectedItemColor: const Color(0xFF00FFA3),
              unselectedItemColor: Colors.white30,
              selectedFontSize: 12,
              unselectedFontSize: 12,
              onTap: (index) {
                setState(() => _selectedIndex = index);
                if (index == 3) Navigator.pushNamed(context, '/profile');
              },
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.home_filled),
                  label: 'Inicio',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.search),
                  label: 'Buscar',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.shield_outlined),
                  label: 'Seguridad',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.person_outline),
                  label: 'Perfil',
                ),
              ],
            ),
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
      ..color = Colors.white.withOpacity(0.03)
      ..strokeWidth = 1.0;
    const double step = 40.0;
    for (double i = 0; i < size.width; i += step) {
      canvas.drawLine(Offset(i, 0), Offset(i, size.height), paint);
    }
    for (double i = 0; i < size.height; i += step) {
      canvas.drawLine(Offset(0, i), Offset(size.width, i), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
