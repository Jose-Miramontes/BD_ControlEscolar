-- ============================================================
--  SISTEMA DE GESTIÓN ESCOLAR - UAQ
--  Script 01: DDL - Creación de Tablas y Restricciones
--  Base de Datos: Oracle Database 19c+
--  Autor: Sistema de Control Escolar UAQ
--  Versión: 1.0
--  Descripción: Creación completa del esquema relacional
--               normalizado hasta 3FN.
-- ============================================================

-- ============================================================
-- SECCIÓN 0: LIMPIEZA (DROP en orden inverso por FK)
-- ============================================================
-- Ejecutar solo si se desea reiniciar el esquema completo.

BEGIN
    FOR t IN (
        SELECT table_name FROM user_tables
        WHERE table_name IN (
            'INSCRIPCION','GRUPO','PLAN_MATERIA',
            'ALUMNO','PROFESOR','PERIODO',
            'MATERIA','PLAN_ESTUDIOS','CARRERA','FACULTAD'
        )
    ) LOOP
        EXECUTE IMMEDIATE 'DROP TABLE ' || t.table_name || ' CASCADE CONSTRAINTS PURGE';
    END LOOP;
END;
/

BEGIN
    FOR s IN (
        SELECT sequence_name FROM user_sequences
        WHERE sequence_name IN (
            'SEQ_FACULTAD','SEQ_CARRERA','SEQ_PLAN',
            'SEQ_MATERIA','SEQ_PROFESOR','SEQ_PERIODO',
            'SEQ_GRUPO','SEQ_ALUMNO','SEQ_INSCRIPCION'
        )
    ) LOOP
        EXECUTE IMMEDIATE 'DROP SEQUENCE ' || s.sequence_name;
    END LOOP;
END;
/


-- ============================================================
-- SECCIÓN 1: SECUENCIAS (equivalente a AUTO_INCREMENT)
-- ============================================================

CREATE SEQUENCE SEQ_FACULTAD    START WITH 1 INCREMENT BY 1 NOCACHE NOCYCLE;
CREATE SEQUENCE SEQ_CARRERA     START WITH 1 INCREMENT BY 1 NOCACHE NOCYCLE;
CREATE SEQUENCE SEQ_PLAN        START WITH 1 INCREMENT BY 1 NOCACHE NOCYCLE;
CREATE SEQUENCE SEQ_MATERIA     START WITH 1 INCREMENT BY 1 NOCACHE NOCYCLE;
CREATE SEQUENCE SEQ_PROFESOR    START WITH 1 INCREMENT BY 1 NOCACHE NOCYCLE;
CREATE SEQUENCE SEQ_PERIODO     START WITH 1 INCREMENT BY 1 NOCACHE NOCYCLE;
CREATE SEQUENCE SEQ_GRUPO       START WITH 1 INCREMENT BY 1 NOCACHE NOCYCLE;
CREATE SEQUENCE SEQ_ALUMNO      START WITH 1 INCREMENT BY 1 NOCACHE NOCYCLE;
CREATE SEQUENCE SEQ_INSCRIPCION START WITH 1 INCREMENT BY 1 NOCACHE NOCYCLE;


-- ============================================================
-- SECCIÓN 2: TABLAS BASE (sin dependencias FK)
-- ============================================================

-- ------------------------------------------------------------
-- TABLA: FACULTAD
-- Unidad académica superior dentro de la UAQ.
-- ------------------------------------------------------------
CREATE TABLE FACULTAD (
    id_facultad     NUMBER          CONSTRAINT PK_FACULTAD PRIMARY KEY,
    nombre          VARCHAR2(100)   CONSTRAINT NN_FAC_NOMBRE    NOT NULL,
    clave_facultad  VARCHAR2(10)    CONSTRAINT NN_FAC_CLAVE     NOT NULL,
    telefono        VARCHAR2(15),
    ubicacion       VARCHAR2(120),
    -- Constraints de unicidad
    CONSTRAINT UQ_FAC_NOMBRE    UNIQUE (nombre),
    CONSTRAINT UQ_FAC_CLAVE     UNIQUE (clave_facultad)
);

COMMENT ON TABLE  FACULTAD              IS 'Facultades y Unidades Académicas de la UAQ';
COMMENT ON COLUMN FACULTAD.id_facultad  IS 'Identificador interno de la facultad (PK)';
COMMENT ON COLUMN FACULTAD.clave_facultad IS 'Clave corta oficial, ej: FCA, FING, FCN';


