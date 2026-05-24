-- ============================================================
--  SISTEMA DE GESTIÓN ESCOLAR - UAQ
--  Script 02: DML - Datos de Prueba Realistas
--  Base de Datos: Oracle Database 19c+
--  Descripción: Poblado de todas las tablas con datos
--               ficticios pero coherentes para pruebas.
-- ============================================================
-- ORDEN DE INSERCIÓN (respeta dependencias FK):
--   1. FACULTAD
--   2. MATERIA
--   3. PERIODO
--   4. CARRERA
--   5. PROFESOR
--   6. PLAN_ESTUDIOS
--   7. PLAN_MATERIA
--   8. GRUPO
--   9. ALUMNO
--  10. INSCRIPCION
-- ============================================================

SET DEFINE OFF;

-- ============================================================
-- 1. FACULTADES
-- ============================================================
INSERT INTO FACULTAD (nombre, clave_facultad, telefono, ubicacion) VALUES
    ('Facultad de Ingeniería',                      'FING',  '442-192-1200', 'Campus Aeropuerto, Querétaro');
INSERT INTO FACULTAD (nombre, clave_facultad, telefono, ubicacion) VALUES
    ('Facultad de Ciencias Naturales',              'FCN',   '442-192-1210', 'Campus Juriquilla, Querétaro');
INSERT INTO FACULTAD (nombre, clave_facultad, telefono, ubicacion) VALUES
    ('Facultad de Contaduría y Administración',     'FCA',   '442-192-1220', 'Campus Centro Universitario');
INSERT INTO FACULTAD (nombre, clave_facultad, telefono, ubicacion) VALUES
    ('Facultad de Informática',                     'FINF',  '442-192-1230', 'Campus Aeropuerto, Querétaro');
INSERT INTO FACULTAD (nombre, clave_facultad, telefono, ubicacion) VALUES
    ('Facultad de Química',                         'FQ',    '442-192-1240', 'Campus Centro Universitario');

COMMIT;

-- ============================================================
-- 2. MATERIAS (catálogo global, independiente de carrera)
-- ============================================================

-- Matemáticas y Ciencias Básicas
INSERT INTO MATERIA (clave_materia, nombre, creditos, horas_teoria, horas_practica, tipo) VALUES
    ('MAT101', 'Cálculo Diferencial',               8, 4, 2, 'OBLIGATORIA');
INSERT INTO MATERIA (clave_materia, nombre, creditos, horas_teoria, horas_practica, tipo) VALUES
    ('MAT102', 'Cálculo Integral',                  8, 4, 2, 'OBLIGATORIA');
INSERT INTO MATERIA (clave_materia, nombre, creditos, horas_teoria, horas_practica, tipo) VALUES
    ('MAT201', 'Álgebra Lineal',                    6, 3, 2, 'OBLIGATORIA');
INSERT INTO MATERIA (clave_materia, nombre, creditos, horas_teoria, horas_practica, tipo) VALUES
    ('MAT202', 'Ecuaciones Diferenciales',          6, 3, 2, 'OBLIGATORIA');
INSERT INTO MATERIA (clave_materia, nombre, creditos, horas_teoria, horas_practica, tipo) VALUES
    ('MAT301', 'Probabilidad y Estadística',        6, 3, 2, 'OBLIGATORIA');

-- Informática / Computación
INSERT INTO MATERIA (clave_materia, nombre, creditos, horas_teoria, horas_practica, tipo) VALUES
    ('INF101', 'Fundamentos de Programación',       8, 3, 4, 'OBLIGATORIA');
INSERT INTO MATERIA (clave_materia, nombre, creditos, horas_teoria, horas_practica, tipo) VALUES
    ('INF102', 'Programación Orientada a Objetos',  8, 3, 4, 'OBLIGATORIA');
INSERT INTO MATERIA (clave_materia, nombre, creditos, horas_teoria, horas_practica, tipo) VALUES
    ('INF201', 'Bases de Datos I',                  8, 3, 4, 'OBLIGATORIA');
INSERT INTO MATERIA (clave_materia, nombre, creditos, horas_teoria, horas_practica, tipo) VALUES
    ('INF202', 'Bases de Datos II',                 6, 2, 4, 'OBLIGATORIA');
INSERT INTO MATERIA (clave_materia, nombre, creditos, horas_teoria, horas_practica, tipo) VALUES
    ('INF301', 'Estructuras de Datos',              8, 3, 4, 'OBLIGATORIA');
INSERT INTO MATERIA (clave_materia, nombre, creditos, horas_teoria, horas_practica, tipo) VALUES
    ('INF302', 'Redes de Computadoras',             6, 3, 2, 'OBLIGATORIA');
INSERT INTO MATERIA (clave_materia, nombre, creditos, horas_teoria, horas_practica, tipo) VALUES
    ('INF401', 'Ingeniería de Software',            8, 4, 2, 'OBLIGATORIA');
INSERT INTO MATERIA (clave_materia, nombre, creditos, horas_teoria, horas_practica, tipo) VALUES
    ('INF402', 'Sistemas Operativos',               6, 3, 2, 'OBLIGATORIA');
