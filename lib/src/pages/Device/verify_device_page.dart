import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../../../services/api_service.dart';
import '../Profile/profile_page.dart'; // Para globalToken

class VerifyDevicePage extends StatefulWidget {
  const VerifyDevicePage({super.key});

  @override
  State<VerifyDevicePage> createState() => _VerifyDevicePageState();
}

class _VerifyDevicePageState extends State<VerifyDevicePage> {
  final TextEditingController _imeiController = TextEditingController();
  bool _isLoading = false;
  bool _isScanning = false;
  Map<String, dynamic>? _result;
  String? _errorMessage;

  final ApiService _apiService = ApiService();

  Future<void> _verify({String? imei, String? qrCode}) async {
    setState(() {
      _isLoading = true;
      _result = null;
      _errorMessage = null;
    });

    try {
      final response = await _apiService.verifyDevice(
        globalToken,
        imei: imei,
        qrCode: qrCode,
      );

      if (response != null && response.statusCode == 200) {
        setState(() {
          _result = response.data;
          _isLoading = false;
        });
      } else {
        final errorMsg = response?.data?['detail'] ?? 'Error al realizar la verificación.';
        setState(() {
          _errorMessage = errorMsg;
          _isLoading = false;
        });
        _showToast(errorMsg, Colors.redAccent);
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Error de conexión con el servidor.';
        _isLoading = false;
      });
      _showToast('Error de conexión', Colors.redAccent);
    }
  }

  void _showToast(String message, Color backgroundColor) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: const TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: backgroundColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      ),
    );
  }

  @override
  void dispose() {
    _imeiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text(
          'Verificación de Celular',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Theme.of(context).colorScheme.primary),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.history, color: Theme.of(context).colorScheme.primary),
            onPressed: () => Navigator.pushNamed(context, '/scan_history'),
          ),
        ],
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 10),
              Text(
                'Blindaje Digital MobileLock',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Consulta el estado de propiedad de cualquier dispositivo móvil por IMEI o escaneando su QR físico.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.5),
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 30),

              // Buscador de IMEI
              _buildImeiBox(),

              const SizedBox(height: 20),
              const Row(
                children: [
                  Expanded(child: Divider(color: Colors.white24)),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text('O ESCANEAR', style: TextStyle(color: Colors.white38, fontSize: 11, fontWeight: FontWeight.bold)),
                  ),
                  Expanded(child: Divider(color: Colors.white24)),
                ],
              ),
              const SizedBox(height: 20),

              // Botón de Scanner
              _buildScannerButton(),

              const SizedBox(height: 30),

              // Cargando
              if (_isLoading)
                Center(
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: CircularProgressIndicator(color: Theme.of(context).colorScheme.primary),
                  ),
                ),

              // Resultados
              if (_result != null) _buildResultCard(),

              // Mensaje de Error
              if (_errorMessage != null)
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.redAccent.withOpacity(0.1),
                    border: Border.all(color: Colors.redAccent.withOpacity(0.3)),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    _errorMessage!,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImeiBox() {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Búsqueda por IMEI',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 15),
          TextField(
            controller: _imeiController,
            keyboardType: TextInputType.number,
            maxLength: 15,
            decoration: InputDecoration(
              hintText: 'Ingresa los 15 dígitos del IMEI',
              hintStyle: TextStyle(color: Colors.white.withOpacity(0.3)),
              counterText: '',
              filled: true,
              fillColor: Theme.of(context).colorScheme.surface,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide.none,
              ),
              prefixIcon: Icon(Icons.search, color: Theme.of(context).colorScheme.primary),
            ),
            style: const TextStyle(color: Colors.white, letterSpacing: 1.5),
          ),
          const SizedBox(height: 15),
          ElevatedButton(
            onPressed: () {
              if (_imeiController.text.length < 14) {
                _showToast('El IMEI debe tener al menos 14-15 dígitos.', Colors.amber);
                return;
              }
              _verify(imei: _imeiController.text);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.primary,
              foregroundColor: Colors.black,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            child: const Text('Consultar Estado', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
          ),
        ],
      ),
    );
  }

  Widget _buildScannerButton() {
    return _isScanning
        ? Column(
            children: [
              Container(
                width: double.infinity,
                height: 280,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  border: Border.all(color: Theme.of(context).colorScheme.primary, width: 2),
                ),
                clipBehavior: Clip.hardEdge,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(23),
                  child: MobileScanner(
                    onDetect: (capture) {
                      final List<Barcode> barcodes = capture.barcodes;
                      if (barcodes.isNotEmpty) {
                        final String? code = barcodes.first.rawValue;
                        if (code != null) {
                          _verify(qrCode: code);
                          setState(() => _isScanning = false);
                        }
                      }
                    },
                  ),
                ),
              ),
              const SizedBox(height: 15),
              TextButton.icon(
                onPressed: () => setState(() => _isScanning = false),
                icon: const Icon(Icons.cancel, color: Colors.redAccent),
                label: const Text('Cancelar Escaneo', style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold)),
              ),
            ],
          )
        : Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Theme.of(context).colorScheme.primary, Color(0xFF00BFFF)],
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: ElevatedButton.icon(
              onPressed: () => setState(() {
                _isScanning = true;
                _result = null;
                _errorMessage = null;
              }),
              icon: const Icon(Icons.qr_code_scanner, color: Colors.black, size: 24),
              label: const Text('Activar Lector QR de Hardware', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                padding: const EdgeInsets.symmetric(vertical: 18),
              ),
            ),
          );
  }

  Widget _buildResultCard() {
    final estado = _result?['estado'] ?? 'NO_REGISTRADO';
    final valor = _result?['valor_consultado'] ?? '';
    final tipo = _result?['tipo_filtro'] ?? 'IMEI';
    final dispositivo = _result?['dispositivo'];

    Color cardColor;
    Color iconColor;
    IconData icon;
    String statusTitle;
    String description;

    if (estado == 'LIBRE') {
      cardColor = Color(0xFF1B4D3E).withOpacity(0.2);
      iconColor = Theme.of(context).colorScheme.primary;
      icon = Icons.shield_outlined;
      statusTitle = 'SEGURO - LIBRE';
      description = 'El dispositivo móvil consultado se encuentra limpio, registrado y sin reportes de robo activos.';
    } else if (estado == 'ROBADO') {
      cardColor = const Color(0xFF8B0000).withOpacity(0.15);
      iconColor = const Color(0xFFFF4B4B);
      icon = Icons.gpp_bad_outlined;
      statusTitle = 'PELIGRO - ROBADO';
      description = '¡ATENCIÓN! Este dispositivo ha sido marcado como robado o extraviado por su propietario original.';
    } else {
      cardColor = const Color(0xFF2E3D40).withOpacity(0.2);
      iconColor = Colors.white70;
      icon = Icons.help_outline;
      statusTitle = 'NO REGISTRADO';
      description = 'El dispositivo móvil no está registrado en el ecosistema MobileLock AI. No posee un título de propiedad blindado.';
    }

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: iconColor.withOpacity(0.3), width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: iconColor.withOpacity(0.15),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: iconColor, size: 30),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      statusTitle,
                      style: TextStyle(color: iconColor, fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '$tipo: $valor',
                      style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 12),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          Text(
            description,
            style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 13, height: 1.4),
          ),
          if (dispositivo != null) ...[
            const SizedBox(height: 15),
            const Divider(color: Colors.white10),
            const SizedBox(height: 10),
            Text(
              'Modelo: ${dispositivo['marca_modelo']}',
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
            ),
            const SizedBox(height: 4),
            Text(
              'Hardware ADN: ${dispositivo['hash_adn_hardware']}',
              style: TextStyle(color: Colors.white.withOpacity(0.4), fontSize: 11),
              overflow: TextOverflow.ellipsis,
            ),
          ]
        ],
      ),
    );
  }
}
