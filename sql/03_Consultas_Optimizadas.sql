-- ============================================================
--  SISTEMA DE GESTIÓN ESCOLAR - UAQ
--  Script 03: Consultas SQL Optimizadas
--  Base de Datos: Oracle Database 19c+
--  Descripción: Consultas complejas con JOINs, agregaciones,
--               subconsultas y funciones de ventana (OLAP).
-- ============================================================

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
-- CONSULTA 3: ÍNDICE DE REPROBACIÓN POR MATERIA Y PERIODO
-- ============================================================
-- Identifica las materias con mayor tasa de reprobación.
-- Útil para decisiones académicas y detección temprana.
-- Usa: JOIN, GROUP BY, HAVING, subconsulta, RATIO_TO_REPORT
-- ============================================================

SELECT
    m.clave_materia,
    m.nombre                    AS materia,
    m.creditos,
    p.clave_periodo             AS periodo,
    pr.nombre || ' ' || pr.apellido_paterno AS profesor,
    total_inscritos,
    total_aprobados,
    total_reprobados,
    alumnos_en_curso,
    -- Tasa de reprobación (sobre los que ya tienen calificación)
    ROUND(
        total_reprobados * 100.0 / NULLIF(total_aprobados + total_reprobados, 0),
        1
    ) AS tasa_reprobacion_pct,
    -- Promedio del grupo
    ROUND(promedio_grupo, 2)    AS promedio_grupo,
    -- Calificación mínima registrada
    ROUND(cal_minima, 2)        AS cal_minima,
    -- Clasificación de riesgo
    CASE
        WHEN ROUND(total_reprobados * 100.0 /
                   NULLIF(total_aprobados + total_reprobados, 0), 1) >= 50
            THEN '🔴 CRÍTICO'
        WHEN ROUND(total_reprobados * 100.0 /
                   NULLIF(total_aprobados + total_reprobados, 0), 1) >= 30
            THEN '🟡 ALTO'
        WHEN ROUND(total_reprobados * 100.0 /
                   NULLIF(total_aprobados + total_reprobados, 0), 1) >= 15
            THEN '🟢 MODERADO'
        ELSE '✅ NORMAL'
    END AS nivel_riesgo
FROM (
    SELECT
        g.id_materia,
        g.id_periodo,
        g.id_profesor,
        COUNT(i.id_inscripcion) AS total_inscritos,
        COUNT(CASE WHEN COALESCE(i.calificacion_extraordinario,
                                  i.calificacion_ordinario,
                                  i.calificacion_final) >= 6 THEN 1 END) AS total_aprobados,
        COUNT(CASE WHEN COALESCE(i.calificacion_extraordinario,
                                  i.calificacion_ordinario,
                                  i.calificacion_final) < 6
                    AND COALESCE(i.calificacion_extraordinario,
                                  i.calificacion_ordinario,
                                  i.calificacion_final) IS NOT NULL
                   THEN 1 END) AS total_reprobados,
        COUNT(CASE WHEN COALESCE(i.calificacion_extraordinario,
                                  i.calificacion_ordinario,
                                  i.calificacion_final) IS NULL THEN 1 END) AS alumnos_en_curso,
        AVG(COALESCE(i.calificacion_extraordinario,
                     i.calificacion_ordinario,
                     i.calificacion_final)) AS promedio_grupo,
        MIN(COALESCE(i.calificacion_extraordinario,
                     i.calificacion_ordinario,
                     i.calificacion_final)) AS cal_minima
    FROM  INSCRIPCION i
    INNER JOIN GRUPO g ON g.id_grupo = i.id_grupo
    GROUP BY g.id_materia, g.id_periodo, g.id_profesor
) stats
INNER JOIN MATERIA  m  ON m.id_materia  = stats.id_materia
INNER JOIN PERIODO  p  ON p.id_periodo  = stats.id_periodo
INNER JOIN PROFESOR pr ON pr.id_profesor = stats.id_profesor
ORDER BY tasa_reprobacion_pct DESC NULLS LAST, promedio_grupo ASC;


-- ============================================================
-- CONSULTA 4: CARGA ACADÉMICA POR PROFESOR EN EL PERIODO ACTIVO
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