INSERT INTO MATERIA (clave_materia, nombre, creditos, horas_teoria, horas_practica, tipo) VALUES
    ('INF501', 'Inteligencia Artificial',           6, 3, 2, 'OPTATIVA');
INSERT INTO MATERIA (clave_materia, nombre, creditos, horas_teoria, horas_practica, tipo) VALUES
    ('INF502', 'Desarrollo Web',                    6, 2, 4, 'OPTATIVA');

-- Administración
INSERT INTO MATERIA (clave_materia, nombre, creditos, horas_teoria, horas_practica, tipo) VALUES
    ('ADM101', 'Introducción a la Administración',  6, 4, 0, 'OBLIGATORIA');
INSERT INTO MATERIA (clave_materia, nombre, creditos, horas_teoria, horas_practica, tipo) VALUES
    ('ADM201', 'Contabilidad General',              8, 4, 2, 'OBLIGATORIA');
INSERT INTO MATERIA (clave_materia, nombre, creditos, horas_teoria, horas_practica, tipo) VALUES
    ('ADM301', 'Finanzas Corporativas',             6, 4, 0, 'OBLIGATORIA');

-- Humanidades (compartida)
INSERT INTO MATERIA (clave_materia, nombre, creditos, horas_teoria, horas_practica, tipo) VALUES
    ('HUM101', 'Ética Profesional',                 4, 3, 0, 'OBLIGATORIA');
INSERT INTO MATERIA (clave_materia, nombre, creditos, horas_teoria, horas_practica, tipo) VALUES
    ('HUM102', 'Expresión Oral y Escrita',          4, 3, 0, 'OBLIGATORIA');

COMMIT;

-- ============================================================
-- 3. PERIODOS ACADÉMICOS
-- ============================================================
INSERT INTO PERIODO (clave_periodo, descripcion, fecha_inicio, fecha_fin, activo) VALUES
    ('2023-A', '2023-A Enero - Junio 2023',     DATE '2023-01-16', DATE '2023-06-30', 'N');
INSERT INTO PERIODO (clave_periodo, descripcion, fecha_inicio, fecha_fin, activo) VALUES
    ('2023-B', '2023-B Agosto - Diciembre 2023', DATE '2023-08-07', DATE '2023-12-15', 'N');
INSERT INTO PERIODO (clave_periodo, descripcion, fecha_inicio, fecha_fin, activo) VALUES
    ('2024-A', '2024-A Enero - Junio 2024',     DATE '2024-01-15', DATE '2024-06-28', 'N');
INSERT INTO PERIODO (clave_periodo, descripcion, fecha_inicio, fecha_fin, activo) VALUES
    ('2024-B', '2024-B Agosto - Diciembre 2024', DATE '2024-08-05', DATE '2024-12-13', 'S');

COMMIT;

-- ============================================================
-- 4. CARRERAS
-- ============================================================
INSERT INTO CARRERA (id_facultad, nombre, clave_carrera, modalidad, duracion_semestres) VALUES
    (4, 'Ingeniería en Sistemas Computacionales',   'ISC',  'PRESENCIAL', 9);
INSERT INTO CARRERA (id_facultad, nombre, clave_carrera, modalidad, duracion_semestres) VALUES
    (4, 'Ingeniería en Tecnologías de Información', 'ITI',  'PRESENCIAL', 9);
INSERT INTO CARRERA (id_facultad, nombre, clave_carrera, modalidad, duracion_semestres) VALUES
    (1, 'Ingeniería Industrial',                    'IIND', 'PRESENCIAL', 9);
INSERT INTO CARRERA (id_facultad, nombre, clave_carrera, modalidad, duracion_semestres) VALUES
    (3, 'Licenciatura en Administración',           'LAD',  'PRESENCIAL', 8);
INSERT INTO CARRERA (id_facultad, nombre, clave_carrera, modalidad, duracion_semestres) VALUES
    (3, 'Licenciatura en Contaduría',               'LCONT','PRESENCIAL', 8);

COMMIT;

-- ============================================================
-- 5. PROFESORES
-- ============================================================
INSERT INTO PROFESOR (id_facultad, numero_empleado, nombre, apellido_paterno, apellido_materno, correo_institucional, telefono, tipo_contrato, activo) VALUES
    (4, 'EMP-001', 'Carlos',    'Ramírez',    'Ortega',   'c.ramirez@uaq.mx',     '442-100-0001', 'TIEMPO COMPLETO', 'S');
INSERT INTO PROFESOR (id_facultad, numero_empleado, nombre, apellido_paterno, apellido_materno, correo_institucional, telefono, tipo_contrato, activo) VALUES
    (4, 'EMP-002', 'Laura',     'González',   'Méndez',   'l.gonzalez@uaq.mx',    '442-100-0002', 'TIEMPO COMPLETO', 'S');
INSERT INTO PROFESOR (id_facultad, numero_empleado, nombre, apellido_paterno, apellido_materno, correo_institucional, telefono, tipo_contrato, activo) VALUES
    (4, 'EMP-003', 'Roberto',   'Hernández',  'Vega',     'r.hernandez@uaq.mx',   '442-100-0003', 'MEDIO TIEMPO',    'S');
