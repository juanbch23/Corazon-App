import 'package:flutter/foundation.dart';
import '../modelos/diagnostico_cardiovascular.dart';
import '../servicios/api_service.dart';

// ViewModel para el diagnóstico cardiovascular siguiendo el patrón MVVM
class DiagnosticoViewModel extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  
  // Estados del ViewModel
  bool _estaCargando = false;
  String? _mensajeError;
  ResultadoDiagnostico? _ultimoDiagnostico;
  List<ResultadoDiagnostico> _historialDiagnosticos = [];

  // Getters para acceder a los estados
  bool get estaCargando => _estaCargando;
  bool get isLoading => _estaCargando; // Alias para compatibilidad
  String? get mensajeError => _mensajeError;
  ResultadoDiagnostico? get ultimoDiagnostico => _ultimoDiagnostico;
  Map<String, dynamic>? get ultimoResultado => _ultimoDiagnostico?.toJson(); // Para compatibilidad con ResultadosVista
  List<ResultadoDiagnostico> get historialDiagnosticos => _historialDiagnosticos;
  List<ResultadoDiagnostico> get historialResultados => _historialDiagnosticos;

  // Método para inicializar el servicio
  void init() {
    _apiService.init();
  }

  // Método para realizar diagnóstico
  Future<bool> realizarDiagnostico(
    DatosClinicosCardiovasculares datosClinicicos, 
    {String? username}
  ) async {
    _estaCargando = true;
    _mensajeError = null;
    notifyListeners();

    try {
      final response = await _apiService.diagnosticar(
        datosClinicicos.toJson(), 
        username: username
      );
      
      // Crear resultado del diagnóstico
      _ultimoDiagnostico = ResultadoDiagnostico.fromJson(response);
      
      // Agregar al historial
      if (_ultimoDiagnostico != null) {
        _historialDiagnosticos.insert(0, _ultimoDiagnostico!);
      }
      
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

  // Método para obtener resultados históricos
  Future<void> cargarHistorialResultados({String? username}) async {
    _estaCargando = true;
    _mensajeError = null;
    notifyListeners();

    try {
      final response = await _apiService.obtenerResultados(username: username);
      
      if (response['resultados'] != null) {
        _historialDiagnosticos = (response['resultados'] as List)
            .map((json) => ResultadoDiagnostico.fromJson(json))
            .toList();
      }
      
      _estaCargando = false;
      notifyListeners();

    } catch (e) {
      _mensajeError = e.toString();
      _estaCargando = false;
      notifyListeners();
    }
  }

  // Método para limpiar errores
  void limpiarError() {
    _mensajeError = null;
    notifyListeners();
  }

  // Método para limpiar diagnóstico actual
  void limpiarDiagnosticoActual() {
    _ultimoDiagnostico = null;
    notifyListeners();
  }

  // Método para cargar resultados (alias para compatibilidad)
  Future<void> cargarResultados({String? username}) async {
    await cargarHistorialResultados(username: username);
  }

  @override
  void dispose() {
    _apiService.dispose();
    super.dispose();
  }
}