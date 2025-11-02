# 🧠 Backend Flask - Documentación Detallada

## 📋 Resumen del Sistema

El backend es un **servidor Flask** que funciona como intermediario entre la aplicación Flutter y la base de datos PostgreSQL, integrando un **modelo de Machine Learning** (TensorFlow Lite) para diagnósticos cardiovasculares en tiempo real.

## 🏗️ Arquitectura MVC del Backend

```
Flask App (app.py)
├── Controladores/    → Manejan HTTP requests/responses
├── Modelos/         → Lógica de negocio + BD + ML  
└── Rutas/           → Endpoints de la API
```

---

## 📂 Estructura de Archivos y Responsabilidades

### 🗂️ `/controlador/` - Capa de Controladores (API Endpoints)

| Archivo | Responsabilidad | Endpoints Principales |
|---------|-----------------|----------------------|
| `controlador.py` | Rutas principales y diagnóstico base | `/api/login`, `/api/registro`, `/api/diagnostico` |
| `controlador_usuario.py` | Gestión de usuarios y autenticación | `/api/login`, `/api/registro`, `/api/logout` |
| `controlador_diagnostico.py` | Procesamiento ML y diagnósticos | `/api/diagnostico`, `/api/diagnostico/<username>` |
| `controlador_resultados.py` | Historial y consulta de resultados | `/api/resultados`, `/api/resultados/<username>` |
| `controlador_configuracion.py` | Perfil de usuario y configuración | `/api/configuracion`, `/api/configuracion/<username>` |
| `controlador_admin.py` | Panel administrativo y estadísticas | `/api/admin/pacientes`, `/api/admin/estadisticas` |
| `controlador_sesion.py` | Gestión de sesiones y autenticación | `/api/session/check`, `/api/session/refresh` |

### 🗂️ `/modelo/` - Capa de Modelos (Lógica de Negocio)

| Archivo | Responsabilidad | Funciones Principales |
|---------|-----------------|----------------------|
| `modelo.py` | Conexión BD y ML base | `obtener_conexion_bd()`, `predecir_con_tflite()` |
| `modelo_usuario.py` | CRUD de usuarios | `buscar_usuario()`, `registrar_usuario()` |
| `modelo_diagnostico.py` | Modelo ML TensorFlow Lite | `predecir()`, manejo del modelo entrenado |
| `modelo_resultados.py` | Gestión de diagnósticos | `guardar_diagnostico()`, `obtener_historial()` |
| `modelo_configuracion.py` | Perfil y configuración | `obtener_perfil()`, `actualizar_perfil()` |
| `modelo_admin.py` | Consultas administrativas | `obtener_estadisticas()`, `listar_pacientes()` |
| `modelo_autenticacion.py` | Lógica de autenticación | `validar_sesion()`, `generar_token()` |

---

## 🔄 Flujo de Procesamiento por Componente

### 1️⃣ **Login de Usuario** (`controlador_usuario.py` + `modelo_usuario.py`)

#### **Controlador: `controlador_usuario.py`**
```python
@blueprint.route('/api/login', methods=['POST'])
def login():
    # PASO 1: Extraer datos del JSON
    username = request.json.get('username')
    password = request.json.get('password')
    
    # PASO 2: Llamar al modelo para validar usuario
    user = ModeloUsuario.buscar_usuario(username, password)
    
    # PASO 3: Crear sesión si es válido
    if user:
        session['logged_in'] = True
        session['user_id'] = user[0]      # ID de PostgreSQL
        session['username'] = user[1]     # Username
        session['user_type'] = user[2]    # 'paciente' o 'administrador'
        return jsonify({'message': 'Inicio de sesión exitoso', 'user_type': user[2]}), 200
    else:
        return jsonify({'message': 'Usuario o contraseña incorrectos'}), 401
```

**¿Qué hace?**
- Recibe JSON con credenciales desde Flutter
- Delega validación al modelo
- Crea sesión HTTP si es exitoso
- Devuelve JSON con resultado

