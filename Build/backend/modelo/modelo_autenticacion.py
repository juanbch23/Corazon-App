import psycopg2
from modelo.modelo import obtener_conexion_bd

class ModeloAutenticacion:
    @staticmethod
    def verificar_credenciales(username, password):
        """Verifica las credenciales del usuario"""
        conn = obtener_conexion_bd()
        cur = conn.cursor()
        
        try:
            cur.execute("""
                SELECT id, username, tipo 
                FROM usuarios 
                WHERE username = %s AND password = %s
            """, (username, password))
            return cur.fetchone()
        finally:
            cur.close()
            conn.close()

    @staticmethod
    def obtener_info_sesion(usuario_id):
        """Obtiene información básica del usuario para la sesión"""
        conn = obtener_conexion_bd()
        cur = conn.cursor()
        
        try:
            cur.execute("""
                SELECT id, username, tipo 
                FROM usuarios 
                WHERE id = %s
            """, (usuario_id,))
            return cur.fetchone()
        finally:
            cur.close()
            conn.close()