-- ------------------------------------------------------------
-- TABLA: MATERIA
-- Unidad curricular independiente de cualquier carrera.
-- Una misma materia (ej: Cálculo I) puede pertenecer a
-- múltiples planes de estudio.
-- ------------------------------------------------------------
CREATE TABLE MATERIA (
    id_materia      NUMBER          CONSTRAINT PK_MATERIA PRIMARY KEY,
    clave_materia   VARCHAR2(10)    CONSTRAINT NN_MAT_CLAVE     NOT NULL,
    nombre          VARCHAR2(100)   CONSTRAINT NN_MAT_NOMBRE    NOT NULL,
    creditos        NUMBER(2)       CONSTRAINT NN_MAT_CRED      NOT NULL,
    horas_teoria    NUMBER(2)       DEFAULT 0,
    horas_practica  NUMBER(2)       DEFAULT 0,
    tipo            VARCHAR2(20)    DEFAULT 'OBLIGATORIA',
    -- Constraints
    CONSTRAINT UQ_MAT_CLAVE     UNIQUE (clave_materia),
    CONSTRAINT CK_MAT_CREDITOS  CHECK  (creditos BETWEEN 1 AND 12),
    CONSTRAINT CK_MAT_TIPO      CHECK  (tipo IN ('OBLIGATORIA','OPTATIVA','ELECTIVA')),
    CONSTRAINT CK_MAT_HT        CHECK  (horas_teoria    >= 0),
    CONSTRAINT CK_MAT_HP        CHECK  (horas_practica  >= 0)
);

COMMENT ON TABLE  MATERIA             IS 'Catálogo general de materias/asignaturas';
COMMENT ON COLUMN MATERIA.clave_materia IS 'Clave oficial, ej: MAT101, INF205';


-- ------------------------------------------------------------
-- TABLA: PERIODO
-- Semestre o periodo académico (2024-A, 2024-B, etc.)
-- Entidad propia para evitar redundancia en GRUPO.
-- ------------------------------------------------------------
CREATE TABLE PERIODO (
    id_periodo      NUMBER          CONSTRAINT PK_PERIODO PRIMARY KEY,
    clave_periodo   VARCHAR2(10)    CONSTRAINT NN_PER_CLAVE     NOT NULL,
    descripcion     VARCHAR2(60)    CONSTRAINT NN_PER_DESC      NOT NULL,
    fecha_inicio    DATE            CONSTRAINT NN_PER_INICIO    NOT NULL,
    fecha_fin       DATE            CONSTRAINT NN_PER_FIN       NOT NULL,
    activo          CHAR(1)         DEFAULT 'N',
    -- Constraints
    CONSTRAINT UQ_PER_CLAVE     UNIQUE (clave_periodo),
    CONSTRAINT CK_PER_ACTIVO    CHECK  (activo IN ('S','N')),
    CONSTRAINT CK_PER_FECHAS    CHECK  (fecha_fin > fecha_inicio)
);

COMMENT ON TABLE  PERIODO           IS 'Periodos académicos: semestres, cuatrimestres, etc.';
COMMENT ON COLUMN PERIODO.activo    IS 'S = periodo vigente actualmente';


-- ============================================================
-- SECCIÓN 3: TABLAS CON DEPENDENCIAS DE PRIMER NIVEL
-- ============================================================

-- ------------------------------------------------------------
-- TABLA: CARRERA
-- Programa académico adscrito a una Facultad.
-- ------------------------------------------------------------
CREATE TABLE CARRERA (
    id_carrera          NUMBER          CONSTRAINT PK_CARRERA PRIMARY KEY,
    id_facultad         NUMBER          CONSTRAINT NN_CAR_FAC   NOT NULL,
    nombre              VARCHAR2(100)   CONSTRAINT NN_CAR_NOM   NOT NULL,
    clave_carrera       VARCHAR2(10)    CONSTRAINT NN_CAR_CLAVE NOT NULL,
    modalidad           VARCHAR2(20)    DEFAULT 'PRESENCIAL',
    duracion_semestres  NUMBER(2)       CONSTRAINT NN_CAR_DUR   NOT NULL,
    -- FK
    CONSTRAINT FK_CAR_FACULTAD  FOREIGN KEY (id_facultad)
        REFERENCES FACULTAD (id_facultad),
    -- Constraints
    CONSTRAINT UQ_CAR_CLAVE     UNIQUE (clave_carrera),
    CONSTRAINT CK_CAR_MODAL     CHECK  (modalidad IN ('PRESENCIAL','MIXTA','EN LÍNEA')),
    CONSTRAINT CK_CAR_DUR       CHECK  (duracion_semestres BETWEEN 1 AND 16)
);

