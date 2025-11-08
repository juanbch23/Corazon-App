# Configuración de la aplicación DEC
# Archivo: config.py

import os

# CONFIGURACIÓN FIJA PARA RAILWAY (sin variables de entorno)
DATABASE_URL = 'postgresql://dec_database_user:yYRGubYoptewjiFC8dQm9qi7nqniM24Z@dpg-d43p8s6r433s739nmumg-a.oregon-postgres.render.com/dec_database'

# Configuración de Flask
SECRET_KEY = 'clave-super-secreta-dec-2025-railway'
FLASK_ENV = 'production'
PORT = int(os.environ.get('PORT', 8080))  # Railway usa PORT dinámico

# Configuración de CORS
CORS_ORIGINS = [
    "http://localhost:5173",
    "http://127.0.0.1:5173",
    "http://localhost:3001",
    "http://localhost:3002",
    "https://web-production-3194.up.railway.app",
    "*"  # Permitir cualquier origen para desarrollo
]

# Función para obtener configuración de BD (FIJA PARA RAILWAY)
def get_db_config():
    # Configuración fija de Render (sin variables de entorno)
    return {
        'host': 'dpg-d43p8s6r433s739nmumg-a.oregon-postgres.render.com',
        'database': 'dec_database',
        'user': 'dec_database_user',
        'password': 'yYRGubYoptewjiFC8dQm9qi7nqniM24Z',
        'port': 5432
    }