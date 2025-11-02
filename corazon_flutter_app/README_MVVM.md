# Sistema de Diagnóstico Cardiovascular - Arquitectura MVVM

## 📋 Descripción del Proyecto

Sistema de diagnóstico cardiovascular desarrollado con Flutter que implementa el patrón arquitectónico **MVVM (Model-View-ViewModel)**. La aplicación permite a los pacientes realizar evaluaciones cardiovasculares usando inteligencia artificial (TensorFlow Lite) y a los administradores gestionar el sistema.

---

## 🏗️ Arquitectura MVVM

### ¿Qué es MVVM?

**MVVM** (Model-View-ViewModel) es un patrón de diseño arquitectónico que separa la lógica de negocio de la interfaz de usuario:

```
┌──────────────┐         ┌──────────────┐         ┌──────────────┐
│              │         │              │         │              │
│    MODEL     │◄────────│  VIEWMODEL   │◄────────│     VIEW     │
│   (Datos)    │         │   (Lógica)   │         │     (UI)     │
│              │         │              │         │              │
└──────────────┘         └──────────────┘         └──────────────┘
       ▲                        ▲                        ▲
       │                        │                        │
  Modelos de datos         Lógica de          Interfaz visual
  (Usuario, etc.)          negocio y          (Widgets Flutter)
                           estado
```

### Componentes del Proyecto

#### 1. **MODELOS** (`lib/modelos/`)
Representan los datos de la aplicación.

- **`usuario.dart`**: Modelo de datos de usuario
  - Atributos: username, nombre, apellido, email, tipo (paciente/admin)
  - Métodos: fromJson(), toJson(), nombreCompleto, esAdmin, esPaciente

- **`diagnostico_cardiovascular.dart`**: Modelo de diagnóstico médico
  - Datos clínicos: edad, genero, presión arterial, colesterol, glucosa, etc.
  - Resultado: nivel de riesgo (0=Bajo, 1=Medio, 2=Alto), confianza
  - Métodos: fromJson(), toJson(), textoRiesgo, mensajeRiesgo, recomendaciones

#### 2. **VIEWMODELS** (`lib/vistamodelos/`)
Contienen la lógica de negocio y el estado de cada pantalla.

- **`login_viewmodel.dart`**: Lógica de inicio de sesión
  - Gestiona autenticación de usuarios
  - Maneja estado de carga y errores
  - Guarda sesión en SharedPreferences
  - Endpoints: POST /api/login

- **`registro_viewmodel.dart`**: Lógica de registro
  - Valida datos de nuevo usuario
  - Crea usuarios en el backend
  - Endpoints: POST /api/registro

- **`home_viewmodel.dart`**: Lógica de pantalla principal
  - Carga información del usuario
  - Maneja navegación según tipo de usuario
  - Endpoints: GET /api/configuracion/:username

- **`diagnostico_viewmodel.dart`**: Lógica de diagnóstico
  - Valida datos clínicos del formulario
  - Envía datos al modelo ML para evaluación
  - Recibe y procesa resultado del diagnóstico
  - Endpoints: POST /api/diagnostico/:username

- **`resultados_viewmodel.dart`**: Lógica de historial
  - Carga diagnósticos previos del usuario
  - Genera gráficos de tendencia de riesgo
  - Endpoints: GET /api/resultados/:username

- **`configuracion_viewmodel.dart`**: Lógica de perfil
  - Carga y actualiza datos personales
  - Gestiona cambios de contraseña
  - Endpoints: GET/POST /api/configuracion/:username

- **`admin_viewmodel.dart`**: Lógica de administración
  - Gestiona lista de pacientes
  - Muestra estadísticas del sistema
  - Accede a diagnósticos de cualquier paciente
  - Endpoints: GET /api/admin/:username

#### 3. **VISTAS** (`lib/vistas/`)
UI pura que solo muestra datos del ViewModel.

- **`login_vista.dart`**: Pantalla de login
  - Formulario de usuario y contraseña
  - Botón de inicio de sesión
  - Enlace a registro
  - **No contiene lógica**, solo muestra y captura datos

- **`registro_vista.dart`**: Pantalla de registro
  - Formulario completo de nuevo usuario
  - Validación visual de campos
  - **Toda la lógica está en RegistroViewModel**

- **`home_vista.dart`**: Pantalla principal
  - Muestra bienvenida personalizada
  - Botones de navegación (Diagnóstico, Resultados, Configuración)
  - Opción de admin si corresponde

- **`diagnostico_vista.dart`**: Formulario de diagnóstico
  - Campos para datos clínicos (edad, género, presión, etc.)
  - Botón de enviar
  - Muestra resultado del diagnóstico

- **`resultados_vista.dart`**: Historial de diagnósticos
  - Lista de diagnósticos previos
  - Gráficos de tendencia con fl_chart
  - Detalles de cada diagnóstico

- **`configuracion_vista.dart`**: Perfil de usuario
  - Muestra y edita datos personales
  - Cambio de contraseña
  - Cerrar sesión