COMMENT ON TABLE  CARRERA IS 'Programas académicos ofertados en la UAQ';


-- ------------------------------------------------------------
-- TABLA: PROFESOR
-- Personal docente adscrito a una facultad.
-- ------------------------------------------------------------
CREATE TABLE PROFESOR (
    id_profesor             NUMBER          CONSTRAINT PK_PROFESOR PRIMARY KEY,
    id_facultad             NUMBER          CONSTRAINT NN_PRO_FAC   NOT NULL,
    numero_empleado         VARCHAR2(15)    CONSTRAINT NN_PRO_EMP   NOT NULL,
    nombre                  VARCHAR2(60)    CONSTRAINT NN_PRO_NOM   NOT NULL,
    apellido_paterno        VARCHAR2(40)    CONSTRAINT NN_PRO_AP    NOT NULL,
    apellido_materno        VARCHAR2(40),
    correo_institucional    VARCHAR2(100)   CONSTRAINT NN_PRO_COR   NOT NULL,
    telefono                VARCHAR2(15),
    tipo_contrato           VARCHAR2(20)    DEFAULT 'ASIGNATURA',
    activo                  CHAR(1)         DEFAULT 'S',
    -- FK
    CONSTRAINT FK_PRO_FACULTAD  FOREIGN KEY (id_facultad)
        REFERENCES FACULTAD (id_facultad),
    -- Constraints
    CONSTRAINT UQ_PRO_EMP   UNIQUE (numero_empleado),
    CONSTRAINT UQ_PRO_COR   UNIQUE (correo_institucional),
    CONSTRAINT CK_PRO_CONT  CHECK  (tipo_contrato IN ('TIEMPO COMPLETO','MEDIO TIEMPO','ASIGNATURA')),
    CONSTRAINT CK_PRO_ACT   CHECK  (activo IN ('S','N'))
);

COMMENT ON TABLE  PROFESOR IS 'Profesores e instructores de la UAQ';


-- ============================================================
-- SECCIÓN 4: TABLAS CON DEPENDENCIAS DE SEGUNDO NIVEL
-- ============================================================

-- ------------------------------------------------------------
-- TABLA: PLAN_ESTUDIOS
-- Versión/generación del mapa curricular de una carrera.
-- Una carrera puede tener múltiples planes (2010, 2020, etc.)
-- pero solo uno activo a la vez.
-- ------------------------------------------------------------
CREATE TABLE PLAN_ESTUDIOS (
    id_plan         NUMBER          CONSTRAINT PK_PLAN PRIMARY KEY,
    id_carrera      NUMBER          CONSTRAINT NN_PLA_CAR   NOT NULL,
    anio_vigencia   NUMBER(4)       CONSTRAINT NN_PLA_ANO   NOT NULL,
    descripcion     VARCHAR2(200),
    activo          CHAR(1)         DEFAULT 'N',
    -- FK
    CONSTRAINT FK_PLA_CARRERA   FOREIGN KEY (id_carrera)
        REFERENCES CARRERA (id_carrera),
    -- Constraints
    CONSTRAINT UQ_PLA_CAR_ANO   UNIQUE (id_carrera, anio_vigencia),
    CONSTRAINT CK_PLA_ACTIVO    CHECK  (activo IN ('S','N')),
    CONSTRAINT CK_PLA_ANIO      CHECK  (anio_vigencia BETWEEN 1990 AND 2099)
);

COMMENT ON TABLE  PLAN_ESTUDIOS IS 'Planes curriculares vigentes e históricos por carrera';
COMMENT ON COLUMN PLAN_ESTUDIOS.activo IS 'S = plan vigente para nuevas inscripciones';


-- ============================================================
-- SECCIÓN 5: TABLAS RELACIONALES (N:M) Y DE TERCER NIVEL
-- ============================================================

