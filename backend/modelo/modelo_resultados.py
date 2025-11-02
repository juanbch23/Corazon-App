import psycopg2
from modelo.modelo import obtener_conexion_bd

class ModeloResultados:
    @staticmethod
    def obtener_ultimo_diagnostico(usuario_id):
        conn = obtener_conexion_bd()
        cur = conn.cursor()
        cur.execute("""
            SELECT r.riesgo, r.confianza, r.fecha_diagnostico 
            FROM diagnostico_resultados r
            JOIN diagnostico_datos d ON r.datos_id = d.id
            WHERE d.usuario_id = %s 
            ORDER BY r.fecha_diagnostico DESC 
            LIMIT 1
        """, (usuario_id,))
        row = cur.fetchone()
        cur.close()
        conn.close()
        return row

    @staticmethod
    def guardar_diagnostico(usuario_id, edad, genero, ps, pd, colesterol, glucosa, fuma, alcohol, actividad, peso, estatura, imc, riesgo, confianza):
        conn = obtener_conexion_bd()
        cur = conn.cursor()
        try:
            # Primero insertar en diagnostico_datos
            cur.execute("""
                INSERT INTO diagnostico_datos (
                    usuario_id, edad, genero, ps, pd, colesterol, glucosa, fuma, alcohol, actividad, peso, estatura, imc
                ) VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)
                RETURNING id
            """, (usuario_id, edad, genero, ps, pd, colesterol, glucosa, fuma, alcohol, actividad, peso, estatura, imc))
            
            datos_id = cur.fetchone()[0]
            
            # Luego insertar en diagnostico_resultados
            cur.execute("""
                INSERT INTO diagnostico_resultados (datos_id, riesgo, confianza, fecha_diagnostico)
                VALUES (%s, %s, %s, NOW())
            """, (datos_id, riesgo, confianza))
            
            conn.commit()
            return True
        except Exception as e:
            conn.rollback()
            print(f"Error al guardar diagnóstico: {e}")
            return False
        finally:
            cur.close()
            conn.close()
