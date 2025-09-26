import 'dart:io';

class AppConfig {
  static const String prodApiUrl = 'http://backend:5000/api';
  static const String devApiUrl = 'http://localhost:5000/api';
  static const String androidEmulatorApiUrl = 'http://10.0.2.2:5000/api';
  
  // Detectar automáticamente la URL correcta según la plataforma
  static String get apiBaseUrl {
    try {
      if (Platform.isAndroid) {
        // En emulador de Android, localhost es el emulador, no el host
        return androidEmulatorApiUrl;
      } else if (Platform.isIOS) {
        // En simulador de iOS, localhost funciona normalmente
        return devApiUrl;
      } else {
        // Web y otras plataformas
        return devApiUrl;
      }
    } catch (e) {
      // Fallback para web (donde Platform no está disponible)
      return devApiUrl;
    }
  }
  
  static const Duration connectTimeout = Duration(seconds: 10);
  static const Duration receiveTimeout = Duration(seconds: 10);
  
  static const Map<String, String> defaultHeaders = {
    'Content-Type': 'application/json',
  };
}