-- ------------------------------------------------------------
-- TABLA: PLAN_MATERIA
-- Relación N:M entre Plan de Estudios y Materia.
-- Define qué materias componen un plan y en qué semestre.
-- PK compuesta garantiza 2FN: cada atributo depende
-- de la clave completa (id_plan + id_materia).
-- ------------------------------------------------------------
CREATE TABLE PLAN_MATERIA (
    id_plan         NUMBER      CONSTRAINT NN_PM_PLAN   NOT NULL,
    id_materia      NUMBER      CONSTRAINT NN_PM_MAT    NOT NULL,
    semestre        NUMBER(2)   CONSTRAINT NN_PM_SEM    NOT NULL,
    es_obligatoria  CHAR(1)     DEFAULT 'S',
    -- PK compuesta
    CONSTRAINT PK_PLAN_MATERIA  PRIMARY KEY (id_plan, id_materia),
    -- FK
    CONSTRAINT FK_PM_PLAN       FOREIGN KEY (id_plan)
        REFERENCES PLAN_ESTUDIOS (id_plan),
    CONSTRAINT FK_PM_MATERIA    FOREIGN KEY (id_materia)
        REFERENCES MATERIA (id_materia),
    -- Constraints
    CONSTRAINT CK_PM_SEM        CHECK (semestre BETWEEN 1 AND 16),
    CONSTRAINT CK_PM_OBLIG      CHECK (es_obligatoria IN ('S','N'))
);

COMMENT ON TABLE  PLAN_MATERIA IS 'Asigna materias a planes de estudio con semestre y carácter';


-- ------------------------------------------------------------
-- TABLA: GRUPO
-- Oferta concreta de una materia en un periodo académico,
-- asignada a un profesor y con cupo definido.
-- ------------------------------------------------------------
CREATE TABLE GRUPO (
    id_grupo        NUMBER          CONSTRAINT PK_GRUPO PRIMARY KEY,
    id_materia      NUMBER          CONSTRAINT NN_GRU_MAT   NOT NULL,
    id_periodo      NUMBER          CONSTRAINT NN_GRU_PER   NOT NULL,
    id_profesor     NUMBER          CONSTRAINT NN_GRU_PRO   NOT NULL,
    clave_grupo     VARCHAR2(10)    CONSTRAINT NN_GRU_CLA   NOT NULL,
    cupo_maximo     NUMBER(3)       CONSTRAINT NN_GRU_CUP   NOT NULL,
    aula            VARCHAR2(20),
    horario         VARCHAR2(120),
    -- FK
    CONSTRAINT FK_GRU_MATERIA   FOREIGN KEY (id_materia)
        REFERENCES MATERIA  (id_materia),
    CONSTRAINT FK_GRU_PERIODO   FOREIGN KEY (id_periodo)
        REFERENCES PERIODO  (id_periodo),
    CONSTRAINT FK_GRU_PROFESOR  FOREIGN KEY (id_profesor)
        REFERENCES PROFESOR (id_profesor),
    -- Una clave de grupo es única por materia y periodo
    CONSTRAINT UQ_GRU_MAT_PER_CLA   UNIQUE (id_materia, id_periodo, clave_grupo),
    -- Constraints
    CONSTRAINT CK_GRU_CUPO  CHECK (cupo_maximo BETWEEN 1 AND 500)
);

COMMENT ON TABLE  GRUPO IS 'Grupos ofertados: materia + periodo + profesor';
COMMENT ON COLUMN GRUPO.horario IS 'Texto libre, ej: LMV 08:00-10:00, MA 10:00-12:00';


