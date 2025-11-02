from flask import Blueprint, jsonify, session
from modelo.modelo_autenticacion import ModeloAutenticacion

class ControladorSesion:
    blueprint = Blueprint('sesion', __name__)

    @staticmethod
    @blueprint.route('/api/sesion', methods=['GET'])
    def verificar_sesion():
        """Verifica si hay una sesión activa y devuelve información del usuario"""
        if not session.get('logged_in'):
            return jsonify({'message': 'No hay sesión activa'}), 200
        
        usuario = ModeloAutenticacion.obtener_info_sesion(session['user_id'])
        if usuario:
            return jsonify({
                'logged_in': True,
                'user_id': usuario[0],
                'username': usuario[1],
                'user_type': usuario[2]
            }), 200
        
        return jsonify({'message': 'Sesión inválida'}), 401