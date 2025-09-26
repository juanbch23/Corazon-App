from flask import Flask
from flask_cors import CORS
import os
from controlador.controlador import rutas
from controlador.controlador_usuario import ControladorUsuario
from controlador.controlador_diagnostico import ControladorDiagnostico
from controlador.controlador_resultados import ControladorResultados
from controlador.controlador_admin import ControladorAdmin
from controlador.controlador_configuracion import ControladorConfiguracion
from controlador.controlador_sesion import ControladorSesion

app = Flask(__name__)
CORS(app, 
     resources={
         r"/*": { 
             "methods": ["GET", "POST", "PUT", "DELETE", "OPTIONS"],
             "allow_headers": ["Content-Type", "Authorization"], 
             "supports_credentials": True,
             "origins": ["http://localhost:5173", "http://127.0.0.1:5173", "http://localhost:3001", "http://localhost:3002", "http://localhost:*"]
         }
     })

# Configuración para Docker y desarrollo
app.secret_key = os.environ.get('SECRET_KEY', 'clave-super-secreta-dec-2025')
app.config['SESSION_COOKIE_SAMESITE'] = 'None'
app.config['SESSION_COOKIE_SECURE'] = False  # Para desarrollo local/Docker
app.config['SESSION_COOKIE_HTTPONLY'] = False  # Para Flutter Web
app.config['SESSION_COOKIE_DOMAIN'] = None  # Permitir cualquier dominio localhost

# Configuración de base de datos
DATABASE_URL = os.environ.get('DATABASE_URL', None)
if DATABASE_URL:
    # Para Docker - parsear DATABASE_URL
    import urllib.parse as urlparse
    url = urlparse.urlparse(DATABASE_URL)
    DB_CONFIG = {
        'host': url.hostname,
        'database': url.path[1:],
        'user': url.username,
        'password': url.password,
        'port': url.port or 5432
    }
else:
    # Para desarrollo local
    DB_CONFIG = {
        'host': 'localhost',
        'database': 'dec_database',
        'user': 'postgres',
        'password': '1234'
    }

app.register_blueprint(rutas)
app.register_blueprint(ControladorUsuario.blueprint)
app.register_blueprint(ControladorDiagnostico.blueprint)
app.register_blueprint(ControladorResultados.blueprint)
app.register_blueprint(ControladorAdmin.blueprint)
app.register_blueprint(ControladorConfiguracion.blueprint)
app.register_blueprint(ControladorSesion.blueprint)

if __name__ == '__main__':
    port = int(os.environ.get('PORT', 5000))
    debug = os.environ.get('FLASK_ENV') != 'production'
    app.run(host='0.0.0.0', debug=debug, port=port)