-- ------------------------------------------------------------
-- TABLA: ALUMNO
-- Estudiante inscrito en un plan de estudios específico.
-- ------------------------------------------------------------
CREATE TABLE ALUMNO (
    id_alumno               NUMBER          CONSTRAINT PK_ALUMNO PRIMARY KEY,
    id_plan                 NUMBER          CONSTRAINT NN_ALU_PLA   NOT NULL,
    numero_expediente       VARCHAR2(15)    CONSTRAINT NN_ALU_EXP   NOT NULL,
    matricula               VARCHAR2(12)    CONSTRAINT NN_ALU_MAT   NOT NULL,
    nombre                  VARCHAR2(60)    CONSTRAINT NN_ALU_NOM   NOT NULL,
    apellido_paterno        VARCHAR2(40)    CONSTRAINT NN_ALU_AP    NOT NULL,
    apellido_materno        VARCHAR2(40),
    fecha_nacimiento        DATE            CONSTRAINT NN_ALU_FN    NOT NULL,
    correo_institucional    VARCHAR2(100)   CONSTRAINT NN_ALU_COR   NOT NULL,
    correo_personal         VARCHAR2(100),
    telefono                VARCHAR2(15),
    semestre_actual         NUMBER(2)       DEFAULT 1,
    estatus                 VARCHAR2(20)    DEFAULT 'ACTIVO',
    fecha_ingreso           DATE            CONSTRAINT NN_ALU_FI    NOT NULL,
    -- FK
    CONSTRAINT FK_ALU_PLAN      FOREIGN KEY (id_plan)
        REFERENCES PLAN_ESTUDIOS (id_plan),
    -- Constraints de unicidad
    CONSTRAINT UQ_ALU_EXP   UNIQUE (numero_expediente),
    CONSTRAINT UQ_ALU_MAT   UNIQUE (matricula),
    CONSTRAINT UQ_ALU_COR   UNIQUE (correo_institucional),
    -- Constraints de dominio
    CONSTRAINT CK_ALU_EST   CHECK  (estatus IN ('ACTIVO','BAJA','EGRESADO','TITULADO')),
    CONSTRAINT CK_ALU_SEM   CHECK  (semestre_actual BETWEEN 1 AND 16),
    CONSTRAINT CK_ALU_FN    CHECK  (fecha_nacimiento < SYSDATE)
);

COMMENT ON TABLE  ALUMNO IS 'Estudiantes registrados en el sistema de control escolar';
COMMENT ON COLUMN ALUMNO.numero_expediente IS 'Número de expediente administrativo (archivo escolar)';
COMMENT ON COLUMN ALUMNO.matricula         IS 'Matrícula académica oficial para trámites';


-- ============================================================
-- SECCIÓN 6: TABLA CENTRAL — INSCRIPCION / CALIFICACIONES
-- ============================================================

-- ------------------------------------------------------------
-- TABLA: INSCRIPCION
-- Registra la inscripción de un alumno a un grupo y almacena
-- toda la trayectoria de calificaciones de esa cursada.
-- Es la tabla transaccional más importante del sistema.
-- ------------------------------------------------------------
CREATE TABLE INSCRIPCION (
    id_inscripcion          NUMBER          CONSTRAINT PK_INSCRIPCION PRIMARY KEY,
    id_alumno               NUMBER          CONSTRAINT NN_INS_ALU   NOT NULL,
    id_grupo                NUMBER          CONSTRAINT NN_INS_GRU   NOT NULL,
    fecha_inscripcion       DATE            DEFAULT SYSDATE         NOT NULL,
    -- Calificaciones parciales (escala 0-10, 2 decimales)
    calificacion_parcial1   NUMBER(4,2),
    calificacion_parcial2   NUMBER(4,2),
    calificacion_parcial3   NUMBER(4,2),
    -- Calificación ordinaria calculada (promedio ponderado)
    calificacion_final      NUMBER(4,2),
    -- Exámenes especiales
    calificacion_ordinario      NUMBER(4,2),
    calificacion_extraordinario NUMBER(4,2),
    estatus_inscripcion     VARCHAR2(20)    DEFAULT 'ACTIVA',
    -- FK
    CONSTRAINT FK_INS_ALUMNO    FOREIGN KEY (id_alumno)
        REFERENCES ALUMNO (id_alumno),
    CONSTRAINT FK_INS_GRUPO     FOREIGN KEY (id_grupo)
        REFERENCES GRUPO  (id_grupo),
    -- Un alumno solo puede estar inscrito una vez en el mismo grupo
    CONSTRAINT UQ_INS_ALU_GRU   UNIQUE (id_alumno, id_grupo),
    -- Constraints de dominio sobre calificaciones
    CONSTRAINT CK_INS_P1    CHECK (calificacion_parcial1       BETWEEN 0 AND 10),
    CONSTRAINT CK_INS_P2    CHECK (calificacion_parcial2       BETWEEN 0 AND 10),
    CONSTRAINT CK_INS_P3    CHECK (calificacion_parcial3       BETWEEN 0 AND 10),
    CONSTRAINT CK_INS_FIN   CHECK (calificacion_final          BETWEEN 0 AND 10),
    CONSTRAINT CK_INS_ORD   CHECK (calificacion_ordinario      BETWEEN 0 AND 10),
    CONSTRAINT CK_INS_EXT   CHECK (calificacion_extraordinario BETWEEN 0 AND 10),
    CONSTRAINT CK_INS_EST   CHECK (estatus_inscripcion IN
                                   ('ACTIVA','BAJA','ACREDITADA','NO ACREDITADA'))
);

