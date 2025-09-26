from flask import Blueprint, jsonify, session
from modelo.modelo_resultados import ModeloResultados
from datetime import datetime

class ControladorResultados:
    blueprint = Blueprint('resultados', __name__)

    @staticmethod
    @blueprint.route('/api/resultados', methods=['GET'])
    def resultados():
        if not session.get('logged_in'):
            return jsonify({'message': 'Unauthorized'}), 401
        diagnostico = None
        if 'ultimo_diagnostico' in session:
            riesgo, confianza, fecha_str = session['ultimo_diagnostico']
            diagnostico = {'riesgo': riesgo, 'confianza': confianza, 'fecha': fecha_str}
            session.pop('ultimo_diagnostico')
        else:
            row = ModeloResultados.obtener_ultimo_diagnostico(session['user_id'])
            if row:
                # Formatear la fecha correctamente
                fecha_formateada = row[2].strftime('%Y-%m-%d %H:%M:%S') if row[2] else None
                diagnostico = {'riesgo': row[0], 'confianza': row[1], 'fecha': fecha_formateada}
        return jsonify({'diagnostico': diagnostico}), 200

    @staticmethod
    @blueprint.route('/api/resultados/<username>', methods=['GET'])
    def resultados_by_username(username):
        """Endpoint alternativo para Flutter Web sin sessions"""
        from modelo.modelo_usuario import ModeloUsuario
        
        # Obtener el usuario por username
        user_row = ModeloUsuario.buscar_usuario_por_username(username)
        if not user_row:
            return jsonify({'message': 'Usuario no encontrado'}), 404
            
        user_id = user_row[0]  # El ID está en la primera posición
        
        diagnostico = None
        row = ModeloResultados.obtener_ultimo_diagnostico(user_id)
        if row:
            # Formatear la fecha correctamente
            fecha_formateada = row[2].strftime('%Y-%m-%d %H:%M:%S') if row[2] else None
            diagnostico = {'riesgo': row[0], 'confianza': row[1], 'fecha': fecha_formateada}
        return jsonify({'diagnostico': diagnostico}), 200