#### **Modelo: `modelo_usuario.py`**
```python
@staticmethod
def buscar_usuario(username, password):
    # PASO 1: Conectar a PostgreSQL
    conn = obtener_conexion_bd()
    cur = conn.cursor()
    
    # PASO 2: Consulta SQL con parámetros seguros
    cur.execute("""
        SELECT id, username, tipo 
        FROM usuarios 
        WHERE username = %s AND password = %s
    """, (username, password))
    
    # PASO 3: Obtener resultado
    user = cur.fetchone()  # None si no existe, tuple si existe
    
    # PASO 4: Cerrar conexión
    cur.close()
    conn.close()
    return user
```

**¿Qué hace?**
- Establece conexión segura con PostgreSQL
- Ejecuta consulta SQL con parámetros (evita SQL injection)
- Retorna tupla `(id, username, tipo)` o `None`

---

### 2️⃣ **Diagnóstico ML** (`controlador_diagnostico.py` + `modelo_diagnostico.py`)

#### **Controlador: `controlador_diagnostico.py`**
```python
@blueprint.route('/api/diagnostico', methods=['POST'])
def diagnostico():
    # PASO 1: Verificar autenticación
    if not session.get('logged_in'):
        return jsonify({'message': 'Unauthorized'}), 401
    
    # PASO 2: Extraer y validar datos médicos
    edad = int(request.json.get('edad'))
    genero = request.json.get('genero')
    ps = int(request.json.get('ps'))          # Presión sistólica
    pd = int(request.json.get('pd'))          # Presión diastólica
    colesterol = float(request.json.get('colesterol'))
    glucosa = float(request.json.get('glucosa'))
    fuma = request.json.get('fuma')           # 's' o 'n'
    alcohol = request.json.get('alcohol')     # 's' o 'n'
    actividad = request.json.get('actividad') # 'no', 'ligera', etc.
    peso = float(request.json.get('peso'))
    estatura = int(request.json.get('estatura'))
    
    # PASO 3: Calcular IMC
    imc = peso / ((estatura / 100) ** 2)
    
    # PASO 4: Codificar datos para el modelo ML
    entrada = [
        0 if edad < 45 else 1 if edad <= 59 else 2,        # Edad categorizada
        0 if 'femenino' in genero.lower() else 1,          # Género binario
        0 if ps < 120 else 1 if ps <= 139 else 2,          # Presión sistólica
        0 if pd < 80 else 1 if pd <= 89 else 2,            # Presión diastólica
        0 if colesterol < 200 else 1 if colesterol <= 239 else 2,  # Colesterol
        0 if glucosa < 100 else 1 if glucosa <= 125 else 2,        # Glucosa
        1 if fuma == 's' else 0,                           # Fuma (binario)
        1 if alcohol == 's' else 0,                        # Alcohol (binario)
        2 if 'no' in actividad.lower() else 1 if '1' in actividad or '2' in actividad else 0,  # Actividad
        1 if imc == 0 else 1 if imc < 18.5 else 0 if imc < 25 else 1 if imc < 30 else 2  # IMC categorizado
    ]
    
    # PASO 5: Ejecutar modelo ML
    input_array = np.array([entrada], dtype=np.float32)
    pred = ControladorDiagnostico.modelo_diagnostico.predecir(input_array)
    
    # PASO 6: Interpretar resultado
    riesgo = int(np.argmax(pred))      # 0=Bajo, 1=Medio, 2=Alto
    confianza = float(np.max(pred))    # Probabilidad del resultado
    
    # PASO 7: Guardar en base de datos
    ModeloResultados.guardar_diagnostico(user_id, edad, genero, ps, pd, colesterol, glucosa, 
                                       fuma, alcohol, actividad, peso, estatura, imc, riesgo, confianza)
    
    # PASO 8: Devolver resultado
    return jsonify({'riesgo': riesgo, 'confianza': confianza}), 200
```

**¿Qué hace?**
- Valida sesión del usuario
- Procesa datos médicos desde JSON
- Transforma datos al formato del modelo ML
- Ejecuta predicción de riesgo cardiovascular
- Guarda todo en PostgreSQL
- Devuelve resultado interpretable

