import 'package:flutter/foundation.dart';
import '../servicios/api_service.dart';

/// ViewModel para el panel de administración
/// Maneja la lógica de gestión de usuarios y estadísticas para administradores
/// Controla el acceso a funcionalidades administrativas del sistema
class AdminViewModel extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  
  // Estados del ViewModel
  bool _estaCargando = false;
  String _error = '';
  Map<String, dynamic>? _datosAdmin;
  List<Map<String, dynamic>> _listaPacientes = [];
  List<Map<String, dynamic>> _pacientesFiltrados = [];
  List<Map<String, dynamic>> _diagnosticosRecientes = [];
  List<Map<String, dynamic>> _actividadReciente = [];
  Map<String, dynamic> _estadisticas = {};
  String _terminoBusqueda = '';

  // Getters para acceder a los estados desde la Vista
  bool get estaCargando => _estaCargando;
  bool get isLoading => _estaCargando; // Alias para compatibilidad
  String get error => _error;
  String? get mensajeError => _error.isNotEmpty ? _error : null;
  Map<String, dynamic>? get datosAdmin => _datosAdmin;
  List<Map<String, dynamic>> get listaPacientes => _listaPacientes;
  List<Map<String, dynamic>> get pacientesFiltrados => _pacientesFiltrados;
  List<Map<String, dynamic>> get diagnosticosRecientes => _diagnosticosRecientes;
  List<Map<String, dynamic>> get actividadReciente => _actividadReciente;
  Map<String, dynamic> get estadisticas => _estadisticas;
  Map<String, dynamic>? get estadisticasGenerales => _estadisticas;

  /// Carga todos los datos necesarios para el panel de administración
  /// Obtiene lista de pacientes, diagnósticos recientes y estadísticas
  Future<void> cargarDatosAdmin() async {
    _estaCargando = true;
    _error = '';
    notifyListeners();

    try {
      // Simulación de carga de datos - integrar con ApiService cuando esté disponible
      await Future.delayed(const Duration(seconds: 2));
      
      // Datos simulados para el panel administrativo
      _listaPacientes = [
        {
          'id': 1,
          'nombre': 'Juan',
          'apellidos': 'Pérez García',
          'email': 'juan.perez@email.com',
          'edad': 35,
          'ultimoDiagnostico': '2024-01-15',
          'ultimo_riesgo': 0.2,
        },
        {
          'id': 2,
          'nombre': 'María',
          'apellidos': 'González López',
          'email': 'maria.gonzalez@email.com',
          'edad': 42,
          'ultimoDiagnostico': '2024-01-14',
          'ultimo_riesgo': 0.7,
        },
        {
          'id': 3,
          'nombre': 'Carlos',
          'apellidos': 'Rodríguez Martín',
          'email': 'carlos.rodriguez@email.com',
          'edad': 58,
          'ultimoDiagnostico': '2024-01-13',
          'ultimo_riesgo': 0.4,
        },
      ];
      
      _pacientesFiltrados = List.from(_listaPacientes);
      
      _estadisticas = {
        'totalPacientes': _listaPacientes.length,
        'diagnosticosHoy': 12,
        'riesgoAlto': 3,
        'uptime': 72,
      };
      
      _actividadReciente = [
        {
          'tipo': 'diagnostico',
          'descripcion': 'Nuevo diagnóstico realizado a María González',
          'timestamp': '2024-01-15 14:30',
        },
        {
          'tipo': 'registro',
          'descripcion': 'Nuevo usuario registrado: Carlos Rodríguez',
          'timestamp': '2024-01-15 12:15',
        },
        {
          'tipo': 'diagnostico',
          'descripcion': 'Diagnóstico de riesgo alto para paciente Juan Pérez',
          'timestamp': '2024-01-15 10:45',  
        },
      ];
      
      _estaCargando = false;
      notifyListeners();

    } catch (e) {
      _error = 'Error al cargar datos del panel admin: ${e.toString()}';
      _estaCargando = false;
      notifyListeners();
    }
  }

  /// Obtiene diagnósticos detallados de un paciente específico
  /// Usado cuando el admin hace clic en "Detalles" de un paciente
  Future<List<Map<String, dynamic>>> obtenerDiagnosticosPaciente(String usernamePaciente) async {
    try {
      final response = await _apiService.obtenerDiagnosticosAdmin(usernamePaciente);
      return List<Map<String, dynamic>>.from(response['diagnosticos'] ?? []);
    } catch (e) {
      _error = 'Error al cargar diagnósticos del paciente: ${e.toString()}';
      notifyListeners();
      return [];
    }
  }

  /// Obtiene un diagnóstico específico con todos sus detalles
  /// Usado para mostrar información completa de un diagnóstico
  Future<Map<String, dynamic>?> obtenerDiagnosticoDetallado(String usernamePaciente, int diagnosticoId) async {
    try {
      final response = await _apiService.obtenerDiagnosticosAdmin(usernamePaciente, diagnosticoId: diagnosticoId);
      return response['diagnostico'];
    } catch (e) {
      _error = 'Error al cargar detalles del diagnóstico: ${e.toString()}';
      notifyListeners();
      return null;
    }
  }

  /// Obtiene estadísticas de riesgo cardiovascular por niveles
  Map<String, int> get estadisticasRiesgo {
    if (_estadisticas.isEmpty) return {};
    
    return {
      'Bajo': _estadisticas['riesgo_bajo'] ?? 0,
      'Moderado': _estadisticas['riesgo_moderado'] ?? 0,
      'Alto': _estadisticas['riesgo_alto'] ?? 0,
      'Muy Alto': _estadisticas['riesgo_muy_alto'] ?? 0,
    };
  }

  /// Obtiene el total de pacientes registrados
  int get totalPacientes => _estadisticas['total_pacientes'] ?? _listaPacientes.length;

  /// Obtiene el total de diagnósticos realizados
  int get totalDiagnosticos => _estadisticas['total_diagnosticos'] ?? 0;

  /// Obtiene los diagnósticos realizados hoy
  int get diagnosticosHoy => _estadisticas['diagnosticos_hoy'] ?? 0;

  /// Obtiene los pacientes con riesgo alto que requieren atención
  List<Map<String, dynamic>> get pacientesRiesgoAlto {
    return _listaPacientes.where((paciente) {
      final ultimoRiesgo = paciente['ultimo_riesgo'];
      return ultimoRiesgo != null && ultimoRiesgo >= 0.3; // 30% o más
    }).toList();
  }

  /// Busca pacientes por nombre o email
  void buscarPacientes(String termino) {
    _terminoBusqueda = termino;
    
    if (termino.isEmpty) {
      _pacientesFiltrados = List.from(_listaPacientes);
    } else {
      final terminoLower = termino.toLowerCase();
      _pacientesFiltrados = _listaPacientes.where((paciente) {
        final nombre = (paciente['nombre'] ?? '').toLowerCase();
        final apellidos = (paciente['apellidos'] ?? '').toLowerCase();
        final email = (paciente['email'] ?? '').toLowerCase();
        
        return nombre.contains(terminoLower) ||
               apellidos.contains(terminoLower) ||
               email.contains(terminoLower);
      }).toList();
    }
    
    notifyListeners();
  }
  
  /// Elimina un paciente del sistema
  Future<void> eliminarPaciente(int pacienteId) async {
    try {
      // Simulación de eliminación - integrar con ApiService
      await Future.delayed(const Duration(milliseconds: 500));
      
      _listaPacientes.removeWhere((paciente) => paciente['id'] == pacienteId);
      _pacientesFiltrados.removeWhere((paciente) => paciente['id'] == pacienteId);
      
      // Actualizar estadísticas
      _estadisticas['totalPacientes'] = _listaPacientes.length;
      
      notifyListeners();
    } catch (e) {
      _error = 'Error al eliminar paciente: ${e.toString()}';
      notifyListeners();
    }
  }

  /// Ordena la lista de pacientes por diferentes criterios
  void ordenarPacientes(String criterio) {
    switch (criterio) {
      case 'nombre':
        _listaPacientes.sort((a, b) => 
          (a['nombre'] ?? '').compareTo(b['nombre'] ?? ''));
        break;
      case 'riesgo':
        _listaPacientes.sort((a, b) => 
          (b['ultimo_riesgo'] ?? 0.0).compareTo(a['ultimo_riesgo'] ?? 0.0));
        break;
      case 'fecha':
        _listaPacientes.sort((a, b) => 
          DateTime.parse(b['ultimo_diagnostico'] ?? '1900-01-01')
            .compareTo(DateTime.parse(a['ultimo_diagnostico'] ?? '1900-01-01')));
        break;
    }
    notifyListeners();
  }

  /// Refresca los datos del panel admin
  Future<void> refrescarDatos() async {
    await cargarDatosAdmin();
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