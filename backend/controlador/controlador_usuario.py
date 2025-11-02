from flask import Blueprint, jsonify, request, session
from modelo.modelo_usuario import ModeloUsuario

class ControladorUsuario:
    blueprint = Blueprint('usuario', __name__)

    @staticmethod
    @blueprint.route('/api/login', methods=['POST'])
    def login():
        username = request.json.get('username')
        password = request.json.get('password')
        user = ModeloUsuario.buscar_usuario(username, password)
        if user:
            session['logged_in'] = True
            session['user_id'] = user[0]
            session['username'] = user[1]
            session['user_type'] = user[2]
            return jsonify({'message': 'Inicio de sesión exitoso', 'user_type': user[2]}), 200
        else:
            return jsonify({'message': 'Usuario o contraseña incorrectos'}), 401

    @staticmethod
    @blueprint.route('/api/registro', methods=['POST'])
    def registro():
        username = request.json.get('username')
        password = request.json.get('password')
        tipo = 'paciente'
        nombre = request.json.get('nombre')
        apellido = request.json.get('apellido')
        fecha_nacimiento = request.json.get('fecha_nacimiento')
        genero = request.json.get('genero')
        telefono = request.json.get('telefono')
        direccion = request.json.get('direccion')
        dni = request.json.get('dni')
        exito, error = ModeloUsuario.registrar_usuario(username, password, tipo, nombre, apellido, fecha_nacimiento, genero, telefono, direccion, dni)
        if exito:
            return jsonify({'message': 'Registro exitoso. Ahora puede iniciar sesión.'}), 201
        else:
            return jsonify({'message': error}), 409

    @staticmethod
    @blueprint.route('/api/logout', methods=['POST'])
    def logout():
        session.clear()
        return jsonify({'message': 'Logout exitoso'}), 200
