-- ============================================================
-- CONSULTA 1: KARDEX ACADÉMICO COMPLETO DE UN ALUMNO
-- ============================================================
-- Muestra todo el historial académico de un alumno:
-- materias cursadas, calificaciones, créditos y estatus.
-- Usa: JOIN múltiple, CASE, COALESCE, ORDER BY
-- ============================================================

SELECT
    a.matricula,
    a.nombre || ' ' || a.apellido_paterno || ' ' || NVL(a.apellido_materno,'') AS alumno,
    c.nombre        AS carrera,
    pe.anio_vigencia AS plan,
    p.clave_periodo  AS periodo,
    m.clave_materia,
    m.nombre         AS materia,
    m.creditos,
    -- Calificaciones individuales
    i.calificacion_parcial1     AS p1,
    i.calificacion_parcial2     AS p2,
    i.calificacion_parcial3     AS p3,
    i.calificacion_final        AS final,
    i.calificacion_ordinario    AS ordinario,
    i.calificacion_extraordinario AS extraordinario,
    -- Calificación que cuenta definitivamente
    COALESCE(
        i.calificacion_extraordinario,
        i.calificacion_ordinario,
        i.calificacion_final
    ) AS calificacion_efectiva,
    -- Resultado legible
    CASE
        WHEN COALESCE(i.calificacion_extraordinario,
                      i.calificacion_ordinario,
                      i.calificacion_final) >= 6 THEN 'APROBADO'
        WHEN COALESCE(i.calificacion_extraordinario,
                      i.calificacion_ordinario,
                      i.calificacion_final) IS NOT NULL THEN 'REPROBADO'
        ELSE 'EN CURSO'
    END AS resultado,
    -- Créditos ganados (solo si aprobó)
    CASE
        WHEN COALESCE(i.calificacion_extraordinario,
                      i.calificacion_ordinario,
                      i.calificacion_final) >= 6
        THEN m.creditos
        ELSE 0
    END AS creditos_acreditados
FROM       INSCRIPCION   i
INNER JOIN ALUMNO        a  ON a.id_alumno  = i.id_alumno
INNER JOIN GRUPO         g  ON g.id_grupo   = i.id_grupo
INNER JOIN MATERIA       m  ON m.id_materia = g.id_materia
INNER JOIN PERIODO       p  ON p.id_periodo = g.id_periodo
INNER JOIN PLAN_ESTUDIOS pe ON pe.id_plan   = a.id_plan
INNER JOIN CARRERA       c  ON c.id_carrera = pe.id_carrera
-- Filtrar por alumno específico (cambiar matrícula según prueba)
WHERE a.matricula = '222001'
ORDER BY p.fecha_inicio, m.clave_materia;


-- ============================================================
-- CONSULTA 2: PROMEDIO GENERAL POR ALUMNO CON RANKING
-- ============================================================
-- Calcula el promedio ponderado de cada alumno (ponderado por
-- créditos) y asigna un ranking dentro de su carrera.
-- Usa: JOIN, AVG ponderado, RANK() función de ventana, HAVING
-- ============================================================

SELECT
    ranking_carrera,
    matricula,
    alumno,
    carrera,
    total_materias_cursadas,
    materias_aprobadas,
    materias_reprobadas,
    creditos_acreditados,
    ROUND(promedio_ponderado, 2)    AS promedio_ponderado,
    ROUND(promedio_simple,    2)    AS promedio_simple,
    -- Clasificación académica
    CASE
        WHEN ROUND(promedio_ponderado, 2) >= 9.0 THEN 'EXCELENTE'
        WHEN ROUND(promedio_ponderado, 2) >= 8.0 THEN 'MUY BUENO'
        WHEN ROUND(promedio_ponderado, 2) >= 7.0 THEN 'BUENO'
        WHEN ROUND(promedio_ponderado, 2) >= 6.0 THEN 'SUFICIENTE'
        ELSE                                           'INSUFICIENTE'
    END AS clasificacion
