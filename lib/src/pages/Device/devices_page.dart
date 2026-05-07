import 'package:flutter/material.dart';
import '../../../services/api_service.dart';
import '../Profile/profile_page.dart';

class DevicesPage extends StatefulWidget {
  const DevicesPage({super.key});

  @override
  State<DevicesPage> createState() => _DevicesPageState();
}

class _DevicesPageState extends State<DevicesPage> {
  bool _isLoading = true;
  List<dynamic> _myDevices = [];

  @override
  void initState() {
    super.initState();
    _fetchDevices();
  }

  Future<void> _fetchDevices() async {
    if (isLoggedIn && globalToken.isNotEmpty) {
      final apiService = ApiService();
      final response = await apiService.getUserDevices(globalToken);

      if (mounted) {
        if (response != null && response.statusCode == 200) {
          setState(() {
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
          Positioned.fill(child: CustomPaint(painter: GridPainter())),
          SafeArea(
            child: Align(
              alignment: Alignment.topCenter,
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 420),
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: _buildHeader(context),
                    ),
                    const SizedBox(height: 30),
                    Expanded(
                      child: _isLoading
                          ? const Center(child: CircularProgressIndicator(color: Color(0xFF00FFA3)))
                          : _myDevices.isEmpty
                              ? _buildEmptyState()
                              : _buildDevicesList(),
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

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      decoration: BoxDecoration(
        color: const Color(0xFF0E1415),
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              ),
              const SizedBox(width: 5),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Mis', style: TextStyle(color: Color(0xFF00FFA3), fontSize: 12, fontWeight: FontWeight.bold)),
                  Text('Dispositivos', style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold, shadows: [Shadow(color: Color(0xFF00FFA3), blurRadius: 10)])),
                ],
              ),
            ],
          ),
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFF1A2426),
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
              icon: const Icon(Icons.add, color: Color(0xFF00FFA3)),
              onPressed: () => Navigator.pushNamed(context, '/register_device'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(30),
            decoration: BoxDecoration(
                shape: BoxShape.circle, 
                color: Colors.white.withValues(alpha: 0.02), 
                border: Border.all(color: Colors.white.withValues(alpha: 0.05))
            ),
            child: Icon(Icons.phonelink_erase_rounded, size: 80, color: Colors.white.withValues(alpha: 0.1)),
          ),
          const SizedBox(height: 30),
          const Text('No hay dispositivos', style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
          const SizedBox(height: 15),
          Text(
            'Aún no has registrado ningún equipo bajo la cuenta:\n$currentEmail', 
            textAlign: TextAlign.center, 
            style: TextStyle(color: Colors.white.withValues(alpha: 0.4), fontSize: 14, height: 1.5)
          ),
        ],
      ),
    );
  }

  Widget _buildDevicesList() {
    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      itemCount: _myDevices.length,
      itemBuilder: (context, index) {
        var device = _myDevices[index];
        String deviceName = device['marca_modelo'] ?? 'Dispositivo Móvil';
        String deviceImei = device['hash_imei'] ?? 'IMEI Desconocido';
        String deviceHardware = device['hash_adn_hardware'] ?? 'HASH_DESCONOCIDO';

        return Container(
          margin: const EdgeInsets.only(bottom: 20),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: const Color(0xFF131D1F),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 55,
                height: 55,
                decoration: BoxDecoration(
                  color: const Color(0xFF00FFA3).withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(
                  Icons.smartphone_rounded,
                  color: Color(0xFF00FFA3),
                  size: 28,
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(deviceName, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                    const SizedBox(height: 4),
                    Text('IMEI: $deviceImei', style: TextStyle(color: Colors.white.withValues(alpha: 0.5), fontSize: 11)),
                    Text('Hardware: $deviceHardware', style: TextStyle(color: Colors.white.withValues(alpha: 0.3), fontSize: 10), overflow: TextOverflow.ellipsis),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Column(
                children: [
                  _buildActionButton('Editar', const Color(0xFFFFC107), Icons.edit_outlined),
                  const SizedBox(height: 8),
                  _buildActionButton('Eliminar', const Color(0xFFFF4B4B), Icons.delete_outline),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildActionButton(String label, Color color, IconData icon) {
    // Definimos el color del texto/icono una sola vez para evitar repetición
    final Color contentColor = color == const Color(0xFFFFC107) ? Colors.black : Colors.white;
    
    return Container(
      width: 90,
      height: 32,
      decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(8)),
      alignment: Alignment.center,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 14, color: contentColor),
          const SizedBox(width: 4),
          Text(label, style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: contentColor)),
        ],
      ),
    );
  }
}

class GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.white.withValues(alpha: 0.03)..strokeWidth = 1.0;
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