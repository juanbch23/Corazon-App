# 🏥 Sistema de Diagnóstico Cardiovascular - Documentación Completa

## 📋 Descripción General

Este proyecto es un **Sistema Inteligente de Diagnóstico Cardiovascular** que combina:
- **Backend Python Flask** con modelo de Machine Learning (TensorFlow Lite)
- **Base de datos PostgreSQL** para persistencia de datos
- **Frontend Flutter** con arquitectura MVVM
- **Containerización Docker** para despliegue

## 🏗️ Arquitectura del Sistema

```
┌─────────────────┐    HTTP/JSON    ┌──────────────────┐    SQL    ┌─────────────────┐
│   Flutter App   │ ◄──────────────► │  Backend Flask   │ ◄────────► │   PostgreSQL    │
│   (Frontend)    │      API REST    │   (Servidor)     │  psycopg2  │  (Base Datos)   │
└─────────────────┘                 └──────────────────┘           └─────────────────┘
      │                                       │
      │ MVVM Pattern                          │ ML Model
      │                                       ▼
┌─────────────────┐                 ┌──────────────────┐
│ Vistas/ViewModels│                │  TensorFlow Lite │
│ Servicios/Modelos│                │   (modelo.tflite) │
└─────────────────┘                 └──────────────────┘
```

---

## 🔧 Backend (Flask + PostgreSQL + TensorFlow)

### 📁 Estructura del Backend

```
backend/
├── app.py                    # Servidor Flask principal
├── modelo/
│   ├── modelo.py             # Conexión BD + ML
│   ├── modelo_usuario.py     # Modelo Usuario
│   ├── modelo_diagnostico.py # Modelo Diagnóstico
│   └── modelo_admin.py       # Modelo Admin
├── controlador/
│   ├── controlador.py        # Rutas principales
│   ├── controlador_usuario.py
│   ├── controlador_diagnostico.py
│   └── controlador_admin.py
├── modeloDEC.tflite          # Modelo ML entrenado
└── requirements.txt          # Dependencias Python
```

### 🚀 Cómo Funciona el Backend

#### 1. **Servidor Principal (app.py)**
```python
# PASO 1: Inicialización del servidor Flask
app = Flask(__name__)
CORS(app)  # Permite peticiones desde Flutter

# PASO 2: Configuración de base de datos
DB_CONFIG = {
    'host': 'localhost',
    'database': 'dec_database', 
    'user': 'postgres',
    'password': '1234'
}

# PASO 3: Registro de controladores (blueprints)
app.register_blueprint(rutas)
app.register_blueprint(ControladorUsuario.blueprint)
app.register_blueprint(ControladorDiagnostico.blueprint)
```

**¿Qué hace?**
- Inicia el servidor web en puerto 5000
- Configura CORS para permitir peticiones desde Flutter
- Registra todas las rutas de la API
- Conecta con PostgreSQL usando las credenciales configuradas

#### 2. **Modelo de Base de Datos (modelo/modelo.py)**
```python
def obtener_conexion_bd():
    return psycopg2.connect('postgresql://postgres:1234@localhost:5432/dec_database')

def predecir_con_tflite(datos_entrada):
    # PASO 1: Cargar modelo TensorFlow Lite
    interprete.set_tensor(detalles_entrada[0]['index'], datos_entrada)
    
    # PASO 2: Ejecutar predicción
    interprete.invoke()
    
    # PASO 3: Obtener resultado
    datos_salida = interprete.get_tensor(detalles_salida[0]['index'])
    return datos_salida[0]
```

**¿Qué hace?**
- Conecta a PostgreSQL usando psycopg2
- Carga el modelo de Machine Learning (TensorFlow Lite)
- Procesa datos de entrada y genera predicciones de riesgo cardiovascular

#### 3. **Controlador Principal (controlador/controlador.py)**

