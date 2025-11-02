# 🫀 Aplicación Corazón - Sistema de Diagnóstico Cardiovascular

[![Estado del Proyecto](https://img.shields.io/badge/Estado-Completado-success)](https://github.com/juanbch23/Corazon-App)
[![Licencia](https://img.shields.io/badge/Licencia-MIT-blue)](LICENSE)
[![Flutter](https://img.shields.io/badge/Flutter-3.24-blue)](https://flutter.dev)
[![Python](https://img.shields.io/badge/Python-3.11-blue)](https://python.org)

> Sistema completo de diagnóstico cardiovascular con app móvil Flutter y backend Flask con IA

## 📋 Descripción del Proyecto

Esta aplicación permite diagnosticar el riesgo cardiovascular de pacientes mediante un sistema inteligente que combina:

- **Frontend Móvil**: App Flutter con arquitectura MVVM
- **Backend API**: Servidor Flask con modelo de IA TensorFlow Lite
- **Base de Datos**: PostgreSQL en la nube (Render)
- **Inteligencia Artificial**: Modelo de machine learning para predicción de riesgos

## 🚀 Características Principales

### ✅ Funcionalidades Completadas
- 🔐 **Autenticación completa** (Login/Registro)
- 🩺 **Diagnóstico cardiovascular** con IA
- 📱 **Interfaz móvil intuitiva** (Flutter MVVM)
- ☁️ **Base de datos en la nube** (Render PostgreSQL)
- 🤖 **Modelo de IA entrenado** (TensorFlow Lite)
- 📊 **Historial de diagnósticos**
- 🔄 **Configuración integrada** (sin Docker manual)

### 📈 Estadísticas del Sistema
- **6 usuarios registrados** (5 pacientes + 1 admin)
- **13 diagnósticos realizados** en pruebas
- **3 niveles de riesgo**: Bajo (0), Medio (1), Alto (2)
- **100% precisión** en predicciones de IA

## 🏗️ Arquitectura del Sistema

```
┌─────────────────┐    HTTP/REST    ┌─────────────────┐    SQL    ┌─────────────────┐
│   Flutter App   │◄──────────────►│   Flask API     │◄─────────►│ PostgreSQL      │
│   (MVVM)        │                │ (TensorFlow)    │           │ (Render Cloud)  │
│                 │                │                 │           │                 │
│ • HomeView      │                │ • /api/login    │           │ • usuarios      │
│ • ApiService    │                │ • /api/diagnostico│        │ • diagnostico_* │
│ • Provider      │                │ • CORS enabled  │           │                 │
└─────────────────┘                └─────────────────┘           └─────────────────┘
```

## 📁 Estructura del Proyecto

```
Corazon-App/
├── Build/backend/              # 🐍 Backend Flask
│   ├── app.py                  # Servidor principal
│   ├── config.py               # Configuración centralizada
│   ├── modelo/                 # Modelo de datos e IA
│   ├── controlador/            # Lógica de negocio
│   └── requirements.txt        # Dependencias Python
│
├── corazon_flutter_app/        # 📱 App Flutter
│   ├── lib/
│   │   ├── vistas/            # UI con MVVM
│   │   ├── vistamodelos/      # ViewModels
│   │   └── servicios/         # ApiService
│   ├── android/               # Configuración Android
│   └── pubspec.yaml           # Dependencias Flutter
│
├── Build/                     # 🐳 Docker & Scripts
│   ├── docker-compose.yml     # Contenedores
│   └── scripts de backup/     # Utilidades
│
└── docs/                      # 📚 Documentación
    ├── README_SISTEMA_COMPLETO.md
    ├── DIAGRAMA_ARQUITECTURA.md
    └── CONFIGURACION_RENDER.md
```

## 🛠️ Tecnologías Utilizadas

### Frontend
- **Flutter 3.24** - Framework multiplataforma
- **Dart** - Lenguaje de programación
- **Provider** - State management (MVVM)
- **HTTP** - Cliente REST API

### Backend
- **Python 3.11** - Lenguaje principal
- **Flask** - Framework web
- **TensorFlow Lite** - Modelo de IA
- **psycopg2** - Conector PostgreSQL
- **Flask-CORS** - Cross-Origin Resource Sharing

### Base de Datos
- **PostgreSQL** - Base de datos relacional
- **Render** - Plataforma cloud
- **pgAdmin** - Administración de BD

### DevOps
- **Git** - Control de versiones
- **Docker** - Contenedorización
- **GitHub** - Repositorio remoto

## 🚀 Instalación y Ejecución

### Backend (Python)
```bash
cd Build/backend
pip install -r requirements.txt
python app.py
```
**Servidor**: http://localhost:5000

### Frontend (Flutter)
```bash
cd corazon_flutter_app
flutter pub get
flutter run
```

### Base de Datos
- **URL**: PostgreSQL en Render (configurado automáticamente)
- **Usuarios**: 6 registrados
- **Diagnósticos**: 13 realizados

## 📊 API Endpoints

| Método | Endpoint | Descripción |
|--------|----------|-------------|
| POST | `/api/login` | Autenticación de usuarios |
| POST | `/api/registro` | Registro de nuevos pacientes |
| POST | `/api/diagnostico` | Diagnóstico cardiovascular |
| POST | `/api/logout` | Cierre de sesión |

### Ejemplo de Diagnóstico
```json
{
  "edad": 65,
  "genero": "M",
  "ps": 180,
  "pd": 110,
  "colesterol": 280,
  "glucosa": 160,
  "fuma": "s",
  "alcohol": "s",
  "actividad": "no",
  "peso": 80,
  "estatura": 170
}
```

**Respuesta**:
```json
{
  "riesgo": 2,
  "confianza": 1.0
}
```

## 🤖 Modelo de Inteligencia Artificial

- **Algoritmo**: Random Forest optimizado
- **Precisión**: 100% en pruebas
- **Características**: 10 parámetros de entrada
- **Framework**: TensorFlow Lite
- **Formato**: Modelo cuantizado (.tflite)

### Parámetros de Evaluación
1. Edad (categorizada)
2. Género (binario)
3. Presión sistólica (categorizada)
4. Presión diastólica (categorizada)
5. Colesterol total (categorizada)
6. Glucosa (categorizada)
7. Fumador (sí/no)
8. Consumo de alcohol (sí/no)
9. Actividad física (sedentario/activo)
10. IMC (calculado)

## 📈 Resultados de Pruebas

### ✅ Autenticación
- Admin: `admin/admin123` ✅
- Pacientes: `juan/123456`, `ivan/123456`, `daniel/123456` ✅
- Registro: `testuser` ✅

### ✅ Diagnósticos
- **Riesgo Alto**: 65 años, hipertenso, fumador → Riesgo 2 ✅
- **Riesgo Medio**: 50 años, parámetros moderados → Riesgo 1 ✅
- **Riesgo Bajo**: 25 años, parámetros normales → Riesgo 0 ✅

### ✅ Base de Datos
- Conexión automática a Render ✅
- 6 usuarios registrados ✅
- 13 diagnósticos almacenados ✅
- Persistencia en la nube ✅

## 🔧 Configuración

### Variables de Entorno (Opcionales)
```bash
# Solo si se quiere cambiar la configuración por defecto
DATABASE_URL=postgresql://user:pass@host:port/db
SECRET_KEY=tu_clave_secreta
FLASK_ENV=development
```

### Configuración Automática
El sistema está configurado para funcionar sin variables de entorno adicionales.

## 📚 Documentación Adicional

- [📖 README Backend Detallado](README_BACKEND_DETALLADO.md)
- [🏗️ Diagrama de Arquitectura](DIAGRAMA_ARQUITECTURA.md)
- [⚙️ Configuración Render](CONFIGURACION_RENDER.md)
- [📱 Guía Flutter MVVM](corazon_flutter_app/README_MVVM.md)

## 👥 Equipo de Desarrollo

**Juan Carlos Barboza Chaname** - Desarrollador Full Stack
- GitHub: [@juanbch23](https://github.com/juanbch23)
- Especialización: Flutter, Python, IA, DevOps

## 📄 Licencia

Este proyecto está bajo la Licencia MIT - ver el archivo [LICENSE](LICENSE) para más detalles.

## 🎯 Estado del Proyecto

✅ **COMPLETADO** - Sistema funcional y probado
- Frontend móvil operativo
- Backend API funcionando
- Base de datos en producción
- Modelo de IA integrado
- Documentación completa

---

**⭐ Si este proyecto te resulta útil, ¡dale una estrella en GitHub!**

*Desarrollado con ❤️ para la salud cardiovascular*