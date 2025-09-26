/// Modelo de Usuario para el Sistema de Diagnóstico Cardiovascular
/// 
/// Representa los datos básicos de un usuario en el sistema, incluyendo:
/// - Información de autenticación (username, tipo de usuario)
/// - Datos personales (nombre, apellidos, contacto)
/// - Integración con backend PostgreSQL Docker
/// 
/// Tipos de usuario soportados:
/// - 'paciente': Usuario regular que realiza diagnósticos
/// - 'admin': Administrador con acceso al panel de gestión
class Usuario {
  final int? id; // ID único en la base de datos PostgreSQL
  final String username; // Nombre de usuario único para login
  final String tipo; // 'paciente' o 'admin'
  final String? nombre; // Nombre real del usuario
  final String? apellido; // Apellidos del usuario
  final String? telefono; // Número de contacto
  final String? email; // Email de contacto y notificaciones

  Usuario({
    this.id,
    required this.username,
    required this.tipo,
    this.nombre,
    this.apellido,
    this.telefono,
    this.email,
  });

  factory Usuario.fromJson(Map<String, dynamic> json) {
    return Usuario(
      id: json['id'],
      username: json['username'] ?? '',
      tipo: json['tipo'] ?? json['user_type'] ?? '',
      nombre: json['nombre'],
      apellido: json['apellido'],
      telefono: json['telefono'],
      email: json['email'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'tipo': tipo,
      'nombre': nombre,
      'apellido': apellido,
      'telefono': telefono,
      'email': email,
    };
  }

  bool get esAdministrador => tipo.toLowerCase() == 'administrador';
  bool get esPaciente => tipo.toLowerCase() == 'paciente';
}