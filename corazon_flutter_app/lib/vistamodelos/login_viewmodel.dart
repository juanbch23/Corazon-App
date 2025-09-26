import 'package:flutter/foundation.dart';
import '../modelos/usuario.dart';
import '../servicios/api_service.dart';

// ViewModel para la pantalla de login siguiendo el patrón MVVM
class LoginViewModel extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  
  // Estados del ViewModel
  bool _estaCargando = false;
  String? _mensajeError;
  Usuario? _usuarioAutenticado;

  // Getters para acceder a los estados
  bool get estaCargando => _estaCargando;
  String? get mensajeError => _mensajeError;
  Usuario? get usuarioAutenticado => _usuarioAutenticado;
  bool get estaAutenticado => _usuarioAutenticado != null;

  // Método para inicializar el servicio
  void init() {
    _apiService.init();
  }

  // Método para realizar login
  Future<bool> iniciarSesion(String username, String password) async {
    _estaCargando = true;
    _mensajeError = null;
    notifyListeners();

    try {
      final response = await _apiService.login(username, password);
      
      // Crear usuario a partir de la respuesta
      _usuarioAutenticado = Usuario(
        username: username,
        tipo: response['user_type'] ?? 'paciente',
      );
      
      _estaCargando = false;
      notifyListeners();
      return true;

    } catch (e) {
      _mensajeError = e.toString();
      _estaCargando = false;
      notifyListeners();
      return false;
    }
  }

  // Método para cerrar sesión
  void cerrarSesion() {
    _usuarioAutenticado = null;
    _mensajeError = null;
    notifyListeners();
  }

  // Método para limpiar errores
  void limpiarError() {
    _mensajeError = null;
    notifyListeners();
  }

  @override
  void dispose() {
    _apiService.dispose();
    super.dispose();
  }
}