FROM (
    SELECT
        a.matricula,
        a.nombre || ' ' || a.apellido_paterno AS alumno,
        c.nombre AS carrera,
        -- Conteos
        COUNT(i.id_inscripcion) AS total_materias_cursadas,
        COUNT(CASE WHEN COALESCE(i.calificacion_extraordinario,
                                  i.calificacion_ordinario,
                                  i.calificacion_final) >= 6 THEN 1 END) AS materias_aprobadas,
        COUNT(CASE WHEN COALESCE(i.calificacion_extraordinario,
                                  i.calificacion_ordinario,
                                  i.calificacion_final) < 6
                    AND COALESCE(i.calificacion_extraordinario,
                                  i.calificacion_ordinario,
                                  i.calificacion_final) IS NOT NULL
                   THEN 1 END) AS materias_reprobadas,
        -- Créditos acreditados
        SUM(CASE WHEN COALESCE(i.calificacion_extraordinario,
                                i.calificacion_ordinario,
                                i.calificacion_final) >= 6
                 THEN m.creditos ELSE 0 END) AS creditos_acreditados,
        -- Promedio ponderado por créditos (solo materias con calificación)
        SUM(
            COALESCE(i.calificacion_extraordinario,
                     i.calificacion_ordinario,
                     i.calificacion_final) * m.creditos
        ) / NULLIF(
            SUM(CASE WHEN COALESCE(i.calificacion_extraordinario,
                                    i.calificacion_ordinario,
                                    i.calificacion_final) IS NOT NULL
                     THEN m.creditos ELSE 0 END), 0
        ) AS promedio_ponderado,
        -- Promedio simple
        AVG(COALESCE(i.calificacion_extraordinario,
                     i.calificacion_ordinario,
                     i.calificacion_final)) AS promedio_simple,
        -- Ranking dentro de la carrera
        RANK() OVER (
            PARTITION BY c.id_carrera
            ORDER BY
                SUM(COALESCE(i.calificacion_extraordinario,
                             i.calificacion_ordinario,
                             i.calificacion_final) * m.creditos)
                / NULLIF(SUM(CASE WHEN COALESCE(i.calificacion_extraordinario,
                                                 i.calificacion_ordinario,
                                                 i.calificacion_final) IS NOT NULL
                                  THEN m.creditos ELSE 0 END), 0) DESC
        ) AS ranking_carrera
    FROM       INSCRIPCION   i
    INNER JOIN ALUMNO        a  ON a.id_alumno  = i.id_alumno
    INNER JOIN GRUPO         g  ON g.id_grupo   = i.id_grupo
    INNER JOIN MATERIA       m  ON m.id_materia = g.id_materia
    INNER JOIN PLAN_ESTUDIOS pe ON pe.id_plan   = a.id_plan
    INNER JOIN CARRERA       c  ON c.id_carrera = pe.id_carrera
    -- Solo alumnos activos con al menos una calificación registrada
    WHERE a.estatus = 'ACTIVO'
      AND COALESCE(i.calificacion_extraordinario,
                   i.calificacion_ordinario,
                   i.calificacion_final) IS NOT NULL
    GROUP BY
        a.id_alumno, a.matricula,
        a.nombre, a.apellido_paterno,
        c.id_carrera, c.nombre
)
ORDER BY carrera, ranking_carrera;



-- ============================================================
-- CONSULTA 3: CARGA ACADÉMICA POR PROFESOR EN EL PERIODO ACTIVO
-- ============================================================
-- Muestra cuántos grupos, alumnos y horas imparte cada profesor
-- en el periodo activo. Detecta sobrecarga o subutilización.
-- Usa: JOIN, GROUP BY, funciones de agregación, subquery
-- ============================================================

SELECT
    pr.numero_empleado,
    pr.nombre || ' ' || pr.apellido_paterno || ' ' || NVL(pr.apellido_materno,'') AS profesor,
    f.nombre            AS facultad,
    pr.tipo_contrato,
    per.clave_periodo,
    COUNT(DISTINCT g.id_grupo)   AS total_grupos,
    COUNT(DISTINCT g.id_materia) AS materias_distintas,
    SUM(m.horas_teoria + m.horas_practica) * COUNT(DISTINCT g.id_grupo)
        / COUNT(DISTINCT g.id_materia) AS horas_semana_aprox,
    COUNT(DISTINCT i.id_alumno) AS total_alumnos_atendidos,
    ROUND(AVG(alumnos_por_grupo.cnt), 1) AS promedio_alumnos_por_grupo,
    -- Indicador de carga respecto al tipo de contrato
    CASE pr.tipo_contrato
        WHEN 'TIEMPO COMPLETO' THEN
            CASE WHEN COUNT(DISTINCT g.id_grupo) >= 4 THEN 'CARGA COMPLETA'
                 WHEN COUNT(DISTINCT g.id_grupo) >= 2 THEN 'CARGA MEDIA'
                 ELSE 'SUBCARGADO' END
        WHEN 'MEDIO TIEMPO' THEN
            CASE WHEN COUNT(DISTINCT g.id_grupo) >= 2 THEN 'CARGA COMPLETA'
                 ELSE 'CARGA MEDIA' END
        ELSE -- ASIGNATURA
            CASE WHEN COUNT(DISTINCT g.id_grupo) >= 3 THEN 'SOBRECARGADO'
                 ELSE 'NORMAL' END
    END AS estatus_carga
FROM       PROFESOR  pr
INNER JOIN FACULTAD  f   ON f.id_facultad  = pr.id_facultad
INNER JOIN GRUPO     g   ON g.id_profesor  = pr.id_profesor
INNER JOIN PERIODO   per ON per.id_periodo = g.id_periodo
INNER JOIN MATERIA   m   ON m.id_materia   = g.id_materia
LEFT  JOIN INSCRIPCION i ON i.id_grupo     = g.id_grupo
-- Subquery para promedio de alumnos por grupo
INNER JOIN (
    SELECT id_grupo, COUNT(id_alumno) AS cnt
    FROM   INSCRIPCION
    GROUP  BY id_grupo
) alumnos_por_grupo ON alumnos_por_grupo.id_grupo = g.id_grupo
-- Solo periodo activo
WHERE per.activo = 'S'
  AND pr.activo  = 'S'
GROUP BY
    pr.id_profesor, pr.numero_empleado, pr.nombre,
    pr.apellido_paterno, pr.apellido_materno,
    pr.tipo_contrato, f.nombre, per.clave_periodo
ORDER BY total_alumnos_atendidos DESC;