-- ============================================================
-- CONSULTA 5: ALUMNOS EN RIESGO ACADÉMICO
-- ============================================================
-- Identifica alumnos con promedio menor a 7.0 en el periodo
-- activo, mostrando su tendencia respecto al periodo anterior.
-- Usa: WITH (CTE), LAG(), funciones de ventana, JOIN múltiple
-- ============================================================

WITH promedios_por_periodo AS (
    -- Calcula el promedio de cada alumno por periodo
    SELECT
        a.id_alumno,
        a.matricula,
        a.nombre || ' ' || a.apellido_paterno AS alumno,
        a.semestre_actual,
        a.estatus,
        c.nombre        AS carrera,
        p.id_periodo,
        p.clave_periodo,
        p.activo        AS periodo_activo,
        COUNT(i.id_inscripcion) AS materias_periodo,
        ROUND(AVG(COALESCE(i.calificacion_extraordinario,
                            i.calificacion_ordinario,
                            i.calificacion_final)), 2) AS promedio_periodo,
        COUNT(CASE WHEN COALESCE(i.calificacion_extraordinario,
                                  i.calificacion_ordinario,
                                  i.calificacion_final) < 6
                    AND COALESCE(i.calificacion_extraordinario,
                                  i.calificacion_ordinario,
                                  i.calificacion_final) IS NOT NULL
                   THEN 1 END) AS reprobadas_periodo
    FROM       ALUMNO        a
    INNER JOIN PLAN_ESTUDIOS pe ON pe.id_plan   = a.id_plan
    INNER JOIN CARRERA       c  ON c.id_carrera = pe.id_carrera
    INNER JOIN INSCRIPCION   i  ON i.id_alumno  = a.id_alumno
    INNER JOIN GRUPO         g  ON g.id_grupo   = i.id_grupo
    INNER JOIN PERIODO       p  ON p.id_periodo = g.id_periodo
    WHERE a.estatus = 'ACTIVO'
    GROUP BY
        a.id_alumno, a.matricula, a.nombre, a.apellido_paterno,
        a.semestre_actual, a.estatus, c.nombre,
        p.id_periodo, p.clave_periodo, p.activo
),
con_tendencia AS (
    -- Agrega la comparativa con el periodo anterior usando LAG
    SELECT
        id_alumno,
        matricula,
        alumno,
        semestre_actual,
        carrera,
        id_periodo,
        clave_periodo,
        periodo_activo,
        materias_periodo,
        promedio_periodo,
        reprobadas_periodo,
        -- Promedio del periodo anterior (función de ventana LAG)
        LAG(promedio_periodo) OVER (
            PARTITION BY id_alumno
            ORDER BY id_periodo
        ) AS promedio_periodo_anterior,
        -- Diferencia respecto al periodo anterior
        promedio_periodo - LAG(promedio_periodo) OVER (
            PARTITION BY id_alumno
            ORDER BY id_periodo
        ) AS variacion_promedio
    FROM promedios_por_periodo
)
SELECT
    matricula,
    alumno,
    carrera,
    semestre_actual,
    clave_periodo       AS periodo_actual,
    materias_periodo,
    promedio_periodo    AS promedio_actual,
    promedio_periodo_anterior,
    ROUND(variacion_promedio, 2) AS variacion,
    reprobadas_periodo  AS materias_reprobadas,
    -- Tendencia
    CASE
        WHEN variacion_promedio IS NULL   THEN '— PRIMER PERIODO'
        WHEN variacion_promedio >  0.5    THEN '📈 MEJORANDO'
        WHEN variacion_promedio < -0.5    THEN '📉 EMPEORANDO'
        ELSE                                   '➡️  ESTABLE'
    END AS tendencia,
    -- Nivel de riesgo
    CASE
        WHEN promedio_periodo < 6.0                 THEN '🔴 RIESGO CRÍTICO'
        WHEN promedio_periodo < 7.0
             AND reprobadas_periodo >= 2            THEN '🟠 RIESGO ALTO'
        WHEN promedio_periodo < 7.0                 THEN '🟡 RIESGO MEDIO'
        ELSE                                             '✅ SIN RIESGO'
    END AS nivel_riesgo
FROM con_tendencia
WHERE periodo_activo = 'S'
  AND (promedio_periodo < 7.0 OR reprobadas_periodo >= 1)
ORDER BY promedio_periodo ASC, reprobadas_periodo DESC;


