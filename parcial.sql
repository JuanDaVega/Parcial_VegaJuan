DROP TABLE IF EXISTS administrador, evaluador, director, alumno, coordinador CASCADE;
DROP TABLE IF EXISTS roles CASCADE;

-- Primero, la tabla de roles
CREATE TABLE roles (
    id int PRIMARY KEY,
    descripcion VARCHAR(50) UNIQUE NOT NULL
);

-- Insertamos los roles
INSERT INTO roles (id, descripcion) VALUES
(1,'administrador'),
(2,'evaluador'),
(3,'director'),
(4,'alumno'),
(5,'coordinador');

-- Tabla de Administradores
CREATE TABLE administrador (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    correo VARCHAR(100) UNIQUE NOT NULL,
    contrasena VARCHAR(100) NOT NULL,
    id_rol INT NOT NULL DEFAULT 1,
    FOREIGN KEY (id_rol) REFERENCES roles(id)
);

-- Tabla de Evaluadores
CREATE TABLE evaluador (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    correo VARCHAR(100) UNIQUE NOT NULL,
    contrasena VARCHAR(100) NOT NULL,
    id_rol INT NOT NULL DEFAULT 2,
    FOREIGN KEY (id_rol) REFERENCES roles(id)
);

-- Tabla de Docentes
CREATE TABLE director (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    correo VARCHAR(100) UNIQUE NOT NULL,
    contrasena VARCHAR(100) NOT NULL,
    id_rol INT NOT NULL DEFAULT 3,
    FOREIGN KEY (id_rol) REFERENCES roles(id)
);

-- Tabla de Alumnos
CREATE TABLE alumno (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    correo VARCHAR(100) UNIQUE NOT NULL,
    contrasena VARCHAR(100) NOT NULL,
    id_rol INT NOT NULL DEFAULT 4,
    FOREIGN KEY (id_rol) REFERENCES roles(id)
);

-- Tabla de Coordinadores
CREATE TABLE coordinador (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    correo VARCHAR(100) UNIQUE NOT NULL,
    contrasena VARCHAR(100) NOT NULL,
    id_rol INT NOT NULL DEFAULT 5,
    FOREIGN KEY (id_rol) REFERENCES roles(id)
);

CREATE TABLE anteproyecto (
    id SERIAL PRIMARY KEY,
    titulo VARCHAR(150) NOT NULL,
    descripcion TEXT NOT NULL,
    estado VARCHAR(50) DEFAULT 'Sin Gestionar',
    id_coordinador INT NOT NULL,
    id_alumno INT,
    id_director INT,
    id_evaluador INT,
    FOREIGN KEY (id_coordinador) REFERENCES coordinador(id),
    FOREIGN KEY (id_alumno) REFERENCES alumno(id),
    FOREIGN KEY (id_director) REFERENCES director(id),
    FOREIGN KEY (id_evaluador) REFERENCES evaluador(id)
);

CREATE TABLE informe_anteproyecto (
    id SERIAL PRIMARY KEY,
    id_anteproyecto INT NOT NULL,
    tipo_usuario VARCHAR(20) NOT NULL CHECK (tipo_usuario IN ('alumno', 'director', 'evaluador')),
    archivo_ruta TEXT NOT NULL,
    fecha_subida TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_anteproyecto) REFERENCES anteproyecto(id)
);



-- Ejemplo de insert
INSERT INTO administrador (nombre, correo, contrasena) VALUES ('Admin Principal', 'admin@uts.edu.co', '123');
INSERT INTO director (nombre, correo, contrasena) VALUES ('Luis Director', 'luis@uts.edu.co', '123');
INSERT INTO director (nombre, correo, contrasena) VALUES ('Javier Director', 'javier@uts.edu.co', '123');
INSERT INTO alumno (nombre, correo, contrasena) VALUES ('Carlos Alumno', 'carlos@uts.edu.co', '123');
INSERT INTO coordinador (nombre, correo, contrasena) VALUES ('Maria Coordinadora', 'maria@uts.edu.co', '123');
INSERT INTO evaluador (nombre, correo, contrasena) VALUES ('Pedro Evaluador', 'pedro@uts.edu.co', '123');


select * from evaluador;


--anteproyecto

INSERT INTO anteproyecto (titulo, descripcion, id_coordinador)
VALUES ('Sistema Solar', 'Aplicación móvil para estudiar los planetas.', 1);

INSERT INTO anteproyecto (titulo, descripcion, id_coordinador)
VALUES ('Sitema Solar', 'Aplicación móvilddd para estudiar los planetas.', 1);

UPDATE anteproyecto
SET id_alumno = 1, id_director = 1, id_evaluador = 2, estado = 'Asignado'
WHERE id = 1;


ALTER TABLE informe_anteproyecto
ADD CONSTRAINT informe_anteproyecto_estado CHECK (estado IN ('Corregir', 'Aprobado', 'Rechazado'));



