import 'package:flutter/material.dart';
import '../../../services/api_service.dart';
import '../Profile/profile_page.dart';
import 'register_device_page.dart';

class DevicesPage extends StatefulWidget {
  const DevicesPage({super.key});

  @override
  State<DevicesPage> createState() => _DevicesPageState();
}

class _DevicesPageState extends State<DevicesPage> {
  bool _isLoading = true;
  List<dynamic> _myDevices = [];
  final TextEditingController _searchController = TextEditingController();
  String _selectedStatusFilter = 'TODOS';

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() => setState(() {}));
    _fetchDevices();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
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
          Positioned.fill(
            child: CustomPaint(
              painter: GridPainter(
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.white.withValues(alpha: 0.03)
                    : Colors.black.withValues(alpha: 0.03),
              ),
            ),
          ),
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
                    const SizedBox(height: 20),
                    if (!_isLoading && _myDevices.isNotEmpty) ...[
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: _buildSearchBar(),
                      ),
                      const SizedBox(height: 15),
                      Padding(
                        padding: const EdgeInsets.only(left: 20),
                        child: _buildFilterChips(),
                      ),
                      const SizedBox(height: 15),
                    ] else ...[
                      const SizedBox(height: 10),
                    ],
                    Expanded(
                      child: _isLoading
                          ? Center(
                              child: CircularProgressIndicator(
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            )
                          : _myDevices.isEmpty
                          ? _buildEmptyState()
                          : _getFilteredDevices().isEmpty
                          ? _buildNoFilteredResultsState()
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
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
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
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Mis',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Dispositivos',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurface,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      shadows: [
                        Shadow(
                          color: Theme.of(
                            context,
                          ).colorScheme.primary.withValues(alpha: 0.5),
                          blurRadius: 10,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
              icon: Icon(
                Icons.add,
                color: Theme.of(context).colorScheme.primary,
              ),
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
              color: Theme.of(
                context,
              ).colorScheme.onSurface.withValues(alpha: 0.02),
              border: Border.all(
                color: Theme.of(
                  context,
                ).colorScheme.onSurface.withValues(alpha: 0.05),
              ),
            ),
            child: Icon(
              Icons.phonelink_erase_rounded,
              size: 80,
              color: Theme.of(
                context,
              ).colorScheme.onSurface.withValues(alpha: 0.1),
            ),
          ),
          const SizedBox(height: 30),
          Text(
            'No hay dispositivos',
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurface,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 15),
          Text(
            'Aún no has registrado ningún equipo bajo la cuenta:\n$currentEmail',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Theme.of(
                context,
              ).colorScheme.onSurface.withValues(alpha: 0.4),
              fontSize: 14,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDevicesList() {
    final filteredList = _getFilteredDevices();
    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      itemCount: filteredList.length,
      itemBuilder: (context, index) {
        var device = filteredList[index];
        String deviceName = device['marca_modelo'] ?? 'Dispositivo Móvil';
        String deviceImei = device['hash_imei'] ?? 'IMEI Desconocido';
        String deviceHardware =
            device['hash_adn_hardware'] ?? 'HASH_DESCONOCIDO';

        return Container(
          margin: const EdgeInsets.only(bottom: 20),
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
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
                  color: Theme.of(
                    context,
                  ).colorScheme.primary.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(
                  Icons.smartphone_rounded,
                  color: Theme.of(context).colorScheme.primary,
                  size: 28,
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            deviceName,
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onSurface,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        const SizedBox(width: 4),
                        _buildStatusBadge(device['estado'] ?? 'LIBRE'),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'IMEI: $deviceImei',
                      style: TextStyle(
                        color: Theme.of(
                          context,
                        ).colorScheme.onSurface.withValues(alpha: 0.5),
                        fontSize: 11,
                      ),
                    ),
                    Text(
                      'Hardware: $deviceHardware',
                      style: TextStyle(
                        color: Theme.of(
                          context,
                        ).colorScheme.onSurface.withValues(alpha: 0.3),
                        fontSize: 10,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    _buildVisualHashBadge(device['hash_visual']),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Column(
                children: [
                  _buildActionButton(
                    'Editar',
                    const Color(0xFFFFC107),
                    Icons.edit_outlined,
                    () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              RegisterDevicePage(deviceToEdit: device),
                        ),
                      );
                      _fetchDevices(); // Recargar la lista después de editar
                    },
                  ),
                  const SizedBox(height: 8),
                  _buildActionButton(
                    'Eliminar',
                    const Color(0xFFFF4B4B),
                    Icons.delete_outline,
                    () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Eliminación disponible en la plataforma web.',
                          ),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildActionButton(
    String label,
    Color color,
    IconData icon,
    VoidCallback onTap,
  ) {
    // Definimos el color del texto/icono una sola vez para evitar repetición
    final Color contentColor = color == const Color(0xFFFFC107)
        ? Colors.black
        : Colors.white;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 90,
        height: 32,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(8),
        ),
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 14, color: contentColor),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: contentColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    Color badgeColor;
    Color textColor;
    String label;

    if (status == 'LIBRE') {
      badgeColor = const Color(0xFF10B981).withValues(alpha: 0.15);
      textColor = const Color(0xFF10B981);
      label = 'Seguro';
    } else if (status == 'ROBADO') {
      badgeColor = Colors.red.withValues(alpha: 0.15);
      textColor = Colors.red;
      label = 'Robado';
    } else {
      badgeColor = Colors.amber.withValues(alpha: 0.15);
      textColor = Colors.amber;
      label = 'Extraviado';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: badgeColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: textColor.withValues(alpha: 0.3)),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: textColor,
          fontSize: 9,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildVisualHashBadge(String? hashVisual) {
    final bool hasHash = hashVisual != null && hashVisual.isNotEmpty;
    final Color badgeColor = hasHash
        ? const Color(0xFF14B8A6).withValues(alpha: 0.15)
        : Colors.orange.withValues(alpha: 0.15);
    final Color textColor = hasHash ? const Color(0xFF14B8A6) : Colors.orange;
    final String label = hasHash ? 'Huella registrada ✅' : 'Sin huella ⚠️';

    return Container(
      margin: const EdgeInsets.only(top: 6),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: badgeColor,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: textColor.withValues(alpha: 0.25)),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: textColor,
          fontSize: 8.5,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  void _showReportBottomSheet(
    BuildContext context,
    Map<String, dynamic> device,
  ) {
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
                  'Estado de Seguridad',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                Text(
                  'Selecciona el estado para: ${device['marca_modelo']}',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.6),
                    fontSize: 13,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                _buildReportOption(
                  context,
                  label: 'Seguro (LIBRE)',
                  desc: 'El equipo está seguro en tu posesión.',
                  color: const Color(0xFF10B981),
                  onTap: () =>
                      _updateDeviceState(device['id_dispositivo'], 'LIBRE'),
                ),
                const SizedBox(height: 12),
                _buildReportOption(
                  context,
                  label: 'Reportado como ROBADO',
                  desc: 'El equipo fue robado y quieres bloquearlo.',
                  color: Colors.redAccent,
                  onTap: () =>
                      _updateDeviceState(device['id_dispositivo'], 'ROBADO'),
                ),
                const SizedBox(height: 12),
                _buildReportOption(
                  context,
                  label: 'Reportado como EXTRAVIADO',
                  desc: 'Perdiste el equipo y quieres alertar.',
                  color: Colors.amber,
                  onTap: () => _updateDeviceState(
                    device['id_dispositivo'],
                    'EXTRAVIADO',
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildReportOption(
    BuildContext context, {
    required String label,
    required String desc,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: () {
        Navigator.pop(context);
        onTap();
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.05),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withOpacity(0.2)),
        ),
        child: Row(
          children: [
            Icon(Icons.shield_outlined, color: color, size: 24),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      color: color,
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    desc,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.5),
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
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
      }
    }
  }

  Widget _buildSearchBar() {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: TextField(
        controller: _searchController,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: 'Buscar por marca, modelo o IMEI...',
          hintStyle: TextStyle(
            color: Colors.white.withValues(alpha: 0.2),
            fontSize: 13,
          ),
          prefixIcon: Icon(
            Icons.search,
            color: Theme.of(context).colorScheme.primary,
            size: 20,
          ),
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(
                    Icons.clear_rounded,
                    color: Colors.white30,
                    size: 18,
                  ),
                  onPressed: () {
                    _searchController.clear();
                  },
                )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            vertical: 15,
            horizontal: 10,
          ),
        ),
      ),
    );
  }

  Widget _buildFilterChips() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        children: [
          _buildFilterChip('Todos', 'TODOS', const Color(0xFF00CEE6)),
          const SizedBox(width: 10),
          _buildFilterChip('Seguro', 'LIBRE', const Color(0xFF10B981)),
          const SizedBox(width: 10),
          _buildFilterChip('Robado', 'ROBADO', Colors.redAccent),
          const SizedBox(width: 10),
          _buildFilterChip('Extraviado', 'EXTRAVIADO', Colors.amber),
          const SizedBox(width: 20),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, String value, Color activeColor) {
    final bool isSelected = _selectedStatusFilter == value;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedStatusFilter = value;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? activeColor.withValues(alpha: 0.15)
              : Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? activeColor
                : Colors.white.withValues(alpha: 0.05),
            width: isSelected ? 1.5 : 1.0,
          ),
        ),
        child: Row(
          children: [
            if (isSelected) ...[
              Icon(Icons.check, color: activeColor, size: 14),
              const SizedBox(width: 6),
            ],
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.white60,
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<dynamic> _getFilteredDevices() {
    final query = _searchController.text.trim().toLowerCase();
    return _myDevices.where((device) {
      final name = (device['marca_modelo'] ?? '').toString().toLowerCase();
      final imei = (device['hash_imei'] ?? '').toString().toLowerCase();
      final status = (device['estado'] ?? 'LIBRE').toString();

      final matchesSearch = name.contains(query) || imei.contains(query);
      final matchesStatus =
          _selectedStatusFilter == 'TODOS' || status == _selectedStatusFilter;

      return matchesSearch && matchesStatus;
    }).toList();
  }

  Widget _buildNoFilteredResultsState() {
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
                Icons.search_off_rounded,
                size: 60,
                color: onSurface.withValues(alpha: 0.2),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Sin coincidencias',
              style: TextStyle(
                color: onSurface,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'No se encontraron dispositivos que coincidan con la búsqueda o el filtro de estado seleccionado.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: onSurface.withValues(alpha: 0.4),
                fontSize: 13,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 20),
            TextButton(
              onPressed: () {
                setState(() {
                  _searchController.clear();
                  _selectedStatusFilter = 'TODOS';
                });
              },
              child: Text(
                'Limpiar filtros',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
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
