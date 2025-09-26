-- Script para actualizar fechas NULL en la base de datos
-- Actualizar fechas NULL en diagnostico_resultados basado en la fecha de ingreso de los datos
UPDATE diagnostico_resultados 
SET fecha_diagnostico = d.fecha_ingreso
FROM diagnostico_datos d 
WHERE diagnostico_resultados.datos_id = d.id 
AND diagnostico_resultados.fecha_diagnostico IS NULL;

-- Actualizar fechas NULL restantes con fecha actual
UPDATE diagnostico_resultados 
SET fecha_diagnostico = CURRENT_TIMESTAMP
WHERE fecha_diagnostico IS NULL;

-- Actualizar fechas NULL en diagnostico_datos
UPDATE diagnostico_datos 
SET fecha_ingreso = CURRENT_TIMESTAMP
WHERE fecha_ingreso IS NULL;

-- Verificar actualizaciones
SELECT 'diagnostico_resultados' as tabla, COUNT(*) as total_registros, 
       COUNT(fecha_diagnostico) as con_fecha, 
       COUNT(*) - COUNT(fecha_diagnostico) as sin_fecha
FROM diagnostico_resultados
UNION ALL
SELECT 'diagnostico_datos' as tabla, COUNT(*) as total_registros, 
       COUNT(fecha_ingreso) as con_fecha, 
       COUNT(*) - COUNT(fecha_ingreso) as sin_fecha
FROM diagnostico_datos;