**Endpoint de Login:**
```python
@rutas.route('/api/login', methods=['POST'])
def login():
    # PASO 1: Obtener datos del JSON
    usuario = request.json.get('username')
    contrasena = request.json.get('password')
    
    # PASO 2: Consultar base de datos
    conn = obtener_conexion_bd()
    cur = conn.cursor()
    cur.execute("SELECT id, username, tipo FROM usuarios WHERE username = %s AND password = %s", 
                (usuario, contrasena))
    user = cur.fetchone()
    
    # PASO 3: Crear sesión si es válido
    if user:
        session['logged_in'] = True
        session['user_id'] = user[0]
        return jsonify({'message': 'Login exitoso', 'user_type': user[2]})
```

**Endpoint de Diagnóstico:**
```python
@rutas.route('/api/diagnostico', methods=['POST'])
def diagnostico():
    # PASO 1: Validar sesión activa
    if not session.get('logged_in'):
        return jsonify({'message': 'Unauthorized'}), 401
    
    # PASO 2: Obtener datos médicos del JSON
    edad = int(request.json.get('edad'))
    genero = request.json.get('genero')
    ps = int(request.json.get('ps'))       # Presión sistólica
    pd = int(request.json.get('pd'))       # Presión diastólica
    colesterol = float(request.json.get('colesterol'))
    # ... más parámetros
    
    # PASO 3: Preparar datos para ML
    entrada = [
        0 if edad < 45 else 1 if edad <= 59 else 2,  # Codificación edad
        0 if 'femenino' in genero.lower() else 1,     # Codificación género
        # ... más transformaciones
    ]
    
    # PASO 4: Ejecutar modelo ML
    input_array = np.array([entrada], dtype=np.float32)
    pred = predecir_con_tflite(input_array)
    riesgo = int(np.argmax(pred))          # 0=Bajo, 1=Medio, 2=Alto
    confianza = float(np.max(pred))        # Confianza de la predicción
    
    # PASO 5: Guardar en base de datos
    cur.execute("""
        INSERT INTO diagnostico_datos (
            usuario_id, edad, genero, ps, pd, colesterol, glucosa,
            fuma, alcohol, actividad, peso, estatura, imc, fecha_ingreso
        ) VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, NOW())
    """, (session['user_id'], edad, genero, ps, pd, col, glu, fuma, alcohol, actividad, peso, estatura, imc))
    
    # PASO 6: Devolver resultado
    return jsonify({'riesgo': riesgo, 'confianza': confianza})
```

---

## 📱 Frontend Flutter (Arquitectura MVVM)

### 📁 Estructura del Frontend

```
lib/
├── main.dart                 # Punto de entrada
├── config/
│   └── app_config.dart       # Configuración URLs
├── modelos/                  # Modelos de datos
│   ├── usuario.dart
│   ├── diagnostico_cardiovascular.dart
│   └── paciente_model.dart
├── servicios/                # Capa de comunicación
│   └── api_service.dart      # HTTP Client
├── vistamodelos/             # Lógica de negocio
│   ├── login_viewmodel.dart
│   ├── diagnostico_viewmodel.dart
│   └── home_viewmodel.dart
└── vistas/                   # Interfaces de usuario
    ├── login_vista.dart
    ├── diagnostico_vista.dart
    └── home_vista.dart
```

### 🔄 Patrón MVVM en Flutter

#### 1. **Configuración de URL (config/app_config.dart)**
```dart
class AppConfig {
  static String get apiBaseUrl {
    if (Platform.isAndroid) {
      return 'http://10.0.2.2:5000/api';  // Emulador Android
    } else {
      return 'http://localhost:5000/api';   // Web/iOS
    }
  }
}
```

**¿Qué hace?**
- Detecta automáticamente la plataforma (Android/iOS/Web)
- Usa la URL correcta para cada caso (emulador Android necesita 10.0.2.2)