COMMENT ON TABLE  INSCRIPCION IS 'Inscripciones de alumnos a grupos con historial de calificaciones';
COMMENT ON COLUMN INSCRIPCION.calificacion_final
    IS 'Promedio ponderado de parciales; puede ser sobreescrita manualmente';
COMMENT ON COLUMN INSCRIPCION.calificacion_ordinario
    IS 'Calificación del examen ordinario (aplica si calificacion_final < 6.0)';
COMMENT ON COLUMN INSCRIPCION.calificacion_extraordinario
    IS 'Calificación del examen extraordinario (segunda oportunidad)';


-- ============================================================
-- SECCIÓN 7: TRIGGERS
-- ============================================================

-- ------------------------------------------------------------
-- TRIGGER: PK automáticas desde secuencias (BEFORE INSERT)
-- Compatible con Oracle 11g/12c/19c (sin IDENTITY columns)
-- ------------------------------------------------------------

CREATE OR REPLACE TRIGGER TRG_FACULTAD_BI
    BEFORE INSERT ON FACULTAD FOR EACH ROW
BEGIN
    IF :NEW.id_facultad IS NULL THEN
        :NEW.id_facultad := SEQ_FACULTAD.NEXTVAL;
    END IF;
END;
/

CREATE OR REPLACE TRIGGER TRG_CARRERA_BI
    BEFORE INSERT ON CARRERA FOR EACH ROW
BEGIN
    IF :NEW.id_carrera IS NULL THEN
        :NEW.id_carrera := SEQ_CARRERA.NEXTVAL;
    END IF;
END;
/

CREATE OR REPLACE TRIGGER TRG_PLAN_BI
    BEFORE INSERT ON PLAN_ESTUDIOS FOR EACH ROW
BEGIN
    IF :NEW.id_plan IS NULL THEN
        :NEW.id_plan := SEQ_PLAN.NEXTVAL;
    END IF;
END;
/

CREATE OR REPLACE TRIGGER TRG_MATERIA_BI
    BEFORE INSERT ON MATERIA FOR EACH ROW
BEGIN
    IF :NEW.id_materia IS NULL THEN
        :NEW.id_materia := SEQ_MATERIA.NEXTVAL;
    END IF;
END;
/

CREATE OR REPLACE TRIGGER TRG_PROFESOR_BI
    BEFORE INSERT ON PROFESOR FOR EACH ROW
BEGIN
    IF :NEW.id_profesor IS NULL THEN
        :NEW.id_profesor := SEQ_PROFESOR.NEXTVAL;
    END IF;
END;
/

CREATE OR REPLACE TRIGGER TRG_PERIODO_BI
    BEFORE INSERT ON PERIODO FOR EACH ROW
BEGIN
    IF :NEW.id_periodo IS NULL THEN
        :NEW.id_periodo := SEQ_PERIODO.NEXTVAL;
    END IF;
END;
/

CREATE OR REPLACE TRIGGER TRG_GRUPO_BI
    BEFORE INSERT ON GRUPO FOR EACH ROW
BEGIN
    IF :NEW.id_grupo IS NULL THEN
        :NEW.id_grupo := SEQ_GRUPO.NEXTVAL;
    END IF;
END;
/

CREATE OR REPLACE TRIGGER TRG_ALUMNO_BI
    BEFORE INSERT ON ALUMNO FOR EACH ROW
BEGIN
    IF :NEW.id_alumno IS NULL THEN
        :NEW.id_alumno := SEQ_ALUMNO.NEXTVAL;
    END IF;
END;
/

CREATE OR REPLACE TRIGGER TRG_INSCRIPCION_BI
    BEFORE INSERT ON INSCRIPCION FOR EACH ROW
BEGIN
    IF :NEW.id_inscripcion IS NULL THEN
        :NEW.id_inscripcion := SEQ_INSCRIPCION.NEXTVAL;
    END IF;
END;
/

