import numpy as np
import tensorflow as tf

class ModeloDiagnostico:
    def __init__(self):
        self.interprete = tf.lite.Interpreter(model_path="modeloDEC.tflite")
        self.interprete.allocate_tensors()
        self.detalles_entrada = self.interprete.get_input_details()
        self.detalles_salida = self.interprete.get_output_details()

    def predecir(self, datos_entrada):
        datos_entrada = datos_entrada.astype(np.float32)
        self.interprete.set_tensor(self.detalles_entrada[0]['index'], datos_entrada)
        self.interprete.invoke()
        datos_salida = self.interprete.get_tensor(self.detalles_salida[0]['index'])
        return datos_salida[0]
