# Sistema de Diagnóstico Cardiovascular - Docker

Este proyecto incluye un sistema completo de diagnóstico cardiovascular con backend Flask, base de datos PostgreSQL y aplicación móvil Flutter.

## 🚀 Inicio Rápido

### Prerrequisitos
- Docker y Docker Compose instalados
- Android Studio (para generar APK)

### 1. Iniciar el Sistema Completo

```bash
# Opción 1: Usar script automático (Windows)
.\start-system.bat

# Opción 2: Comandos manuales
docker-compose up -d postgres  # Base de datos
docker-compose up -d backend   # API Flask
```

### 2. Generar APK Android

```bash
# Opción 1: Usar script automático (Windows)
.\generate-apk.bat

# Opción 2: Comando manual
docker-compose run --rm android_builder
```

## 📋 Servicios Disponibles

| Servicio | Puerto | URL | Descripción |
|----------|--------|-----|-------------|
| Backend Flask | 5000 | http://localhost:5000 | API REST |
| PostgreSQL | 5432 | localhost:5432 | Base de datos |
| Android Builder | - | - | Generador de APK |

## 🔧 Configuración

### Variables de Entorno

**Backend (.env)**
```env
DATABASE_URL=postgresql://postgres:password@postgres:5432/dec_database
FLASK_ENV=production
SECRET_KEY=tu_clave_secreta
```

**Flutter (app_config.dart)**
- Desarrollo: `http://127.0.0.1:5000/api`
- Producción: `http://backend:5000/api`

### Base de Datos

La base de datos se inicializa automáticamente con:
- Estructura de tablas (script_DEC.sql)
- Actualización de fechas NULL (update_fechas.sql)

## 📱 APK Android

El APK se genera en: `corazon_flutter_app/dec_cardiovascular.apk`

**Características del APK:**
- Versión release optimizada
- Conexión configurada para backend Docker
- Tamaño optimizado (~50MB)

## 🛠️ Comandos Útiles

```bash
# Ver logs en tiempo real
docker-compose logs -f backend
docker-compose logs -f postgres

# Reiniciar servicios
docker-compose restart backend

# Limpiar contenedores y volúmenes
docker-compose down -v

# Reconstruir imágenes
docker-compose build --no-cache

# Acceder a PostgreSQL
docker-compose exec postgres psql -U postgres -d dec_database
```

## 🔍 Verificación del Sistema

### 1. Backend Funcionando
```bash
curl http://localhost:5000/api/health
```

### 2. Base de Datos Conectada
```bash
docker-compose exec postgres psql -U postgres -d dec_database -c "SELECT COUNT(*) FROM usuarios;"
```

### 3. APK Generado
```bash
ls -la corazon_flutter_app/dec_cardiovascular.apk
```

## 📊 API Endpoints

| Método | Endpoint | Descripción |
|--------|----------|-------------|
| POST | `/api/login` | Autenticación |
| POST | `/api/registro` | Registro usuario |
| GET | `/api/admin` | Datos admin |
| POST | `/api/diagnostico` | Nuevo diagnóstico |
| GET | `/api/resultados` | Obtener resultados |

## 🐛 Solución de Problemas

### Backend no conecta a BD
```bash
# Verificar que PostgreSQL esté corriendo
docker-compose ps postgres

# Reiniciar base de datos
docker-compose restart postgres
```

### Error al generar APK
```bash
# Limpiar cache de Flutter
docker-compose run --rm android_builder flutter clean

# Reconstruir imagen Android
docker-compose build --no-cache android_builder
```

### Puertos ocupados
```bash
# Verificar puertos en uso
netstat -an | findstr :5000
netstat -an | findstr :5432

# Cambiar puertos en docker-compose.yml si es necesario
```

## 🔄 Desarrollo Local vs Docker

### Desarrollo Local
- Backend: Python directo
- BD: PostgreSQL local
- Flutter: `flutter run`

### Docker
- Backend: Contenedor Flask
- BD: Contenedor PostgreSQL  
- Flutter: APK generado

## 📞 Soporte

Para problemas específicos:
1. Verificar logs: `docker-compose logs [servicio]`
2. Revisar configuración de puertos
3. Validar conectividad de red Docker

---
**Última actualización:** Agosto 2025
