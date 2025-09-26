import 'package:flutter/foundation.dart';
import '../servicios/api_service.dart';

/// ViewModel para el registro de nuevos usuarios
/// Maneja la lógica de negocio para crear nuevas cuentas de usuario
/// Siguiendo el patrón MVVM, separa la lógica de la presentación
class RegistroViewModel extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  
  // Estados del ViewModel
  bool _estaCargando = false;
  String? _mensajeError;
  String? _mensajeExito;
  
  // Datos del formulario de registro
  String _usuario = '';
  String _contrasena = '';
  String _confirmarContrasena = '';
  String _nombre = '';
  String _apellido = '';
  String _fechaNacimiento = '';
  String _genero = '';
  String _telefono = '';
  String _dni = '';
  String _direccion = '';

  // Getters para acceder a los estados desde la Vista
  bool get estaCargando => _estaCargando;
  bool get isLoading => _estaCargando; // Alias para compatibilidad
  String? get mensajeError => _mensajeError;
  String? get mensajeExito => _mensajeExito;
  
  // Getters para los datos del formulario
  String get usuario => _usuario;
  String get contrasena => _contrasena;
  String get confirmarContrasena => _confirmarContrasena;
  String get nombre => _nombre;
  String get apellido => _apellido;
  String get fechaNacimiento => _fechaNacimiento;
  String get genero => _genero;
  String get telefono => _telefono;
  String get dni => _dni;
  String get direccion => _direccion;

  // Setters para actualizar los datos del formulario
  void setUsuario(String valor) {
    _usuario = valor;
    _limpiarMensajes();
  }

  void setContrasena(String valor) {
    _contrasena = valor;
    _limpiarMensajes();
  }

  void setConfirmarContrasena(String valor) {
    _confirmarContrasena = valor;
    _limpiarMensajes();
  }

  void setNombre(String valor) {
    _nombre = valor;
    _limpiarMensajes();
  }

  void setApellido(String valor) {
    _apellido = valor;
    _limpiarMensajes();
  }

  void setFechaNacimiento(String valor) {
    _fechaNacimiento = valor;
    _limpiarMensajes();
  }

  void setGenero(String valor) {
    _genero = valor;
    _limpiarMensajes();
  }

  void setTelefono(String valor) {
    _telefono = valor;
    _limpiarMensajes();
  }

  void setDni(String valor) {
    _dni = valor;
    _limpiarMensajes();
  }

  void setDireccion(String valor) {
    _direccion = valor;
    _limpiarMensajes();
  }

  /// Valida los datos del formulario antes del registro
  bool _validarDatos() {
    if (_usuario.isEmpty) {
      _mensajeError = 'El usuario es requerido';
      return false;
    }

    if (_contrasena.isEmpty) {
      _mensajeError = 'La contraseña es requerida';
      return false;
    }

    if (_contrasena != _confirmarContrasena) {
      _mensajeError = 'Las contraseñas no coinciden';
      return false;
    }

    if (_contrasena.length < 6) {
      _mensajeError = 'La contraseña debe tener al menos 6 caracteres';
      return false;
    }

    if (_nombre.isEmpty) {
      _mensajeError = 'El nombre es requerido';
      return false;
    }

    if (_apellido.isEmpty) {
      _mensajeError = 'El apellido es requerido';
      return false;
    }

    if (_fechaNacimiento.isEmpty) {
      _mensajeError = 'La fecha de nacimiento es requerida';
      return false;
    }

    if (_genero.isEmpty) {
      _mensajeError = 'El género es requerido';
      return false;
    }

    if (_telefono.isEmpty) {
      _mensajeError = 'El teléfono es requerido';
      return false;
    }

    if (_dni.isEmpty) {
      _mensajeError = 'El DNI es requerido';
      return false;
    }

    if (_direccion.isEmpty) {
      _mensajeError = 'La dirección es requerida';
      return false;
    }

    return true;
  }

  /// Registra un nuevo usuario en el sistema
  /// Se comunica con el backend a través del ApiService
  /// Retorna true si el registro fue exitoso, false en caso contrario
  Future<bool> registrarUsuario() async {
    if (!_validarDatos()) {
      notifyListeners();
      return false;
    }

    _estaCargando = true;
    _mensajeError = null;
    _mensajeExito = null;
    notifyListeners();

    try {
      // Preparar datos para enviar al backend
      final datosRegistro = {
        'username': _usuario,
        'password': _contrasena,
        'nombre': _nombre,
        'apellido': _apellido,
        'fecha_nacimiento': _fechaNacimiento,
        'genero': _genero,
        'telefono': _telefono,
        'dni': _dni,
        'direccion': _direccion,
      };

      // Llamar al servicio de API para registrar el usuario
      await _apiService.registrarUsuario(datosRegistro);
      
      _mensajeExito = 'Usuario registrado exitosamente';
      _estaCargando = false;
      notifyListeners();
      return true;

    } catch (e) {
      _mensajeError = 'Error al registrar usuario: ${e.toString()}';
      _estaCargando = false;
      notifyListeners();
      return false;
    }
  }

  /// Limpia los mensajes de error y éxito
  void _limpiarMensajes() {
    if (_mensajeError != null || _mensajeExito != null) {
      _mensajeError = null;
      _mensajeExito = null;
      notifyListeners();
    }
  }

  /// Limpia todos los datos del formulario
  void limpiarFormulario() {
    _usuario = '';
    _contrasena = '';
    _confirmarContrasena = '';
    _nombre = '';
    _apellido = '';
    _fechaNacimiento = '';
    _genero = '';
    _telefono = '';
    _dni = '';
    _direccion = '';
    _mensajeError = null;
    _mensajeExito = null;
    notifyListeners();
  }

  @override
  void dispose() {
    _apiService.dispose();
    super.dispose();
  }
}