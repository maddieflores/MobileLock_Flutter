import 'package:dio/dio.dart';

class ApiService {
  // Configuración base para conectar con tu Django
  final Dio _dio = Dio(
    BaseOptions(
      //baseUrl: 'http://10.0.2.2:8000', // IP para emulador Android -> Localhost
      baseUrl: 'http://127.0.0.1:8000/',
      connectTimeout: const Duration(seconds: 5),
      receiveTimeout: const Duration(seconds: 3),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ),
  );

  // Ejemplo de una función para pedir datos (Sprints, Usuarios, etc.)
  Future<Response> getDatos(String endpoint) async {
    try {
      return await _dio.get(endpoint);
    } catch (e) {
      rethrow;
    }
  }
}
