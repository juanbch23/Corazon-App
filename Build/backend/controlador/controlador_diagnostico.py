from flask import Blueprint, jsonify, request, session
from modelo.modelo_diagnostico import ModeloDiagnostico
import numpy as np
from datetime import datetime
from modelo.modelo_usuario import ModeloUsuario

class ControladorDiagnostico:
    blueprint = Blueprint('diagnostico', __name__)
    modelo_diagnostico = ModeloDiagnostico()

    @staticmethod
    @blueprint.route('/api/diagnostico', methods=['POST'])
    def diagnostico():
        if not session.get('logged_in'):
            return jsonify({'message': 'Unauthorized'}), 401
        try:
            edad = int(request.json.get('edad'))
            genero = request.json.get('genero')
            ps = int(request.json.get('ps'))
            pd = int(request.json.get('pd'))
            col = float(request.json.get('colesterol'))
            glu = float(request.json.get('glucosa'))
            fuma = request.json.get('fuma')
            alcohol = request.json.get('alcohol')
            actividad = request.json.get('actividad')
            peso = float(request.json.get('peso'))
            estatura = int(request.json.get('estatura'))
            imc = peso / ((estatura / 100) ** 2)
            entrada = [
                0 if edad < 45 else 1 if edad <= 59 else 2,
                0 if 'femenino' in genero.lower() else 1,
                0 if ps < 120 else 1 if ps <= 139 else 2,
                0 if pd < 80 else 1 if pd <= 89 else 2,
                0 if col < 200 else 1 if col <= 239 else 2,
                0 if glu < 100 else 1 if glu <= 125 else 2,
                1 if fuma == 's' else 0,
                1 if alcohol == 's' else 0,
                2 if 'no' in actividad.lower() else 1 if '1' in actividad or '2' in actividad else 0,
                1 if imc == 0 else 1 if imc < 18.5 else 0 if imc < 25 else 1 if imc < 30 else 2
            ]
            input_array = np.array([entrada], dtype=np.float32)
            pred = ControladorDiagnostico.modelo_diagnostico.predecir(input_array)
            riesgo = int(np.argmax(pred))
            confianza = float(np.max(pred))
            
            # Guardar el diagnóstico en la base de datos
            from modelo.modelo_resultados import ModeloResultados
            user_id = session.get('user_id')
            ModeloResultados.guardar_diagnostico(
                user_id, edad, genero, ps, pd, col, glu, fuma, alcohol, actividad, peso, estatura, imc, riesgo, confianza
            )
            
            session['ultimo_diagnostico'] = [
                riesgo,
                confianza,
                datetime.now().strftime('%Y-%m-%d %H:%M:%S')
            ]
            return jsonify({'riesgo': riesgo, 'confianza': confianza}), 200
        except Exception as e:
            return jsonify({'message': f'Error en el diagnóstico: {str(e)}'}), 500

    @staticmethod
    @blueprint.route('/api/diagnostico/<username>', methods=['POST'])
    def diagnostico_by_username(username):
        """Endpoint alternativo para Flutter Web sin sessions"""
        from modelo.modelo_usuario import ModeloUsuario
        from modelo.modelo_resultados import ModeloResultados
        
        # Verificar que el usuario existe
        user_row = ModeloUsuario.buscar_usuario_por_username(username)
        if not user_row:
            return jsonify({'message': 'Usuario no encontrado'}), 404
            
        user_id = user_row[0]  # El ID está en la primera posición
            
        try:
            edad = int(request.json.get('edad'))
            genero = request.json.get('genero')
            ps = int(request.json.get('ps'))
            pd = int(request.json.get('pd'))
            col = float(request.json.get('colesterol'))
            glu = float(request.json.get('glucosa'))
            fuma = request.json.get('fuma')
            alcohol = request.json.get('alcohol')
            actividad = request.json.get('actividad')
            peso = float(request.json.get('peso'))
            estatura = int(request.json.get('estatura'))
            imc = peso / ((estatura / 100) ** 2)
            entrada = [
                0 if edad < 45 else 1 if edad <= 59 else 2,
                0 if 'femenino' in genero.lower() else 1,
                0 if ps < 120 else 1 if ps <= 139 else 2,
                0 if pd < 80 else 1 if pd <= 89 else 2,
                0 if col < 200 else 1 if col <= 239 else 2,
                0 if glu < 100 else 1 if glu <= 125 else 2,
                1 if fuma == 's' else 0,
                1 if alcohol == 's' else 0,
                2 if 'no' in actividad.lower() else 1 if '1' in actividad or '2' in actividad else 0,
                1 if imc == 0 else 1 if imc < 18.5 else 0 if imc < 25 else 1 if imc < 30 else 2
            ]
            input_array = np.array([entrada], dtype=np.float32)
            pred = ControladorDiagnostico.modelo_diagnostico.predecir(input_array)
            riesgo = int(np.argmax(pred))
            confianza = float(np.max(pred))
            
            # Guardar el diagnóstico en la base de datos
            ModeloResultados.guardar_diagnostico(
                user_id, edad, genero, ps, pd, col, glu, fuma, alcohol, actividad, peso, estatura, imc, riesgo, confianza
            )
            
            return jsonify({'riesgo': riesgo, 'confianza': confianza}), 200
        except Exception as e:
            return jsonify({'message': f'Error en el diagnóstico: {str(e)}'}), 500
