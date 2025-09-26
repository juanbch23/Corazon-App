@echo off
echo =========================================
echo  GENERANDO APK ANDROID - MODO SIMPLE
echo =========================================
echo.
echo Selecciona el metodo:
echo [1] Local con Flutter instalado
echo [2] Docker (mas lento pero completo)
echo.
set /p choice="Ingresa tu opcion (1-2): "

if "%choice%"=="1" goto local_flutter
if "%choice%"=="2" goto docker_flutter
echo Opcion invalida!
pause
exit

:local_flutter
echo.
echo 📱 Generando APK con Flutter LOCAL...
cd "..\corazon_flutter_app"

echo 🧹 Limpiando proyecto...
flutter clean

echo 📦 Obteniendo dependencias...
flutter pub get

echo 🏗️ Construyendo APK...
flutter build apk --release

if exist "build\app\outputs\flutter-apk\app-release.apk" (
    copy "build\app\outputs\flutter-apk\app-release.apk" "dec_cardiovascular.apk"
    echo ✅ APK generado: dec_cardiovascular.apk
    dir "dec_cardiovascular.apk"
) else (
    echo ❌ Error al generar APK
)
goto end

:docker_flutter
echo.
echo 🐳 Generando APK con Docker...
echo ⚠️  Esto puede tomar 10-20 minutos la primera vez...
docker-compose run --rm android_builder
goto end

:end
echo.
echo 📱 APK listo para instalar en Android!
echo 📋 Ubicacion: corazon_flutter_app\dec_cardiovascular.apk
echo.
pause
