# 🚀 PROMPT DETALLADO PARA GENERADOR DE IMÁGENES - ARQUITECTURA COMPLETA

## 📋 **INSTRUCCIONES PARA EL GENERADOR DE IMÁGENES:**

Crea una imagen profesional y detallada que muestre la arquitectura completa de un sistema de diagnóstico cardiovascular. La imagen debe ser clara, con colores diferenciados y flechas que indiquen el flujo de datos.

## 🏗️ **COMPONENTES A INCLUIR:**

### **1. Frontend - Flutter App (Móvil)**
- **Icono**: 📱 Smartphone con logo Flutter
- **Nombre**: "Flutter MVVM App"
- **Descripción**: Aplicación móvil con arquitectura MVVM
- **Color**: Azul Flutter (#02569B)

### **2. Backend - Flask API Server**
- **Icono**: 🖥️ Servidor con logo Python/Flask
- **Nombre**: "Flask REST API"
- **Descripción**: Servidor API con endpoints REST
- **Componentes internos**:
  - Controladores (autenticación, diagnóstico, resultados)
  - Modelos (usuario, diagnóstico, resultados)
  - TensorFlow Lite integration
- **Color**: Verde Python (#3776AB)

### **3. Base de Datos - PostgreSQL**
- **Icono**: 🐘 Elefante (logo PostgreSQL)
- **Nombre**: "PostgreSQL Database"
- **Descripción**: Base de datos relacional
- **Tablas a mostrar**:
  - `usuarios` (id, username, password, tipo)
  - `diagnostico_datos` (usuario_id, edad, genero, ps, pd, colesterol, glucosa, fuma, alcohol, actividad, peso, estatura, imc, fecha_ingreso)
  - `diagnostico_resultados` (datos_id, riesgo, confianza, fecha_diagnostico)
- **Color**: Azul PostgreSQL (#336791)

### **4. Machine Learning - TensorFlow Lite**
- **Icono**: 🧠 Cerebro con logo TensorFlow
- **Nombre**: "TensorFlow Lite ML Model"
- **Descripción**: Modelo entrenado para predicción de riesgo cardiovascular
- **Entradas**: 10 características médicas codificadas
- **Salidas**: Probabilidades de riesgo (Bajo/Medio/Alto)
- **Color**: Naranja TensorFlow (#FF6F00)

### **5. Contenerización - Docker**
- **Icono**: 🐳 Ballena Docker
- **Contenedores**:
  - `dec_backend` (Flask + TensorFlow Lite)
  - `dec_postgres` (PostgreSQL database)
- **Docker Compose**: Orquestación de servicios
- **Color**: Azul Docker (#2496ED)

## 🔄 **FLUJO DE DATOS (CON FLECHAS):**

### **Flujo Principal de Diagnóstico:**
1. **Usuario → Flutter App**: Ingresa datos médicos en formulario
2. **Flutter App → Flask API**: HTTP POST con JSON de datos médicos
3. **Flask API → PostgreSQL**: Consulta usuario autenticado
4. **Flask API → TensorFlow Lite**: Envía datos codificados para predicción
5. **TensorFlow Lite → Flask API**: Retorna probabilidades de riesgo
6. **Flask API → PostgreSQL**: Guarda diagnóstico completo
7. **Flask API → Flutter App**: HTTP Response con resultado
8. **Flutter App → Usuario**: Muestra resultado con nivel de riesgo

### **Flujo de Autenticación:**
1. **Flutter App → Flask API**: POST /api/login con credenciales
2. **Flask API → PostgreSQL**: SELECT usuario WHERE username/password
3. **PostgreSQL → Flask API**: Retorna datos de usuario
4. **Flask API → Flutter App**: JWT token + tipo de usuario

## 📊 **CONSULTAS SQL A MOSTRAR:**

```sql
-- Autenticación
SELECT id, username, tipo FROM usuarios WHERE username = %s AND password = %s

-- Guardar diagnóstico
INSERT INTO diagnostico_datos (usuario_id, edad, genero, ps, pd, colesterol, glucosa, fuma, alcohol, actividad, peso, estatura, imc, fecha_ingreso)
VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, NOW())
RETURNING id

-- Guardar resultado ML
INSERT INTO diagnostico_resultados (datos_id, riesgo, confianza, fecha_diagnostico)
VALUES (%s, %s, %s, NOW())

-- Obtener historial
SELECT d.*, r.riesgo, r.confianza FROM diagnostico_datos d
JOIN diagnostico_resultados r ON d.id = r.datos_id
WHERE d.usuario_id = %s ORDER BY d.fecha_ingreso DESC
```

## 🎨 **ESTILO DE LA IMAGEN:**

- **Formato**: Horizontal landscape (16:9)
- **Estilo**: Diagrama de arquitectura profesional, tipo AWS/Azure
- **Colores**: Usa la paleta definida arriba
- **Tipografía**: Sans-serif clara y legible
- **Elementos**: Iconos reconocibles, flechas con dirección clara
- **Layout**: Componentes organizados lógicamente de izquierda a derecha
- **Detalles**: Incluye nombres de endpoints, tipos de conexiones (HTTP, SQL, Docker network)

## 📝 **ELEMENTOS ADICIONALES:**

- **Redes Docker**: Muestra cómo los contenedores se comunican
- **Volúmenes**: Indica persistencia de datos PostgreSQL
- **Puertos**: 5432 (PostgreSQL), 5000 (Flask)
- **Environment Variables**: DATABASE_URL para conexión
- **Sesiones**: Gestión de estado HTTP en Flask
- **Transformación de Datos**: Muestra cómo los datos médicos se codifican antes del ML

## 🎯 **PROPÓSITO:**
Esta imagen debe explicar visualmente cómo funciona todo el sistema de diagnóstico cardiovascular, desde que el usuario abre la app móvil hasta que recibe su resultado de riesgo cardíaco, mostrando todas las capas técnicas involucradas.