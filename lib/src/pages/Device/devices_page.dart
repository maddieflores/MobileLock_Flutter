import 'package:flutter/material.dart';
// IMPORTANTE: Ruta correcta para acceder a las variables globales
import '../Profile/profile_page.dart';

class DevicesPage extends StatefulWidget {
  const DevicesPage({super.key});

  @override
  State<DevicesPage> createState() => _DevicesPageState();
}

class _DevicesPageState extends State<DevicesPage> {
  @override
  Widget build(BuildContext context) {
    // FILTRADO DINÁMICO:
    // Buscamos en la lista GLOBAL solo los dispositivos que coincidan con el correo actual
    final List<DeviceModel> userDevices = globalDevices
        .where(
          (device) =>
              device.ownerEmail.trim().toLowerCase() ==
              currentEmail.trim().toLowerCase(),
        )
        .toList();

    return Scaffold(
      backgroundColor: const Color(0xFF060B0C),
      body: Stack(
        children: [
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
                    _buildHeader(context),

                    Expanded(
                      child: userDevices.isEmpty
                          ? _buildEmptyState()
                          : ListView.builder(
                              physics: const BouncingScrollPhysics(),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 10,
                              ),
                              itemCount: userDevices.length,
                              itemBuilder: (context, index) =>
                                  _buildDeviceCard(userDevices[index]),
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

  // --- INTERFAZ CUANDO NO HAY DISPOSITIVOS ---
  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(25),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.02),
              ),
              child: Icon(
                Icons.phonelink_off_rounded,
                size: 80,
                color: Colors.white.withOpacity(0.05),
              ),
            ),
            const SizedBox(height: 25),
            const Text(
              'No hay dispositivos',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Aún no has registrado ningún equipo bajo la cuenta:\n$currentEmail',
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white38,
                fontSize: 13,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- ENCABEZADO CON EL BOTÓN "+" A LA DERECHA ---
  Widget _buildHeader(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.03),
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: Colors.white.withOpacity(0.08)),
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
          const SizedBox(width: 5),
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Mis',
                style: TextStyle(color: Color(0xFF00FFA3), fontSize: 14),
              ),
              Text(
                'Dispositivos',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  shadows: [Shadow(color: Color(0xFF00FFA3), blurRadius: 10)],
                ),
              ),
            ],
          ),
          const Spacer(),
          // Botón alineado a la derecha
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFF00FFA3).withOpacity(0.1),
              borderRadius: BorderRadius.circular(15),
            ),
            child: IconButton(
              icon: const Icon(Icons.add, color: Color(0xFF00FFA3), size: 28),
              onPressed: () => Navigator.pushNamed(context, '/register_device'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDeviceCard(DeviceModel device) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF0E1415),
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
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
              Icons.phone_android,
              color: Color(0xFF00FFA3),
              size: 30,
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  device.model,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'IMEI: ${device.imei}',
                  style: const TextStyle(color: Colors.white54, fontSize: 12),
                ),
                Text(
                  device.hardware,
                  style: const TextStyle(color: Colors.white38, fontSize: 11),
                ),
              ],
            ),
          ),
        ],
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
    for (double i = 0; i < size.width; i += 40)
      canvas.drawLine(Offset(i, 0), Offset(i, size.height), paint);
    for (double i = 0; i < size.height; i += 40)
      canvas.drawLine(Offset(0, i), Offset(size.width, i), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