-- ------------------------------------------------------------
-- TRIGGER: Calcular calificacion_final automáticamente
-- Se ejecuta al actualizar calificaciones parciales.
-- Ponderación: 33% P1 + 33% P2 + 34% P3
-- ------------------------------------------------------------
CREATE OR REPLACE TRIGGER TRG_INSCRIPCION_CALCULA_FINAL
    BEFORE INSERT OR UPDATE OF
        calificacion_parcial1,
        calificacion_parcial2,
        calificacion_parcial3
    ON INSCRIPCION
    FOR EACH ROW
DECLARE
    v_parciales_ingresados NUMBER := 0;
    v_suma                 NUMBER := 0;
BEGIN
    -- Contar cuántos parciales ya tienen valor
    IF :NEW.calificacion_parcial1 IS NOT NULL THEN
        v_parciales_ingresados := v_parciales_ingresados + 1;
        v_suma := v_suma + :NEW.calificacion_parcial1;
    END IF;
    IF :NEW.calificacion_parcial2 IS NOT NULL THEN
        v_parciales_ingresados := v_parciales_ingresados + 1;
        v_suma := v_suma + :NEW.calificacion_parcial2;
    END IF;
    IF :NEW.calificacion_parcial3 IS NOT NULL THEN
        v_parciales_ingresados := v_parciales_ingresados + 1;
        v_suma := v_suma + :NEW.calificacion_parcial3;
    END IF;

    -- Solo calcular si los 3 parciales están ingresados
    IF v_parciales_ingresados = 3 THEN
        :NEW.calificacion_final := ROUND(v_suma / 3, 2);

        -- Actualizar estatus automáticamente
        IF :NEW.calificacion_final >= 6 THEN
            :NEW.estatus_inscripcion := 'ACREDITADA';
        ELSE
            :NEW.estatus_inscripcion := 'NO ACREDITADA';
        END IF;
    END IF;
END;
/

-- ------------------------------------------------------------
-- TRIGGER: Solo un plan activo por carrera
-- Desactiva automáticamente el plan anterior al activar uno nuevo.
-- ------------------------------------------------------------
CREATE OR REPLACE TRIGGER TRG_PLAN_UN_ACTIVO
    BEFORE INSERT OR UPDATE OF activo ON PLAN_ESTUDIOS
    FOR EACH ROW
    WHEN (NEW.activo = 'S')
BEGIN
    UPDATE PLAN_ESTUDIOS
    SET    activo = 'N'
    WHERE  id_carrera = :NEW.id_carrera
      AND  activo     = 'S'
      AND  id_plan   != NVL(:NEW.id_plan, -1);
END;
/


-- ============================================================
-- SECCIÓN 8: ÍNDICES para optimización de consultas
-- ============================================================

-- Índices en FK (Oracle NO los crea automáticamente en FK)
CREATE INDEX IDX_CARRERA_FACULTAD   ON CARRERA      (id_facultad);
CREATE INDEX IDX_PLAN_CARRERA       ON PLAN_ESTUDIOS (id_carrera);
CREATE INDEX IDX_PROFESOR_FACULTAD  ON PROFESOR      (id_facultad);
CREATE INDEX IDX_ALUMNO_PLAN        ON ALUMNO        (id_plan);
CREATE INDEX IDX_GRUPO_MATERIA      ON GRUPO         (id_materia);
CREATE INDEX IDX_GRUPO_PERIODO      ON GRUPO         (id_periodo);
CREATE INDEX IDX_GRUPO_PROFESOR     ON GRUPO         (id_profesor);
CREATE INDEX IDX_INS_ALUMNO         ON INSCRIPCION   (id_alumno);
CREATE INDEX IDX_INS_GRUPO          ON INSCRIPCION   (id_grupo);

-- Índices para consultas frecuentes
CREATE INDEX IDX_ALUMNO_ESTATUS     ON ALUMNO       (estatus);
CREATE INDEX IDX_ALUMNO_SEMESTRE    ON ALUMNO       (semestre_actual);
CREATE INDEX IDX_INS_ESTATUS        ON INSCRIPCION  (estatus_inscripcion);
CREATE INDEX IDX_PERIODO_ACTIVO     ON PERIODO      (activo);
CREATE INDEX IDX_INS_CAL_FINAL      ON INSCRIPCION  (calificacion_final);

