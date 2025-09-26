import numpy as np
import tensorflow as tf
import psycopg2
import os

def cargar_interprete():
    interprete = tf.lite.Interpreter(model_path="modeloDEC.tflite")
    interprete.allocate_tensors()
    return interprete

interprete = cargar_interprete()
detalles_entrada = interprete.get_input_details()
detalles_salida = interprete.get_output_details()

def predecir_con_tflite(datos_entrada):
    datos_entrada = datos_entrada.astype(np.float32)
    interprete.set_tensor(detalles_entrada[0]['index'], datos_entrada)
    interprete.invoke()
    datos_salida = interprete.get_tensor(detalles_salida[0]['index'])
    return datos_salida[0]

# Modelo para conexión a base de datos
def obtener_conexion_bd():
    # Configuración para Docker o desarrollo local
    DATABASE_URL = os.environ.get('DATABASE_URL')
    
    if DATABASE_URL:
        # Para Docker - usar DATABASE_URL del contenedor
        return psycopg2.connect(DATABASE_URL)
    else:
        # Para desarrollo local
        return psycopg2.connect('postgresql://postgres:1234@localhost:5432/dec_database')