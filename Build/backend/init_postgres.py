import psycopg2
from modelo.modelo import obtener_conexion_bd

def init_database():
    try:
        conn = obtener_conexion_bd()
        cur = conn.cursor()
        
        # Leer y ejecutar el script SQL
        with open('../BD/script_DEC.sql', 'r', encoding='utf-8') as file:
            sql_script = file.read()
        
        # Ejecutar el script
        cur.execute(sql_script)
        
        # Insertar usuarios de prueba
        cur.execute("""
            INSERT INTO usuarios (username, password, tipo, nombre, apellido, genero)
            VALUES (%s, %s, %s, %s, %s, %s)
        """, ('admin', 'admin123', 'admin', 'Administrador', 'Sistema', 'M'))
        
        cur.execute("""
            INSERT INTO usuarios (username, password, tipo, nombre, apellido, genero)
            VALUES (%s, %s, %s, %s, %s, %s)
        """, ('paciente', 'paciente123', 'paciente', 'Usuario', 'Prueba', 'F'))
        
        conn.commit()
        print("Base de datos PostgreSQL inicializada correctamente!")
        print("Usuarios de prueba creados:")
        print("- Admin: usuario='admin', contraseña='admin123'")
        print("- Paciente: usuario='paciente', contraseña='paciente123'")
        
    except Exception as e:
        print(f"Error al inicializar la base de datos: {e}")
    finally:
        if cur:
            cur.close()
        if conn:
            conn.close()

if __name__ == '__main__':
    init_database()
