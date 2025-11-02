from flask import Blueprint, jsonify, session, request
from modelo.modelo_admin import ModeloAdmin

class ControladorAdmin:
    blueprint = Blueprint('admin', __name__)

    @staticmethod
    @blueprint.route('/api/admin', methods=['GET'])
    def admin_panel():
        if not session.get('logged_in') or session.get('user_type') != 'administrador':
            return jsonify({'message': 'Acceso no autorizado'}), 403
        
        filtro = request.args.get('filtro', '').lower()
        pacientes = ModeloAdmin.obtener_pacientes(filtro)
        return jsonify({'pacientes': pacientes}), 200

    @staticmethod
    @blueprint.route('/api/admin/<username>', methods=['GET'])
    def admin_panel_by_username(username):
        """Endpoint alternativo para Flutter Web sin sessions"""
        from modelo.modelo_usuario import ModeloUsuario
        
        # Verificar que el usuario sea admin
        user_row = ModeloUsuario.buscar_usuario_por_username(username)
        if not user_row or user_row[2] != 'administrador':
            return jsonify({'message': 'Acceso no autorizado'}), 403
        
        filtro = request.args.get('filtro', '').lower()
        pacientes = ModeloAdmin.obtener_pacientes(filtro)
        return jsonify({'pacientes': pacientes}), 200

    @staticmethod
    @blueprint.route('/api/admin/diagnosticos/<int:usuario_id>', methods=['GET'])
    def obtener_historial_usuario(usuario_id):
        if not session.get('logged_in') or session.get('user_type') != 'administrador':
            return jsonify({'message': 'Acceso no autorizado'}), 403
        
        historial = ModeloAdmin.obtener_historial_diagnosticos(usuario_id)
        return jsonify(historial), 200

    @staticmethod
    @blueprint.route('/api/admin/<username>/diagnosticos/<int:usuario_id>', methods=['GET'])
    def obtener_historial_usuario_by_username(username, usuario_id):
        """Endpoint alternativo para Flutter Web sin sessions"""
        from modelo.modelo_usuario import ModeloUsuario
        
        # Verificar que el usuario sea admin
        user_row = ModeloUsuario.buscar_usuario_por_username(username)
        if not user_row or user_row[2] != 'administrador':
            return jsonify({'message': 'Acceso no autorizado'}), 403
        
        historial = ModeloAdmin.obtener_historial_diagnosticos(usuario_id)
        return jsonify(historial), 200