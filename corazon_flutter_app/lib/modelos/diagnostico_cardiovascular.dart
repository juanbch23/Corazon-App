/// Modelos para el Sistema de Diagnóstico Cardiovascular
/// 
/// Compatible con:
/// - Backend Docker: PostgreSQL + Flask + TensorFlow Lite
/// - Modelo de IA para predicción de riesgo cardiovascular
/// - Patrón MVVM con ViewModels especializados
library;

/// Modelo de Datos Clínicos para Diagnóstico Cardiovascular
/// 
/// Contiene todos los parámetros médicos necesarios para la evaluación
/// de riesgo cardiovascular usando inteligencia artificial.
/// Los valores están estandarizados según protocolos médicos internacionales.
class DatosClinicosCardiovasculares {
  final int edad; // Edad del paciente en años
  final int sexo; // 1 = Masculino, 0 = Femenino
  final int tipoDolorPecho; // 1-4 según clasificación médica
  final int presionArterialReposo; // Presión sistólica en mmHg
  final int colesterol; // Colesterol sérico en mg/dl
  final int azucarSangre; // 1 = >120 mg/dl, 0 = <=120 mg/dl
  final int electrocardiogramaReposo; // 0-2 según clasificación
  final int frecuenciaCardiacaMaxima; // Frecuencia cardíaca máxima alcanzada
  final int anginaInducidaEjercicio; // 1 = Sí, 0 = No
  final double depresionST; // Depresión del segmento ST inducida por ejercicio
  final int pendienteSegmentoST; // 1-3 según clasificación
  final int numeroVasosColoreados; // 0-3 vasos principales coloreados por fluoroscopia
  final int talasemia; // 3, 6, 7 según clasificación médica

  DatosClinicosCardiovasculares({
    required this.edad,
    required this.sexo,
    required this.tipoDolorPecho,
    required this.presionArterialReposo,
    required this.colesterol,
    required this.azucarSangre,
    required this.electrocardiogramaReposo,
    required this.frecuenciaCardiacaMaxima,
    required this.anginaInducidaEjercicio,
    required this.depresionST,
    required this.pendienteSegmentoST,
    required this.numeroVasosColoreados,
    required this.talasemia,
  });

  /// Crea una instancia desde JSON del backend
  factory DatosClinicosCardiovasculares.fromJson(Map<String, dynamic> json) {
    return DatosClinicosCardiovasculares(
      edad: json['edad'] ?? 0,
      sexo: json['sexo'] ?? 0,
      tipoDolorPecho: json['tipo_dolor_pecho'] ?? 1,
      presionArterialReposo: json['presion_arterial_reposo'] ?? 120,
      colesterol: json['colesterol'] ?? 200,
      azucarSangre: json['azucar_sangre'] ?? 0,
      electrocardiogramaReposo: json['electrocardiograma_reposo'] ?? 0,
      frecuenciaCardiacaMaxima: json['frecuencia_cardiaca_maxima'] ?? 150,
      anginaInducidaEjercicio: json['angina_inducida_ejercicio'] ?? 0,
      depresionST: (json['depresion_st'] ?? 0.0).toDouble(),
      pendienteSegmentoST: json['pendiente_segmento_st'] ?? 1,
      numeroVasosColoreados: json['numero_vasos_coloreados'] ?? 0,
      talasemia: json['talasemia'] ?? 3,
    );
  }

  /// Convierte a JSON para envío al backend
  Map<String, dynamic> toJson() {
    return {
      'edad': edad,
      'sexo': sexo,
      'tipo_dolor_pecho': tipoDolorPecho,
      'presion_arterial_reposo': presionArterialReposo,
      'colesterol': colesterol,
      'azucar_sangre': azucarSangre,
      'electrocardiograma_reposo': electrocardiogramaReposo,
      'frecuencia_cardiaca_maxima': frecuenciaCardiacaMaxima,
      'angina_inducida_ejercicio': anginaInducidaEjercicio,
      'depresion_st': depresionST,
      'pendiente_segmento_st': pendienteSegmentoST,
      'numero_vasos_coloreados': numeroVasosColoreados,
      'talasemia': talasemia,
    };
  }