#### **Modelo: `modelo_diagnostico.py`**
```python
class ModeloDiagnostico:
    def __init__(self):
        # PASO 1: Cargar modelo TensorFlow Lite
        self.interprete = tf.lite.Interpreter(model_path="modeloDEC.tflite")
        self.interprete.allocate_tensors()
        
        # PASO 2: Obtener detalles del modelo
        self.detalles_entrada = self.interprete.get_input_details()
        self.detalles_salida = self.interprete.get_output_details()

    def predecir(self, datos_entrada):
        # PASO 1: Preparar datos (formato Float32)
        datos_entrada = datos_entrada.astype(np.float32)
        
        # PASO 2: Cargar datos en el modelo
        self.interprete.set_tensor(self.detalles_entrada[0]['index'], datos_entrada)
        
        # PASO 3: Ejecutar inferencia
        self.interprete.invoke()
        
        # PASO 4: Obtener predicción
        datos_salida = self.interprete.get_tensor(self.detalles_salida[0]['index'])
        return datos_salida[0]  # Array de 3 probabilidades [P(bajo), P(medio), P(alto)]
```

**¿Qué hace?**
- Carga modelo entrenado TensorFlow Lite en memoria
- Procesa array de entrada (10 características codificadas)
- Ejecuta inferencia neuronal
- Retorna array de probabilidades para cada nivel de riesgo

---

### 3️⃣ **Gestión de Resultados** (`controlador_resultados.py` + `modelo_resultados.py`)

#### **Funcionalidad: Guardar Diagnóstico**
```python
# En modelo_resultados.py
@staticmethod
def guardar_diagnostico(user_id, edad, genero, ps, pd, colesterol, glucosa, 
                       fuma, alcohol, actividad, peso, estatura, imc, riesgo, confianza):
    conn = obtener_conexion_bd()
    cur = conn.cursor()
    
    # PASO 1: Guardar datos médicos originales
    cur.execute("""
        INSERT INTO diagnostico_datos (
            usuario_id, edad, genero, ps, pd, colesterol, glucosa,
            fuma, alcohol, actividad, peso, estatura, imc, fecha_ingreso
        ) VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, NOW())
        RETURNING id
    """, (user_id, edad, genero, ps, pd, colesterol, glucosa, fuma, alcohol, actividad, peso, estatura, imc))
    
    datos_id = cur.fetchone()[0]  # Obtener ID del registro insertado
    
    # PASO 2: Guardar resultado del ML
    cur.execute("""
        INSERT INTO diagnostico_resultados (
            datos_id, riesgo, confianza, fecha_diagnostico
        ) VALUES (%s, %s, %s, NOW())
    """, (datos_id, riesgo, confianza))
    
    conn.commit()
    cur.close()
    conn.close()
```

**¿Qué hace?**
- Guarda datos médicos originales en tabla `diagnostico_datos`
- Guarda resultado ML en tabla `diagnostico_resultados`
- Establece relación entre ambas tablas
- Timestamp automático para auditoría

---

### 4️⃣ **Panel Administrativo** (`controlador_admin.py` + `modelo_admin.py`)

#### **Funcionalidad: Estadísticas del Sistema**
```python
# En modelo_admin.py
@staticmethod
def obtener_estadisticas():
    conn = obtener_conexion_bd()
    cur = conn.cursor()
    
    # PASO 1: Contar pacientes totales
    cur.execute("SELECT COUNT(*) FROM usuarios WHERE tipo = 'paciente'")
    total_pacientes = cur.fetchone()[0]
    
    # PASO 2: Contar diagnósticos totales
    cur.execute("SELECT COUNT(*) FROM diagnostico_datos")
    total_diagnosticos = cur.fetchone()[0]
    
    # PASO 3: Diagnósticos por nivel de riesgo
    cur.execute("""
        SELECT riesgo, COUNT(*) 
        FROM diagnostico_resultados 
        GROUP BY riesgo 
        ORDER BY riesgo
    """)
    riesgos = cur.fetchall()
    
    # PASO 4: Diagnósticos recientes (últimos 7 días)
    cur.execute("""
        SELECT COUNT(*) 
        FROM diagnostico_datos 
        WHERE fecha_ingreso >= NOW() - INTERVAL '7 days'
    """)
    diagnosticos_semana = cur.fetchone()[0]
    
    cur.close()
    conn.close()
    
    return {
        'total_pacientes': total_pacientes,
        'total_diagnosticos': total_diagnosticos,
        'riesgos': dict(riesgos),
        'diagnosticos_semana': diagnosticos_semana
    }
```

