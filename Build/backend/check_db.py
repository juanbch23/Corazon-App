import psycopg2

# Conexión directa a PostgreSQL
try:
    conn = psycopg2.connect(
        host="localhost",
        database="heart_disease_db",
        user="postgres",
        password="123456"
    )
    cur = conn.cursor()

    print('=== USUARIOS ===')
    cur.execute('SELECT id, username, nombre, apellido, tipo FROM usuarios')
    usuarios = cur.fetchall()
    for u in usuarios:
        print(u)

    print('\n=== DIAGNOSTICO_DATOS ===')
    cur.execute('SELECT id, usuario_id FROM diagnostico_datos')
    datos = cur.fetchall()
    for d in datos:
        print(d)

    print('\n=== DIAGNOSTICO_RESULTADOS ===')
    cur.execute('SELECT id, datos_id, fecha_diagnostico FROM diagnostico_resultados')
    resultados = cur.fetchall()
    for r in resultados:
        print(r)

    print('\n=== CONSULTA COMPLETA ===')
    cur.execute("""
        SELECT 
            u.id, 
            u.username, 
            u.nombre, 
            u.apellido,
            COUNT(r.id) as total_diagnosticos,
            MAX(r.fecha_diagnostico) as ultimo_diagnostico
        FROM usuarios u
        LEFT JOIN diagnostico_datos d ON d.usuario_id = u.id
        LEFT JOIN diagnostico_resultados r ON r.datos_id = d.id
        WHERE u.tipo = 'paciente'
        GROUP BY u.id, u.username, u.nombre, u.apellido ORDER BY u.nombre
    """)
    pacientes = cur.fetchall()
    print("Resultado de la consulta de pacientes:")
    for p in pacientes:
        print(p)

    cur.close()
    conn.close()
    
except Exception as e:
    print(f"Error: {e}")
