# Referencia de Consultas — Control Escolar UAQ

## Consultas Rápidas de Uso Común

### Buscar alumno por matrícula o nombre
```sql
-- Por matrícula exacta
SELECT * FROM VW_EXPEDIENTE_ALUMNO WHERE matricula = '222001';

-- Por apellido (búsqueda parcial)
SELECT * FROM VW_EXPEDIENTE_ALUMNO
WHERE apellido_paterno LIKE 'LÓPEZ%'
ORDER BY apellido_paterno, nombre;
```

### Ver calificaciones del periodo activo de un alumno
```sql
SELECT materia, periodo, p1, p2, p3, cal_final, resultado
FROM   VW_CALIFICACION_EFECTIVA
WHERE  matricula    = '222001'
ORDER  BY periodo, materia;
```

### Alumnos inscritos en un grupo
```sql
SELECT
    a.matricula,
    a.nombre || ' ' || a.apellido_paterno AS alumno,
    i.calificacion_parcial1,
    i.calificacion_parcial2,
    i.calificacion_parcial3,
    i.calificacion_final,
    i.estatus_inscripcion
FROM  INSCRIPCION i
JOIN  ALUMNO  a ON a.id_alumno = i.id_alumno
WHERE i.id_grupo = :id_grupo
ORDER BY a.apellido_paterno;
```

### Grupos ofertados en el periodo activo
```sql
SELECT
    m.clave_materia,
    m.nombre           AS materia,
    g.clave_grupo,
    pr.nombre || ' ' || pr.apellido_paterno AS profesor,
    g.aula,
    g.horario,
    g.cupo_maximo,
    COUNT(i.id_inscripcion) AS inscritos
FROM       GRUPO     g
INNER JOIN PERIODO   p  ON p.id_periodo  = g.id_periodo  AND p.activo = 'S'
INNER JOIN MATERIA   m  ON m.id_materia  = g.id_materia
INNER JOIN PROFESOR  pr ON pr.id_profesor = g.id_profesor
LEFT  JOIN INSCRIPCION i ON i.id_grupo   = g.id_grupo
GROUP BY m.clave_materia, m.nombre, g.clave_grupo,
         pr.nombre, pr.apellido_paterno, g.aula,
         g.horario, g.cupo_maximo
ORDER BY m.clave_materia, g.clave_grupo;
```

### Materias reprobadas por un alumno (para reinscripción)
```sql
SELECT
    m.clave_materia,
    m.nombre        AS materia,
    m.creditos,
    p.clave_periodo AS periodo_cursado,
    COALESCE(i.calificacion_extraordinario,
             i.calificacion_ordinario,
             i.calificacion_final) AS calificacion_obtenida
FROM       INSCRIPCION i
INNER JOIN GRUPO       g ON g.id_grupo   = i.id_grupo
INNER JOIN MATERIA     m ON m.id_materia = g.id_materia
INNER JOIN PERIODO     p ON p.id_periodo = g.id_periodo
INNER JOIN ALUMNO      a ON a.id_alumno  = i.id_alumno
WHERE a.matricula = :matricula
  AND COALESCE(i.calificacion_extraordinario,
               i.calificacion_ordinario,
               i.calificacion_final) < 6
ORDER BY p.fecha_inicio DESC;
```

---

## Consultas Administrativas

### Conteo de alumnos por carrera y semestre
```sql
SELECT
    c.nombre    AS carrera,
    a.semestre_actual AS semestre,
    COUNT(*)    AS total_alumnos
FROM  ALUMNO        a
JOIN  PLAN_ESTUDIOS pe ON pe.id_plan   = a.id_plan
JOIN  CARRERA       c  ON c.id_carrera = pe.id_carrera
WHERE a.estatus = 'ACTIVO'
GROUP BY c.nombre, a.semestre_actual
ORDER BY c.nombre, a.semestre_actual;
```

### Verificar cupo disponible en grupos
```sql
SELECT
    g.id_grupo,
    m.nombre            AS materia,
    g.clave_grupo,
    g.cupo_maximo,
    COUNT(i.id_alumno)  AS inscritos,
    g.cupo_maximo - COUNT(i.id_alumno) AS lugares_disponibles
FROM       GRUPO       g
INNER JOIN MATERIA     m  ON m.id_materia  = g.id_materia
INNER JOIN PERIODO     p  ON p.id_periodo  = g.id_periodo AND p.activo = 'S'
LEFT  JOIN INSCRIPCION i  ON i.id_grupo    = g.id_grupo
GROUP BY g.id_grupo, m.nombre, g.clave_grupo, g.cupo_maximo
HAVING g.cupo_maximo - COUNT(i.id_alumno) > 0
ORDER BY m.nombre, g.clave_grupo;
```

---

## Comandos Útiles de Mantenimiento

```sql
-- Ver todos los objetos del esquema
SELECT object_type, object_name, status
FROM   user_objects
ORDER  BY object_type, object_name;

-- Verificar constraints activos
SELECT constraint_name, constraint_type, table_name, status
FROM   user_constraints
WHERE  status = 'ENABLED'
ORDER  BY table_name, constraint_type;

-- Ver índices creados
SELECT index_name, table_name, uniqueness
FROM   user_indexes
ORDER  BY table_name;

-- Recompilar triggers inválidos
BEGIN
    FOR t IN (SELECT trigger_name FROM user_triggers WHERE status = 'DISABLED') LOOP
        EXECUTE IMMEDIATE 'ALTER TRIGGER ' || t.trigger_name || ' ENABLE';
    END LOOP;
END;
/
```