**¿Qué hace?**
- Genera estadísticas agregadas del sistema
- Consultas optimizadas con GROUP BY y fechas
- Métricas para dashboard administrativo

---

## 🤖 Integración del Modelo de Machine Learning

### 📊 **Proceso de Codificación de Datos**

El modelo requiere que todos los datos médicos se conviertan a **valores numéricos categorizados**:

#### **Transformaciones Aplicadas:**

1. **Edad**: `<45` → 0, `45-59` → 1, `≥60` → 2
2. **Género**: `femenino` → 0, `masculino` → 1  
3. **Presión Sistólica**: `<120` → 0, `120-139` → 1, `≥140` → 2
4. **Presión Diastólica**: `<80` → 0, `80-89` → 1, `≥90` → 2
5. **Colesterol**: `<200` → 0, `200-239` → 1, `≥240` → 2
6. **Glucosa**: `<100` → 0, `100-125` → 1, `≥126` → 2
7. **Fuma**: `no` → 0, `sí` → 1
8. **Alcohol**: `no` → 0, `sí` → 1
9. **Actividad**: `intensa` → 0, `moderada/ligera` → 1, `no` → 2
10. **IMC**: `normal` → 0, `sobrepeso` → 1, `obesidad` → 2

### 🧠 **Ejecución del Modelo**

```python
# Ejemplo de entrada procesada:
entrada = [1, 1, 2, 1, 1, 0, 1, 0, 1, 1]  # Datos codificados
input_array = np.array([entrada], dtype=np.float32)

# Ejecutar modelo TensorFlow Lite
pred = modelo.predecir(input_array)
# Resultado: [0.15, 0.70, 0.15] = 70% probabilidad riesgo medio

riesgo = np.argmax(pred)      # 1 (riesgo medio)
confianza = np.max(pred)      # 0.70 (70% confianza)
```

### 📈 **Interpretación de Resultados**

| Valor Riesgo | Significado | Rango Confianza | Acción Recomendada |
|--------------|-------------|-----------------|-------------------|
| 0 | **Riesgo Bajo** | 60-95% | Mantener hábitos saludables |
| 1 | **Riesgo Medio** | 65-90% | Consulta médica preventiva |
| 2 | **Riesgo Alto** | 70-95% | Atención médica urgente |

---

## 🔗 Conexión con PostgreSQL

### 📊 **Función de Conexión Base**
```python
# En modelo.py
def obtener_conexion_bd():
    DATABASE_URL = os.environ.get('DATABASE_URL')
    
    if DATABASE_URL:
        # Para Docker - usar variable de entorno
        return psycopg2.connect(DATABASE_URL)
    else:
        # Para desarrollo local
        return psycopg2.connect('postgresql://postgres:1234@localhost:5432/dec_database')
```

### 🛡️ **Prácticas de Seguridad Implementadas**

1. **Parámetros SQL**: Todas las consultas usan `%s` para evitar SQL injection
2. **Gestión de Conexiones**: Apertura/cierre explícito en cada operación
3. **Transacciones**: `commit()` y `rollback()` para integridad de datos
4. **Validación de Sesiones**: Verificación en endpoints sensibles

---

## 🚀 Resumen del Flujo Completo

### 📱 **Flutter → Backend → PostgreSQL → ML → Respuesta**

1. **Flutter envía JSON** → `POST /api/diagnostico`
2. **Controlador valida** sesión y extrae datos
3. **Modelo transforma** datos al formato ML
4. **TensorFlow Lite** ejecuta predicción
5. **PostgreSQL guarda** datos originales + resultado
6. **JSON response** con riesgo y confianza
7. **Flutter muestra** resultado al usuario

### ⚙️ **Ventajas de esta Arquitectura**

- ✅ **Separación clara** de responsabilidades (MVC)
- ✅ **Reutilización** de modelos entre controladores
- ✅ **Escalabilidad** para nuevos endpoints
- ✅ **Mantenibilidad** del código ML separado
- ✅ **Seguridad** con validaciones en cada capa
- ✅ **Auditoría** completa en base de datos

Este backend está diseñado para ser **robusto, escalable y mantenible**, proporcionando una base sólida para el sistema de diagnóstico cardiovascular.