  @override
  String toString() {
    return 'DatosClinicosCardiovasculares(edad: $edad, sexo: $sexo, tipoDolorPecho: $tipoDolorPecho, presionArterialReposo: $presionArterialReposo, colesterol: $colesterol, azucarSangre: $azucarSangre, electrocardiogramaReposo: $electrocardiogramaReposo, frecuenciaCardiacaMaxima: $frecuenciaCardiacaMaxima, anginaInducidaEjercicio: $anginaInducidaEjercicio, depresionST: $depresionST, pendienteSegmentoST: $pendienteSegmentoST, numeroVasosColoreados: $numeroVasosColoreados, talasemia: $talasemia)';
  }
}

/// Modelo de Resultado de Diagnóstico Cardiovascular
/// 
/// Representa el resultado completo de una evaluación cardiovascular,
/// incluyendo el nivel de riesgo calculado por la IA, recomendaciones
/// médicas y parámetros clínicos utilizados.
/// 
/// Usado para:
/// - Mostrar historial de diagnósticos en ResultadosVista
/// - Generar gráficos de tendencia de riesgo
/// - Almacenar resultados en base de datos PostgreSQL
class ResultadoDiagnostico {
  final int id; // ID único del diagnóstico
  final DateTime fecha; // Fecha y hora del diagnóstico
  final double probabilidadRiesgo; // Probabilidad de riesgo (0.0 - 1.0)
  final String nivelRiesgo; // 'Bajo', 'Moderado', 'Alto'
  final List<String> recomendaciones; // Recomendaciones médicas
  final Map<String, String> parametrosClinicos; // Parámetros clave mostrados
  final int? usuarioId; // ID del usuario que realizó el diagnóstico
  final DatosClinicosCardiovasculares? datosCompletos; // Datos completos utilizados

  ResultadoDiagnostico({
    required this.id,
    required this.fecha,
    required this.probabilidadRiesgo,
    required this.nivelRiesgo,
    required this.recomendaciones,
    required this.parametrosClinicos,
    this.usuarioId,
    this.datosCompletos,
  });

  /// Crea una instancia desde JSON del backend
  factory ResultadoDiagnostico.fromJson(Map<String, dynamic> json) {
    return ResultadoDiagnostico(
      id: json['id'] ?? 0,
      fecha: DateTime.tryParse(json['fecha_diagnostico'] ?? '') ?? DateTime.now(),
      probabilidadRiesgo: (json['riesgo_cardiovascular'] ?? 0.0).toDouble(),
      nivelRiesgo: json['nivel_riesgo'] ?? _calcularNivelRiesgo(json['riesgo_cardiovascular'] ?? 0.0),
      recomendaciones: List<String>.from(json['recomendaciones'] ?? []),
      parametrosClinicos: Map<String, String>.from(json['parametros_clinicos'] ?? {}),
      usuarioId: json['usuario_id'],
      datosCompletos: json['datos_utilizados'] != null 
          ? DatosClinicosCardiovasculares.fromJson(json['datos_utilizados'])
          : null,
    );
  }

  /// Convierte a JSON para almacenamiento
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fecha_diagnostico': fecha.toIso8601String(),
      'riesgo_cardiovascular': probabilidadRiesgo,
      'nivel_riesgo': nivelRiesgo,
      'recomendaciones': recomendaciones,
      'parametros_clinicos': parametrosClinicos,
      'usuario_id': usuarioId,
      'datos_utilizados': datosCompletos?.toJson(),
    };
  }

  /// Calcula el nivel de riesgo basado en la probabilidad
  static String _calcularNivelRiesgo(double probabilidad) {
    if (probabilidad < 0.3) return 'Bajo';
    if (probabilidad < 0.6) return 'Moderado';
    return 'Alto';
  }

  /// Obtiene el color representativo del nivel de riesgo
  String get colorRiesgo {
    switch (nivelRiesgo.toLowerCase()) {
      case 'bajo':
        return '#4CAF50'; // Verde
      case 'moderado':
        return '#FF9800'; // Naranja
      case 'alto':
        return '#F44336'; // Rojo
      default:
        return '#9E9E9E'; // Gris
    }
  }

  /// Obtiene un resumen legible del diagnóstico
  String get resumen {
    return 'Riesgo $nivelRiesgo (${(probabilidadRiesgo * 100).toStringAsFixed(1)}%) - ${fecha.day}/${fecha.month}/${fecha.year}';
  }

  @override
  String toString() {
    return 'ResultadoDiagnostico(id: $id, fecha: $fecha, probabilidadRiesgo: $probabilidadRiesgo, nivelRiesgo: $nivelRiesgo)';
  }
}