#### 2. **Servicio API (servicios/api_service.dart)**
```dart
class ApiService {
  // PASO 1: Cliente HTTP Singleton
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  
  // PASO 2: Método Login
  Future<Map<String, dynamic>> login(String username, String password) async {
    final response = await post('/login', data: {
      'username': username,
      'password': password,
    });
    
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Error de autenticación');
    }
  }
  
  // PASO 3: Método Diagnóstico
  Future<Map<String, dynamic>> realizarDiagnostico(Map<String, dynamic> datos) async {
    final response = await post('/diagnostico', data: datos);
    return jsonDecode(response.body);
  }
}
```

**¿Qué hace?**
- Maneja todas las peticiones HTTP al backend
- Convierte JSON de respuesta en Map<String, dynamic>
- Maneja errores de conexión y códigos de respuesta

#### 3. **ViewModel (vistamodelos/diagnostico_viewmodel.dart)**
```dart
class DiagnosticoViewModel extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  
  // PASO 1: Estados del ViewModel
  bool _estaCargando = false;
  String _error = '';
  Map<String, dynamic>? _resultado;
  
  // PASO 2: Getters para la Vista
  bool get estaCargando => _estaCargando;
  String get error => _error;
  Map<String, dynamic>? get resultado => _resultado;
  
  // PASO 3: Método para realizar diagnóstico
  Future<void> realizarDiagnostico(Map<String, dynamic> datosMedicos) async {
    _estaCargando = true;
    _error = '';
    notifyListeners();  // Notifica a la Vista que se actualice
    
    try {
      // Llamada al servicio API
      _resultado = await _apiService.realizarDiagnostico(datosMedicos);
    } catch (e) {
      _error = 'Error al realizar diagnóstico: $e';
    } finally {
      _estaCargando = false;
      notifyListeners();  // Notifica cambios a la Vista
    }
  }
}
```

**¿Qué hace?**
- Mantiene el estado de la pantalla (cargando, error, datos)
- Coordina entre la Vista y el Servicio API
- Notifica automáticamente cambios a la interfaz usando Provider

#### 4. **Vista (vistas/diagnostico_vista.dart)**
```dart
class DiagnosticoVista extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<DiagnosticoViewModel>(  // Escucha cambios del ViewModel
        builder: (context, viewModel, child) {
          
          // PASO 1: Mostrar loading si está cargando
          if (viewModel.estaCargando) {
            return CircularProgressIndicator();
          }
          
          // PASO 2: Mostrar error si hay error
          if (viewModel.error.isNotEmpty) {
            return Text('Error: ${viewModel.error}');
          }
          
          // PASO 3: Mostrar formulario o resultado
          return Column(
            children: [
              // Formulario de datos médicos
              TextFormField(/* edad */),
              TextFormField(/* presión */),
              // ... más campos
              
              ElevatedButton(
                onPressed: () {
                  // PASO 4: Llamar al ViewModel
                  final datos = {
                    'edad': _edadController.text,
                    'genero': _generoSeleccionado,
                    'ps': _presionSistolicaController.text,
                    // ... más datos
                  };
                  
                  viewModel.realizarDiagnostico(datos);
                },
                child: Text('Realizar Diagnóstico'),
              ),
              
              // Mostrar resultado si existe
              if (viewModel.resultado != null)
                _buildResultado(viewModel.resultado!),
            ],
          );
        },
      ),
    );
  }
}
```

**¿Qué hace?**
- Muestra la interfaz de usuario reactiva
- Escucha cambios del ViewModel usando Consumer
- Recolecta datos del usuario y los envía al ViewModel

---

## 🔄 Flujo Completo de Datos

### 📊 Ejemplo: Realizar un Diagnóstico

#### **PASO 1: Usuario interactúa con la Vista**
```
Usuario llena formulario → Presiona "Realizar Diagnóstico"
```

#### **PASO 2: Vista llama al ViewModel**
```dart
// En DiagnosticoVista
final datos = {
  'edad': 45,
  'genero': 'masculino',
  'ps': 140,
  'pd': 90,
  'colesterol': 220.5,
  // ... más campos
};

viewModel.realizarDiagnostico(datos);
```

