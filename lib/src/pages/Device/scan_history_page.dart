import 'package:flutter/material.dart';
import '../../../services/api_service.dart';
import '../Profile/profile_page.dart'; // Para globalToken

class ScanHistoryPage extends StatefulWidget {
  const ScanHistoryPage({super.key});

  @override
  State<ScanHistoryPage> createState() => _ScanHistoryPageState();
}

class _ScanHistoryPageState extends State<ScanHistoryPage> {
  bool _isLoading = true;
  List<dynamic> _history = [];
  final ApiService _apiService = ApiService();

  @override
  void initState() {
    super.initState();
    _fetchHistory();
  }

  Future<void> _fetchHistory() async {
    setState(() => _isLoading = true);
    try {
      final response = await _apiService.getScanHistory(globalToken);
      if (response != null && response.statusCode == 200) {
        setState(() {
          _history = response.data;
          _isLoading = false;
        });
      } else {
        setState(() => _isLoading = false);
      }
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  String _formatDate(String dateString) {
    try {
      final DateTime dt = DateTime.parse(dateString).toLocal();
      // Formato básico de fecha
      return '${dt.day}/${dt.month}/${dt.year} - ${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
    } catch (e) {
      return dateString;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text(
          'Historial de Consultas',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Theme.of(context).colorScheme.primary),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 0,
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator(color: Theme.of(context).colorScheme.primary))
          : RefreshIndicator(
              onRefresh: _fetchHistory,
              color: Theme.of(context).colorScheme.primary,
              backgroundColor: Theme.of(context).colorScheme.surface,
              child: _history.isEmpty ? _buildEmptyState() : _buildHistoryList(),
            ),
    );
  }

  Widget _buildEmptyState() {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      children: [
        SizedBox(height: MediaQuery.of(context).size.height * 0.25),
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(25),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.02),
                  border: Border.all(color: Colors.white.withOpacity(0.05)),
                ),
                child: Icon(Icons.history_toggle_off_outlined, size: 70, color: Colors.white.withOpacity(0.2)),
              ),
              const SizedBox(height: 25),
              const Text(
                'Sin búsquedas registradas',
                style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Text(
                'Tus consultas e imágenes QR escaneadas aparecerán aquí.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white.withOpacity(0.4), fontSize: 13),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildHistoryList() {
    return ListView.builder(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      itemCount: _history.length,
      itemBuilder: (context, index) {
        final scan = _history[index];
        final tipo = scan['tipo_filtro'] ?? 'IMEI';
        final valor = scan['valor_consultado_ofuscado'] ?? '';
        final estado = scan['resultado_estado'] ?? 'NO_REGISTRADO';
        final modelo = scan['marca_modelo_detectado'] ?? 'Dispositivo Desconocido';
        final fecha = scan['fecha_consulta'] ?? '';

        Color badgeColor;
        Color statusColor;
        IconData statusIcon;

        if (estado == 'LIBRE') {
          badgeColor = Color(0xFF1B4D3E).withOpacity(0.15);
          statusColor = Theme.of(context).colorScheme.primary;
          statusIcon = Icons.verified_user_outlined;
        } else if (estado == 'ROBADO') {
          badgeColor = const Color(0xFF8B0000).withOpacity(0.12);
          statusColor = const Color(0xFFFF4B4B);
          statusIcon = Icons.gpp_bad_outlined;
        } else {
          badgeColor = const Color(0xFF2E3D40).withOpacity(0.15);
          statusColor = Colors.white60;
          statusIcon = Icons.help_outline;
        }

        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white.withOpacity(0.04)),
          ),
          child: Row(
            children: [
              Container(
                width: 45,
                height: 45,
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  tipo == 'IMEI' ? Icons.tag : Icons.qr_code,
                  color: statusColor,
                  size: 22,
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      modelo,
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '$tipo: $valor',
                      style: TextStyle(color: Colors.white.withOpacity(0.4), fontSize: 11),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      _formatDate(fecha),
                      style: TextStyle(color: Colors.white.withOpacity(0.25), fontSize: 10),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: badgeColor,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: statusColor.withOpacity(0.2)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(statusIcon, color: statusColor, size: 12),
                    const SizedBox(width: 4),
                    Text(
                      estado,
                      style: TextStyle(color: statusColor, fontWeight: FontWeight.bold, fontSize: 10),
                    ),
                  ],
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
