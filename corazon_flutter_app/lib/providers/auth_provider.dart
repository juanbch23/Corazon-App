import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/api_service.dart';

class AuthProvider with ChangeNotifier {
  bool _isAuthenticated = false;
  String? _username;
  String? _userType;
  String? _nombreCompleto;
  bool _isLoading = false;

  bool get isAuthenticated => _isAuthenticated;
  String? get username => _username;
  String? get userType => _userType;
  String? get nombreCompleto => _nombreCompleto;
  bool get isLoading => _isLoading;
  bool get isAdmin => _userType == 'administrador';

  final ApiService _apiService = ApiService();

  AuthProvider() {
    _loadAuthState();
  }

  // Cargar estado de autenticación desde SharedPreferences
  Future<void> _loadAuthState() async {
    final prefs = await SharedPreferences.getInstance();
    _isAuthenticated = prefs.getBool('isAuthenticated') ?? false;
    _username = prefs.getString('username');
    _userType = prefs.getString('userType');
    _nombreCompleto = prefs.getString('nombreCompleto');
    notifyListeners();
  }

  // Guardar estado de autenticación
  Future<void> _saveAuthState() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isAuthenticated', _isAuthenticated);
    if (_username != null) await prefs.setString('username', _username!);
    if (_userType != null) await prefs.setString('userType', _userType!);
    if (_nombreCompleto != null) await prefs.setString('nombreCompleto', _nombreCompleto!);
  }

  // Login
  Future<bool> login(String username, String password) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await _apiService.login(username, password);
      
      _isAuthenticated = true;
      _username = username; // Guardar el username que se usó para el login
      _userType = response['user_type'];
      
      // Obtener información del usuario desde configuración usando username
      try {
        final configResponse = await _apiService.obtenerConfiguracion(username: username);
        final nombre = configResponse['nombre'] ?? '';
        final apellido = configResponse['apellido'] ?? '';
        _nombreCompleto = '$nombre $apellido'.trim();
        if (_nombreCompleto!.isEmpty) {
          _nombreCompleto = username; // Fallback al username si no hay nombre
        }
      } catch (e) {
        _nombreCompleto = username; // Fallback al username si falla la llamada
      }
      
      await _saveAuthState();
      
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      throw e.toString();
    }
  }

  // Registro
  Future<bool> register(Map<String, dynamic> userData) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _apiService.register(userData);
      
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      throw e.toString();
    }
  }

  // Logout
  Future<void> logout() async {
    _isAuthenticated = false;
    _username = null;
    _userType = null;
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    
    notifyListeners();
  }
  
  // Verificar si es paciente
  bool get isPaciente => _userType == 'paciente';
}
