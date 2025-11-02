# Configuración para ejecutar backend sin Docker
# Archivo: configurar_backend_sin_docker.ps1

Write-Host "=== CONFIGURACIÓN BACKEND SIN DOCKER ===" -ForegroundColor Green

# Configurar variable de entorno DATABASE_URL para Render
$DATABASE_URL = "postgresql://dec_database_user:yYRGubYoptewjiFC8dQm9qi7nqniM24Z@dpg-d43p8s6r433s739nmumg-a.oregon-postgres.render.com/dec_database"

Write-Host "Configurando DATABASE_URL..." -ForegroundColor Cyan
[Environment]::SetEnvironmentVariable("DATABASE_URL", $DATABASE_URL, "User")
[Environment]::SetEnvironmentVariable("DATABASE_URL", $DATABASE_URL, "Process")

# Verificar que se configuró
$configured = [Environment]::GetEnvironmentVariable("DATABASE_URL", "Process")
if ($configured) {
    Write-Host "✅ DATABASE_URL configurada correctamente" -ForegroundColor Green
} else {
    Write-Host "❌ Error configurando DATABASE_URL" -ForegroundColor Red
    exit 1
}

# Configurar otras variables de entorno
[Environment]::SetEnvironmentVariable("FLASK_ENV", "development", "Process")
[Environment]::SetEnvironmentVariable("SECRET_KEY", "clave-super-secreta-dec-2025", "Process")

Write-Host "`n=== INSTRUCCIONES PARA EJECUTAR ===" -ForegroundColor Yellow
Write-Host "1. Instalar dependencias (si no están instaladas):" -ForegroundColor White
Write-Host "   pip install -r requirements.txt" -ForegroundColor Gray
Write-Host "`n2. Ejecutar el backend:" -ForegroundColor White
Write-Host "   python app.py" -ForegroundColor Gray
Write-Host "`n3. El backend estará disponible en:" -ForegroundColor White
Write-Host "   http://localhost:5000" -ForegroundColor Gray

Write-Host "`n=== VERIFICACIÓN ===" -ForegroundColor Cyan
Write-Host "Para verificar que funciona, ejecuta en otra terminal:" -ForegroundColor White
Write-Host "Invoke-WebRequest -Uri 'http://localhost:5000/api/login' -Method POST -Body '{\`"username\`":\`"admin\`",\`"password\`":\`"admin123\`"}' -ContentType 'application/json'" -ForegroundColor Gray

Read-Host "`nPresiona Enter para continuar"