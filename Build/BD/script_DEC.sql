--SCRIPT PROYECTO DE DETECCION DE ENFERMEDADES CARDIOVASCULARES DEC
--Usuarios
CREATE TABLE usuarios (
    id SERIAL PRIMARY KEY,
    username VARCHAR(50) NOT NULL,
    password VARCHAR(100) NOT NULL,
    tipo VARCHAR(20) NOT NULL,
    nombre VARCHAR(100),
    apellido VARCHAR(100),
    fecha_nacimiento DATE,
    genero VARCHAR(20),
    telefono VARCHAR(20),
    direccion TEXT,
    dni VARCHAR(20),
    fecha_registro TIMESTAMP
);

--Diagnostico_datos
CREATE TABLE diagnostico_datos (
    id SERIAL PRIMARY KEY,
    usuario_id INT NOT NULL,
    edad INT NOT NULL,
    genero VARCHAR(10) NOT NULL,
    ps INT NOT NULL,
    pd INT NOT NULL,
    colesterol FLOAT NOT NULL,
    glucosa FLOAT NOT NULL,
    fuma VARCHAR(1) NOT NULL,
    alcohol VARCHAR(1) NOT NULL,
    actividad VARCHAR(20) NOT NULL,
    peso FLOAT NOT NULL,
    estatura FLOAT NOT NULL,
    imc FLOAT NOT NULL,
    fecha_ingreso TIMESTAMP,
    FOREIGN KEY (usuario_id) REFERENCES usuarios(id) ON DELETE CASCADE
);
--Diagnostico/resultados
CREATE TABLE diagnostico_resultados (
    id SERIAL PRIMARY KEY,
    datos_id INT NOT NULL,
    riesgo INT NOT NULL,
    confianza FLOAT8 NOT NULL,
    notas TEXT,
    fecha_diagnostico TIMESTAMP,
    FOREIGN KEY (datos_id) REFERENCES diagnostico_datos(id) ON DELETE CASCADE
);
