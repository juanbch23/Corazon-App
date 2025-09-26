import psycopg2
from modelo.modelo import obtener_conexion_bd

class ModeloConfiguracion:
    @staticmethod
    def obtener_datos_usuario(usuario_id):
        """Obtiene datos personales del usuario"""
        conn = obtener_conexion_bd()
        cur = conn.cursor()
        
        try:
            cur.execute("""
                SELECT 
                    nombre, apellido, fecha_nacimiento, 
                    genero, telefono, direccion, dni
                FROM usuarios 
                WHERE id = %s
            """, (usuario_id,))
            
            resultado = cur.fetchone()
            if not resultado:
                return None
                
            campos = [
                'nombre', 'apellido', 'fecha_nacimiento',
                'genero', 'telefono', 'direccion', 'dni'
            ]
            return dict(zip(campos, resultado))
            
        finally:
            cur.close()
            conn.close()

    @staticmethod
    def actualizar_datos_usuario(usuario_id, datos):
        """Actualiza los datos personales del usuario"""
        conn = obtener_conexion_bd()
        cur = conn.cursor()
        
        try:
            cur.execute("""
                UPDATE usuarios SET
                    nombre = %s,
                    apellido = %s,
                    fecha_nacimiento = %s,
                    genero = %s,
                    telefono = %s,
                    direccion = %s,
                    dni = %s
                WHERE id = %s
            """, (
                datos['nombre'],
                datos['apellido'],
                datos['fecha_nacimiento'],
                datos['genero'],
                datos['telefono'],
                datos['direccion'],
                datos['dni'],
                usuario_id
            ))
            conn.commit()
            return True
        except Exception as e:
            conn.rollback()
            raise e
        finally:
            cur.close()
            conn.close()