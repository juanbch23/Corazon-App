import numpy as np
import tensorflow as tf
import psycopg2
import os
from config import get_db_config
from config import get_db_config

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
    # Usar configuración centralizada de config.py
    db_config = get_db_config()
    return psycopg2.connect(
        host=db_config['host'],
        database=db_config['database'],
        user=db_config['user'],
        password=db_config['password'],
        port=db_config.get('port', 5432)
    )