# 🚀 GUÍA RÁPIDA - Ejecutar Aplicación Cardiovascular MVVM

## ✅ Pasos para Ejecutar en Emulador Android

### 1. Abrir PowerShell en la carpeta del proyecto
```powershell
cd "c:\Users\Juan\programacion-Aplicada\Programacion aplicada lll\corazon_flutter_app"
```

### 2. Ver emuladores disponibles
```powershell
flutter emulators
```

### 3. Iniciar un emulador (elegir uno de la lista)
```powershell
flutter emulators --launch <nombre_emulador>
```
Ejemplo:
```powershell
flutter emulators --launch Pixel_3a_API_33_x86_64
```

### 4. Esperar que el emulador inicie (30-60 segundos)

### 5. Ejecutar la aplicación
```powershell
flutter run
```

O usar el script automático:
```powershell
.\ejecutar-app.ps1
```

---

## 📱 Pasos para Generar APK e Instalar en Celular

### Opción A: Usar el script automático
```powershell
.\generar-apk.ps1
```

### Opción B: Manual

#### 1. Limpiar y obtener dependencias
```powershell
flutter clean
flutter pub get
```

#### 2. Construir APK
```powershell
flutter build apk --release
```

#### 3. La APK estará en:
```
build\app\outputs\flutter-apk\app-release.apk
```

#### 4. Instalar en celular

**Método 1: Por USB con ADB**
```powershell
adb install build\app\outputs\flutter-apk\app-release.apk
```

**Método 2: Copiar manualmente**
1. Conecta tu celular al PC
2. Copia `app-release.apk` al celular
3. En el celular:
   - Ve a Configuración → Seguridad
   - Habilita "Fuentes desconocidas" o "Instalar apps desconocidas"
   - Abre la APK desde el explorador de archivos
   - Acepta los permisos e instala

---

## 🔧 Requisitos Previos

### Backend (IMPORTANTE)
El backend DEBE estar corriendo antes de usar la app:

```powershell
cd "c:\Users\Juan\programacion-Aplicada\Programacion aplicada lll\Proyecto -corazon-web\Build"
docker-compose up -d
```

Verificar que esté corriendo:
```powershell
docker ps
```

Deberías ver 2 contenedores:
- `backend_backend_1` (Flask API)
- `backend_postgres_1` (PostgreSQL)

### URL del Backend
- **Emulador Android**: `http://10.0.2.2:5000/api`
- **Dispositivo físico**: Cambia a la IP de tu PC en `lib/config/app_config.dart`

---

## 👤 Usuarios de Prueba

### Paciente
- **Usuario**: `paciente1`
- **Contraseña**: `123456`

Funcionalidades:
- Realizar diagnósticos cardiovasculares
- Ver historial de resultados
- Editar perfil personal

### Administrador
- **Usuario**: `admin`
- **Contraseña**: `admin123`

Funcionalidades adicionales:
- Ver lista de todos los pacientes
- Acceder a diagnósticos de cualquier paciente
- Gestionar el sistema

---

## 🏗️ Estructura MVVM del Proyecto

```
lib/
├── main.dart                    → Punto de entrada, rutas
├── config/
│   └── app_config.dart          → URLs del backend
├── modelos/
│   ├── usuario.dart             → Modelo de Usuario
│   └── diagnostico_cardiovascular.dart → Modelo de Diagnóstico
├── vistamodelos/
│   ├── login_viewmodel.dart     → Lógica de login
│   ├── registro_viewmodel.dart  → Lógica de registro
│   ├── home_viewmodel.dart      → Lógica del home
│   ├── diagnostico_viewmodel.dart → Lógica de diagnóstico
│   ├── resultados_viewmodel.dart → Lógica de resultados
│   ├── configuracion_viewmodel.dart → Lógica de perfil
│   └── admin_viewmodel.dart     → Lógica de admin
├── vistas/
│   ├── login_vista.dart         → UI de login
│   ├── registro_vista.dart      → UI de registro
│   ├── home_vista.dart          → UI del home
│   ├── diagnostico_vista.dart   → UI de diagnóstico
│   ├── resultados_vista.dart    → UI de resultados
│   ├── configuracion_vista.dart → UI de perfil
│   └── admin_vista.dart         → UI de admin
└── servicios/
    └── api_service.dart         → Comunicación con backend
```

---

## 🐛 Solución de Problemas

### La app no se conecta al backend
1. Verifica que Docker esté corriendo:
   ```powershell
   docker ps
   ```
2. Prueba la API manualmente:
   ```powershell
   curl http://localhost:5000/api/login
   ```
