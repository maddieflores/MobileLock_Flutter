import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
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

  // Estados para validación física por IA
  XFile? _physicalImage;
  final ImagePicker _picker = ImagePicker();
  bool _physicalLoading = false;
  Map<String, dynamic>? _physicalResult;
  String _loadingStepText = '';

  final ApiService _apiService = ApiService();

  Future<void> _verify({String? imei, String? qrCode}) async {
    setState(() {
      _isLoading = true;
      _result = null;
      _errorMessage = null;
      _physicalImage = null;
      _physicalResult = null;
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
        final errorMsg =
            response?.data?['detail'] ?? 'Error al realizar la verificación.';
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
        content: Text(
          message,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
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
          icon: Icon(
            Icons.arrow_back,
            color: Theme.of(context).colorScheme.primary,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.history,
              color: Theme.of(context).colorScheme.primary,
            ),
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
                    child: Text(
                      'O ESCANEAR',
                      style: TextStyle(
                        color: Colors.white38,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
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
                    child: CircularProgressIndicator(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),

              // Resultados
              if (_result != null) _buildResultCard(),

              if (_result != null &&
                  _result!['dispositivo'] != null &&
                  _result!['dispositivo']['hash_visual'] != null) ...[
                _buildPhysicalVerificationSection(),
              ],

              // Mensaje de Error
              if (_errorMessage != null)
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.redAccent.withOpacity(0.1),
                    border: Border.all(
                      color: Colors.redAccent.withOpacity(0.3),
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    _errorMessage!,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.redAccent,
                      fontWeight: FontWeight.bold,
                    ),
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
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
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
              prefixIcon: Icon(
                Icons.search,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            style: const TextStyle(color: Colors.white, letterSpacing: 1.5),
          ),
          const SizedBox(height: 15),
          ElevatedButton(
            onPressed: () {
              if (_imeiController.text.length < 14) {
                _showToast(
                  'El IMEI debe tener al menos 14-15 dígitos.',
                  Colors.amber,
                );
                return;
              }
              _verify(imei: _imeiController.text);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.primary,
              foregroundColor: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            child: const Text(
              'Consultar Estado',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            ),
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
                  border: Border.all(
                    color: Theme.of(context).colorScheme.primary,
                    width: 2,
                  ),
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
                label: const Text(
                  'Cancelar Escaneo',
                  style: TextStyle(
                    color: Colors.redAccent,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          )
        : Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Theme.of(context).colorScheme.primary,
                  Color(0xFF00BFFF),
                ],
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: ElevatedButton.icon(
              onPressed: () => setState(() {
                _isScanning = true;
                _result = null;
                _errorMessage = null;
              }),
              icon: const Icon(
                Icons.qr_code_scanner,
                color: Colors.black,
                size: 24,
              ),
              label: const Text(
                'Activar Lector QR de Hardware',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
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
      description =
          'El dispositivo móvil consultado se encuentra limpio, registrado y sin reportes de robo activos.';
    } else if (estado == 'ROBADO') {
      cardColor = const Color(0xFF8B0000).withOpacity(0.15);
      iconColor = const Color(0xFFFF4B4B);
      icon = Icons.gpp_bad_outlined;
      statusTitle = 'PELIGRO - ROBADO';
      description =
          '¡ATENCIÓN! Este dispositivo ha sido marcado como robado por su propietario original.';
    } else if (estado == 'EXTRAVIADO') {
      cardColor = Colors.amber.withOpacity(0.15);
      iconColor = Colors.amber;
      icon = Icons.warning_amber_rounded;
      statusTitle = 'ADVERTENCIA - EXTRAVIADO';
      description =
          '¡ATENCIÓN! Este dispositivo ha sido marcado como extraviado por su propietario original.';
    } else {
      cardColor = const Color(0xFF2E3D40).withOpacity(0.2);
      iconColor = Colors.white70;
      icon = Icons.help_outline;
      statusTitle = 'NO REGISTRADO';
      description =
          'El dispositivo móvil no está registrado en el ecosistema MobileLock AI. No posee un título de propiedad blindado.';
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
                      style: TextStyle(
                        color: iconColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '$tipo: $valor',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.5),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          Text(
            description,
            style: TextStyle(
              color: Colors.white.withOpacity(0.8),
              fontSize: 13,
              height: 1.4,
            ),
          ),
          if (dispositivo != null) ...[
            const SizedBox(height: 15),
            const Divider(color: Colors.white10),
            const SizedBox(height: 10),
            Text(
              'Modelo: ${dispositivo['marca_modelo']}',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Hardware ADN: ${dispositivo['hash_adn_hardware']}',
              style: TextStyle(
                color: Colors.white.withOpacity(0.4),
                fontSize: 11,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ],
      ),
    );
  }

  Future<void> _pickPhysicalImage() async {
    final XFile? image = await _picker.pickImage(
      source: ImageSource.camera,
      maxWidth: 800,
      maxHeight: 800,
      imageQuality: 85,
    );
    if (image != null) {
      setState(() {
        _physicalImage = image;
        _physicalResult = null;
      });
    }
  }

  Future<void> _verifyPhysical() async {
    if (_physicalImage == null) return;
    setState(() {
      _physicalLoading = true;
      _physicalResult = null;
      _loadingStepText = 'Inicializando IA...';
    });

    final steps = [
      'Normalizando canales RGB...',
      'Extrayendo vector EfficientNet-B0 (1280 floats)...',
      'Calculando Similitud Coseno con NumPy...',
      'Validando contra Blockchain...',
    ];

    final String? tipoFiltro = _result != null
        ? _result!['tipo_filtro'] as String?
        : null;
    final String? valorConsultado = _result != null
        ? _result!['valor_consultado'] as String?
        : null;
    final String? imeiParam = tipoFiltro == 'IMEI' ? valorConsultado : null;
    final String? qrParam = tipoFiltro == 'QR' ? valorConsultado : null;

    final bytes = await _physicalImage!.readAsBytes();
    final filename = _physicalImage!.name;

    Future<Response?> requestFuture = _apiService.verifyDevicePhysical(
      globalToken,
      imeiParam,
      qrParam,
      bytes,
      filename,
    );

    for (var step in steps) {
      if (!_physicalLoading) break;
      await Future.delayed(const Duration(milliseconds: 600));
      if (mounted && _physicalLoading) {
        setState(() {
          _loadingStepText = step;
        });
      }
    }

    try {
      final response = await requestFuture;
      if (response != null && response.statusCode == 200) {
        setState(() {
          _physicalResult = response.data;
          _physicalLoading = false;
        });
        final bool authentic = _physicalResult?['autentico'] ?? false;
        final double similarity = (_physicalResult?['similitud'] ?? 0.0) * 100;
        if (authentic) {
          _showToast(
            '🛡️ Dispositivo físico AUTÉNTICO (${similarity.toStringAsFixed(1)}%)',
            Colors.green,
          );
        } else {
          _showToast(
            '⚠️ ALERTA: No coincide (${similarity.toStringAsFixed(1)}%)',
            Colors.redAccent,
          );
        }
      } else {
        final errorMsg =
            response?.data?['detail'] ??
            'Error al procesar la verificación física.';
        setState(() {
          _physicalLoading = false;
        });
        _showToast(errorMsg, Colors.redAccent);
      }
    } catch (e) {
      setState(() {
        _physicalLoading = false;
      });
      _showToast('Error de conexión con el servidor.', Colors.redAccent);
    }
  }

  Widget _buildPhysicalVerificationSection() {
    final dispositivo = _result?['dispositivo'];
    if (dispositivo == null || dispositivo['hash_visual'] == null) {
      return const SizedBox.shrink();
    }

    return Container(
      margin: const EdgeInsets.only(top: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: Colors.purple.withOpacity(0.3), width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.purple.withOpacity(0.15),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.fingerprint,
                  color: Colors.purpleAccent,
                  size: 28,
                ),
              ),
              const SizedBox(width: 15),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Validación Física por IA',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'EfficientNet-B0 Cosine Similarity (70%)',
                      style: TextStyle(color: Colors.white38, fontSize: 11),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          const Divider(color: Colors.white10),
          const SizedBox(height: 15),

          if (_physicalResult == null) ...[
            const Text(
              'Toma una foto en tiempo real del equipo físico para contrastarla con el registro original de la Blockchain.',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 13,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 20),
            if (_physicalLoading)
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Column(
                    children: [
                      const CircularProgressIndicator(
                        color: Colors.purpleAccent,
                      ),
                      const SizedBox(height: 15),
                      Text(
                        _loadingStepText,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Extrayendo embeddings visuales...',
                        style: TextStyle(color: Colors.white38, fontSize: 11),
                      ),
                    ],
                  ),
                ),
              )
            else if (_physicalImage == null)
              InkWell(
                onTap: _pickPhysicalImage,
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 35,
                    horizontal: 20,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.purple.withOpacity(0.03),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.purple.withOpacity(0.2)),
                  ),
                  child: const Column(
                    children: [
                      Icon(
                        Icons.camera_enhance,
                        color: Colors.purpleAccent,
                        size: 38,
                      ),
                      SizedBox(height: 12),
                      Text(
                        'Tomar Foto de Validación',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      SizedBox(height: 6),
                      Text(
                        'Usa la cámara trasera bajo buena luz',
                        style: TextStyle(color: Colors.white38, fontSize: 11),
                      ),
                    ],
                  ),
                ),
              )
            else ...[
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: kIsWeb
                    ? Image.network(
                        _physicalImage!.path,
                        height: 220,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      )
                    : Image.file(
                        File(_physicalImage!.path),
                        height: 220,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
              ),
              const SizedBox(height: 15),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => setState(() => _physicalImage = null),
                      icon: const Icon(
                        Icons.delete_outline,
                        color: Colors.redAccent,
                      ),
                      label: const Text(
                        'Remover',
                        style: TextStyle(color: Colors.redAccent),
                      ),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.redAccent),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _verifyPhysical,
                      icon: const Icon(
                        Icons.shield_outlined,
                        color: Colors.black,
                      ),
                      label: const Text(
                        'Validar con IA',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.purpleAccent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ] else ...[
            _buildPhysicalResultBanner(),
            const SizedBox(height: 20),
            const Text(
              'Comparación Visual Lado a Lado',
              style: TextStyle(
                color: Colors.white70,
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Referencia Oficial',
                        style: TextStyle(color: Colors.white38, fontSize: 11),
                      ),
                      const SizedBox(height: 6),
                      Container(
                        height: 150,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.black45,
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(color: Colors.white12),
                        ),
                        clipBehavior: Clip.hardEdge,
                        child: _buildReferenceImageWidget(
                          dispositivo['url_imagen_referencia'],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Captura en Vivo',
                        style: TextStyle(color: Colors.white38, fontSize: 11),
                      ),
                      const SizedBox(height: 6),
                      Container(
                        height: 150,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.black45,
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(color: Colors.white12),
                        ),
                        clipBehavior: Clip.hardEdge,
                        child: kIsWeb
                            ? Image.network(
                                _physicalImage!.path,
                                fit: BoxFit.cover,
                              )
                            : Image.file(
                                File(_physicalImage!.path),
                                fit: BoxFit.cover,
                              ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            TextButton.icon(
              onPressed: () => setState(() {
                _physicalImage = null;
                _physicalResult = null;
              }),
              icon: const Icon(Icons.refresh, color: Colors.purpleAccent),
              label: const Text(
                'Nueva Validación Física',
                style: TextStyle(
                  color: Colors.purpleAccent,
                  fontWeight: FontWeight.bold,
                ),
              ),
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildPhysicalResultBanner() {
    final bool authentic = _physicalResult?['autentico'] ?? false;
    final double similarity = (_physicalResult?['similitud'] ?? 0.0) * 100;
    final String message = _physicalResult?['mensaje'] ?? '';

    final Color color = authentic ? Colors.green : Colors.redAccent;
    final IconData icon = authentic
        ? Icons.verified_user_rounded
        : Icons.gpp_bad_rounded;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.3), width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 28),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  authentic ? 'HARDWARE AUTÉNTICO' : 'ALTERACIÓN DETECTADA',
                  style: TextStyle(
                    color: color,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            message,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              'COINCIDENCIA: ${similarity.toStringAsFixed(1)}% (Umbral: ${((_physicalResult?['umbral'] ?? 0.70) * 100).toStringAsFixed(0)}%)',
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.bold,
                fontSize: 11,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReferenceImageWidget(String? path) {
    if (path == null || path.isEmpty) {
      return const Center(
        child: Text(
          'Sin imagen',
          style: TextStyle(color: Colors.white30, fontSize: 11),
        ),
      );
    }

    String url = path;
    if (!path.startsWith('http://') && !path.startsWith('https://')) {
      final host = kIsWeb ? 'http://localhost:8000' : 'http://192.168.0.3:8000';
      final prefix = path.startsWith('/') ? '' : '/';
      url = '$host$prefix$path';
    }

    return Image.network(
      url,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
        return const Center(
          child: Icon(Icons.broken_image, color: Colors.white24, size: 30),
        );
      },
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return const Center(
          child: SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: Colors.purpleAccent,
            ),
          ),
        );
      },
    );
  }
}
