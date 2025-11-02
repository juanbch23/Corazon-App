from flask import Blueprint, jsonify, request, session
from datetime import datetime
from modelo.modelo import predecir_con_tflite, obtener_conexion_bd
import numpy as np
import psycopg2

rutas = Blueprint('rutas', __name__)

@rutas.route('/api/login', methods=['POST'])
def login():
    usuario = request.json.get('username')
    contrasena = request.json.get('password')
    conn = obtener_conexion_bd()
    cur = conn.cursor()
    cur.execute("""
        SELECT id, username, tipo 
        FROM usuarios 
        WHERE username = %s AND password = %s
    """, (usuario, contrasena))
    user = cur.fetchone()
    cur.close()
    conn.close()
    if user:
        session['logged_in'] = True
        session['user_id'] = user[0]
        session['username'] = user[1]
        session['user_type'] = user[2]
        return jsonify({'message': 'Inicio de sesión exitoso', 'user_type': user[2]}), 200
    else:
        return jsonify({'message': 'Usuario o contraseña incorrectos'}), 401

@rutas.route('/api/registro', methods=['POST'])
def registro():
    usuario = request.json.get('username')
    contrasena = request.json.get('password')
    tipo = 'paciente'
    nombre = request.json.get('nombre')
    apellido = request.json.get('apellido') 
    fecha_nacimiento = request.json.get('fecha_nacimiento')
    genero = request.json.get('genero')
    telefono = request.json.get('telefono')
    direccion = request.json.get('direccion')
    dni = request.json.get('dni')
    try:
        conn = obtener_conexion_bd()
        cur = conn.cursor()
        cur.execute("""
            INSERT INTO usuarios (
                username, password, tipo,
                nombre, apellido, fecha_nacimiento,
                genero, telefono, direccion, dni
            )
            VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s)
        """, (
            usuario, contrasena, tipo,
            nombre, apellido, fecha_nacimiento,
            genero, telefono, direccion, dni
        ))
        conn.commit()
        return jsonify({'message': 'Registro exitoso. Ahora puede iniciar sesión.'}), 201
    except psycopg2.IntegrityError:
        conn.rollback()
        return jsonify({'message': 'El nombre de usuario o DNI ya existe'}), 409
    except Exception as e:
        conn.rollback()
        return jsonify({'message': f'Error en el registro: {str(e)}'}), 500
    finally:
        cur.close()
        conn.close()

@rutas.route('/api/logout', methods=['POST'])
def logout():
    session.clear()
    return jsonify({'message': 'Logout exitoso'}), 200

@rutas.route('/api/diagnostico', methods=['POST'])
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
        pred = predecir_con_tflite(input_array)
        riesgo = int(np.argmax(pred))
        confianza = float(np.max(pred))
        conn = obtener_conexion_bd()
        cur = conn.cursor()
        cur.execute("""
            INSERT INTO diagnostico_datos (
                usuario_id, edad, genero, ps, pd, colesterol, glucosa,
                fuma, alcohol, actividad, peso, estatura, imc, fecha_ingreso
            ) VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, NOW())
            RETURNING id
        """, (
            session['user_id'], edad, genero, ps, pd, col, glu,
            fuma, alcohol, actividad, peso, estatura, imc
        ))
        datos_id = cur.fetchone()[0]
        cur.execute("""
            INSERT INTO diagnostico_resultados (
                datos_id, riesgo, confianza, notas, fecha_diagnostico
            ) VALUES (%s, %s, %s, %s, NOW())
        """, (
            datos_id, riesgo, confianza, None 
        ))
        conn.commit()
        session['ultimo_diagnostico'] = [
            riesgo,
            confianza,
            datetime.now().strftime('%Y-%m-%d %H:%M:%S')
        ]
        return jsonify({'riesgo': riesgo, 'confianza': confianza}), 200
    except Exception as e:
        return jsonify({'message': f'Error en el diagnóstico: {str(e)}'}), 500
    finally:
        if 'cur' in locals(): cur.close()
        if 'conn' in locals(): conn.close()