-- ============================================================
-- CONSULTA 6 (BONUS): AVANCE CURRICULAR POR ALUMNO
-- ============================================================
-- Calcula qué porcentaje del plan de estudios ha acreditado
-- cada alumno, cuántos créditos le faltan y cuándo puede egresar.
-- Usa: CTE, LEFT JOIN, CASE, SUM condicional
-- ============================================================

WITH creditos_plan AS (
    -- Total de créditos obligatorios por plan
    SELECT
        pm.id_plan,
        SUM(m.creditos) AS total_creditos_obligatorios,
        COUNT(*)        AS total_materias_obligatorias
    FROM  PLAN_MATERIA pm
    INNER JOIN MATERIA m ON m.id_materia = pm.id_materia
    WHERE pm.es_obligatoria = 'S'
    GROUP BY pm.id_plan
),
creditos_alumno AS (
    -- Créditos acreditados por alumno
    SELECT
        a.id_alumno,
        a.matricula,
        a.nombre || ' ' || a.apellido_paterno AS alumno,
        a.semestre_actual,
        a.id_plan,
        SUM(CASE WHEN COALESCE(i.calificacion_extraordinario,
                                i.calificacion_ordinario,
                                i.calificacion_final) >= 6
                 THEN m.creditos ELSE 0 END) AS creditos_acreditados,
        COUNT(DISTINCT CASE WHEN COALESCE(i.calificacion_extraordinario,
                                           i.calificacion_ordinario,
                                           i.calificacion_final) >= 6
                            THEN g.id_materia END) AS materias_acreditadas
    FROM       ALUMNO        a
    LEFT  JOIN INSCRIPCION   i  ON i.id_alumno  = a.id_alumno
    LEFT  JOIN GRUPO         g  ON g.id_grupo   = i.id_grupo
    LEFT  JOIN MATERIA       m  ON m.id_materia = g.id_materia
    WHERE a.estatus = 'ACTIVO'
    GROUP BY a.id_alumno, a.matricula, a.nombre,
             a.apellido_paterno, a.semestre_actual, a.id_plan
)
SELECT
    ca.matricula,
    ca.alumno,
    c.nombre                        AS carrera,
    c.duracion_semestres            AS semestres_plan,
    ca.semestre_actual,
    ca.creditos_acreditados,
    cp.total_creditos_obligatorios  AS creditos_totales,
    cp.total_creditos_obligatorios - ca.creditos_acreditados AS creditos_faltantes,
    ca.materias_acreditadas,
    cp.total_materias_obligatorias  AS materias_totales,
    -- Porcentaje de avance
    ROUND(ca.creditos_acreditados * 100.0 /
          NULLIF(cp.total_creditos_obligatorios, 0), 1) AS avance_pct,
    -- Semestres estimados para terminar (estimación simple)
    CEIL((cp.total_creditos_obligatorios - ca.creditos_acreditados)
         / NULLIF(ca.creditos_acreditados / NULLIF(ca.semestre_actual - 1, 0), 0)
    ) AS semestres_restantes_est,
    -- Barra de progreso ASCII
    RPAD('█', ROUND(ca.creditos_acreditados * 20 /
                    NULLIF(cp.total_creditos_obligatorios, 0)), '█')
    || RPAD('░', 20 - ROUND(ca.creditos_acreditados * 20 /
                             NULLIF(cp.total_creditos_obligatorios, 0)), '░')
    AS progreso_visual
FROM       creditos_alumno ca
INNER JOIN creditos_plan   cp  ON cp.id_plan   = ca.id_plan
INNER JOIN PLAN_ESTUDIOS   pe  ON pe.id_plan   = ca.id_plan
INNER JOIN CARRERA         c   ON c.id_carrera = pe.id_carrera
ORDER BY avance_pct DESC;


-- ============================================================
-- FIN DEL SCRIPT DE CONSULTAS
-- ============================================================
-- Consultas incluidas:
--   1. Kardex académico completo de un alumno
--   2. Promedio ponderado con ranking por carrera (RANK)
--   3. Índice de reprobación por materia y periodo
--   4. Carga académica por profesor en periodo activo
--   5. Alumnos en riesgo con tendencia histórica (LAG/CTE)
--   6. Avance curricular y créditos faltantes por alumno
-- ============================================================
