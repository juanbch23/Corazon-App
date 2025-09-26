import psycopg2
from modelo.modelo import obtener_conexion_bd

class ModeloUsuario:
    @staticmethod
    def buscar_usuario(username, password):
        conn = obtener_conexion_bd()
        cur = conn.cursor()
        cur.execute("""
            SELECT id, username, tipo 
            FROM usuarios 
            WHERE username = %s AND password = %s
        """, (username, password))
        user = cur.fetchone()
        cur.close()
        conn.close()
        return user

    @staticmethod
    def buscar_usuario_por_username(username):
        """Buscar usuario solo por username (para endpoints alternativos)"""
        conn = obtener_conexion_bd()
        cur = conn.cursor()
        cur.execute("""
            SELECT id, username, tipo 
            FROM usuarios 
            WHERE username = %s
        """, (username,))
        user = cur.fetchone()
        cur.close()
        conn.close()
        return user

    @staticmethod
    def registrar_usuario(username, password, tipo, nombre, apellido, fecha_nacimiento, genero, telefono, direccion, dni):
        conn = obtener_conexion_bd()
        cur = conn.cursor()
        try:
            cur.execute("""
                INSERT INTO usuarios (
                    username, password, tipo,
                    nombre, apellido, fecha_nacimiento,
                    genero, telefono, direccion, dni
                )
                VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s)
            """, (
                username, password, tipo,
                nombre, apellido, fecha_nacimiento,
                genero, telefono, direccion, dni
            ))
            conn.commit()
            return True, None
        except psycopg2.IntegrityError:
            conn.rollback()
            return False, 'El nombre de usuario o DNI ya existe'
        except Exception as e:
            conn.rollback()
            return False, f'Error en el registro: {str(e)}'
        finally:
            cur.close()
            conn.close()
