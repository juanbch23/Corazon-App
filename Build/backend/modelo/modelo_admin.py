import psycopg2
from modelo.modelo import obtener_conexion_bd

class ModeloAdmin:
    @staticmethod
    def obtener_pacientes(filtro=''):
        """Obtiene lista de pacientes con filtro opcional"""
        conn = obtener_conexion_bd()
        cur = conn.cursor()
        
        consulta = """
            SELECT 
                u.id, 
                u.username, 
                u.nombre, 
                u.apellido,
                COUNT(r.id) as total_diagnosticos,
                TO_CHAR(MAX(r.fecha_diagnostico), 'YYYY-MM-DD HH24:MI:SS') as ultimo_diagnostico
            FROM usuarios u
            LEFT JOIN diagnostico_datos d ON d.usuario_id = u.id
            LEFT JOIN diagnostico_resultados r ON r.datos_id = d.id
            WHERE u.tipo = 'paciente'
        """
        params = []
        
        if filtro:
            consulta += """
                AND (
                    LOWER(u.username) LIKE %s OR
                    LOWER(u.nombre) LIKE %s OR
                    LOWER(u.apellido) LIKE %s
                )
            """
            params = [f"%{filtro}%"] * 3
        
        consulta += " GROUP BY u.id, u.username, u.nombre, u.apellido ORDER BY u.nombre"
        
        cur.execute(consulta, params)
        pacientes = cur.fetchall()
        cur.close()
        conn.close()
        
        return pacientes
    
    @staticmethod
    def obtener_historial_diagnosticos(usuario_id):
        """Obtiene todos los diagnósticos con datos completos para un paciente"""
        conn = obtener_conexion_bd()
        cur = conn.cursor()

        try:
            cur.execute("""
                SELECT 
                    r.fecha_diagnostico, d.edad, d.genero, d.ps, d.pd,
                    d.colesterol, d.glucosa, d.fuma, d.alcohol, d.actividad,
                    d.peso, d.estatura, d.imc, r.riesgo, r.confianza
                FROM diagnostico_resultados r
                JOIN diagnostico_datos d ON r.datos_id = d.id
                WHERE d.usuario_id = %s
                ORDER BY r.fecha_diagnostico DESC
            """, (usuario_id,))
            
            columnas = [desc[0] for desc in cur.description]
            resultados = cur.fetchall()

            historial = [dict(zip(columnas, fila)) for fila in resultados]
            return historial
        finally:
            cur.close()
            conn.close()