import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart'; // <--- Agrega esto para debugPrint

class ApiService {
  
  static final String _baseUrl = 'http://192.168.0.7:8000/api'; 

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
        '/token/', 
        data: {
          'correo_electronico': username,
          'password': password,
        },
      );
      return response;
    } on DioException catch (e) {
      // Cambiado print por debugPrint
      debugPrint("Error en login: ${e.response?.data ?? e.message}");
      return e.response; 
    }
  }

  Future<Response?> register(String correo, String password, String nombres, String apPaterno, String apMaterno) async {
    try {
      final response = await _dio.post(
        '/users/auth/register/', 
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
      return await _dio.get('/users/profile/get/');
    } on DioException catch (e) {
      debugPrint("Error al obtener perfil: ${e.response?.data ?? e.message}");
      return e.response;
    }
  }

  Future<Response?> getUserDevices(String token) async {
    try {
      _dio.options.headers['Authorization'] = 'Bearer $token';
      return await _dio.get('/devices/list/');
    } on DioException catch (e) {
      debugPrint("Error al obtener dispositivos: ${e.response?.data ?? e.message}");
      return e.response;
    }
  }

  Future<Response?> registerDevice(String token, String marcaModelo, String imei, String hardware, {String? imagePath}) async {
    try {
      _dio.options.headers['Authorization'] = 'Bearer $token';
      
      Map<String, dynamic> dataMap = {
        'marca_modelo': marcaModelo,
        'hash_imei': imei,
        'hash_adn_hardware': hardware,
      };

      if (imagePath != null) {
        dataMap['url_imagen_referencia'] = await MultipartFile.fromFile(imagePath);
      }

      FormData formData = FormData.fromMap(dataMap);

      return await _dio.post(
        '/devices/create/', 
        data: formData,
      );
    } on DioException catch (e) {
      debugPrint("Error al registrar equipo: ${e.response?.data ?? e.message}");
      return e.response;
    }
  }

  Future<Response?> transferDevice(String token, int deviceId, String newOwnerEmail) async {
    try {
      _dio.options.headers['Authorization'] = 'Bearer $token';
      return await _dio.post(
        '/devices/transfer/$deviceId/',
        data: {
          'nuevo_propietario_email': newOwnerEmail,
        },
      );
    } on DioException catch (e) {
      debugPrint("Error al transferir equipo: ${e.response?.data ?? e.message}");
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
}