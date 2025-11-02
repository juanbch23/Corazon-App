@echo off
echo === CONFIGURACIÓN BACKEND SIN DOCKER ===

REM Configurar variable de entorno DATABASE_URL
set DATABASE_URL=postgresql://dec_database_user:yYRGubYoptewjiFC8dQm9qi7nqniM24Z@dpg-d43p8s6r433s739nmumg-a.oregon-postgres.render.com/dec_database

echo Configurando DATABASE_URL...
echo %DATABASE_URL%

REM Configurar otras variables
set FLASK_ENV=development
set SECRET_KEY=clave-super-secreta-dec-2025

echo.
echo === INSTRUCCIONES ===
echo 1. Instalar dependencias (primera vez):
echo    pip install -r requirements.txt
echo.
echo 2. Ejecutar el backend:
echo    python app.py
echo.
echo 3. Verificar que funciona:
echo    curl -X POST http://localhost:5000/api/login ^
echo         -H "Content-Type: application/json" ^
echo         -d "{\"username\":\"admin\",\"password\":\"admin123\"}"
echo.
echo Presiona cualquier tecla para continuar...
pause > nul