INSERT INTO PROFESOR (id_facultad, numero_empleado, nombre, apellido_paterno, apellido_materno, correo_institucional, telefono, tipo_contrato, activo) VALUES
    (4, 'EMP-004', 'Ana María', 'Torres',     'Castillo', 'a.torres@uaq.mx',      '442-100-0004', 'ASIGNATURA',      'S');
INSERT INTO PROFESOR (id_facultad, numero_empleado, nombre, apellido_paterno, apellido_materno, correo_institucional, telefono, tipo_contrato, activo) VALUES
    (1, 'EMP-005', 'Jorge',     'Morales',    'Ríos',     'j.morales@uaq.mx',     '442-100-0005', 'TIEMPO COMPLETO', 'S');
INSERT INTO PROFESOR (id_facultad, numero_empleado, nombre, apellido_paterno, apellido_materno, correo_institucional, telefono, tipo_contrato, activo) VALUES
    (3, 'EMP-006', 'Patricia',  'Sánchez',    'Luna',     'p.sanchez@uaq.mx',     '442-100-0006', 'TIEMPO COMPLETO', 'S');
INSERT INTO PROFESOR (id_facultad, numero_empleado, nombre, apellido_paterno, apellido_materno, correo_institucional, telefono, tipo_contrato, activo) VALUES
    (4, 'EMP-007', 'Miguel',    'Flores',     'Reyes',    'm.flores@uaq.mx',      '442-100-0007', 'ASIGNATURA',      'S');
INSERT INTO PROFESOR (id_facultad, numero_empleado, nombre, apellido_paterno, apellido_materno, correo_institucional, telefono, tipo_contrato, activo) VALUES
    (4, 'EMP-008', 'Sofía',     'Jiménez',    'Cruz',     's.jimenez@uaq.mx',     '442-100-0008', 'TIEMPO COMPLETO', 'S');

COMMIT;

-- ============================================================
-- 6. PLANES DE ESTUDIO
-- ============================================================
INSERT INTO PLAN_ESTUDIOS (id_carrera, anio_vigencia, descripcion, activo) VALUES
    (1, 2020, 'Plan ISC 2020 - Rediseño curricular con énfasis en nube y datos', 'S');
INSERT INTO PLAN_ESTUDIOS (id_carrera, anio_vigencia, descripcion, activo) VALUES
    (2, 2020, 'Plan ITI 2020 - Orientado a infraestructura y ciberseguridad',    'S');
INSERT INTO PLAN_ESTUDIOS (id_carrera, anio_vigencia, descripcion, activo) VALUES
    (3, 2019, 'Plan IIND 2019 - Ingeniería Industrial con manufactura avanzada', 'S');
INSERT INTO PLAN_ESTUDIOS (id_carrera, anio_vigencia, descripcion, activo) VALUES
    (4, 2021, 'Plan LAD 2021 - Administración con enfoque digital',              'S');
INSERT INTO PLAN_ESTUDIOS (id_carrera, anio_vigencia, descripcion, activo) VALUES
    (5, 2021, 'Plan LCONT 2021 - Contaduría actualizada NIF 2021',              'S');

COMMIT;

-- ============================================================
-- 7. PLAN_MATERIA (qué materias van en cada plan y semestre)
-- Plan 1 = ISC 2020
-- ============================================================

-- Semestre 1 - ISC
INSERT INTO PLAN_MATERIA VALUES (1,  1, 1, 'S');  -- Cálculo Diferencial
INSERT INTO PLAN_MATERIA VALUES (1,  6, 1, 'S');  -- Fundamentos de Programación
INSERT INTO PLAN_MATERIA VALUES (1, 19, 1, 'S');  -- Ética Profesional
INSERT INTO PLAN_MATERIA VALUES (1, 20, 1, 'S');  -- Expresión Oral y Escrita
-- Semestre 2 - ISC
INSERT INTO PLAN_MATERIA VALUES (1,  2, 2, 'S');  -- Cálculo Integral
INSERT INTO PLAN_MATERIA VALUES (1,  7, 2, 'S');  -- POO
INSERT INTO PLAN_MATERIA VALUES (1,  3, 2, 'S');  -- Álgebra Lineal
-- Semestre 3 - ISC
INSERT INTO PLAN_MATERIA VALUES (1,  4, 3, 'S');  -- Ecuaciones Diferenciales
INSERT INTO PLAN_MATERIA VALUES (1,  8, 3, 'S');  -- Bases de Datos I
INSERT INTO PLAN_MATERIA VALUES (1, 10, 3, 'S');  -- Estructuras de Datos
-- Semestre 4 - ISC
INSERT INTO PLAN_MATERIA VALUES (1,  5, 4, 'S');  -- Probabilidad y Estadística
INSERT INTO PLAN_MATERIA VALUES (1,  9, 4, 'S');  -- Bases de Datos II
INSERT INTO PLAN_MATERIA VALUES (1, 11, 4, 'S');  -- Redes de Computadoras
-- Semestre 5 - ISC
INSERT INTO PLAN_MATERIA VALUES (1, 12, 5, 'S');  -- Ingeniería de Software
INSERT INTO PLAN_MATERIA VALUES (1, 13, 5, 'S');  -- Sistemas Operativos
INSERT INTO PLAN_MATERIA VALUES (1, 14, 5, 'N');  -- IA (optativa)
INSERT INTO PLAN_MATERIA VALUES (1, 15, 5, 'N');  -- Desarrollo Web (optativa)

