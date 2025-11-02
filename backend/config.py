# Configuración de la aplicación DEC
# Archivo: config.py

import os

# Configuración de base de datos
DATABASE_URL = os.environ.get('DATABASE_URL', 'postgresql://dec_database_user:yYRGubYoptewjiFC8dQm9qi7nqniM24Z@dpg-d43p8s6r433s739nmumg-a.oregon-postgres.render.com/dec_database')

# Configuración de Flask
SECRET_KEY = os.environ.get('SECRET_KEY', 'clave-super-secreta-dec-2025')
FLASK_ENV = os.environ.get('FLASK_ENV', 'development')
PORT = int(os.environ.get('PORT', 5000))

# Configuración de CORS
CORS_ORIGINS = [
    "http://localhost:5173",
    "http://127.0.0.1:5173",
    "http://localhost:3001",
    "http://localhost:3002",
    "http://localhost:*"
]

# Función para obtener configuración de BD
def get_db_config():
    if DATABASE_URL and DATABASE_URL != 'postgresql://dec_database_user:yYRGubYoptewjiFC8dQm9qi7nqniM24Z@dpg-d43p8s6r433s739nmumg-a.oregon-postgres.render.com/dec_database':
        # Si hay una DATABASE_URL personalizada, la usa
        import urllib.parse as urlparse
        url = urlparse.urlparse(DATABASE_URL)
        return {
            'host': url.hostname,
            'database': url.path[1:],
            'user': url.username,
            'password': url.password,
            'port': url.port or 5432
        }
    elif DATABASE_URL == 'postgresql://dec_database_user:yYRGubYoptewjiFC8dQm9qi7nqniM24Z@dpg-d43p8s6r433s739nmumg-a.oregon-postgres.render.com/dec_database':
        # Configuración por defecto de Render
        return {
            'host': 'dpg-d43p8s6r433s739nmumg-a.oregon-postgres.render.com',
            'database': 'dec_database',
            'user': 'dec_database_user',
            'password': 'yYRGubYoptewjiFC8dQm9qi7nqniM24Z',
            'port': 5432
        }
    else:
        # Configuración de desarrollo local
        return {
            'host': 'localhost',
            'database': 'dec_database',
            'user': 'postgres',
            'password': '1234'
        }