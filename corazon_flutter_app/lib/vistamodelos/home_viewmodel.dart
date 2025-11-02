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
  String _nombreCompleto = '';
  bool _esAdmin = false;
  Map<String, dynamic>? _datosUsuario;
  
  // Getters para acceder a los estados desde la Vista
  bool get estaCargando => _estaCargando;
  bool get isLoading => _estaCargando; // Alias para compatibilidad
  String get error => _error;
  String? get mensajeError => _error.isNotEmpty ? _error : null;
  String get nombreUsuario => _nombreUsuario;
  String get nombreCompleto => _nombreCompleto;
  bool get esAdmin => _esAdmin;
  String? get tipoUsuario => _esAdmin ? 'admin' : 'paciente';
  Map<String, dynamic>? get datosUsuario => _datosUsuario;
  
  /// Obtiene las opciones del menú principal del dashboard
  List<Map<String, dynamic>> get opcionesMenu {
    List<Map<String, dynamic>> opciones = [
      {
        'titulo': 'Nuevo Diagnóstico',
        'descripcion': 'Realizar evaluación cardiovascular',
        'icono': Icons.medical_services,
        'ruta': '/diagnostico',
        'color': Colors.orange.shade600,
      },
      {
        'titulo': 'Mis Resultados', 
        'descripcion': 'Ver diagnósticos anteriores',
        'icono': Icons.assessment,
        'ruta': '/resultados',
        'color': Colors.orange.shade600,
      },
      {
        'titulo': 'Configuración',
        'descripcion': 'Actualizar datos personales',
        'icono': Icons.settings,
        'ruta': '/configuracion',
        'color': Colors.orange.shade600,
      },
    ];
    
    if (_esAdmin) {
      opciones.add({
        'titulo': 'Panel de Administrador',
        'descripcion': 'Gestionar pacientes del sistema',
        'icono': Icons.admin_panel_settings,
        'ruta': '/admin/pacientes',
        'color': Colors.grey.shade700,
      });
    }
    
    return opciones;
  }

  /// Carga los datos del usuario desde el almacenamiento local
  Future<void> cargarDatosUsuario() async {
    try {
      _estaCargando = true;
      _error = '';
      notifyListeners();

      // Intentar obtener datos del usuario actual
      final datos = await _apiService.obtenerConfiguracion();
      
      _nombreUsuario = datos['username'] ?? '';
      _nombreCompleto = datos['nombre_completo'] ?? datos['nombre'] ?? _nombreUsuario;
      _esAdmin = _determinarTipoUsuario(_nombreUsuario, datos);
      _datosUsuario = datos;
    } catch (e) {
      _error = 'Error al cargar datos del usuario: $e';
      debugPrint('Error en cargarDatosUsuario: $e');
    } finally {
      _estaCargando = false;
      notifyListeners();
    }
  }

  /// Inicializa los datos del viewmodel (alias para cargarDatosUsuario)
  Future<void> inicializarDatos() async {
    await cargarDatosUsuario();
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

  /// Limpia los datos del usuario al cerrar sesión
  void cerrarSesion() {
    _nombreUsuario = '';
    _nombreCompleto = '';
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