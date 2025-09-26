@echo off
echo =========================================
echo  GENERANDO APK ANDROID
echo =========================================
echo.

echo [1/2] Construyendo contenedor Android...
docker-compose build android_builder

echo.
echo [2/2] Generando APK...
docker-compose run --rm android_builder

echo.
if exist "corazon_flutter_app\dec_cardiovascular.apk" (
    echo ✅ APK generado exitosamente!
    echo 📱 Ubicación: corazon_flutter_app\dec_cardiovascular.apk
    echo.
    echo 📊 Información del APK:
    dir "corazon_flutter_app\dec_cardiovascular.apk"
) else (
    echo ❌ Error al generar APK
    echo 📋 Revisa los logs para más información
)

echo.
pause