-- Plan 2 = ITI 2020 (comparte varias materias con ISC)
INSERT INTO PLAN_MATERIA VALUES (2,  1, 1, 'S');
INSERT INTO PLAN_MATERIA VALUES (2,  6, 1, 'S');
INSERT INTO PLAN_MATERIA VALUES (2, 19, 1, 'S');
INSERT INTO PLAN_MATERIA VALUES (2,  2, 2, 'S');
INSERT INTO PLAN_MATERIA VALUES (2,  7, 2, 'S');
INSERT INTO PLAN_MATERIA VALUES (2,  8, 3, 'S');
INSERT INTO PLAN_MATERIA VALUES (2, 11, 3, 'S');
INSERT INTO PLAN_MATERIA VALUES (2, 12, 4, 'S');

-- Plan 4 = LAD 2021
INSERT INTO PLAN_MATERIA VALUES (4, 16, 1, 'S');  -- Intro Administración
INSERT INTO PLAN_MATERIA VALUES (4, 19, 1, 'S');  -- Ética
INSERT INTO PLAN_MATERIA VALUES (4, 20, 1, 'S');  -- Expresión Oral
INSERT INTO PLAN_MATERIA VALUES (4, 17, 2, 'S');  -- Contabilidad General
INSERT INTO PLAN_MATERIA VALUES (4,  5, 2, 'S');  -- Prob y Estadística
INSERT INTO PLAN_MATERIA VALUES (4, 18, 3, 'S');  -- Finanzas Corporativas

COMMIT;

-- ============================================================
-- 8. GRUPOS (oferta académica 2024-B y 2024-A)
-- ============================================================
-- Grupos 2024-B (id_periodo = 4)

-- Cálculo Diferencial - MAT101 (id_materia=1)
INSERT INTO GRUPO (id_materia, id_periodo, id_profesor, clave_grupo, cupo_maximo, aula, horario) VALUES
    (1, 4, 1, 'G01', 35, 'A-201', 'LMV 07:00-09:00');
INSERT INTO GRUPO (id_materia, id_periodo, id_profesor, clave_grupo, cupo_maximo, aula, horario) VALUES
    (1, 4, 5, 'G02', 35, 'A-202', 'MA  09:00-12:00');

-- Fundamentos de Programación - INF101 (id_materia=6)
INSERT INTO GRUPO (id_materia, id_periodo, id_profesor, clave_grupo, cupo_maximo, aula, horario) VALUES
    (6, 4, 2, 'G01', 30, 'LAB-1', 'LMV 09:00-11:00');
INSERT INTO GRUPO (id_materia, id_periodo, id_profesor, clave_grupo, cupo_maximo, aula, horario) VALUES
    (6, 4, 7, 'G02', 30, 'LAB-2', 'MA  14:00-17:00');

-- POO - INF102 (id_materia=7)
INSERT INTO GRUPO (id_materia, id_periodo, id_profesor, clave_grupo, cupo_maximo, aula, horario) VALUES
    (7, 4, 2, 'G01', 30, 'LAB-1', 'LMV 11:00-13:00');

-- Bases de Datos I - INF201 (id_materia=8)
INSERT INTO GRUPO (id_materia, id_periodo, id_profesor, clave_grupo, cupo_maximo, aula, horario) VALUES
    (8, 4, 1, 'G01', 28, 'LAB-3', 'MA  07:00-10:00');
INSERT INTO GRUPO (id_materia, id_periodo, id_profesor, clave_grupo, cupo_maximo, aula, horario) VALUES
    (8, 4, 3, 'G02', 28, 'LAB-2', 'LMV 15:00-17:00');

-- Estructuras de Datos - INF301 (id_materia=10)
INSERT INTO GRUPO (id_materia, id_periodo, id_profesor, clave_grupo, cupo_maximo, aula, horario) VALUES
    (10, 4, 8, 'G01', 30, 'LAB-3', 'LMV 13:00-15:00');

-- Ética Profesional - HUM101 (id_materia=19)
INSERT INTO GRUPO (id_materia, id_periodo, id_profesor, clave_grupo, cupo_maximo, aula, horario) VALUES
    (19, 4, 4, 'G01', 40, 'B-101', 'MA  11:00-13:00');

-- Introducción a la Administración - ADM101 (id_materia=16)
INSERT INTO GRUPO (id_materia, id_periodo, id_profesor, clave_grupo, cupo_maximo, aula, horario) VALUES
    (16, 4, 6, 'G01', 40, 'C-101', 'LMV 07:00-09:00');

-- Grupos históricos 2024-A (id_periodo = 3) para tener historial
INSERT INTO GRUPO (id_materia, id_periodo, id_profesor, clave_grupo, cupo_maximo, aula, horario) VALUES
    (1, 3, 1, 'G01', 35, 'A-201', 'LMV 07:00-09:00');
INSERT INTO GRUPO (id_materia, id_periodo, id_profesor, clave_grupo, cupo_maximo, aula, horario) VALUES
    (6, 3, 2, 'G01', 30, 'LAB-1', 'LMV 09:00-11:00');