3. En emulador, la URL debe ser `http://10.0.2.2:5000/api`
4. En dispositivo físico, usa la IP de tu PC

### Error "Waiting for another flutter command to release the startup lock"
```powershell
taskkill /F /IM dart.exe
taskkill /F /IM flutter.exe
```

### Error de dependencias
```powershell
flutter clean
flutter pub get
```

### Emulador muy lento
- Asigna más RAM al emulador (mínimo 2GB)
- Habilita aceleración por hardware (Intel HAXM o Hyper-V)
- Cierra otras aplicaciones pesadas

---

## 📊 Pantallas de la Aplicación

### 1. **Login** (`/login`)
- Formulario de usuario y contraseña
- Validación de credenciales
- Redirección a Home o Admin según tipo de usuario

### 2. **Registro** (`/registro`)
- Formulario completo de nuevo paciente
- Validaciones de datos
- Creación de usuario en backend

### 3. **Home** (`/home`)
- Bienvenida personalizada
- Botón "Nuevo Diagnóstico"
- Botón "Mis Resultados"
- Botón "Configuración"
- Botón "Panel Admin" (solo para admin)

### 4. **Diagnóstico** (`/diagnostico`)
- Formulario de datos clínicos:
  - Edad, género, peso, estatura
  - Presión arterial (sistólica y diastólica)
  - Colesterol, glucosa
  - Hábitos (fumar, alcohol, actividad física)
- Envío a modelo ML
- Resultado inmediato

### 5. **Resultados** (`/resultados`)
- Último diagnóstico realizado
- Gráfico de riesgo
- Recomendaciones médicas según nivel de riesgo
- Historial de diagnósticos previos

### 6. **Configuración** (`/configuracion`)
- Datos personales editables
- Cambio de contraseña
- Cerrar sesión

### 7. **Admin** (`/admin`)
- Lista de pacientes del sistema
- Acceso a diagnósticos de cualquier paciente
- Estadísticas generales

---

## 📡 Endpoints del Backend Utilizados

| Pantalla | Endpoint | Método | Descripción |
|----------|----------|--------|-------------|
| Login | `/api/login` | POST | Autenticar usuario |
| Registro | `/api/registro` | POST | Crear nuevo usuario |
| Home | `/api/configuracion/:username` | GET | Obtener nombre usuario |
| Diagnóstico | `/api/diagnostico/:username` | POST | Realizar diagnóstico ML |
| Resultados | `/api/resultados/:username` | GET | Obtener historial |
| Configuración | `/api/configuracion/:username` | GET/POST | Ver/editar perfil |
| Admin | `/api/admin/:username` | GET | Lista de pacientes |

---

## 🎯 Características MVVM Implementadas

### ✅ Separación de Responsabilidades
- **Vista**: Solo UI, no contiene lógica
- **ViewModel**: Toda la lógica de negocio
- **Modelo**: Estructura de datos

### ✅ Estado Reactivo con Provider
- ViewModels extienden `ChangeNotifier`
- Vistas usan `Consumer` para actualizarse
- Cambios automáticos en la UI

### ✅ Navegación con go_router
- Rutas definidas en `main.dart`
- Navegación programática
- Parámetros en rutas

### ✅ Servicios Reutilizables
- `ApiService` singleton
- Compartido por todos los ViewModels
- Manejo centralizado de errores

---

## 📝 Para el Profesor

Este proyecto demuestra:

1. **Arquitectura MVVM completa**
   - Separación clara entre capas
   - Código organizado y mantenible

2. **Integración con Backend Docker**
   - PostgreSQL + Flask + TensorFlow Lite
   - API REST funcionando

3. **UI/UX Profesional**
   - Diseño consistente
   - Feedback visual (loading, errores)
   - Validaciones en formularios

4. **Funcionalidades Completas**
   - Login/Registro
   - Diagnóstico con ML
   - Historial con gráficos
   - Panel de administración

5. **Buenas Prácticas**
   - Código documentado
   - Manejo de errores
   - Persistencia de sesión
   - URLs configurables

---

## 🎉 ¡Listo para Usar!

La aplicación está completamente funcional con arquitectura MVVM.

**Próximos pasos:**
1. Iniciar el backend Docker
2. Ejecutar la app en emulador o generar APK
3. Probar todas las funcionalidades
4. ¡Presentar al profesor!

---

**Autor**: Juan  
**Curso**: Programación Aplicada III  
**Fecha**: Octubre 2025  
**Proyecto**: Sistema de Diagnóstico Cardiovascular con MVVM