#### **PASO 3: ViewModel llama al Servicio**
```dart
// En DiagnosticoViewModel
Future<void> realizarDiagnostico(Map<String, dynamic> datosMedicos) async {
  _estaCargando = true;
  notifyListeners();  // Vista muestra loading
  
  try {
    _resultado = await _apiService.realizarDiagnostico(datosMedicos);
  } catch (e) {
    _error = e.toString();
  }
  
  _estaCargando = false;
  notifyListeners();  // Vista se actualiza con resultado
}
```

#### **PASO 4: Servicio hace petición HTTP**
```dart
// En ApiService
Future<Map<String, dynamic>> realizarDiagnostico(Map<String, dynamic> datos) async {
  final url = Uri.parse('http://localhost:5000/api/diagnostico');
  final response = await http.post(
    url,
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode(datos),
  );
  
  return jsonDecode(response.body);
}
```

#### **PASO 5: Backend recibe la petición**
```python
# En controlador.py
@rutas.route('/api/diagnostico', methods=['POST'])
def diagnostico():
    # Obtener datos del JSON
    edad = int(request.json.get('edad'))        # 45
    genero = request.json.get('genero')         # 'masculino'
    ps = int(request.json.get('ps'))            # 140
    # ... más datos
```

#### **PASO 6: Backend procesa con ML**
```python
# Transformar datos para el modelo
entrada = [
    1,          # edad 45-59 = código 1
    1,          # masculino = código 1  
    1,          # ps 120-139 = código 1
    1,          # pd 80-89 = código 1
    1,          # colesterol 200-239 = código 1
    # ... más transformaciones
]

# Ejecutar modelo ML
input_array = np.array([entrada], dtype=np.float32)
pred = predecir_con_tflite(input_array)
riesgo = int(np.argmax(pred))      # Ejemplo: 1 (riesgo medio)
confianza = float(np.max(pred))    # Ejemplo: 0.75 (75% confianza)
```

#### **PASO 7: Backend guarda en PostgreSQL**
```sql
-- Guardar datos del diagnóstico
INSERT INTO diagnostico_datos (
    usuario_id, edad, genero, ps, pd, colesterol, 
    glucosa, fuma, alcohol, actividad, peso, estatura, 
    imc, fecha_ingreso
) VALUES (
    1, 45, 'masculino', 140, 90, 220.5, 
    95.0, 'n', 's', 'moderada', 80.5, 175, 
    26.3, NOW()
);

-- Guardar resultado del ML
INSERT INTO diagnostico_resultados (
    datos_id, riesgo, confianza, fecha_diagnostico
) VALUES (LAST_INSERT_ID(), 1, 0.75, NOW());
```

#### **PASO 8: Backend devuelve JSON**
```python
return jsonify({
    'riesgo': 1,           # 0=Bajo, 1=Medio, 2=Alto
    'confianza': 0.75,     # 75% de confianza
    'message': 'Diagnóstico completado'
}), 200
```

#### **PASO 9: Flutter recibe y muestra resultado**
```dart
// ApiService devuelve Map al ViewModel
{
  'riesgo': 1,
  'confianza': 0.75,
  'message': 'Diagnóstico completado'
}

// ViewModel actualiza estado
_resultado = respuestaAPI;
notifyListeners();

// Vista se refresca automáticamente y muestra:
// "Riesgo: MEDIO (75% confianza)"
```

---

## 🗃️ Base de Datos PostgreSQL

### 📊 Estructura de Tablas

#### **Tabla: usuarios**
```sql
CREATE TABLE usuarios (
    id SERIAL PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    tipo VARCHAR(20) DEFAULT 'paciente',  -- 'paciente' o 'admin'
    nombre VARCHAR(100),
    apellido VARCHAR(100),
    fecha_nacimiento DATE,
    genero VARCHAR(10),
    telefono VARCHAR(20),
    direccion TEXT,
    dni VARCHAR(20) UNIQUE,
    fecha_registro TIMESTAMP DEFAULT NOW()
);
```

