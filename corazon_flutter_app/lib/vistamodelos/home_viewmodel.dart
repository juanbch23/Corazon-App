import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../servicios/api_service.dart';

/// ViewModel para el menú principal/home de la aplicación
/// Maneja la lógica de navegación y datos generales del usuario
/// Controla el flujo principal de la aplicación después del login
class HomeViewModel extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  
  // Estados del ViewModel
  bool _estaCargando = false;
  String _error = '';
  String _nombreUsuario = '';
  bool _esAdmin = false;
  Map<String, dynamic>? _datosUsuario;
  
  // Getters para acceder a los estados desde la Vista
  bool get estaCargando => _estaCargando;
  bool get isLoading => _estaCargando; // Alias para compatibilidad
  String get error => _error;
  String? get mensajeError => _error.isNotEmpty ? _error : null;
  String get nombreUsuario => _nombreUsuario;
  bool get esAdmin => _esAdmin;
  String? get tipoUsuario => _esAdmin ? 'admin' : 'paciente';
  Map<String, dynamic>? get datosUsuario => _datosUsuario;

  /// Inicializa los datos del usuario al cargar el menú principal
  /// Determina si es admin o paciente para mostrar opciones correspondientes
  Future<void> inicializarDatos() async {
    _estaCargando = true;
    _error = '';
    notifyListeners();

    try {
      // Simulación de carga de datos del usuario - integrar con ApiService
      await Future.delayed(const Duration(seconds: 1));
      
      // Datos simulados del usuario - reemplazar con llamada real
      _datosUsuario = {
        'nombre': 'Juan Pérez',
        'email': 'juan.perez@email.com',
        'rol': 'paciente', // o 'admin'
      };
      
      _nombreUsuario = _datosUsuario!['nombre'] ?? 'Usuario';
      _esAdmin = _determinarTipoUsuario('juan.perez', _datosUsuario!);
      
      _estaCargando = false;
      notifyListeners();

    } catch (e) {
      _error = 'Error al cargar datos del usuario: ${e.toString()}';
      _estaCargando = false;
      notifyListeners();
    }
  }

  /// Determina si el usuario es administrador
  /// Basado en el username y datos del perfil
  bool _determinarTipoUsuario(String username, Map<String, dynamic> datos) {
    // Si el username es 'admin' o tiene rol de administrador
    if (username.toLowerCase() == 'admin' || 
        datos['rol'] == 'admin' || 
        datos['es_admin'] == true) {
      return true;
    }
    return false;
  }

  /// Verifica si el usuario actual es administrador
  bool get esAdministrador => _esAdmin;

  /// Verifica si el usuario actual es paciente
  bool get esPaciente => !_esAdmin;

  /// Obtiene las opciones del menú según el tipo de usuario
  List<Map<String, dynamic>> get opcionesMenu {
    if (_esAdmin) {
      return [
        {
          'titulo': 'Panel de Administración',
          'icono': Icons.admin_panel_settings,
          'ruta': '/admin',
          'descripcion': 'Gestionar usuarios y diagnósticos'
        },
        {
          'titulo': 'Ver Diagnósticos',
          'icono': Icons.analytics,
          'ruta': '/diagnostico',
          'descripcion': 'Revisar diagnósticos de pacientes'
        },
        {
          'titulo': 'Configuración',
          'icono': Icons.settings,
          'ruta': '/configuracion',
          'descripcion': 'Configurar mi información personal'
        },
      ];
    } else {
      return [
        {
          'titulo': 'Realizar Diagnóstico',
          'icono': Icons.favorite,
          'ruta': '/diagnostico',
          'descripcion': 'Evaluación cardiovascular'
        },
        {
          'titulo': 'Mis Resultados',
          'icono': Icons.assessment,
          'ruta': '/resultados',
          'descripcion': 'Ver historial de diagnósticos'
        },
        {
          'titulo': 'Configuración',
          'icono': Icons.settings,
          'ruta': '/configuracion',
          'descripcion': 'Configurar mi información personal'
        },
      ];
    }
  }

  /// Limpia los datos del usuario al cerrar sesión
  void cerrarSesion() {
    _nombreUsuario = '';
    _esAdmin = false;
    _datosUsuario = null;
    _error = '';
    notifyListeners();
  }

  /// Limpia mensajes de error
  void limpiarError() {
    _error = '';
    notifyListeners();
  }

  @override
  void dispose() {
    _apiService.dispose();
    super.dispose();
  }
}