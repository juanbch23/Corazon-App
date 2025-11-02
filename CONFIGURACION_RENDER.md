# 📋 CONFIGURACIÓN RECOMENDADA PARA RENDER POSTGRESQL

## 🎯 CONFIGURACIÓN ÓPTIMA PARA TU PROYECTO DEC

### **Campos a Configurar:**

#### **1. Nombre** ⭐
```
dec-cardiovascular-db
```
**¿Por qué?** Nombre descriptivo, único y relacionado con tu proyecto.

#### **2. Base de datos** (Opcional)
```
dec_database
```
**¿Por qué?** Mismo nombre que tu base de datos local para consistencia.

#### **3. Usuario** (Opcional)
```
postgres
```
**¿Por qué?** Mismo usuario que usas localmente.

#### **4. Región** ✅
```
Oregón (oeste de EE. UU.)
```
**Excelente elección** - buena latencia para usuarios en América.

#### **5. Versión de PostgreSQL** ⚠️ IMPORTANTE
```
15
```
**¿Por qué?** Tu backup actual es de PostgreSQL 15. La versión 17 podría causar incompatibilidades.

#### **6. Plan** ✅
```
Gratis - $0 al mes
```
**Perfecto** para desarrollo y testing. Incluye:
- 256 MB RAM
- 0.1 CPU
- 1 GB almacenamiento

#### **7. Almacenamiento** ✅
```
1 GB
```
**Suficiente** para tus datos actuales (~23KB) con mucho espacio para crecimiento.

#### **8. Opciones Adicionales** ❌
```
❌ Escalado automático del almacenamiento: Desactivado
❌ Alta disponibilidad: Desactivado (no disponible en Free)
❌ Datadog: No necesario por ahora
```

---

## 🚀 PASOS PARA COMPLETAR LA CONFIGURACIÓN:

### **Paso 1: Llena los campos**
- Nombre: `dec-cardiovascular-db`
- Base de datos: `dec_database`
- Usuario: `postgres`
- Región: Oregon (ya seleccionado)
- Versión: `15`
- Plan: Free (ya seleccionado)
- Almacenamiento: `1` GB

### **Paso 2: Haz clic en "Crear base de datos"**
- Espera 5-10 minutos mientras Render crea tu base de datos
- Verás el progreso en el dashboard

### **Paso 3: Copia la DATABASE_URL**
Una vez creada, ve a:
- Dashboard → Tu base de datos → "External Database URL"
- **Cópiala y guárdala** - la necesitarás para conectar

### **Paso 4: Verifica la conexión**
```bash
# Prueba la conexión (reemplaza TU_URL)
psql "TU_DATABASE_URL_AQUI" -c "SELECT version();"
```

---

## 📊 ESPECIFICACIONES TÉCNICAS RECOMENDADAS:

| Campo | Valor Recomendado | Razón |
|-------|------------------|--------|
| **Nombre** | `dec-cardiovascular-db` | Descriptivo y único |
| **Base de datos** | `dec_database` | Consistencia con local |
| **Usuario** | `postgres` | Mismo que Docker |
| **Región** | Oregon | Buena latencia |
| **Versión** | `15` | Compatible con tu backup |
| **Plan** | Free | $0 para testing |
| **RAM** | 256 MB | Suficiente para desarrollo |
| **Almacenamiento** | 1 GB | Espacio para crecimiento |

---

## ⚡ PRÓXIMOS PASOS DESPUÉS DE CREAR:

1. **Copia la DATABASE_URL** 📋
2. **Restaura tu backup** 🔄
3. **Actualiza docker-compose.yml** ⚙️
4. **Prueba la conexión** ✅

---

## 💡 NOTAS IMPORTANTES:

- **Versión PostgreSQL 15**: Es crucial usar la misma versión que tu backup
- **Plan Free**: Perfecto para desarrollo, limita conexiones simultáneas
- **Región**: Oregon es buena para usuarios en América Latina
- **Almacenamiento**: 1GB es más que suficiente para empezar

¿Ya creaste la base de datos? Si tienes la DATABASE_URL, puedo ayudarte con el siguiente paso de restauración.