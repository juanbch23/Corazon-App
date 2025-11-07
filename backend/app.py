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
from config import get_db_config, SECRET_KEY, FLASK_ENV, PORT, CORS_ORIGINS

app = Flask(__name__)
CORS(app, 
     resources={
         r"/*": { 
             "methods": ["GET", "POST", "PUT", "DELETE", "OPTIONS"],
             "allow_headers": ["Content-Type", "Authorization"], 
             "supports_credentials": True,
             "origins": CORS_ORIGINS
         }
     })

# Configuración para Docker y desarrollo
app.secret_key = SECRET_KEY
app.config['SESSION_COOKIE_SAMESITE'] = 'None'
app.config['SESSION_COOKIE_SECURE'] = False  # Para desarrollo local/Docker
app.config['SESSION_COOKIE_HTTPONLY'] = False  # Para Flutter Web
app.config['SESSION_COOKIE_DOMAIN'] = None  # Permitir cualquier dominio localhost

# Configuración de base de datos
DB_CONFIG = get_db_config()

app.register_blueprint(rutas)
app.register_blueprint(ControladorUsuario.blueprint)
app.register_blueprint(ControladorDiagnostico.blueprint)
app.register_blueprint(ControladorResultados.blueprint)
app.register_blueprint(ControladorAdmin.blueprint)
app.register_blueprint(ControladorConfiguracion.blueprint)
app.register_blueprint(ControladorSesion.blueprint)

if __name__ == '__main__':
    debug = FLASK_ENV != 'production'
    port = int(os.environ.get('PORT', PORT))  # Render usa PORT env var
    app.run(host='0.0.0.0', debug=debug, port=port)