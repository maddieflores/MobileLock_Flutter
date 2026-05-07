import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart'; 

class ApiService {
  
  static final String _baseUrl = 'http://192.168.0.7:8000/api';  //colocar la ip de su red cuando trabaje

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

  // =======================================================
  // --- LOGIN ---
  // =======================================================
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

  // =======================================================
  // --- REGISTRO DE USUARIO ---
  // =======================================================
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
      print("Error en registro: ${e.response?.data ?? e.message}");
      return e.response; 
    }
  }

  // =======================================================
  // --- PERFIL DE USUARIO ---
  // =======================================================
  Future<Response?> getUserProfile(String token) async {
    try {
      _dio.options.headers['Authorization'] = 'Bearer $token';
      return await _dio.get('/users/profile/get/');
    } on DioException catch (e) {
      print("Error al obtener perfil: ${e.response?.data ?? e.message}");
      return e.response;
    }
  }

  // =======================================================
  // --- LISTA DE DISPOSITIVOS (DASHBOARD) ---
  // =======================================================
  Future<Response?> getUserDevices(String token) async {
    try {
      _dio.options.headers['Authorization'] = 'Bearer $token';
      return await _dio.get('/devices/list/');
    } on DioException catch (e) {
      print("Error al obtener dispositivos: ${e.response?.data ?? e.message}");
      return e.response;
    }
  }

  // =======================================================
  // --- REGISTRAR NUEVO DISPOSITIVO ---
  // =======================================================
  Future<Response?> registerDevice(String token, String marcaModelo, String imei, String hardware) async {
    try {
      _dio.options.headers['Authorization'] = 'Bearer $token';
      return await _dio.post(
        '/devices/create/', // Ruta de tu views.py
        data: {
          'marca_modelo': marcaModelo,
          'hash_imei': imei,
          'hash_adn_hardware': hardware,
        },
      );
    } on DioException catch (e) {
      print("Error al registrar equipo: ${e.response?.data ?? e.message}");
      return e.response;
    }
  }

  // =======================================================
  // --- FUNCIÓN GENÉRICA ---
  // =======================================================
  Future<Response?> getDatos(String endpoint) async {
    try {
      return await _dio.get(endpoint);
    } on DioException catch (e) {
      print("Error en getDatos: ${e.message}");
      return null;
    }
  }
}