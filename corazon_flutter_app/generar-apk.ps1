# Script para generar APK del Sistema de Diagnóstico Cardiovascular
# Arquitectura MVVM con Flutter
# Autor: Juan - Programación Aplicada III

Write-Host "==================================================" -ForegroundColor Cyan
Write-Host "  GENERADOR DE APK - Sistema Cardiovascular MVVM" -ForegroundColor Cyan
Write-Host "==================================================" -ForegroundColor Cyan
Write-Host ""

# Verificar que Flutter esté instalado
Write-Host "[1/5] Verificando instalación de Flutter..." -ForegroundColor Yellow
$flutterCheck = flutter doctor
if ($LASTEXITCODE -ne 0) {
    Write-Host "ERROR: Flutter no está instalado correctamente" -ForegroundColor Red
    exit 1
}
Write-Host "✓ Flutter instalado correctamente" -ForegroundColor Green
Write-Host ""

# Limpiar proyecto
Write-Host "[2/5] Limpiando proyecto..." -ForegroundColor Yellow
flutter clean
if ($LASTEXITCODE -ne 0) {
    Write-Host "ERROR: No se pudo limpiar el proyecto" -ForegroundColor Red
    exit 1
}
Write-Host "✓ Proyecto limpiado" -ForegroundColor Green
Write-Host ""

# Obtener dependencias
Write-Host "[3/5] Obteniendo dependencias..." -ForegroundColor Yellow
flutter pub get
if ($LASTEXITCODE -ne 0) {
    Write-Host "ERROR: No se pudieron obtener las dependencias" -ForegroundColor Red
    exit 1
}
Write-Host "✓ Dependencias obtenidas" -ForegroundColor Green
Write-Host ""

# Construir APK
Write-Host "[4/5] Construyendo APK (esto puede tardar varios minutos)..." -ForegroundColor Yellow
Write-Host "Compilando aplicación Flutter con arquitectura MVVM..." -ForegroundColor Cyan
flutter build apk --release
if ($LASTEXITCODE -ne 0) {
    Write-Host "ERROR: No se pudo construir la APK" -ForegroundColor Red
    exit 1
}
Write-Host "✓ APK construida exitosamente" -ForegroundColor Green
Write-Host ""

# Mostrar ubicación de la APK
Write-Host "[5/5] Finalizando..." -ForegroundColor Yellow
$apkPath = "build\app\outputs\flutter-apk\app-release.apk"
if (Test-Path $apkPath) {
    $fullPath = (Resolve-Path $apkPath).Path
    $fileSize = (Get-Item $apkPath).Length / 1MB
    
    Write-Host ""
    Write-Host "================================================" -ForegroundColor Green
    Write-Host "  ✓ APK GENERADA EXITOSAMENTE" -ForegroundColor Green
    Write-Host "================================================" -ForegroundColor Green
    Write-Host ""
    Write-Host "Ubicación: " -NoNewline
    Write-Host "$fullPath" -ForegroundColor Cyan
    Write-Host "Tamaño: " -NoNewline
    Write-Host ("{0:N2} MB" -f $fileSize) -ForegroundColor Cyan
    Write-Host ""
    Write-Host "Instrucciones de instalación:" -ForegroundColor Yellow
    Write-Host "1. Conecta tu celular Android al PC por USB" -ForegroundColor White
    Write-Host "2. Habilita 'Depuración USB' en tu celular" -ForegroundColor White
    Write-Host "3. Habilita 'Instalar apps desconocidas' en configuración" -ForegroundColor White
    Write-Host "4. Copia la APK a tu celular" -ForegroundColor White
    Write-Host "5. Abre la APK desde el celular para instalar" -ForegroundColor White
    Write-Host ""
    Write-Host "O usa ADB para instalar directamente:" -ForegroundColor Yellow
    Write-Host "adb install $apkPath" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "Backend requerido:" -ForegroundColor Yellow
    Write-Host "Asegúrate de que el backend Docker esté corriendo en:" -ForegroundColor White
    Write-Host "http://localhost:5000" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "Usuarios de prueba:" -ForegroundColor Yellow
    Write-Host "Paciente: usuario=paciente1, contraseña=123456" -ForegroundColor White
    Write-Host "Admin: usuario=admin, contraseña=admin123" -ForegroundColor White
    Write-Host ""
    Write-Host "================================================" -ForegroundColor Green
    Write-Host "  Proyecto: Sistema Cardiovascular MVVM" -ForegroundColor Cyan
    Write-Host "  Autor: Juan" -ForegroundColor Cyan
    Write-Host "  Curso: Programación Aplicada III" -ForegroundColor Cyan
    Write-Host "================================================" -ForegroundColor Green
} else {
    Write-Host "ERROR: No se encontró la APK en la ubicación esperada" -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "Presiona cualquier tecla para salir..." -ForegroundColor Gray
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
