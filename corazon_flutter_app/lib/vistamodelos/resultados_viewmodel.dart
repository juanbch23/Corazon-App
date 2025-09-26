import 'package:flutter/material.dart';
import '../servicios/api_service.dart';
import '../modelos/diagnostico_cardiovascular.dart';

/// ViewModel para la Vista de Resultados y Historial Cardiovascular
/// 
/// Maneja toda la lógica relacionada con:
/// - Carga del historial de diagnósticos del usuario
/// - Visualización de estadísticas de riesgo cardiovascular
/// - Filtrado y búsqueda de resultados por fecha
/// - Gestión de gráficos y tendencias de salud
/// - Comunicación con el backend para obtener diagnósticos históricos
/// 
/// Integrado con el sistema de diagnóstico cardiovascular Docker + PostgreSQL
class ResultadosViewModel extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  
  // Estado de la vista
  bool _estaCargando = false;
  String _error = '';
  
  // Datos de resultados y historial
  List<ResultadoDiagnostico> _historialDiagnosticos = [];
  List<ResultadoDiagnostico> _resultadosFiltrados = [];
  Map<String, dynamic> _estadisticasUsuario = {};
  String _filtroFecha = 'todos'; // 'todos', 'mes', 'trimestre', 'año'
  String _filtroRiesgo = 'todos'; // 'todos', 'bajo', 'moderado', 'alto'
  
  // Datos para gráficos y tendencias
  List<Map<String, dynamic>> _datosGraficoTendencia = [];
  Map<String, int> _distribucionRiesgo = {};
  
  // Getters para acceso desde la Vista
  bool get estaCargando => _estaCargando;
  bool get isLoading => _estaCargando; // Alias para compatibilidad
  String get error => _error;
  List<ResultadoDiagnostico> get historialDiagnosticos => _historialDiagnosticos;
  List<ResultadoDiagnostico> get resultadosFiltrados => _resultadosFiltrados;
  List<ResultadoDiagnostico> get resultados => _resultadosFiltrados.isNotEmpty ? _resultadosFiltrados : _historialDiagnosticos; // Lista principal de resultados
  Map<String, dynamic> get estadisticasUsuario => _estadisticasUsuario;
  List<Map<String, dynamic>> get datosGraficoTendencia => _datosGraficoTendencia;
  Map<String, int> get distribucionRiesgo => _distribucionRiesgo;
  String get filtroFecha => _filtroFecha;
  String get filtroRiesgo => _filtroRiesgo;
  
  // Getters para estadísticas rápidas
  int get totalDiagnosticos => _historialDiagnosticos.length;
  double get riesgoPromedio => _calcularRiesgoPromedio();
  String get ultimoDiagnostico => _obtenerUltimoDiagnostico();
  String get tendenciaRiesgo => _calcularTendenciaRiesgo();
  
  // Getter para el último resultado (compatibilidad con ResultadosVista)
  ResultadoDiagnostico? get ultimoResultado => _historialDiagnosticos.isNotEmpty ? _historialDiagnosticos.first : null;
  
  @override
  void dispose() {
    super.dispose();
  }
  
  /// Carga todos los resultados de diagnósticos del usuario
  /// Obtiene el historial completo desde el backend PostgreSQL
  Future<void> cargarResultados() async {
    _setEstaCargando(true);
    _setError('');
    
    try {
      // Simulación de carga de datos - integrar con ApiService cuando esté disponible
      await Future.delayed(const Duration(seconds: 2));
      
      // Datos simulados de historial - reemplazar con llamada real al backend
      _historialDiagnosticos = [
        ResultadoDiagnostico(
          id: 1,
          fecha: DateTime.now().subtract(const Duration(days: 7)),
          probabilidadRiesgo: 0.15,
          nivelRiesgo: 'Bajo',
          recomendaciones: [
            'Mantener actividad física regular',
            'Continuar con dieta balanceada',
            'Control anual con cardiólogo'
          ],
          parametrosClinicos: {
            'presionArterial': '120/80',
            'colesterol': '180 mg/dl',
            'frecuenciaCardiaca': '72 bpm',
          },
        ),
        ResultadoDiagnostico(
          id: 2,
          fecha: DateTime.now().subtract(const Duration(days: 30)),
          probabilidadRiesgo: 0.35,
          nivelRiesgo: 'Moderado',
          recomendaciones: [
            'Reducir consumo de sal',
            'Incrementar ejercicio cardiovascular',
            'Control cada 6 meses'
          ],
          parametrosClinicos: {
            'presionArterial': '140/90',
            'colesterol': '220 mg/dl',
            'frecuenciaCardiaca': '85 bpm',
          },
        ),
        ResultadoDiagnostico(
          id: 3,
          fecha: DateTime.now().subtract(const Duration(days: 90)),
          probabilidadRiesgo: 0.45,
          nivelRiesgo: 'Alto',
          recomendaciones: [
            'Consulta inmediata con cardiólogo',
            'Medicación según prescripción médica',
            'Cambios urgentes en estilo de vida'
          ],
          parametrosClinicos: {
            'presionArterial': '160/100',
            'colesterol': '280 mg/dl',
            'frecuenciaCardiaca': '95 bpm',
          },
        ),
      ];
      
      // Inicializar filtros y estadísticas
      _resultadosFiltrados = List.from(_historialDiagnosticos);
      _calcularEstadisticasUsuario();
      _generarDatosGraficos();
      
    } catch (e) {
      _setError('Error al cargar resultados: $e');
    } finally {
      _setEstaCargando(false);
    }
  }
  
  /// Aplica filtros de fecha a los resultados
  void aplicarFiltroFecha(String filtro) {
    _filtroFecha = filtro;
    _aplicarFiltros();
    notifyListeners();
  }
  
  /// Aplica filtros de nivel de riesgo a los resultados
  void aplicarFiltroRiesgo(String filtro) {
    _filtroRiesgo = filtro;
    _aplicarFiltros();
    notifyListeners();
  }
  
  /// Aplica todos los filtros activos a la lista de resultados
  void _aplicarFiltros() {
    List<ResultadoDiagnostico> resultados = List.from(_historialDiagnosticos);
    
    // Filtro por fecha
    if (_filtroFecha != 'todos') {
      final ahora = DateTime.now();
      DateTime fechaLimite;
      
      switch (_filtroFecha) {
        case 'mes':
          fechaLimite = ahora.subtract(const Duration(days: 30));
          break;
        case 'trimestre':
          fechaLimite = ahora.subtract(const Duration(days: 90));
          break;
        case 'año':
          fechaLimite = ahora.subtract(const Duration(days: 365));
          break;
        default:
          fechaLimite = DateTime(1900);
      }
      
      resultados = resultados.where((resultado) => 
        resultado.fecha.isAfter(fechaLimite)).toList();
    }
    
    // Filtro por nivel de riesgo
    if (_filtroRiesgo != 'todos') {
      resultados = resultados.where((resultado) => 
        resultado.nivelRiesgo.toLowerCase() == _filtroRiesgo.toLowerCase()).toList();
    }
    
    _resultadosFiltrados = resultados;
  }
  
  /// Calcula estadísticas generales del usuario
  void _calcularEstadisticasUsuario() {
    if (_historialDiagnosticos.isEmpty) {
      _estadisticasUsuario = {};
      return;
    }
    
    final riesgos = _historialDiagnosticos.map((r) => r.probabilidadRiesgo).toList();
    final promedio = riesgos.reduce((a, b) => a + b) / riesgos.length;
    
    _estadisticasUsuario = {
      'totalDiagnosticos': _historialDiagnosticos.length,
      'riesgoPromedio': promedio,
      'riesgoMinimo': riesgos.reduce((a, b) => a < b ? a : b),
      'riesgoMaximo': riesgos.reduce((a, b) => a > b ? a : b),
      'ultimaEvaluacion': _historialDiagnosticos.first.fecha,
      'tendencia': _calcularTendenciaRiesgo(),
    };
    
    // Calcular distribución de riesgo
    _distribucionRiesgo = {
      'Bajo': _historialDiagnosticos.where((r) => r.nivelRiesgo == 'Bajo').length,
      'Moderado': _historialDiagnosticos.where((r) => r.nivelRiesgo == 'Moderado').length,
      'Alto': _historialDiagnosticos.where((r) => r.nivelRiesgo == 'Alto').length,
    };
  }
  
  /// Genera datos para los gráficos de tendencia
  void _generarDatosGraficos() {
    _datosGraficoTendencia = _historialDiagnosticos.map((resultado) => {
      'fecha': resultado.fecha,
      'riesgo': resultado.probabilidadRiesgo,
      'nivel': resultado.nivelRiesgo,
    }).toList();
    
    // Ordenar por fecha para el gráfico
    _datosGraficoTendencia.sort((a, b) => 
      (a['fecha'] as DateTime).compareTo(b['fecha'] as DateTime));
  }
  
  /// Calcula el riesgo promedio de todos los diagnósticos
  double _calcularRiesgoPromedio() {
    if (_historialDiagnosticos.isEmpty) return 0.0;
    
    final suma = _historialDiagnosticos
        .map((r) => r.probabilidadRiesgo)
        .reduce((a, b) => a + b);
    
    return suma / _historialDiagnosticos.length;
  }
  
  /// Obtiene la fecha del último diagnóstico
  String _obtenerUltimoDiagnostico() {
    if (_historialDiagnosticos.isEmpty) return 'Nunca';
    
    final ultimo = _historialDiagnosticos.first.fecha;
    final diferencia = DateTime.now().difference(ultimo).inDays;
    
    if (diferencia == 0) return 'Hoy';
    if (diferencia == 1) return 'Ayer';
    if (diferencia < 7) return 'Hace $diferencia días';
    if (diferencia < 30) return 'Hace ${(diferencia / 7).floor()} semanas';
    return 'Hace ${(diferencia / 30).floor()} meses';
  }
  
  /// Calcula la tendencia del riesgo (mejorando/empeorando/estable)
  String _calcularTendenciaRiesgo() {
    if (_historialDiagnosticos.length < 2) return 'Insuficientes datos';
    
    final riesgoActual = _historialDiagnosticos.first.probabilidadRiesgo;
    final riesgoAnterior = _historialDiagnosticos[1].probabilidadRiesgo;
    
    final diferencia = riesgoActual - riesgoAnterior;
    
    if (diferencia.abs() < 0.05) return 'Estable';
    return diferencia > 0 ? 'Empeorando' : 'Mejorando';
  }
  
  /// Obtiene un resultado específico por ID
  ResultadoDiagnostico? obtenerResultadoPorId(int id) {
    try {
      return _historialDiagnosticos.firstWhere((r) => r.id == id);
    } catch (e) {
      return null;
    }
  }
  
  /// Refresca todos los datos de resultados
  Future<void> refrescarDatos() async {
    await cargarResultados();
  }
  
  /// Limpia los filtros aplicados
  void limpiarFiltros() {
    _filtroFecha = 'todos';
    _filtroRiesgo = 'todos';
    _aplicarFiltros();
    notifyListeners();
  }
  
  // Métodos helper para actualizar el estado
  void _setEstaCargando(bool valor) {
    _estaCargando = valor;
    notifyListeners();
  }
  
  void _setError(String mensaje) {
    _error = mensaje;
    notifyListeners();
  }
}