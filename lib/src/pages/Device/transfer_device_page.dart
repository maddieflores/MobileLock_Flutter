import 'package:flutter/material.dart';
import '../../../services/api_service.dart';
import '../Profile/profile_page.dart';

class TransferDevicePage extends StatefulWidget {
  final int deviceId;
  final String marcaModelo;

  const TransferDevicePage({super.key, required this.deviceId, required this.marcaModelo});

  @override
  State<TransferDevicePage> createState() => _TransferDevicePageState();
}

class _TransferDevicePageState extends State<TransferDevicePage> {
  final TextEditingController _emailController = TextEditingController();
  bool _isTransferring = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _handleTransfer() async {
    final email = _emailController.text.trim();
    if (email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ingresa el correo del nuevo propietario'), backgroundColor: Colors.redAccent),
      );
      return;
    }

    setState(() {
      _isTransferring = true;
    });

    final apiService = ApiService();
    final response = await apiService.transferDevice(globalToken, widget.deviceId, email);

    if (mounted) {
      setState(() {
        _isTransferring = false;
      });

      if (response != null && response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('¡Transferencia completada con éxito!'), backgroundColor: Colors.green),
        );
        Navigator.pop(context, true); // Devuelve true para recargar la lista
      } else {
        String errMsg = 'No se pudo transferir el equipo';
        if (response?.data != null && response?.data is Map) {
          errMsg = response?.data['detail'] ?? errMsg;
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errMsg), backgroundColor: Colors.redAccent),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Transferir Propiedad', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Equipo a transferir:',
                    style: TextStyle(color: Colors.white54, fontSize: 13),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    widget.marcaModelo,
                    style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            const Text(
              'Correo electrónico del nuevo dueño',
              style: TextStyle(color: Colors.white70, fontSize: 14),
            ),
            const SizedBox(height: 10),
            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
              ),
              child: TextField(
                controller: _emailController,
                style: const TextStyle(color: Colors.white),
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  hintText: 'ejemplo@dominio.com',
                  hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.2)),
                  prefixIcon: Icon(Icons.email_outlined, color: Theme.of(context).colorScheme.primary, size: 18),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                ),
              ),
            ),
            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: _isTransferring ? null : _handleTransfer,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF00CEE6),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                ),
                child: _isTransferring
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('Confirmar Transferencia', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
