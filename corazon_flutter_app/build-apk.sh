#!/bin/bash

echo "🔧 Configurando proyecto Flutter para Android..."

# Verificar configuración Flutter
flutter doctor

# Limpiar proyecto
echo "🧹 Limpiando proyecto..."
flutter clean

# Obtener dependencias
echo "📦 Obteniendo dependencias..."
flutter pub get

# Actualizar configuración de la API para producción
echo "⚙️ Configurando API para Docker..."
sed -i 's|http://localhost:5000|http://backend:5000|g' lib/services/api_service.dart

# Generar APK de release
echo "🏗️ Generando APK de release..."
flutter build apk --release

# Copiar APK generado
if [ -f "build/app/outputs/flutter-apk/app-release.apk" ]; then
    cp build/app/outputs/flutter-apk/app-release.apk /workspace/dec_cardiovascular.apk
    echo "✅ APK generado exitosamente: dec_cardiovascular.apk"
    ls -la /workspace/dec_cardiovascular.apk
else
    echo "❌ Error: No se pudo generar el APK"
    exit 1
fi

# Restaurar configuración original
sed -i 's|http://backend:5000|http://localhost:5000|g' lib/services/api_service.dart

echo "🎉 Proceso completado!"
