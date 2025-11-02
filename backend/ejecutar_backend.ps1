# Ejecutar backend sin Docker - Script simple
# Archivo: ejecutar_backend.ps1

Write-Host "=== EJECUTANDO BACKEND SIN DOCKER ===" -ForegroundColor Green

# Configurar variables de entorno
$env:DATABASE_URL = "postgresql://dec_database_user:yYRGubYoptewjiFC8dQm9qi7nqniM24Z@dpg-d43p8s6r433s739nmumg-a.oregon-postgres.render.com/dec_database"
$env:FLASK_ENV = "development"
$env:SECRET_KEY = "clave-super-secreta-dec-2025"

Write-Host "Variables de entorno configuradas:" -ForegroundColor Cyan
Write-Host "  DATABASE_URL: $env:DATABASE_URL" -ForegroundColor White
Write-Host "  FLASK_ENV: $env:FLASK_ENV" -ForegroundColor White

Write-Host "`nIniciando servidor Flask..." -ForegroundColor Yellow
Write-Host "Presiona Ctrl+C para detener el servidor" -ForegroundColor Gray
Write-Host ""

# Ejecutar el servidor
python app.py