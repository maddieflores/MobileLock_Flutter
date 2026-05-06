import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart'; 

class ApiService {
  // Detecta automáticamente: usa 127.0.0.1 en la Web y 10.0.2.2 en el emulador
  static final String _baseUrl = kIsWeb 
      ? 'http://127.0.0.1:8000/api' 
      : 'http://10.0.2.2:8000/api'; 

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
      print("Error en login: ${e.response?.data ?? e.message}");
      return e.response; 
    }
  }

  // --- NUEVA FUNCIÓN PARA OBTENER LOS DATOS DEL PERFIL ---
  Future<Response?> getUserProfile(String token) async {
    try {
      // Ponemos el Token en la cabecera para que Django nos reconozca
      _dio.options.headers['Authorization'] = 'Bearer $token';
      // Llamamos a la ruta exacta de tu urls.py
      return await _dio.get('/users/profile/get/');
    } on DioException catch (e) {
      print("Error al obtener perfil: ${e.response?.data ?? e.message}");
      return e.response;
    }
  }
  // -------------------------------------------------------

  Future<Response?> getDatos(String endpoint) async {
    try {
      return await _dio.get(endpoint);
    } on DioException catch (e) {
      print("Error en getDatos: ${e.message}");
      return null;
    }
  }
}