#### **Tabla: diagnostico_datos**
```sql
CREATE TABLE diagnostico_datos (
    id SERIAL PRIMARY KEY,
    usuario_id INTEGER REFERENCES usuarios(id),
    edad INTEGER NOT NULL,
    genero VARCHAR(10) NOT NULL,
    ps INTEGER NOT NULL,           -- Presión sistólica
    pd INTEGER NOT NULL,           -- Presión diastólica  
    colesterol DECIMAL(5,2),       -- mg/dL
    glucosa DECIMAL(5,2),          -- mg/dL
    fuma CHAR(1) CHECK (fuma IN ('s', 'n')),
    alcohol CHAR(1) CHECK (alcohol IN ('s', 'n')),
    actividad VARCHAR(20),         -- 'no', 'ligera', 'moderada', 'intensa'
    peso DECIMAL(5,2),             -- kg
    estatura INTEGER,              -- cm
    imc DECIMAL(4,2),              -- Calculado: peso/(estatura/100)²
    fecha_ingreso TIMESTAMP DEFAULT NOW()
);
```

#### **Tabla: diagnostico_resultados**
```sql
CREATE TABLE diagnostico_resultados (
    id SERIAL PRIMARY KEY,
    datos_id INTEGER REFERENCES diagnostico_datos(id),
    riesgo INTEGER NOT NULL,       -- 0=Bajo, 1=Medio, 2=Alto
    confianza DECIMAL(4,3),        -- 0.000-1.000
    notas TEXT,
    fecha_diagnostico TIMESTAMP DEFAULT NOW()
);
```

### 🔍 Consultas Típicas

**Obtener historial de un paciente:**
```sql
SELECT 
    dd.fecha_ingreso,
    dd.edad, dd.genero, dd.ps, dd.pd,
    dr.riesgo, dr.confianza
FROM diagnostico_datos dd
JOIN diagnostico_resultados dr ON dd.id = dr.datos_id
WHERE dd.usuario_id = 1
ORDER BY dd.fecha_ingreso DESC;
```

**Estadísticas para administrador:**
```sql
-- Total de pacientes
SELECT COUNT(*) as total_pacientes FROM usuarios WHERE tipo = 'paciente';

-- Total de diagnósticos
SELECT COUNT(*) as total_diagnosticos FROM diagnostico_datos;

-- Diagnósticos por nivel de riesgo
SELECT 
    riesgo,
    COUNT(*) as cantidad,
    CASE riesgo
        WHEN 0 THEN 'Bajo'
        WHEN 1 THEN 'Medio' 
        WHEN 2 THEN 'Alto'
    END as nivel
FROM diagnostico_resultados 
GROUP BY riesgo;
```

---

## 🤖 Modelo de Machine Learning

### 🧠 TensorFlow Lite

El modelo `modeloDEC.tflite` es un modelo entrenado que:

**Entrada (10 características):**
1. **Edad codificada**: 0 (<45), 1 (45-59), 2 (≥60)
2. **Género**: 0 (femenino), 1 (masculino)
3. **Presión sistólica**: 0 (<120), 1 (120-139), 2 (≥140)
4. **Presión diastólica**: 0 (<80), 1 (80-89), 2 (≥90)
5. **Colesterol**: 0 (<200), 1 (200-239), 2 (≥240)
6. **Glucosa**: 0 (<100), 1 (100-125), 2 (≥126)
7. **Fuma**: 0 (no), 1 (sí)
8. **Alcohol**: 0 (no), 1 (sí)
9. **Actividad física**: 0 (intensa), 1 (moderada/ligera), 2 (no)
10. **IMC codificado**: 0 (normal), 1 (sobrepeso), 2 (obesidad)

**Salida (3 probabilidades):**
- `[0.1, 0.7, 0.2]` → Riesgo Medio (índice 1, confianza 70%)
- `[0.8, 0.15, 0.05]` → Riesgo Bajo (índice 0, confianza 80%)
- `[0.05, 0.25, 0.7]` → Riesgo Alto (índice 2, confianza 70%)

