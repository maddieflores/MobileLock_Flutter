import 'package:flutter/material.dart';
import '../../../services/api_service.dart';
import '../Profile/profile_page.dart'; // Para acceder a globalToken e isLoggedIn

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int _selectedIndex = 0;
  
  // --- VARIABLES PARA LOS DISPOSITIVOS ---
  bool _isLoading = true;
  List<dynamic> _myDevices = []; // Aquí guardaremos los equipos de NeonDB

  @override
  void initState() {
    super.initState();
    _fetchDevices();
  }

  // --- FUNCIÓN PARA TRAER LOS DISPOSITIVOS DE NEONDB ---
  Future<void> _fetchDevices() async {
    if (isLoggedIn && globalToken.isNotEmpty) {
      final apiService = ApiService();
      final response = await apiService.getUserDevices(globalToken);

      if (mounted) {
        if (response != null && response.statusCode == 200) {
          setState(() {
            // Asignamos la lista que nos devuelve Django
            _myDevices = response.data;
            _isLoading = false;
          });
        } else {
          setState(() => _isLoading = false);
        }
      }
    } else {
      if (mounted) setState(() => _isLoading = false);
    }
  }

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

                          // --- SECCIÓN DINÁMICA: ESTADO DE VINCULACIÓN ---
                          if (_isLoading)
                            const Padding(
                              padding: EdgeInsets.all(40.0),
                              child: Center(
                                child: CircularProgressIndicator(color: Color(0xFF00FFA3)),
                              ),
                            )
                          else if (_myDevices.isEmpty)
                            _buildEmptyDeviceCard()
                          else
                            _buildActiveDevicesList(),

                          const SizedBox(height: 30),

                          // --- SECCIÓN: MIS DISPOSITIVOS ---
                          _buildSectionHeader(
                            'Gestión de Equipos',
                            'Añadir equipo', // Nuevo texto
                            onActionTap: () => Navigator.pushNamed(context, '/register_device'), // Acción
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
                                  // --- CONTADOR DINÁMICO ---
                                  'Total de dispositivos registrados: ${_myDevices.length}',
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
                                  _myDevices.isNotEmpty 
                                      ? 'Dispositivos sincronizados' 
                                      : 'Aún no tienes dispositivos registrados',
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

// ===========================================================================
  // LA TARJETA QUE MUESTRA TUS XIAOMI (CON IMEI VERTICAL Y ESCUDO BLOCKCHAIN)
  // ===========================================================================
  Widget _buildActiveDevicesList() {
    return Column(
      children: _myDevices.asMap().entries.map((entry) {
        
        int index = entry.key; 
        var device = entry.value; 

        String deviceName = device['marca_modelo'] ?? 'Dispositivo Móvil';
        String deviceImei = device['hash_imei'] ?? 'IMEI Desconocido';
        String deviceHardware = device['hash_adn_hardware'] ?? 'HASH_DESCONOCIDO';
        
        String etiquetaDispositivo = (index == 0) ? 'Dispositivo principal' : 'Dispositivo vinculado';
        
        return Container(
          margin: const EdgeInsets.only(bottom: 15),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF131D1F), Color(0xFF0E1415)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0xFF00FFA3).withOpacity(0.3)),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF00FFA3).withOpacity(0.05),
                blurRadius: 15,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Encabezado con Icono y Nombre
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFF00FFA3).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.smartphone_rounded, color: Color(0xFF00FFA3)),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          etiquetaDispositivo, 
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.5),
                            fontSize: 10,
                          ),
                        ),
                        Text(
                          deviceName, 
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: const Color(0xFF00FFA3).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: const Color(0xFF00FFA3).withOpacity(0.5)),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.shield_rounded, color: Color(0xFF00FFA3), size: 12),
                        SizedBox(width: 4),
                        Text(
                          'Seguro',
                          style: TextStyle(
                            color: Color(0xFF00FFA3),
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              
              // 2. Columna VERTICAL de IMEI y Hardware ID (Para mejor lectura)
              Column(
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.03),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      'IMEI: $deviceImei',
                      style: const TextStyle(color: Colors.white70, fontSize: 12),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.03),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      'Hardware ID: $deviceHardware',
                      style: const TextStyle(color: Colors.white70, fontSize: 12),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              
              // 3. Pie de la tarjeta: Certificado Blockchain (MÁS LIMPIO, TIPO WEB)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                decoration: BoxDecoration(
                  color: const Color(0xFF1A1F21),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text(
                      'Certificado Blockchain',
                      style: TextStyle(
                        color: Colors.white, 
                        fontWeight: FontWeight.bold, 
                        fontSize: 13,
                      ),
                    ),
                    // Escudo similar a tu imagen web
                    Icon(
                      Icons.verified_user_outlined, 
                      color: Color(0xFF00FFA3), 
                      size: 22,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
  // ===========================================================================

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

Widget _buildSectionHeader(String title, String actionText, {VoidCallback? onActionTap}) {
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
        if (actionText.isNotEmpty)
          InkWell(
            onTap: onActionTap, // <--- Ahora es clickeable
            borderRadius: BorderRadius.circular(20),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: Row(
                children: [
                  if (title == 'Gestión de Equipos') // Solo mostramos el '+' en esta sección
                    const Icon(Icons.add_circle_outline, color: Color(0xFF00FFA3), size: 14),
                  if (title == 'Gestión de Equipos')
                    const SizedBox(width: 4),
                  Text(
                    actionText,
                    style: TextStyle(
                      // Si es Gestión de equipos brilla en neón, sino se queda atenuado
                      color: title == 'Gestión de Equipos' ? const Color(0xFF00FFA3) : Colors.white.withOpacity(0.3),
                      fontSize: 12,
                      fontWeight: title == 'Gestión de Equipos' ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                ],
              ),
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