- **`admin_vista.dart`**: Panel de administración
  - Lista de pacientes del sistema
  - Acceso a diagnósticos de pacientes
  - Estadísticas generales

#### 4. **SERVICIOS** (`lib/servicios/`)
Comunicación con el backend.

- **`api_service.dart`**: Servicio HTTP para backend
  - Métodos: get(), post(), put(), delete()
  - Endpoints implementados:
    - POST /api/login
    - POST /api/registro
    - POST /api/diagnostico/:username
    - GET /api/resultados/:username
    - GET/POST /api/configuracion/:username
    - GET /api/admin/:username
  - Manejo de errores de conexión

#### 5. **CONFIGURACIÓN** (`lib/config/`)
Configuración global de la app.

- **`app_config.dart`**: URLs y configuración
  - URL backend: http://10.0.2.2:5000/api (emulador Android)
  - Timeouts de conexión
  - Headers HTTP

---

## 📱 Pantallas de la Aplicación

### Para Pacientes:

1. **Login** → Autenticación de usuario
2. **Registro** → Crear nueva cuenta
3. **Home** → Dashboard principal
4. **Diagnóstico** → Formulario de evaluación cardiovascular
5. **Resultados** → Historial de diagnósticos con gráficos
6. **Configuración** → Ver/editar perfil personal

### Para Administradores:

7. **Admin** → Panel de administración de pacientes

---

## 🔄 Flujo de Datos en MVVM

### Ejemplo: Realizar un Diagnóstico

```
1. VISTA (diagnostico_vista.dart)
   ↓
   Usuario completa formulario y presiona "Enviar"
   ↓
2. VIEWMODEL (diagnostico_viewmodel.dart)
   ↓
   - Valida datos del formulario
   - Cambia estado a "cargando"
   - Llama al servicio API
   ↓
3. SERVICIO (api_service.dart)
   ↓
   - POST /api/diagnostico/:username
   - Envía datos clínicos al backend
   ↓
4. BACKEND (Flask + PostgreSQL + TensorFlow Lite)
   ↓
   - Procesa datos con modelo ML
   - Calcula riesgo cardiovascular
   - Guarda en base de datos
   - Retorna resultado
   ↓
5. SERVICIO (api_service.dart)
   ↓
   - Recibe respuesta JSON
   - Retorna al ViewModel
   ↓
6. VIEWMODEL (diagnostico_viewmodel.dart)
   ↓
   - Actualiza estado con resultado
   - notifyListeners() para actualizar UI
   ↓
7. VISTA (diagnostico_vista.dart)
   ↓
   - Se reconstruye automáticamente
   - Muestra resultado al usuario
```

---

## 🛠️ Tecnologías Utilizadas

### Frontend (Flutter):
- **Flutter SDK**: Framework multiplataforma
- **Dart**: Lenguaje de programación
- **Provider**: Gestión de estado (MVVM)
- **go_router**: Navegación entre pantallas
- **http**: Comunicación HTTP con backend
- **fl_chart**: Gráficos de tendencia
- **shared_preferences**: Almacenamiento local de sesión

### Backend (Docker):
- **PostgreSQL 15**: Base de datos relacional
- **Flask**: Framework web Python
- **TensorFlow Lite**: Modelo ML para diagnóstico
- **Docker Compose**: Orquestación de contenedores

---

## 📡 Endpoints del Backend

| Método | Endpoint | Descripción |
|--------|----------|-------------|
| POST | `/api/login` | Autenticar usuario |
| POST | `/api/registro` | Registrar nuevo usuario |
| POST | `/api/diagnostico/:username` | Realizar diagnóstico cardiovascular |
| GET | `/api/resultados/:username` | Obtener historial de diagnósticos |
| GET | `/api/configuracion/:username` | Obtener datos de perfil |
| POST | `/api/configuracion/:username` | Actualizar datos de perfil |
| GET | `/api/admin/:username` | Panel admin: lista de pacientes |
| GET | `/api/admin/:username/diagnosticos/:id` | Admin: diagnósticos de un paciente |

---

## 🚀 Cómo Ejecutar el Proyecto

### 1. Requisitos Previos
- Flutter SDK instalado
- Android Studio / Xcode (para emuladores)
- Backend Docker corriendo en http://localhost:5000

### 2. Instalar Dependencias
```bash
cd corazon_flutter_app
flutter pub get
```

### 3. Ejecutar en Emulador Android
```bash
# Verificar emuladores disponibles
flutter emulators

# Lanzar emulador
flutter emulators --launch <emulator_id>

# Ejecutar aplicación
flutter run
```

### 4. Ejecutar en Dispositivo Físico
```bash
# Conectar dispositivo por USB
# Habilitar depuración USB en el dispositivo

# Verificar dispositivos conectados
flutter devices

# Ejecutar aplicación
flutter run
```

---

## 📂 Estructura del Proyecto

