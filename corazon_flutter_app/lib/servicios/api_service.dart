import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import '../config/app_config.dart';

/// Servicio de API para comunicación con el backend Docker
/// 
/// Este servicio maneja todas las comunicaciones HTTP con nuestro backend Flask
/// que está ejecutándose en contenedores Docker (PostgreSQL + Flask).
/// 
/// Funcionalidades principales:
/// - Autenticación de usuarios (login/registro)
/// - Diagnóstico cardiovascular usando modelo ML TensorFlow Lite
/// - Gestión de perfiles de usuario
/// - Administración de resultados y estadísticas
/// 
/// El backend está disponible en: http://10.0.2.2:5000 (emulador Android)
/// Base de datos: PostgreSQL 15 en puerto 5432
class ApiService {
  // Singleton pattern para una sola instancia del servicio
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  late http.Client _client;
  late Map<String, String> _defaultHeaders;

  void init() {
    _client = http.Client();
    _defaultHeaders = Map<String, String>.from(AppConfig.defaultHeaders);
    _defaultHeaders['Content-Type'] = 'application/json';
    print('ApiService inicializado para diagnóstico cardiovascular');
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

  /// Autentica un usuario en el sistema
  /// Envía credenciales al endpoint /login del backend Flask
  /// El backend verifica las credenciales contra la base de datos PostgreSQL
  /// Retorna datos del usuario si la autenticación es exitosa
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

  /// Registra un nuevo usuario en el sistema
  /// Envía los datos del usuario al endpoint /registro del backend Flask
  /// El backend valida los datos y los almacena en PostgreSQL
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

  /// Alias para registrarUsuario - mantiene compatibilidad con ViewModels
  /// Registra un nuevo usuario usando el método register
  Future<Map<String, dynamic>> registrarUsuario(Map<String, dynamic> userData) async {
    return await register(userData);
  }

  /// Realiza diagnóstico cardiovascular usando ML
  /// Envía datos clínicos al backend Flask que usa TensorFlow Lite
  /// El modelo ML procesa: edad, género, presión, colesterol, glucosa, etc.
  /// Retorna probabilidad de riesgo cardiovascular y recomendaciones
  /// Los resultados se almacenan en PostgreSQL para historial
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

  /// Obtiene historial de diagnósticos del usuario
  /// Consulta la base de datos PostgreSQL para recuperar resultados previos
  /// Incluye datos del diagnóstico, fecha, riesgo calculado y recomendaciones
  /// Usado para mostrar historial y seguimiento de la salud cardiovascular
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

  /// Obtiene configuración del perfil de usuario
  /// Consulta datos personales desde PostgreSQL para mostrar en pantalla de perfil
  /// Incluye nombre, apellido, fecha nacimiento, género, teléfono, DNI, dirección
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

  /// Actualiza configuración del perfil de usuario
  /// Envía datos actualizados al backend para guardar en PostgreSQL
  /// Permite modificar información personal del usuario
  Future<Map<String, dynamic>> actualizarConfiguracion(Map<String, dynamic> datosConfiguracion, {String? username}) async {
    try {
      final endpoint = username != null ? '/configuracion/$username' : '/configuracion';
      final response = await post(endpoint, data: datosConfiguracion);
      
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Error ${response.statusCode}: ${response.body}');
      }
    } catch (e) {
      throw _handleError(e);
    }
  }

  /// Obtiene datos para panel de administración
  /// Consulta estadísticas y gestión de usuarios para administradores
  /// Incluye lista de pacientes, diagnósticos recientes, estadísticas generales
  Future<Map<String, dynamic>> obtenerDatosAdmin({String? username}) async {
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

  /// Obtiene diagnósticos de un paciente específico para administradores
  /// Permite a los admin ver historial completo de cualquier paciente
  /// Usado en panel de administración para gestión de pacientes
  Future<Map<String, dynamic>> obtenerDiagnosticosAdmin(String username, {int? diagnosticoId}) async {
    try {
      final endpoint = diagnosticoId != null 
          ? '/admin/$username/diagnosticos/$diagnosticoId'
          : '/admin/$username/diagnosticos';
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

  void dispose() {
    _client.close();
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
