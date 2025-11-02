# Script para ejecutar la aplicación en emulador Android
# Sistema de Diagnóstico Cardiovascular - MVVM
# Autor: Juan - Programación Aplicada III

Write-Host "==================================================" -ForegroundColor Cyan
Write-Host "  INICIAR APP - Sistema Cardiovascular MVVM" -ForegroundColor Cyan
Write-Host "==================================================" -ForegroundColor Cyan
Write-Host ""

# Verificar emuladores disponibles
Write-Host "[1/3] Verificando emuladores disponibles..." -ForegroundColor Yellow
flutter emulators
Write-Host ""

# Preguntar si quiere iniciar un emulador
Write-Host "¿Deseas iniciar un emulador? (S/N): " -ForegroundColor Yellow -NoNewline
$respuesta = Read-Host
if ($respuesta -eq "S" -or $respuesta -eq "s") {
    Write-Host "Ingresa el ID del emulador (por ejemplo: Pixel_3a_API_33_x86_64): " -ForegroundColor Yellow -NoNewline
    $emulatorId = Read-Host
    Write-Host "Iniciando emulador $emulatorId..." -ForegroundColor Cyan
    Start-Process -FilePath "flutter" -ArgumentList "emulators --launch $emulatorId" -NoNewWindow
    Write-Host "Esperando a que el emulador inicie (30 segundos)..." -ForegroundColor Cyan
    Start-Sleep -Seconds 30
}

Write-Host ""
Write-Host "[2/3] Obteniendo dependencias..." -ForegroundColor Yellow
flutter pub get
Write-Host ""

Write-Host "[3/3] Ejecutando aplicación..." -ForegroundColor Yellow
Write-Host "Iniciando Sistema de Diagnóstico Cardiovascular..." -ForegroundColor Cyan
Write-Host ""
Write-Host "Backend requerido: http://10.0.2.2:5000/api" -ForegroundColor Yellow
Write-Host "Usuarios de prueba:" -ForegroundColor Yellow
Write-Host "- Paciente: usuario=paciente1, contraseña=123456" -ForegroundColor White
Write-Host "- Admin: usuario=admin, contraseña=admin123" -ForegroundColor White
Write-Host ""

flutter run

Write-Host ""
Write-Host "Aplicación finalizada." -ForegroundColor Green
