import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import '../config/app_config.dart';

class ApiService {
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  late http.Client _client;
  late Map<String, String> _defaultHeaders;

  void init() {
    _client = http.Client();
    _defaultHeaders = Map<String, String>.from(AppConfig.defaultHeaders);
    _defaultHeaders['Content-Type'] = 'application/json';
    print('ApiService inicializado para móvil');
  }

  // GET request
  Future<http.Response> get(String endpoint, {Map<String, String>? headers}) async {
    try {
      final url = Uri.parse('${AppConfig.apiBaseUrl}$endpoint');
      final combinedHeaders = {..._defaultHeaders, ...?headers};
      
      print('GET: $url');
      final response = await _client.get(url, headers: combinedHeaders);
      
      print('Respuesta GET: ${response.statusCode}');
      return response;
    } catch (e) {
      print('Error en GET: $e');
      rethrow;
    }
  }

  // POST request
  Future<http.Response> post(String endpoint, {
    Map<String, dynamic>? data,
    Map<String, String>? headers,
  }) async {
    try {
      final url = Uri.parse('${AppConfig.apiBaseUrl}$endpoint');
      final combinedHeaders = {..._defaultHeaders, ...?headers};
      
      final body = data != null ? jsonEncode(data) : null;
      
      print('POST: $url');
      print('Body: $body');
      final response = await _client.post(url, headers: combinedHeaders, body: body);
      
      print('Respuesta POST: ${response.statusCode}');
      return response;
    } catch (e) {
      print('Error en POST: $e');
      rethrow;
    }
  }

  // PUT request  
  Future<http.Response> put(String endpoint, {
    Map<String, dynamic>? data,
    Map<String, String>? headers,
  }) async {
    try {
      final url = Uri.parse('${AppConfig.apiBaseUrl}$endpoint');
      final combinedHeaders = {..._defaultHeaders, ...?headers};
      
      final body = data != null ? jsonEncode(data) : null;
      
      print('PUT: $url');
      final response = await _client.put(url, headers: combinedHeaders, body: body);
      
      print('Respuesta PUT: ${response.statusCode}');
      return response;
    } catch (e) {
      print('Error en PUT: $e');
      rethrow;
    }
  }

  // DELETE request
  Future<http.Response> delete(String endpoint, {Map<String, String>? headers}) async {
    try {
      final url = Uri.parse('${AppConfig.apiBaseUrl}$endpoint');
      final combinedHeaders = {..._defaultHeaders, ...?headers};
      
      print('DELETE: $url');
      final response = await _client.delete(url, headers: combinedHeaders);
      
      print('Respuesta DELETE: ${response.statusCode}');
      return response;
    } catch (e) {
      print('Error en DELETE: $e');
      rethrow;
    }
  }

  void dispose() {
    _client.close();
  }

  // Login
  Future<Map<String, dynamic>> login(String username, String password) async {
    try {
      final response = await post('/login', data: {
        'username': username,
        'password': password,
      });
      
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Error ${response.statusCode}: ${response.body}');
      }
    } catch (e) {
      throw _handleError(e);
    }
  }

  // Registro
  Future<Map<String, dynamic>> register(Map<String, dynamic> userData) async {
    try {
      final response = await post('/registro', data: userData);
      
      if (response.statusCode == 200 || response.statusCode == 201) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Error ${response.statusCode}: ${response.body}');
      }
    } catch (e) {
      throw _handleError(e);
    }
  }

  // Diagnóstico
  Future<Map<String, dynamic>> diagnosticar(Map<String, dynamic> datosClinicicos, {String? username}) async {
    try {
      final endpoint = username != null ? '/diagnostico/$username' : '/diagnostico';
      final response = await post(endpoint, data: datosClinicicos);
      
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Error ${response.statusCode}: ${response.body}');
      }
    } catch (e) {
      throw _handleError(e);
    }
  }

  // Obtener resultados
  Future<Map<String, dynamic>> obtenerResultados({String? username}) async {
    try {
      final endpoint = username != null ? '/resultados/$username' : '/resultados';
      final response = await get(endpoint);
      
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Error ${response.statusCode}: ${response.body}');
      }
    } catch (e) {
      throw _handleError(e);
    }
  }

  // Configuración de usuario
  Future<Map<String, dynamic>> obtenerConfiguracion({String? username}) async {
    try {
      final endpoint = username != null ? '/configuracion/$username' : '/configuracion';
      final response = await get(endpoint);
      
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Error ${response.statusCode}: ${response.body}');
      }
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<Map<String, dynamic>> actualizarConfiguracion(Map<String, dynamic> config, {String? username}) async {
    try {
      final endpoint = username != null ? '/configuracion/$username' : '/configuracion';
      final response = await post(endpoint, data: config);
      
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Error ${response.statusCode}: ${response.body}');
      }
    } catch (e) {
      throw _handleError(e);
    }
  }

  // Métodos de administrador
  Future<Map<String, dynamic>> obtenerPacientesAdmin({String? username}) async {
    try {
      final endpoint = username != null ? '/admin/$username' : '/admin';
      final response = await get(endpoint);
      
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Error ${response.statusCode}: ${response.body}');
      }
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<List<dynamic>> obtenerHistorialDiagnosticos(int usuarioId, {String? username}) async {
    try {
      final endpoint = username != null 
          ? '/admin/$username/diagnosticos/$usuarioId'
          : '/admin/diagnosticos/$usuarioId';
      final response = await get(endpoint);
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data is List ? data : [];
      } else {
        throw Exception('Error ${response.statusCode}: ${response.body}');
      }
    } catch (e) {
      throw _handleError(e);
    }
  }

  String _handleError(dynamic error) {
    if (error is SocketException) {
      return 'Error de conexión. Verifica tu conexión a internet';
    } else if (error is HttpException) {
      return 'Error HTTP: ${error.message}';
    } else if (error is FormatException) {
      return 'Error de formato en la respuesta del servidor';
    } else {
      return 'Error desconocido: $error';
    }
  }
}