```
corazon_flutter_app/
│
├── lib/
│   ├── main.dart                   # Punto de entrada, configuración de rutas
│   │
│   ├── modelos/                    # MODELOS - Datos de la app
│   │   ├── usuario.dart
│   │   └── diagnostico_cardiovascular.dart
│   │
│   ├── vistamodelos/               # VIEWMODELS - Lógica de negocio
│   │   ├── login_viewmodel.dart
│   │   ├── registro_viewmodel.dart
│   │   ├── home_viewmodel.dart
│   │   ├── diagnostico_viewmodel.dart
│   │   ├── resultados_viewmodel.dart
│   │   ├── configuracion_viewmodel.dart
│   │   └── admin_viewmodel.dart
│   │
│   ├── vistas/                     # VISTAS - UI pura
│   │   ├── login_vista.dart
│   │   ├── registro_vista.dart
│   │   ├── home_vista.dart
│   │   ├── diagnostico_vista.dart
│   │   ├── resultados_vista.dart
│   │   ├── configuracion_vista.dart
│   │   └── admin_vista.dart
│   │
│   ├── servicios/                  # SERVICIOS - API y lógica externa
│   │   └── api_service.dart
│   │
│   └── config/                     # CONFIGURACIÓN
│       └── app_config.dart
│
├── pubspec.yaml                    # Dependencias del proyecto
├── android/                        # Configuración Android
├── ios/                           # Configuración iOS
└── assets/                        # Imágenes y recursos
```

---

## 🎯 Ventajas de MVVM en este Proyecto

1. **Separación de Responsabilidades**
   - Vista solo se encarga de UI
   - ViewModel maneja toda la lógica
   - Modelo representa los datos

2. **Testabilidad**
   - ViewModels pueden testearse sin UI
   - Lógica de negocio aislada

3. **Mantenibilidad**
   - Código organizado y fácil de mantener
   - Cambios en UI no afectan lógica
   - Cambios en lógica no afectan UI

4. **Reusabilidad**
   - ViewModels pueden reutilizarse
   - Servicios compartidos entre ViewModels
   - Modelos consistentes en toda la app

5. **Estado Reactivo**
   - Provider notifica cambios automáticamente
   - UI se actualiza sola cuando cambia el estado
   - Menos código boilerplate

---

## 👨‍💼 Usuarios del Sistema

### Paciente
- Username: `paciente1` / Password: `123456`
- Puede realizar diagnósticos
- Ver su historial de resultados
- Editar su perfil

### Administrador
- Username: `admin` / Password: `admin123`
- Ve todos los pacientes
- Accede a diagnósticos de cualquier paciente
- Gestiona el sistema

---

## 📊 Modelo de Diagnóstico Cardiovascular

El sistema usa un modelo de Machine Learning (TensorFlow Lite) que evalúa:

### Datos de Entrada:
- Edad
- Género
- Presión arterial (sistólica y diastólica)
- Colesterol
- Glucosa
- Hábitos (fumar, alcohol, actividad física)
- Peso y estatura (para calcular IMC)

### Resultado:
- **Nivel de riesgo**: 0 (Bajo), 1 (Medio), 2 (Alto)
- **Confianza**: Porcentaje de certeza del modelo
- **Recomendaciones**: Consejos médicos según el riesgo

---

## 📝 Notas para el Profesor

Este proyecto demuestra:

1. **Implementación correcta de MVVM**
   - Separación clara entre View, ViewModel y Model
   - Uso de Provider para estado reactivo
   - Servicios para lógica externa

2. **Buenas prácticas de Flutter**
   - Código documentado
   - Widgets reutilizables
   - Manejo de errores
   - Navegación con go_router

3. **Integración con Backend**
   - Comunicación HTTP con API REST
   - Manejo de autenticación
   - Persistencia de sesión

4. **UI/UX profesional**
   - Diseño consistente
   - Retroalimentación visual
   - Estados de carga
   - Manejo de errores visible

---

## 🔧 Resolución de Problemas Comunes

### Backend no responde
- Verificar que Docker esté corriendo
- URL correcta: http://10.0.2.2:5000/api (Android)
- Revisar logs del backend

### Error de dependencias
```bash
flutter clean
flutter pub get
```

### Emulador no inicia
```bash
flutter doctor
flutter emulators --launch <emulator_id>
```

---

## 📞 Contacto

**Alumno**: Juan
**Proyecto**: Sistema de Diagnóstico Cardiovascular con MVVM
**Curso**: Programación Aplicada III
**Fecha**: Octubre 2025

---

## ✅ Checklist de Funcionalidades

- [x] Login de usuarios (pacientes y admin)
- [x] Registro de nuevos pacientes
- [x] Dashboard principal
- [x] Formulario de diagnóstico cardiovascular
- [x] Integración con modelo ML (TensorFlow Lite)
- [x] Historial de diagnósticos con gráficos
- [x] Configuración de perfil
- [x] Panel de administración
- [x] Persistencia de sesión
- [x] Manejo de errores
- [x] Arquitectura MVVM completa
- [x] Documentación del código
- [x] Backend Docker funcionando

---

**¡El proyecto está completo y funcional con arquitectura MVVM!** 🎉
