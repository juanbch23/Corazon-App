@echo off
echo =========================================
echo  SISTEMA DE DIAGNOSTICO CARDIOVASCULAR
echo =========================================
echo.
echo Selecciona el modo de ejecucion:
echo [1] Local (Python + PostgreSQL local)
echo [2] Docker Simple (Rapido)
echo [3] Docker Completo (Con Android APK)
echo.
set /p choice="Ingresa tu opcion (1-3): "

if "%choice%"=="1" goto local
if "%choice%"=="2" goto docker_simple  
if "%choice%"=="3" goto docker_full
echo Opcion invalida!
pause
exit

:local
echo.
echo 🚀 Iniciando en modo LOCAL...
echo 📋 Asegurate de tener:
echo    - PostgreSQL corriendo en puerto 5432
echo    - Base de datos 'dec_database' creada
echo.
start powershell -NoExit -Command "cd 'backend'; python app.py"
echo ✅ Backend iniciado en nueva ventana
echo 🌐 Disponible en: http://localhost:5000
goto end

:docker_simple
echo.
echo 🐳 Iniciando Docker SIMPLE...
docker-compose -f docker-compose.simple.yml up -d postgres
echo ⏳ Esperando PostgreSQL...
timeout /t 10
docker-compose -f docker-compose.simple.yml up -d backend
echo ✅ Sistema Docker iniciado!
echo 🌐 Backend: http://localhost:5000
echo �️  PostgreSQL: puerto 5432
goto end

:docker_full
echo.
echo 🐳 Iniciando Docker COMPLETO...
docker-compose up -d postgres
echo ⏳ Esperando PostgreSQL...
timeout /t 15
docker-compose up -d backend
echo ✅ Sistema completo iniciado!
echo 🌐 Backend: http://localhost:5000
echo � Para APK: docker-compose up android_builder
goto end

:end
echo.
echo 📋 Comandos utiles:
echo    - Ver logs: docker-compose logs -f backend
echo    - Detener: docker-compose down
echo    - Probar API: http://localhost:5000/api/admin
echo.
pause
