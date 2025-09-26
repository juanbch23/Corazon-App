# Proyecto Corazón Web - Guía de Arranque Backend y Base de Datos

## 1. Clonar el repositorio y abrir la carpeta del proyecto

## 2. Crear y activar entorno virtual Python
```powershell
cd "c:\Proyecto -corazon-web\Build\backend"
py -m venv env
.\env\Scripts\activate
```

## 3. Instalar dependencias Python
```powershell
pip install -r requirements.txt
```

## 4. (Recomendado) Usar Docker para PostgreSQL local
```powershell
docker run --name postgres-dec -e POSTGRES_PASSWORD=admin123 -e POSTGRES_DB=db_dec -e POSTGRES_USER=db_user -p 5432:5432 -d postgres:13
```
- Si ya existe el contenedor, solo ejecuta:  
  `docker start postgres-dec`

## 5. Inicializar la base de datos y crear usuarios de prueba
```powershell
python init_postgres.py
```
Esto crea las tablas y dos usuarios:
- Admin: usuario=`admin`, contraseña=`admin123`
- Paciente: usuario=`paciente`, contraseña=`paciente123`

## 6. Arrancar el backend Flask
```powershell
python app.py
```
El backend quedará disponible en: http://127.0.0.1:5000

## 7. Arrancar el frontend React
```powershell
cd "c:\Proyecto -corazon-web\Build\frontend"
npm install
npm run dev
```
El frontend quedará disponible en: http://localhost:5173

## 8. Probar acceso
- Ingresa a http://localhost:5173
- Login admin: `admin` / `admin123`
- Login paciente: `paciente` / `paciente123`

---

## Comandos útiles Docker
- Ver contenedores activos: `docker ps`
- Parar contenedor: `docker stop postgres-dec`
- Iniciar contenedor: `docker start postgres-dec`
- Ver logs: `docker logs postgres-dec`

---

**¡Listo! Tu entorno de desarrollo está configurado para backend, base de datos y frontend.**