INSERT INTO GRUPO (id_materia, id_periodo, id_profesor, clave_grupo, cupo_maximo, aula, horario) VALUES
    (8, 3, 1, 'G01', 28, 'LAB-3', 'MA  07:00-10:00');

COMMIT;

-- ============================================================
-- 9. ALUMNOS
-- ============================================================

-- Alumnos de ISC (id_plan = 1)
INSERT INTO ALUMNO (id_plan, numero_expediente, matricula, nombre, apellido_paterno, apellido_materno, fecha_nacimiento, correo_institucional, correo_personal, telefono, semestre_actual, estatus, fecha_ingreso) VALUES
    (1, 'EXP-2022-0001', '222001', 'Diego',      'López',     'Martínez', DATE '2003-04-15', 'diego.lopez@alumnos.uaq.mx',      'diego.lm@gmail.com',     '442-201-0001', 5, 'ACTIVO',  DATE '2022-08-08');
INSERT INTO ALUMNO (id_plan, numero_expediente, matricula, nombre, apellido_paterno, apellido_materno, fecha_nacimiento, correo_institucional, correo_personal, telefono, semestre_actual, estatus, fecha_ingreso) VALUES
    (1, 'EXP-2022-0002', '222002', 'Valeria',    'Moreno',    'Guzmán',   DATE '2003-07-22', 'valeria.moreno@alumnos.uaq.mx',   'vale.mg@hotmail.com',    '442-201-0002', 5, 'ACTIVO',  DATE '2022-08-08');
INSERT INTO ALUMNO (id_plan, numero_expediente, matricula, nombre, apellido_paterno, apellido_materno, fecha_nacimiento, correo_institucional, correo_personal, telefono, semestre_actual, estatus, fecha_ingreso) VALUES
    (1, 'EXP-2022-0003', '222003', 'Sebastián',  'Herrera',   'Olvera',   DATE '2002-11-30', 'sebastian.herrera@alumnos.uaq.mx','seba.ho@gmail.com',       '442-201-0003', 5, 'ACTIVO',  DATE '2022-08-08');
INSERT INTO ALUMNO (id_plan, numero_expediente, matricula, nombre, apellido_paterno, apellido_materno, fecha_nacimiento, correo_institucional, correo_personal, telefono, semestre_actual, estatus, fecha_ingreso) VALUES
    (1, 'EXP-2023-0001', '232001', 'Camila',     'Vargas',    'Peña',     DATE '2004-02-14', 'camila.vargas@alumnos.uaq.mx',    'cami.vp@gmail.com',      '442-201-0004', 3, 'ACTIVO',  DATE '2023-08-07');
INSERT INTO ALUMNO (id_plan, numero_expediente, matricula, nombre, apellido_paterno, apellido_materno, fecha_nacimiento, correo_institucional, correo_personal, telefono, semestre_actual, estatus, fecha_ingreso) VALUES
    (1, 'EXP-2023-0002', '232002', 'Rodrigo',    'Castañeda', 'Bravo',    DATE '2004-05-08', 'rodrigo.castaneda@alumnos.uaq.mx','rodri.cb@outlook.com',   '442-201-0005', 3, 'ACTIVO',  DATE '2023-08-07');
INSERT INTO ALUMNO (id_plan, numero_expediente, matricula, nombre, apellido_paterno, apellido_materno, fecha_nacimiento, correo_institucional, correo_personal, telefono, semestre_actual, estatus, fecha_ingreso) VALUES
    (1, 'EXP-2024-0001', '242001', 'Isabella',   'Núñez',     'Santos',   DATE '2005-09-19', 'isabella.nunez@alumnos.uaq.mx',   'isa.ns@gmail.com',       '442-201-0006', 1, 'ACTIVO',  DATE '2024-08-05');
INSERT INTO ALUMNO (id_plan, numero_expediente, matricula, nombre, apellido_paterno, apellido_materno, fecha_nacimiento, correo_institucional, correo_personal, telefono, semestre_actual, estatus, fecha_ingreso) VALUES
    (1, 'EXP-2024-0002', '242002', 'Emiliano',   'Rojas',     'Delgado',  DATE '2005-01-25', 'emiliano.rojas@alumnos.uaq.mx',   'emi.rd@gmail.com',       '442-201-0007', 1, 'ACTIVO',  DATE '2024-08-05');
INSERT INTO ALUMNO (id_plan, numero_expediente, matricula, nombre, apellido_paterno, apellido_materno, fecha_nacimiento, correo_institucional, correo_personal, telefono, semestre_actual, estatus, fecha_ingreso) VALUES
    (1, 'EXP-2021-0001', '212001', 'Fernanda',   'Acosta',    'Romero',   DATE '2002-06-03', 'fernanda.acosta@alumnos.uaq.mx',  'fer.ar@gmail.com',       '442-201-0008', 7, 'ACTIVO',  DATE '2021-08-09');
