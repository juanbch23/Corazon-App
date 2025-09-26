import 'package:flutter/material.dart';
import '../servicios/api_service.dart';

/// ViewModel para la gestión de configuración del usuario
/// 
/// Maneja toda la lógica relacionada con:
/// - Carga y actualización del perfil de usuario
/// - Validación de datos de configuración
/// - Gestión de preferencias de la aplicación
/// - Comunicación con el backend para persistir cambios
class ConfiguracionViewModel extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  
  // Estado de la vista
  bool _estaCargando = false;
  String _error = '';
  bool _hayCambios = false;
  
  // Controladores de texto para los campos del formulario
  final TextEditingController nombreController = TextEditingController();
  final TextEditingController apellidosController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController edadController = TextEditingController();
  final TextEditingController pesoController = TextEditingController();
  final TextEditingController alturaController = TextEditingController();
  
  // Datos del usuario y configuraciones
  String _sexoSeleccionado = '';
  bool _notificacionesActivadas = true;
  bool _modoOscuroActivado = false;
  bool _guardarHistorial = true;
  
  // Datos originales para detectar cambios
  Map<String, dynamic> _datosOriginales = {};
  
  // Opciones para dropdowns
  final List<String> opcionesSexo = ['Masculino', 'Femenino', 'Otro'];
  
  // Getters para el estado
  bool get estaCargando => _estaCargando;
  String get error => _error;
  bool get hayCambios => _hayCambios;
  
  // Getters para los datos del usuario
  String get sexoSeleccionado => _sexoSeleccionado;
  bool get notificacionesActivadas => _notificacionesActivadas;
  bool get modoOscuroActivado => _modoOscuroActivado;
  bool get guardarHistorial => _guardarHistorial;
  
  @override
  void dispose() {
    // Limpiar controladores al destruir el ViewModel
    nombreController.dispose();
    apellidosController.dispose();
    emailController.dispose();
    edadController.dispose();
    pesoController.dispose();
    alturaController.dispose();
    super.dispose();
  }
  
  /// Carga los datos del usuario desde el backend
  Future<void> cargarDatosUsuario() async {
    _setEstaCargando(true);
    _setError('');
    
    try {
      // Simulación de carga de datos - integrar con ApiService cuando esté disponible
      await Future.delayed(const Duration(seconds: 1));
      
      // Datos de ejemplo - reemplazar con llamada real al backend
      final datosUsuario = {
        'nombre': 'Juan',
        'apellidos': 'Pérez García',
        'email': 'juan.perez@email.com',
        'edad': 35,
        'sexo': 'Masculino',
        'peso': 75.5,
        'altura': 175,
        'notificaciones': true,
        'modoOscuro': false,
        'guardarHistorial': true,
      };
      
      // Llenar los controladores con los datos cargados
      nombreController.text = datosUsuario['nombre']?.toString() ?? '';
      apellidosController.text = datosUsuario['apellidos']?.toString() ?? '';
      emailController.text = datosUsuario['email']?.toString() ?? '';
      edadController.text = datosUsuario['edad']?.toString() ?? '';
      pesoController.text = datosUsuario['peso']?.toString() ?? '';
      alturaController.text = datosUsuario['altura']?.toString() ?? '';
      
      _sexoSeleccionado = datosUsuario['sexo']?.toString() ?? '';
      _notificacionesActivadas = (datosUsuario['notificaciones'] as bool?) ?? true;
      _modoOscuroActivado = (datosUsuario['modoOscuro'] as bool?) ?? false;
      _guardarHistorial = (datosUsuario['guardarHistorial'] as bool?) ?? true;
      
      // Guardar copia de los datos originales para detectar cambios
      _datosOriginales = Map<String, dynamic>.from(datosUsuario);
      _hayCambios = false;
      
      // Configurar listeners para detectar cambios en los controladores
      _configurarListeners();
      
    } catch (e) {
      _setError('Error al cargar la configuración: $e');
    } finally {
      _setEstaCargando(false);
    }
  }
  
  /// Configura los listeners para detectar cambios en los controladores
  void _configurarListeners() {
    nombreController.addListener(_verificarCambios);
    apellidosController.addListener(_verificarCambios);
    edadController.addListener(_verificarCambios);
    pesoController.addListener(_verificarCambios);
    alturaController.addListener(_verificarCambios);
  }
  
  /// Guarda los cambios realizados en la configuración
  Future<bool> guardarCambios() async {
    if (!_hayCambios) return true;
    
    _setEstaCargando(true);
    _setError('');
    
    try {
      // Preparar datos para envío
      final datosActualizados = {
        'nombre': nombreController.text,
        'apellidos': apellidosController.text,
        'email': emailController.text,
        'edad': int.tryParse(edadController.text) ?? 0,
        'sexo': _sexoSeleccionado,
        'peso': double.tryParse(pesoController.text) ?? 0.0,
        'altura': int.tryParse(alturaController.text) ?? 0,
        'notificaciones': _notificacionesActivadas,
        'modoOscuro': _modoOscuroActivado,
        'guardarHistorial': _guardarHistorial,
      };
      
      // Simulación de guardado - integrar con ApiService
      await Future.delayed(const Duration(seconds: 2));
      
      // Aquí iría la llamada real al backend
      // await _apiService.actualizarConfiguracion(datosActualizados);
      
      // Actualizar datos originales después del guardado exitoso
      _datosOriginales = Map<String, dynamic>.from(datosActualizados);
      _hayCambios = false;
      
      return true;
    } catch (e) {
      _setError('Error al guardar la configuración: $e');
      return false;
    } finally {
      _setEstaCargando(false);
    }
  }
  
  /// Descarta los cambios realizados y restaura los datos originales
  void descartarCambios() {
    nombreController.text = _datosOriginales['nombre']?.toString() ?? '';
    apellidosController.text = _datosOriginales['apellidos']?.toString() ?? '';
    emailController.text = _datosOriginales['email']?.toString() ?? '';
    edadController.text = _datosOriginales['edad']?.toString() ?? '';
    pesoController.text = _datosOriginales['peso']?.toString() ?? '';
    alturaController.text = _datosOriginales['altura']?.toString() ?? '';
    
    _sexoSeleccionado = _datosOriginales['sexo']?.toString() ?? '';
    _notificacionesActivadas = (_datosOriginales['notificaciones'] as bool?) ?? true;
    _modoOscuroActivado = (_datosOriginales['modoOscuro'] as bool?) ?? false;
    _guardarHistorial = (_datosOriginales['guardarHistorial'] as bool?) ?? true;
    
    _hayCambios = false;
    notifyListeners();
  }
  
  /// Actualiza el sexo seleccionado
  void actualizarSexo(String? valor) {
    if (valor != null) {
      _sexoSeleccionado = valor;
      _verificarCambios();
      notifyListeners();
    }
  }
  
  /// Toggle para notificaciones
  void toggleNotificaciones(bool valor) {
    _notificacionesActivadas = valor;
    _verificarCambios();
    notifyListeners();
  }
  
  /// Toggle para modo oscuro
  void toggleModoOscuro(bool valor) {
    _modoOscuroActivado = valor;
    _verificarCambios();
    notifyListeners();
  }
  
  /// Toggle para guardar historial
  void toggleGuardarHistorial(bool valor) {
    _guardarHistorial = valor;
    _verificarCambios();
    notifyListeners();
  }
  
  /// Verifica si hay cambios pendientes comparando con los datos originales
  void _verificarCambios() {
    final datosActuales = {
      'nombre': nombreController.text,
      'apellidos': apellidosController.text,
      'email': emailController.text,
      'edad': int.tryParse(edadController.text) ?? 0,
      'sexo': _sexoSeleccionado,
      'peso': double.tryParse(pesoController.text) ?? 0.0,
      'altura': int.tryParse(alturaController.text) ?? 0,
      'notificaciones': _notificacionesActivadas,
      'modoOscuro': _modoOscuroActivado,
      'guardarHistorial': _guardarHistorial,
    };
    
    _hayCambios = !_sonIguales(datosActuales, _datosOriginales);
    notifyListeners();
  }
  
  /// Compara dos mapas para detectar diferencias
  bool _sonIguales(Map<String, dynamic> map1, Map<String, dynamic> map2) {
    if (map1.length != map2.length) return false;
    
    for (var key in map1.keys) {
      if (map1[key] != map2[key]) return false;
    }
    
    return true;
  }
  
  // Validadores para los campos del formulario
  String? validarNombre(String? valor) {
    if (valor == null || valor.isEmpty) {
      return 'El nombre es obligatorio';
    }
    if (valor.length < 2) {
      return 'El nombre debe tener al menos 2 caracteres';
    }
    return null;
  }
  
  String? validarApellidos(String? valor) {
    if (valor == null || valor.isEmpty) {
      return 'Los apellidos son obligatorios';
    }
    if (valor.length < 2) {
      return 'Los apellidos deben tener al menos 2 caracteres';
    }
    return null;
  }
  
  String? validarEmail(String? valor) {
    if (valor == null || valor.isEmpty) {
      return 'El email es obligatorio';
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(valor)) {
      return 'Ingrese un email válido';
    }
    return null;
  }
  
  String? validarEdad(String? valor) {
    if (valor == null || valor.isEmpty) {
      return 'La edad es obligatoria';
    }
    final edad = int.tryParse(valor);
    if (edad == null) {
      return 'Ingrese una edad válida';
    }
    if (edad < 18 || edad > 120) {
      return 'La edad debe estar entre 18 y 120 años';
    }
    return null;
  }
  
  String? validarPeso(String? valor) {
    if (valor == null || valor.isEmpty) {
      return 'El peso es obligatorio';
    }
    final peso = double.tryParse(valor);
    if (peso == null) {
      return 'Ingrese un peso válido';
    }
    if (peso < 30 || peso > 300) {
      return 'El peso debe estar entre 30 y 300 kg';
    }
    return null;
  }
  
  String? validarAltura(String? valor) {
    if (valor == null || valor.isEmpty) {
      return 'La altura es obligatoria';
    }
    final altura = int.tryParse(valor);
    if (altura == null) {
      return 'Ingrese una altura válida';
    }
    if (altura < 100 || altura > 250) {
      return 'La altura debe estar entre 100 y 250 cm';
    }
    return null;
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