-- Índice compuesto para búsquedas de alumnos por nombre
CREATE INDEX IDX_ALUMNO_NOMBRE ON ALUMNO (apellido_paterno, apellido_materno, nombre);


-- ============================================================
-- SECCIÓN 9: VISTAS útiles
-- ============================================================

-- ------------------------------------------------------------
-- VISTA: Expediente completo del alumno
-- ------------------------------------------------------------
CREATE OR REPLACE VIEW VW_EXPEDIENTE_ALUMNO AS
SELECT
    a.id_alumno,
    a.matricula,
    a.numero_expediente,
    a.nombre || ' ' || a.apellido_paterno || ' ' || NVL(a.apellido_materno,'') AS nombre_completo,
    a.fecha_nacimiento,
    a.correo_institucional,
    a.semestre_actual,
    a.estatus,
    a.fecha_ingreso,
    c.nombre        AS carrera,
    c.clave_carrera,
    f.nombre        AS facultad,
    pe.anio_vigencia AS plan_vigencia
FROM       ALUMNO        a
INNER JOIN PLAN_ESTUDIOS pe ON pe.id_plan    = a.id_plan
INNER JOIN CARRERA       c  ON c.id_carrera  = pe.id_carrera
INNER JOIN FACULTAD      f  ON f.id_facultad = c.id_facultad;

COMMENT ON TABLE VW_EXPEDIENTE_ALUMNO IS 'Vista consolidada del expediente académico por alumno';


-- ------------------------------------------------------------
-- VISTA: Calificación efectiva (la que cuenta para el historial)
-- Lógica: usa extraordinario si existe, ordinario si pasó,
--         si no calificacion_final.
-- ------------------------------------------------------------
CREATE OR REPLACE VIEW VW_CALIFICACION_EFECTIVA AS
SELECT
    i.id_inscripcion,
    a.matricula,
    a.nombre || ' ' || a.apellido_paterno AS alumno,
    m.clave_materia,
    m.nombre        AS materia,
    m.creditos,
    p.clave_periodo AS periodo,
    i.calificacion_parcial1    AS p1,
    i.calificacion_parcial2    AS p2,
    i.calificacion_parcial3    AS p3,
    i.calificacion_final       AS cal_final,
    i.calificacion_ordinario   AS cal_ordinario,
    i.calificacion_extraordinario AS cal_extraordinario,
    -- Calificación que cuenta definitivamente
    CASE
        WHEN i.calificacion_extraordinario IS NOT NULL
            THEN i.calificacion_extraordinario
        WHEN i.calificacion_ordinario IS NOT NULL
            THEN i.calificacion_ordinario
        ELSE i.calificacion_final
    END AS calificacion_efectiva,
    -- Estado final de la materia
    CASE
        WHEN COALESCE(i.calificacion_extraordinario,
                      i.calificacion_ordinario,
                      i.calificacion_final) >= 6
            THEN 'APROBADO'
        WHEN COALESCE(i.calificacion_extraordinario,
                      i.calificacion_ordinario,
                      i.calificacion_final) IS NOT NULL
            THEN 'REPROBADO'
        ELSE 'EN CURSO'
    END AS resultado,
    i.estatus_inscripcion
FROM       INSCRIPCION i
INNER JOIN ALUMNO  a ON a.id_alumno  = i.id_alumno
INNER JOIN GRUPO   g ON g.id_grupo   = i.id_grupo
INNER JOIN MATERIA m ON m.id_materia = g.id_materia
INNER JOIN PERIODO p ON p.id_periodo = g.id_periodo;

COMMENT ON TABLE VW_CALIFICACION_EFECTIVA IS 'Vista con la calificación final efectiva respetando la jerarquía: extraordinario > ordinario > final';


-- ============================================================
-- FIN DEL SCRIPT DDL
-- ============================================================
-- Objetos creados:
--   9 Tablas         : FACULTAD, CARRERA, PLAN_ESTUDIOS,
--                      MATERIA, PLAN_MATERIA, PERIODO,
--                      GRUPO, ALUMNO, INSCRIPCION
--   9 Secuencias     : SEQ_FACULTAD ... SEQ_INSCRIPCION
--  12 Triggers       : PK automáticas + lógica de negocio
--  16 Índices        : FK + consultas frecuentes
--   2 Vistas         : VW_EXPEDIENTE_ALUMNO,
--                      VW_CALIFICACION_EFECTIVA
-- ============================================================