-- Alumno con baja
INSERT INTO ALUMNO (id_plan, numero_expediente, matricula, nombre, apellido_paterno, apellido_materno, fecha_nacimiento, correo_institucional, correo_personal, telefono, semestre_actual, estatus, fecha_ingreso) VALUES
    (1, 'EXP-2022-0004', '222004', 'Arturo',     'Mendoza',   'Gil',      DATE '2003-03-11', 'arturo.mendoza@alumnos.uaq.mx',   'artu.mg@gmail.com',      '442-201-0009', 3, 'BAJA',    DATE '2022-08-08');

-- Alumnos de ITI (id_plan = 2)
INSERT INTO ALUMNO (id_plan, numero_expediente, matricula, nombre, apellido_paterno, apellido_materno, fecha_nacimiento, correo_institucional, correo_personal, telefono, semestre_actual, estatus, fecha_ingreso) VALUES
    (2, 'EXP-2023-0003', '232003', 'Lucía',      'Espinoza',  'Fuentes',  DATE '2004-03-27', 'lucia.espinoza@alumnos.uaq.mx',   'lu.ef@gmail.com',        '442-201-0010', 3, 'ACTIVO',  DATE '2023-08-07');
INSERT INTO ALUMNO (id_plan, numero_expediente, matricula, nombre, apellido_paterno, apellido_materno, fecha_nacimiento, correo_institucional, correo_personal, telefono, semestre_actual, estatus, fecha_ingreso) VALUES
    (2, 'EXP-2024-0003', '242003', 'Maximiliano','Guerrero',  'Lara',     DATE '2005-12-01', 'maximiliano.guerrero@alumnos.uaq.mx','max.gl@gmail.com',     '442-201-0011', 1, 'ACTIVO',  DATE '2024-08-05');

-- Alumnos de LAD (id_plan = 4)
INSERT INTO ALUMNO (id_plan, numero_expediente, matricula, nombre, apellido_paterno, apellido_materno, fecha_nacimiento, correo_institucional, correo_personal, telefono, semestre_actual, estatus, fecha_ingreso) VALUES
    (4, 'EXP-2023-0004', '232004', 'Andrea',     'Salinas',   'Mora',     DATE '2004-08-16', 'andrea.salinas@alumnos.uaq.mx',   'andy.sm@gmail.com',      '442-201-0012', 3, 'ACTIVO',  DATE '2023-08-07');
INSERT INTO ALUMNO (id_plan, numero_expediente, matricula, nombre, apellido_paterno, apellido_materno, fecha_nacimiento, correo_institucional, correo_personal, telefono, semestre_actual, estatus, fecha_ingreso) VALUES
    (4, 'EXP-2024-0004', '242004', 'Pablo',      'Ibarra',    'Campos',   DATE '2005-10-05', 'pablo.ibarra@alumnos.uaq.mx',     'pab.ic@gmail.com',       '442-201-0013', 1, 'ACTIVO',  DATE '2024-08-05');

COMMIT;

-- ============================================================
-- 10. INSCRIPCIONES Y CALIFICACIONES
-- ============================================================
-- Grupos 2024-B activos (ids 1-10 aprox)
-- Grupos 2024-A históricos (ids 11-13)
--
-- Referencia de grupos creados:
--   id 1  = MAT101 G01  periodo 2024-B  (prof 1)
--   id 2  = MAT101 G02  periodo 2024-B  (prof 5)
--   id 3  = INF101 G01  periodo 2024-B  (prof 2)
--   id 4  = INF101 G02  periodo 2024-B  (prof 7)
--   id 5  = INF102 G01  periodo 2024-B  (prof 2)
--   id 6  = INF201 G01  periodo 2024-B  (prof 1)
--   id 7  = INF201 G02  periodo 2024-B  (prof 3)
--   id 8  = INF301 G01  periodo 2024-B  (prof 8)
--   id 9  = HUM101 G01  periodo 2024-B  (prof 4)
--   id 10 = ADM101 G01  periodo 2024-B  (prof 6)
--   id 11 = MAT101 G01  periodo 2024-A  (prof 1)
--   id 12 = INF101 G01  periodo 2024-A  (prof 2)
--   id 13 = INF201 G01  periodo 2024-A  (prof 1)
-- ============================================================

-- ---- Semestre actual 2024-B (calificaciones en curso / finalizadas) ----

-- Diego López (id=1) — semestre 5
INSERT INTO INSCRIPCION (id_alumno, id_grupo, fecha_inscripcion, calificacion_parcial1, calificacion_parcial2, calificacion_parcial3, calificacion_ordinario) VALUES
    (1, 6, DATE '2024-08-05', 8.5, 9.0, 8.0, NULL);   -- BD1 G01
INSERT INTO INSCRIPCION (id_alumno, id_grupo, fecha_inscripcion, calificacion_parcial1, calificacion_parcial2, calificacion_parcial3) VALUES
    (1, 8, DATE '2024-08-05', 7.0, 8.5, 9.0);          -- Estructuras G01
INSERT INTO INSCRIPCION (id_alumno, id_grupo, fecha_inscripcion, calificacion_parcial1, calificacion_parcial2, calificacion_parcial3) VALUES
    (1, 9, DATE '2024-08-05', 9.5, 10.0, 9.0);         -- Ética G01

