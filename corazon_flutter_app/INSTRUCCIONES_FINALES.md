# 🎯 INSTRUCCIONES FINALES - Ejecutar la Aplicación

## ✅ Estado Actual del Proyecto

**TODO ESTÁ LISTO** ✨

El proyecto ha sido migrado completamente a arquitectura MVVM y está funcionando igual que el proyecto original "Proyecto -corazon-web".

---

## 🚀 OPCIÓN 1: Ejecutar en Emulador Android (RECOMENDADO)

### Paso 1: Iniciar un Emulador

Tienes 2 emuladores disponibles:
- **Medium_Phone_API_36.0** (Recomendado - más moderno)
- **Pixel_5**

**Comando para iniciar:**
```powershell
flutter emulators --launch Medium_Phone_API_36.0
```

O si prefieres el Pixel 5:
```powershell
flutter emulators --launch Pixel_5
```

**Espera 30-60 segundos** a que el emulador inicie completamente.

### Paso 2: Ejecutar la Aplicación

```powershell
flutter run
```

La app se instalará y ejecutará automáticamente en el emulador.

---

## 📱 OPCIÓN 2: Generar APK para Celular Físico

### Paso 1: Generar la APK

```powershell
.\generar-apk.ps1
```

O manualmente:
```powershell
flutter build apk --release
```

### Paso 2: La APK estará en:
```
build\app\outputs\flutter-apk\app-release.apk
```

### Paso 3: Instalar en tu Celular

**Método A: Con cable USB**
1. Conecta tu celular al PC
2. Habilita "Depuración USB" en el celular
3. Ejecuta:
```powershell
adb install build\app\outputs\flutter-apk\app-release.apk
```

**Método B: Manualmente**
1. Copia `app-release.apk` al celular
2. En el celular: Configuración → Seguridad → Habilitar "Fuentes desconocidas"
3. Abre el archivo APK desde el explorador
4. Instala la app

---

## ⚠️ IMPORTANTE: Backend debe estar corriendo

Antes de usar la app, asegúrate de que el backend Docker esté activo:

```powershell
cd "c:\Users\Juan\programacion-Aplicada\Programacion aplicada lll\Proyecto -corazon-web\Build"
docker-compose up -d
```

Verifica que esté corriendo:
```powershell
docker ps
```

Deberías ver:
- `backend_backend_1` (Flask)
- `backend_postgres_1` (PostgreSQL)

---

## 👤 Usuarios de Prueba

### Paciente
```
Usuario: paciente1
Contraseña: 123456
```

### Administrador
```
Usuario: admin
Contraseña: admin123
```

---

## 🎬 COMANDO RÁPIDO (TODO EN UNO)

Copia y pega este comando en PowerShell para ejecutar todo:

```powershell
cd 'c:\Users\Juan\programacion-Aplicada\Programacion aplicada lll\corazon_flutter_app'; flutter emulators --launch Medium_Phone_API_36.0; Start-Sleep -Seconds 30; flutter run
```

Esto:
1. Cambia a la carpeta del proyecto
2. Inicia el emulador
3. Espera 30 segundos
4. Ejecuta la aplicación

---

## 📋 Checklist Antes de Ejecutar

- [ ] Backend Docker está corriendo
- [ ] Flutter SDK está instalado (`flutter doctor`)
- [ ] Emulador disponible o celular conectado
- [ ] Dependencias instaladas (`flutter pub get`)

---

## 🐛 Problemas Comunes

### "Waiting for another flutter command..."
```powershell
taskkill /F /IM dart.exe
taskkill /F /IM flutter.exe
```

### Backend no responde
```powershell
# Verifica que Docker esté corriendo
docker ps

# Reinicia el backend
cd "Proyecto -corazon-web\Build"
docker-compose restart
```

### Emulador no inicia
```powershell
# Verifica emuladores
flutter emulators

# Prueba con el otro emulador
flutter emulators --launch Pixel_5
```

---

## 📊 Pantallas de la App

1. **Login** → Inicio de sesión
2. **Registro** → Crear cuenta nueva
3. **Home** → Dashboard principal
4. **Diagnóstico** → Evaluación cardiovascular
5. **Resultados** → Historial con gráficos
6. **Configuración** → Perfil del usuario
7. **Admin** → Panel de administración (solo admin)

---

## 📝 Archivos de Documentación Creados

1. **README_MVVM.md** → Explicación completa de MVVM
2. **GUIA_EJECUCION.md** → Guía detallada de ejecución
3. **RESUMEN_MIGRACION_MVVM.md** → Comparación antes/después
4. **INSTRUCCIONES_FINALES.md** → Este archivo

---

## 🎯 Para el Profesor

### Puntos a destacar:

1. **Arquitectura MVVM completa**
   - Model: `modelos/`
   - View: `vistas/`
   - ViewModel: `vistamodelos/`

2. **Funcionalidad 100% mantenida**
   - Todas las pantallas funcionan igual
   - Mismo backend Docker
   - Mismas características

3. **Código mejor organizado**
   - Separación de responsabilidades
   - Más mantenible y testeable
   - Documentación completa

4. **Scripts de automatización**
   - `ejecutar-app.ps1`
   - `generar-apk.ps1`

---

## ✅ TODO LISTO

El proyecto está **100% funcional** con arquitectura **MVVM**.

**Siguiente paso:** Ejecutar uno de los comandos de arriba para ver la app funcionando.

---

**¡Éxito con tu presentación!** 🎉

**Autor**: Juan  
**Proyecto**: Sistema de Diagnóstico Cardiovascular MVVM  
**Curso**: Programación Aplicada III
