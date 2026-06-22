import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class ApiService {
  static final String _baseUrl = kIsWeb
      ? 'http://localhost:8000/api/'
      : 'http://192.168.0.16:8000/api/';

  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: _baseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ),
  );

  Future<Response?> login(String username, String password) async {
    try {
      final response = await _dio.post(
        'token/',
        data: {'correo_electronico': username, 'password': password},
      );
      return response;
    } on DioException catch (e) {
      // Cambiado print por debugPrint
      debugPrint("Error en login: ${e.response?.data ?? e.message}");
      return e.response;
    }
  }

  Future<Response?> register(
    String correo,
    String password,
    String nombres,
    String apPaterno,
    String apMaterno,
  ) async {
    try {
      final response = await _dio.post(
        'users/auth/register/',
        data: {
          'correo_electronico': correo,
          'password': password,
          'nombres': nombres,
          'apellido_paterno': apPaterno,
          'apellido_materno': apMaterno,
        },
      );
      return response;
    } on DioException catch (e) {
      debugPrint("Error en registro: ${e.response?.data ?? e.message}");
      return e.response;
    }
  }

  Future<Response?> getUserProfile(String token) async {
    try {
      _dio.options.headers['Authorization'] = 'Bearer $token';
      return await _dio.get('users/profile/get/');
    } on DioException catch (e) {
      debugPrint("Error al obtener perfil: ${e.response?.data ?? e.message}");
      return e.response;
    }
  }

  Future<Response?> getUserDevices(String token) async {
    try {
      _dio.options.headers['Authorization'] = 'Bearer $token';
      return await _dio.get('devices/list/');
    } on DioException catch (e) {
      debugPrint(
        "Error al obtener dispositivos: ${e.response?.data ?? e.message}",
      );
      return e.response;
    }
  }

  Future<Response?> registerDevice(
    String token,
    String marcaModelo,
    String imei,
    String hardware, {
    String? imagePath,
  }) async {
    try {
      _dio.options.headers['Authorization'] = 'Bearer $token';

      Map<String, dynamic> dataMap = {
        'marca_modelo': marcaModelo,
        'hash_imei': imei,
        'hash_adn_hardware': hardware,
      };

      if (imagePath != null) {
        dataMap['url_imagen_referencia'] = await MultipartFile.fromFile(
          imagePath,
        );
      }

      FormData formData = FormData.fromMap(dataMap);

      return await _dio.post('devices/create/', data: formData);
    } on DioException catch (e) {
      debugPrint("Error al registrar equipo: ${e.response?.data ?? e.message}");
      return e.response;
    }
  }

  Future<Response?> updateDevice(
    String token,
    int deviceId,
    String marcaModelo,
    String imei,
    String hardware, {
    String? imagePath,
  }) async {
    try {
      _dio.options.headers['Authorization'] = 'Bearer $token';

      Map<String, dynamic> dataMap = {
        'marca_modelo': marcaModelo,
        'hash_imei': imei,
        'hash_adn_hardware': hardware,
      };

      if (imagePath != null) {
        dataMap['url_imagen_referencia'] = await MultipartFile.fromFile(
          imagePath,
        );
      }

      FormData formData = FormData.fromMap(dataMap);

      return await _dio.put('devices/update/$deviceId/', data: formData);
    } on DioException catch (e) {
      debugPrint(
        "Error al actualizar equipo: ${e.response?.data ?? e.message}",
      );
      return e.response;
    }
  }

  Future<Response?> transferDevice(
    String token,
    int deviceId,
    String newOwnerEmail,
  ) async {
    try {
      _dio.options.headers['Authorization'] = 'Bearer $token';
      return await _dio.post(
        'devices/transfer/$deviceId/',
        data: {'nuevo_propietario_email': newOwnerEmail},
      );
    } on DioException catch (e) {
      debugPrint(
        "Error al transferir equipo: ${e.response?.data ?? e.message}",
      );
      return e.response;
    }
  }

  Future<Response?> getDatos(String endpoint) async {
    try {
      return await _dio.get(endpoint);
    } on DioException catch (e) {
      debugPrint("Error en getDatos: ${e.message}");
      return null;
    }
  }

  Future<Response?> verifyDevice(
    String token, {
    String? imei,
    String? qrCode,
  }) async {
    try {
      _dio.options.headers['Authorization'] = 'Bearer $token';
      final Map<String, dynamic> queryParameters = {};
      if (imei != null) queryParameters['imei'] = imei;
      if (qrCode != null) queryParameters['qr_code'] = qrCode;

      return await _dio.get(
        'devices/verify/',
        queryParameters: queryParameters,
      );
    } on DioException catch (e) {
      debugPrint(
        "Error al verificar dispositivo: ${e.response?.data ?? e.message}",
      );
      return e.response;
    }
  }

  Future<Response?> getScanHistory(String token) async {
    try {
      _dio.options.headers['Authorization'] = 'Bearer $token';
      return await _dio.get('devices/scan-history/');
    } on DioException catch (e) {
      debugPrint(
        "Error al obtener historial: ${e.response?.data ?? e.message}",
      );
      return e.response;
    }
  }

  Future<Response?> reportDeviceState(
    String token,
    int deviceId,
    String estado,
  ) async {
    try {
      _dio.options.headers['Authorization'] = 'Bearer $token';
      return await _dio.patch(
        'devices/report-state/$deviceId/',
        data: {'estado': estado},
      );
    } on DioException catch (e) {
      debugPrint("Error al reportar estado: ${e.response?.data ?? e.message}");
      return e.response;
    }
  }

  Future<Response?> verifyDevicePhysical(
    String token,
    String? imei,
    String? qrCode,
    List<int> bytes,
    String filename,
  ) async {
    try {
      _dio.options.headers['Authorization'] = 'Bearer $token';

      Map<String, dynamic> dataMap = {};
      if (imei != null && imei.isNotEmpty) dataMap['imei'] = imei;
      if (qrCode != null && qrCode.isNotEmpty) dataMap['qr_code'] = qrCode;

      dataMap['imagen_verificacion'] = MultipartFile.fromBytes(
        bytes,
        filename: filename,
      );

      FormData formData = FormData.fromMap(dataMap);

      return await _dio.post('devices/verify/', data: formData);
    } on DioException catch (e) {
      debugPrint(
        "Error al verificar dispositivo físicamente: ${e.response?.data ?? e.message}",
      );
      return e.response;
    }
  }
}