-- Valeria Moreno (id=2) — semestre 5
INSERT INTO INSCRIPCION (id_alumno, id_grupo, fecha_inscripcion, calificacion_parcial1, calificacion_parcial2, calificacion_parcial3) VALUES
    (2, 6, DATE '2024-08-05', 10.0, 9.5, 10.0);        -- BD1 G01
INSERT INTO INSCRIPCION (id_alumno, id_grupo, fecha_inscripcion, calificacion_parcial1, calificacion_parcial2, calificacion_parcial3) VALUES
    (2, 8, DATE '2024-08-05', 9.0, 8.0, 9.5);          -- Estructuras G01
INSERT INTO INSCRIPCION (id_alumno, id_grupo, fecha_inscripcion, calificacion_parcial1, calificacion_parcial2, calificacion_parcial3) VALUES
    (2, 9, DATE '2024-08-05', 8.0, 9.0, 8.5);          -- Ética G01

-- Sebastián Herrera (id=3) — semestre 5 (alumno con bajo rendimiento)
INSERT INTO INSCRIPCION (id_alumno, id_grupo, fecha_inscripcion, calificacion_parcial1, calificacion_parcial2, calificacion_parcial3, calificacion_ordinario) VALUES
    (3, 6, DATE '2024-08-05', 4.5, 5.0, 4.0, 6.5);    -- BD1 G01 (reprobó → ordinario
INSERT INTO INSCRIPCION (id_alumno, id_grupo, fecha_inscripcion, calificacion_parcial1, calificacion_parcial2, calificacion_parcial3) VALUES
    (3, 8, DATE '2024-08-05', 6.0, 5.5, 5.0);          -- Estructuras (en riesgo)
INSERT INTO INSCRIPCION (id_alumno, id_grupo, fecha_inscripcion, calificacion_parcial1, calificacion_parcial2, calificacion_parcial3, calificacion_extraordinario) VALUES
    (3, 9, DATE '2024-08-05', 3.0, 4.0, 5.0, 7.0);    -- Ética (reprobó → extraordinario

-- Camila Vargas (id=4) — semestre 3
INSERT INTO INSCRIPCION (id_alumno, id_grupo, fecha_inscripcion, calificacion_parcial1, calificacion_parcial2, calificacion_parcial3) VALUES
    (4, 5, DATE '2024-08-05', 9.0, 9.5, 9.0);          -- POO G01
INSERT INTO INSCRIPCION (id_alumno, id_grupo, fecha_inscripcion, calificacion_parcial1, calificacion_parcial2, calificacion_parcial3) VALUES
    (4, 1, DATE '2024-08-05', 7.5, 8.0, 8.5);          -- Cálculo Dif G01
INSERT INTO INSCRIPCION (id_alumno, id_grupo, fecha_inscripcion, calificacion_parcial1, calificacion_parcial2, calificacion_parcial3) VALUES
    (4, 9, DATE '2024-08-05', 10.0, 9.0, 10.0);        -- Ética G01

-- Rodrigo Castañeda (id=5) — semestre 3
INSERT INTO INSCRIPCION (id_alumno, id_grupo, fecha_inscripcion, calificacion_parcial1, calificacion_parcial2, calificacion_parcial3) VALUES
    (5, 5, DATE '2024-08-05', 6.5, 7.0, 6.0);          -- POO G01
INSERT INTO INSCRIPCION (id_alumno, id_grupo, fecha_inscripcion, calificacion_parcial1, calificacion_parcial2, calificacion_parcial3) VALUES
    (5, 2, DATE '2024-08-05', 5.0, 6.0, 5.5);          -- Cálculo Dif G02 (en riesgo)
INSERT INTO INSCRIPCION (id_alumno, id_grupo, fecha_inscripcion, calificacion_parcial1, calificacion_parcial2, calificacion_parcial3) VALUES
    (5, 9, DATE '2024-08-05', 8.0, 7.5, 8.0);          -- Ética G01

-- Isabella Núñez (id=6) — semestre 1 (recién ingresada)
INSERT INTO INSCRIPCION (id_alumno, id_grupo, fecha_inscripcion, calificacion_parcial1, calificacion_parcial2) VALUES
    (6, 1, DATE '2024-08-05', 8.0, 7.5);               -- Cálculo Dif G01 (parcial 3 pendiente)
INSERT INTO INSCRIPCION (id_alumno, id_grupo, fecha_inscripcion, calificacion_parcial1, calificacion_parcial2) VALUES
    (6, 3, DATE '2024-08-05', 9.0, 8.5);               -- Fund. Prog G01

-- Emiliano Rojas (id=7) — semestre 1
INSERT INTO INSCRIPCION (id_alumno, id_grupo, fecha_inscripcion, calificacion_parcial1, calificacion_parcial2) VALUES
    (7, 1, DATE '2024-08-05', 6.0, 5.0);               -- Cálculo Dif G01 (bajo)
INSERT INTO INSCRIPCION (id_alumno, id_grupo, fecha_inscripcion, calificacion_parcial1, calificacion_parcial2) VALUES
    (7, 4, DATE '2024-08-05', 7.0, 7.5);               -- Fund. Prog G02

-- Lucía Espinoza ITI (id=10) — semestre 3
INSERT INTO INSCRIPCION (id_alumno, id_grupo, fecha_inscripcion, calificacion_parcial1, calificacion_parcial2, calificacion_parcial3) VALUES
    (10, 7, DATE '2024-08-05', 8.5, 8.0, 9.0);         -- BD1 G02
INSERT INTO INSCRIPCION (id_alumno, id_grupo, fecha_inscripcion, calificacion_parcial1, calificacion_parcial2, calificacion_parcial3) VALUES
    (10, 9, DATE '2024-08-05', 9.0, 9.5, 9.0);         -- Ética G01

-- Maximiliano Guerrero ITI (id=11) — semestre 1
INSERT INTO INSCRIPCION (id_alumno, id_grupo, fecha_inscripcion, calificacion_parcial1, calificacion_parcial2) VALUES
    (11, 4, DATE '2024-08-05', 8.0, 8.5);              -- Fund. Prog G02

-- Andrea Salinas LAD (id=12) — semestre 3
INSERT INTO INSCRIPCION (id_alumno, id_grupo, fecha_inscripcion, calificacion_parcial1, calificacion_parcial2, calificacion_parcial3) VALUES
    (12, 10, DATE '2024-08-05', 9.5, 9.0, 9.5);        -- ADM101 G01
INSERT INTO INSCRIPCION (id_alumno, id_grupo, fecha_inscripcion, calificacion_parcial1, calificacion_parcial2, calificacion_parcial3) VALUES
    (12, 9, DATE '2024-08-05', 10.0, 9.0, 9.5);        -- Ética G01

-- Pablo Ibarra LAD (id=13) — semestre 1
INSERT INTO INSCRIPCION (id_alumno, id_grupo, fecha_inscripcion, calificacion_parcial1) VALUES
    (13, 10, DATE '2024-08-05', 7.0);                  -- ADM101 (solo 1er parcial)

-- ---- Historial 2024-A (grupos 11, 12, 13) calificaciones cerradas ----

-- Diego 2024-A: Cálculo Dif (grupo 11)
INSERT INTO INSCRIPCION (id_alumno, id_grupo, fecha_inscripcion, calificacion_parcial1, calificacion_parcial2, calificacion_parcial3) VALUES
    (1, 11, DATE '2024-01-15', 9.0, 8.5, 9.0);
-- Diego 2024-A: Fund Prog (grupo 12)
INSERT INTO INSCRIPCION (id_alumno, id_grupo, fecha_inscripcion, calificacion_parcial1, calificacion_parcial2, calificacion_parcial3) VALUES
    (1, 12, DATE '2024-01-15', 8.0, 9.0, 9.5);

-- Valeria 2024-A: Cálculo Dif (grupo 11)
INSERT INTO INSCRIPCION (id_alumno, id_grupo, fecha_inscripcion, calificacion_parcial1, calificacion_parcial2, calificacion_parcial3) VALUES
    (2, 11, DATE '2024-01-15', 10.0, 9.5, 10.0);
-- Valeria 2024-A: Fund Prog (grupo 12)
INSERT INTO INSCRIPCION (id_alumno, id_grupo, fecha_inscripcion, calificacion_parcial1, calificacion_parcial2, calificacion_parcial3) VALUES
    (2, 12, DATE '2024-01-15', 9.5, 10.0, 9.5);

-- Sebastián 2024-A: Cálculo Dif reprobado → BD1 extraordinario
INSERT INTO INSCRIPCION (id_alumno, id_grupo, fecha_inscripcion, calificacion_parcial1, calificacion_parcial2, calificacion_parcial3, calificacion_extraordinario) VALUES
    (3, 11, DATE '2024-01-15', 4.0, 3.5, 5.0, 6.0);   -- Reprobó, pasó con extraordinario
INSERT INTO INSCRIPCION (id_alumno, id_grupo, fecha_inscripcion, calificacion_parcial1, calificacion_parcial2, calificacion_parcial3) VALUES
    (3, 13, DATE '2024-01-15', 5.0, 4.5, 4.0);         -- BD1 histórico, reprobó

COMMIT;

-- ============================================================
-- VERIFICACIÓN DE DATOS INSERTADOS
-- ============================================================
SELECT 'FACULTAD'      AS tabla, COUNT(*) AS registros FROM FACULTAD
UNION ALL SELECT 'MATERIA',       COUNT(*) FROM MATERIA
UNION ALL SELECT 'PERIODO',       COUNT(*) FROM PERIODO
UNION ALL SELECT 'CARRERA',       COUNT(*) FROM CARRERA
UNION ALL SELECT 'PROFESOR',      COUNT(*) FROM PROFESOR
UNION ALL SELECT 'PLAN_ESTUDIOS', COUNT(*) FROM PLAN_ESTUDIOS
UNION ALL SELECT 'PLAN_MATERIA',  COUNT(*) FROM PLAN_MATERIA
UNION ALL SELECT 'GRUPO',         COUNT(*) FROM GRUPO
UNION ALL SELECT 'ALUMNO',        COUNT(*) FROM ALUMNO
UNION ALL SELECT 'INSCRIPCION',   COUNT(*) FROM INSCRIPCION
ORDER BY 1;

-- ============================================================
-- FIN DEL SCRIPT DML
-- ============================================================