### ⚙️ Procesamiento en Backend

```python
def predecir_con_tflite(datos_entrada):
    # PASO 1: Cargar modelo en memoria
    interprete = tf.lite.Interpreter(model_path="modeloDEC.tflite")
    interprete.allocate_tensors()
    
    # PASO 2: Preparar entrada
    datos_entrada = datos_entrada.astype(np.float32)
    interprete.set_tensor(detalles_entrada[0]['index'], datos_entrada)
    
    # PASO 3: Ejecutar inferencia
    interprete.invoke()
    
    # PASO 4: Obtener predicción
    datos_salida = interprete.get_tensor(detalles_salida[0]['index'])
    return datos_salida[0]  # Array de 3 probabilidades

# Ejemplo de uso:
entrada = [1, 1, 1, 1, 1, 0, 1, 0, 1, 1]  # Datos codificados
input_array = np.array([entrada], dtype=np.float32)
prediccion = predecir_con_tflite(input_array)  # [0.1, 0.65, 0.25]

riesgo = np.argmax(prediccion)        # 1 (índice mayor probabilidad)
confianza = np.max(prediccion)        # 0.65 (65% de confianza)
```

---

## 🚀 Cómo Ejecutar el Proyecto

### 🐋 Opción 1: Docker (Recomendado)

#### **Backend + PostgreSQL**
```bash
# En la carpeta Build/
cd Build/
docker-compose up -d

# Verificar que estén ejecutándose:
docker-compose ps
```

#### **Flutter**
```bash
# En la carpeta corazon_flutter_app/
cd corazon_flutter_app/
flutter pub get
flutter run -d chrome
```

### 💻 Opción 2: Desarrollo Local

#### **PostgreSQL**
```bash
# Instalar PostgreSQL y crear base de datos
createdb dec_database
psql dec_database < BD/script_DEC.sql
```

#### **Backend Flask**
```bash
cd Build/backend/
pip install -r requirements.txt
python app.py
```

#### **Flutter**
```bash
cd corazon_flutter_app/
flutter pub get
flutter run
```

---

## 🔗 Endpoints de la API

| Método | Endpoint | Descripción | Parámetros |
|--------|----------|-------------|------------|
| POST | `/api/login` | Autenticación | `username`, `password` |
| POST | `/api/registro` | Registro de usuario | `username`, `password`, `nombre`, etc. |
| POST | `/api/logout` | Cerrar sesión | - |
| POST | `/api/diagnostico` | Realizar diagnóstico ML | Datos médicos completos |
| GET | `/api/resultados` | Historial del usuario | - |
| GET | `/api/configuracion` | Perfil del usuario | - |
| PUT | `/api/configuracion` | Actualizar perfil | Datos del usuario |
| GET | `/api/admin/pacientes` | Lista de pacientes (admin) | - |
| GET | `/api/admin/estadisticas` | Estadísticas (admin) | - |

---

## 🎯 Resumen del Flujo

1. **Usuario** abre la app Flutter
2. **Flutter** carga la configuración de URL según plataforma
3. **Usuario** hace login → **Vista** → **ViewModel** → **ApiService** → **HTTP POST** → **Backend Flask**
4. **Backend** verifica credenciales en **PostgreSQL** → devuelve respuesta JSON
5. **Flutter** recibe respuesta → **ApiService** → **ViewModel** → **Vista** se actualiza
6. **Usuario** llena diagnóstico → mismo flujo hasta **Backend**
7. **Backend** procesa datos → **TensorFlow Lite** → predicción ML → guarda en **PostgreSQL**
8. **Flutter** muestra resultado → **Usuario** ve su diagnóstico

Este sistema garantiza:
- ✅ **Separación de responsabilidades** (MVVM + MVC)
- ✅ **Comunicación async** HTTP/JSON  
- ✅ **Persistencia** en PostgreSQL
- ✅ **Inteligencia artificial** con TensorFlow Lite
- ✅ **Escalabilidad** con Docker
- ✅ **Multiplataforma** con Flutter
