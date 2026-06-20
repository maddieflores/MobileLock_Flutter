import 'package:flutter/material.dart';
import '../../../services/api_service.dart';
import '../Profile/profile_page.dart';
import '../../../main.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int _selectedIndex = 0;

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
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
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
                    Expanded(
                      child: ListView(
                        physics: const BouncingScrollPhysics(),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 20,
                        ),
                        children: [
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              // CAMBIO: withValues
                              color: Colors.white.withValues(alpha: 0.03),
                              borderRadius: BorderRadius.circular(25),
                              border: Border.all(
                                color: Colors.white.withValues(alpha: 0.08),
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
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurface
                                            .withValues(alpha: 0.5),
                                        fontSize: 13,
                                      ),
                                    ),
                                    Text(
                                      'Mi Panel',
                                      style: TextStyle(
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.onSurface,
                                        fontSize: 26,
                                        fontWeight: FontWeight.bold,
                                        shadows: [
                                          Shadow(
                                            color: Theme.of(
                                              context,
                                            ).colorScheme.primary,
                                            blurRadius: 10,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    ValueListenableBuilder<ThemeMode>(
                                      valueListenable: themeNotifier,
                                      builder: (context, currentMode, _) {
                                        final isDark =
                                            currentMode == ThemeMode.dark;
                                        return GestureDetector(
                                          onTap: () {
                                            themeNotifier.value = isDark
                                                ? ThemeMode.light
                                                : ThemeMode.dark;
                                          },
                                          child: Container(
                                            padding: const EdgeInsets.all(12),
                                            decoration: BoxDecoration(
                                              color: Theme.of(
                                                context,
                                              ).colorScheme.surface,
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                              border: Border.all(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .onSurface
                                                    .withValues(alpha: 0.05),
                                              ),
                                            ),
                                            child: Icon(
                                              isDark
                                                  ? Icons.light_mode
                                                  : Icons.dark_mode,
                                              color: Theme.of(
                                                context,
                                              ).colorScheme.primary,
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                    const SizedBox(width: 8),
                                    _buildNotificationIcon(),
                                  ],
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 20),

                          if (_isLoading)
                            Padding(
                              padding: EdgeInsets.all(40.0),
                              child: Center(
                                child: CircularProgressIndicator(
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                              ),
                            )
                          else if (_myDevices.isEmpty)
                            _buildEmptyDeviceCard()
                          else
                            _buildActiveDevicesList(),

                          const SizedBox(height: 30),

                          _buildSectionHeader(
                            'Gestión de Equipos',
                            'Añadir equipo',
                            onActionTap: () => Navigator.pushNamed(
                              context,
                              '/register_device',
                            ),
                          ),
                          const SizedBox(height: 15),
                          _buildDeviceAccessCard(),

                          const SizedBox(height: 30),

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
                            onTap: _showQuickReportBottomSheet,
                          ),
                          _buildActionCard(
                            Icons.verified_user_rounded,
                            'Verificar',
                            'Confirma identidad y certificado',
                            onTap: () =>
                                Navigator.pushNamed(context, '/verify_device'),
                          ),
                          _buildActionCard(
                            Icons.storefront_outlined,
                            'Mercado',
                            'Explora equipos verificados',
                          ),

                          const SizedBox(height: 30),

                          _buildSectionHeader('Actividad reciente', ''),
                          const SizedBox(height: 15),

                          Container(
                            width: double.infinity,
                            padding: EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.surface,
                              borderRadius: BorderRadius.circular(25),
                              border: Border.all(
                                color: Colors.white.withValues(alpha: 0.05),
                              ),
                            ),
                            child: Column(
                              children: [
                                _buildActivityItem(
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

  Widget _buildActiveDevicesList() {
    return Column(
      children: _myDevices.asMap().entries.map((entry) {
        int index = entry.key;
        var device = entry.value;

        String deviceName = device['marca_modelo'] ?? 'Dispositivo Móvil';
        String deviceImei = device['hash_imei'] ?? 'IMEI Desconocido';
        String deviceHardware =
            device['hash_adn_hardware'] ?? 'HASH_DESCONOCIDO';

        String etiquetaDispositivo = (index == 0)
            ? 'Dispositivo principal'
            : 'Dispositivo vinculado';

        return Container(
          margin: const EdgeInsets.only(bottom: 15),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: Theme.of(
                context,
              ).colorScheme.primary.withValues(alpha: 0.3),
            ),
            boxShadow: [
              BoxShadow(
                color: Theme.of(
                  context,
                ).colorScheme.primary.withValues(alpha: 0.05),
                blurRadius: 15,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Theme.of(
                        context,
                      ).colorScheme.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.smartphone_rounded,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          etiquetaDispositivo,
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.5),
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
                  _buildDashboardStatusBadge(device['estado'] ?? 'LIBRE'),
                ],
              ),
              const SizedBox(height: 20),

              Column(
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.03),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      'IMEI: $deviceImei',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.03),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      'Hardware ID: $deviceHardware',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.03),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Huella IA:',
                          style: TextStyle(color: Colors.white70, fontSize: 12),
                        ),
                        Text(
                          device['hash_visual'] != null &&
                                  (device['hash_visual'] as String).isNotEmpty
                              ? 'Registrada ✅'
                              : 'Sin Huella ⚠️',
                          style: TextStyle(
                            color:
                                device['hash_visual'] != null &&
                                    (device['hash_visual'] as String).isNotEmpty
                                ? const Color(0xFF14B8A6)
                                : Colors.orange,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),

              Container(
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Certificado Blockchain',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                    Icon(
                      Icons.verified_user_outlined,
                      color: Theme.of(context).colorScheme.primary,
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

  Widget _buildDeviceAccessCard() {
    return InkWell(
      onTap: () => Navigator.pushNamed(context, '/devices'),
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.2),
          ),
          boxShadow: [
            BoxShadow(
              color: Theme.of(
                context,
              ).colorScheme.primary.withValues(alpha: 0.05),
              blurRadius: 15,
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Theme.of(
                  context,
                ).colorScheme.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Icon(
                Icons.phonelink_setup_rounded,
                color: Theme.of(context).colorScheme.primary,
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
            Icon(
              Icons.arrow_forward_ios_rounded,
              color: Theme.of(context).colorScheme.primary,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationIcon() {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: Icon(
        Icons.notifications_none_rounded,
        color: Theme.of(context).colorScheme.primary,
      ),
    );
  }

  Widget _buildEmptyDeviceCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(30),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.03),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.phonelink_erase_rounded,
              color: Colors.white.withValues(alpha: 0.2),
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
              color: Colors.white.withValues(alpha: 0.4),
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 25),
          ElevatedButton(
            onPressed: () => Navigator.pushNamed(context, '/register_device'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.primary,
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

  Widget _buildSectionHeader(
    String title,
    String actionText, {
    VoidCallback? onActionTap,
  }) {
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
            onTap: onActionTap,
            borderRadius: BorderRadius.circular(20),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: Row(
                children: [
                  if (title == 'Gestión de Equipos')
                    Icon(
                      Icons.add_circle_outline,
                      color: Theme.of(context).colorScheme.primary,
                      size: 14,
                    ),
                  if (title == 'Gestión de Equipos') const SizedBox(width: 4),
                  Text(
                    actionText,
                    style: TextStyle(
                      color: title == 'Gestión de Equipos'
                          ? Theme.of(context).colorScheme.primary
                          : Colors.white.withValues(alpha: 0.3),
                      fontSize: 12,
                      fontWeight: title == 'Gestión de Equipos'
                          ? FontWeight.bold
                          : FontWeight.normal,
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
    VoidCallback? onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isWarning
                      ? Colors.redAccent.withValues(alpha: 0.1)
                      : Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: isWarning
                      ? Colors.redAccent
                      : Theme.of(context).colorScheme.primary,
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
                        color: Colors.white.withValues(alpha: 0.4),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActivityItem(String title, String subtitle) {
    return Row(
      children: [
        Icon(
          Icons.access_time_rounded,
          color: Theme.of(context).colorScheme.primary,
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
                  color: Colors.white.withValues(alpha: 0.3),
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDashboardStatusBadge(String status) {
    Color badgeColor;
    Color textColor;
    IconData icon;
    String label;

    if (status == 'LIBRE') {
      badgeColor = const Color(0xFF10B981).withValues(alpha: 0.15);
      textColor = const Color(0xFF10B981);
      icon = Icons.shield_rounded;
      label = 'Seguro';
    } else if (status == 'ROBADO') {
      badgeColor = Colors.red.withValues(alpha: 0.15);
      textColor = Colors.red;
      icon = Icons.gpp_bad_rounded;
      label = 'Robado';
    } else {
      badgeColor = Colors.amber.withValues(alpha: 0.15);
      textColor = Colors.amber;
      icon = Icons.warning_amber_rounded;
      label = 'Extraviado';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: badgeColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: textColor.withValues(alpha: 0.5)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: textColor, size: 12),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              color: textColor,
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  void _showQuickReportBottomSheet() {
    if (_myDevices.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No tienes dispositivos registrados para reportar.'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1c1c2a),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25),
          topRight: Radius.circular(25),
        ),
      ),
      builder: (BuildContext bc) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Reportar Robo',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                Text(
                  'Selecciona la acción para el equipo correspondiente:',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.6),
                    fontSize: 13,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                Flexible(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: _myDevices.length,
                    itemBuilder: (context, idx) {
                      final device = _myDevices[idx];
                      final String deviceName =
                          device['marca_modelo'] ?? 'Dispositivo';
                      final String estado = device['estado'] ?? 'LIBRE';
                      final int deviceId = device['id_dispositivo'];

                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.02),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.05),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    deviceName,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    estado == 'LIBRE'
                                        ? 'Seguro'
                                        : (estado == 'ROBADO'
                                              ? 'Robado'
                                              : 'Extraviado'),
                                    style: TextStyle(
                                      color: estado == 'LIBRE'
                                          ? const Color(0xFF10B981)
                                          : (estado == 'ROBADO'
                                                ? Colors.redAccent
                                                : Colors.amber),
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Row(
                              children: [
                                if (estado == 'LIBRE') ...[
                                  TextButton(
                                    onPressed: () async {
                                      Navigator.pop(context);
                                      final verificado =
                                          await _showPasswordConfirmationDialog(
                                            context,
                                          );
                                      if (verificado) {
                                        _updateDeviceState(deviceId, 'ROBADO');
                                      }
                                    },
                                    style: TextButton.styleFrom(
                                      foregroundColor: Colors.redAccent,
                                    ),
                                    child: const Text(
                                      'ROBO',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ] else ...[
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                      _updateDeviceState(deviceId, 'LIBRE');
                                    },
                                    style: TextButton.styleFrom(
                                      foregroundColor: const Color(0xFF10B981),
                                    ),
                                    child: const Text(
                                      'RECUPERAR',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _updateDeviceState(int deviceId, String newState) async {
    setState(() => _isLoading = true);
    final apiService = ApiService();
    final response = await apiService.reportDeviceState(
      globalToken,
      deviceId,
      newState,
    );

    if (mounted) {
      if (response != null && response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Estado actualizado a $newState exitosamente ✅'),
            backgroundColor: const Color(0xFF10B981),
            behavior: SnackBarBehavior.floating,
          ),
        );
        _fetchDevices();
      } else {
        setState(() => _isLoading = false);
        final errorMsg =
            response?.data?['detail'] ?? 'Error al actualizar el estado.';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMsg),
            backgroundColor: Colors.redAccent,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  Future<bool> _showPasswordConfirmationDialog(BuildContext context) async {
    final TextEditingController passwordController = TextEditingController();
    bool isVerifying = false;
    String? errorMessage;

    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              backgroundColor: const Color(0xFF1c1c2a),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide(color: Colors.white.withValues(alpha: 0.08)),
              ),
              title: Row(
                children: [
                  const Icon(Icons.shield_outlined, color: Colors.redAccent),
                  const SizedBox(width: 10),
                  Text(
                    'Confirmar Reporte de Robo',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Para reportar el equipo como ROBADO, introduce tu contraseña de acceso para confirmar tu identidad.',
                    style: const TextStyle(color: Colors.white70, fontSize: 13),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFF101415),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: errorMessage != null
                            ? Colors.redAccent
                            : Colors.white.withValues(alpha: 0.05),
                      ),
                    ),
                    child: TextField(
                      controller: passwordController,
                      obscureText: true,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: 'Contraseña de seguridad',
                        hintStyle: TextStyle(
                          color: Colors.white.withValues(alpha: 0.2),
                          fontSize: 13,
                        ),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 15,
                          vertical: 12,
                        ),
                      ),
                    ),
                  ),
                  if (errorMessage != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 8, left: 5),
                      child: Text(
                        errorMessage!,
                        style: const TextStyle(
                          color: Colors.redAccent,
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: isVerifying
                      ? null
                      : () => Navigator.pop(context, false),
                  child: const Text(
                    'Cancelar',
                    style: TextStyle(color: Colors.white54),
                  ),
                ),
                ElevatedButton(
                  onPressed: isVerifying
                      ? null
                      : () async {
                          final password = passwordController.text.trim();
                          if (password.isEmpty) {
                            setState(() {
                              errorMessage = 'Introduce tu contraseña';
                            });
                            return;
                          }
                          setState(() {
                            isVerifying = true;
                            errorMessage = null;
                          });

                          final apiService = ApiService();
                          final response = await apiService.login(
                            currentEmail,
                            password,
                          );

                          if (response != null && response.statusCode == 200) {
                            Navigator.pop(context, true);
                          } else {
                            setState(() {
                              isVerifying = false;
                              errorMessage = 'Contraseña incorrecta';
                            });
                          }
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: isVerifying
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : const Text(
                          'Confirmar',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                ),
              ],
            );
          },
        );
      },
    );

    passwordController.dispose();
    return result ?? false;
  }

  Widget _buildBottomNav() {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: Container(
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(color: Colors.white.withValues(alpha: 0.05)),
              ),
            ),
            child: BottomNavigationBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              type: BottomNavigationBarType.fixed,
              currentIndex: _selectedIndex,
              selectedItemColor: Theme.of(context).colorScheme.primary,
              unselectedItemColor: Colors.white30,
              selectedFontSize: 12,
              unselectedFontSize: 12,
              onTap: (index) async {
                if (index == 1) {
                  Navigator.pushNamed(context, '/register_device');
                  return;
                }
                if (index == 2) {
                  _showQuickReportBottomSheet();
                  return;
                }
                if (index == 3) {
                  final result = await Navigator.pushNamed(context, '/profile');
                  if (result == 'show_report') {
                    _showQuickReportBottomSheet();
                  }
                  return;
                }
                setState(() => _selectedIndex = index);
              },
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.home_filled),
                  label: 'Inicio',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.add_circle_outline_rounded),
                  label: 'Registrar',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.warning_amber_rounded),
                  label: 'Reportar Robo',
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
      ..color = Colors.white.withValues(alpha: 0.03)
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
