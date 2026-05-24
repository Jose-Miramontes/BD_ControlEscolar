# Modelo Entidad-Relación — Sistema de Control Escolar UAQ

## Diagrama de Relaciones

```
┌──────────────┐        ┌──────────────┐        ┌───────────────────┐
│   FACULTAD   │1──────N│   CARRERA    │1──────N │  PLAN_ESTUDIOS    │
│──────────────│        │──────────────│        │───────────────────│
│ PK id_fac    │        │ PK id_carrera│        │ PK id_plan        │
│ nombre       │        │ FK id_fac    │        │ FK id_carrera     │
│ clave_fac    │        │ nombre       │        │ anio_vigencia     │
│ telefono     │        │ clave_car    │        │ activo            │
│ ubicacion    │        │ modalidad    │        └────────┬──────────┘
└──────┬───────┘        │ duracion_sem │                 │
       │                └──────────────┘                 │ N
       │ 1                                               │
       │                                                 ▼
       │            ┌─────────────────────────────────────────────┐
       │            │              PLAN_MATERIA                    │
       │            │─────────────────────────────────────────────│
       │            │ PK,FK id_plan    ◄── PLAN_ESTUDIOS          │
       │            │ PK,FK id_materia ◄── MATERIA                │
       │            │ semestre                                     │
       │            │ es_obligatoria                              │
       │            └─────────────────────────────────────────────┘
       │
       │ N
       ▼
┌──────────────┐        ┌──────────────┐        ┌───────────────────┐
│   PROFESOR   │        │    GRUPO     │N──────1 │    MATERIA        │
│──────────────│        │──────────────│        │───────────────────│
│ PK id_prof   │1──────N│ PK id_grupo  │        │ PK id_materia     │
│ FK id_fac    │        │ FK id_materia│        │ clave_materia     │
│ num_empleado │        │ FK id_periodo│        │ nombre            │
│ nombre       │        │ FK id_prof   │        │ creditos          │
│ correo       │        │ clave_grupo  │        │ horas_teoria      │
│ tipo_contrato│        │ cupo_maximo  │        │ horas_practica    │
│ activo       │        │ aula/horario │        │ tipo              │
└──────────────┘        └──────┬───────┘        └───────────────────┘
                               │ 1
                               │              ┌───────────────────┐
                               │              │     PERIODO       │
                               │              │───────────────────│
                               │    N─────────│ PK id_periodo     │
                               │              │ clave_periodo     │
                               │              │ descripcion       │
                               │              │ fecha_inicio      │
                               │              │ fecha_fin         │
                               │              │ activo            │
                               │              └───────────────────┘
                               │ N
                               ▼
┌──────────────┐        ┌──────────────────────────────────────────┐
│    ALUMNO    │1──────N │              INSCRIPCION                 │
│──────────────│        │──────────────────────────────────────────│
│ PK id_alumno │        │ PK id_inscripcion                        │
│ FK id_plan   │        │ FK id_alumno  ◄── ALUMNO                 │
│ num_expedien │        │ FK id_grupo   ◄── GRUPO                  │
│ matricula    │        │ fecha_inscripcion                         │
│ nombre       │        │ calificacion_parcial1                    │
│ correo       │        │ calificacion_parcial2                    │
│ semestre_act │        │ calificacion_parcial3                    │
│ estatus      │        │ calificacion_final  (calculada, trigger) │
│ fecha_ingreso│        │ calificacion_ordinario                   │
└──────────────┘        │ calificacion_extraordinario              │
                        │ estatus_inscripcion                      │
                        └──────────────────────────────────────────┘
```

---

## Descripción de Relaciones

| Relación | Cardinalidad | Descripción |
|---|---|---|
| FACULTAD → CARRERA | 1:N | Una facultad puede tener muchas carreras |
| FACULTAD → PROFESOR | 1:N | Un profesor está adscrito a una facultad |
| CARRERA → PLAN_ESTUDIOS | 1:N | Una carrera puede tener varios planes históricos |
| PLAN_ESTUDIOS ↔ MATERIA | N:M (via PLAN_MATERIA) | Un plan tiene muchas materias; una materia puede estar en varios planes |
| MATERIA → GRUPO | 1:N | Una materia se oferta en múltiples grupos por periodo |
| PERIODO → GRUPO | 1:N | Un periodo tiene múltiples grupos |
| PROFESOR → GRUPO | 1:N | Un profesor imparte múltiples grupos |
| ALUMNO → INSCRIPCION | 1:N | Un alumno puede inscribirse a muchos grupos |
| GRUPO → INSCRIPCION | 1:N | Un grupo tiene muchos alumnos inscritos |

---

## Reglas de Negocio Implementadas

### Mediante Constraints

| Regla | Implementación |
|---|---|
| Matrícula única por alumno | `UNIQUE (matricula)` |
| Un alumno no puede repetir grupo | `UNIQUE (id_alumno, id_grupo)` en INSCRIPCION |
| Clave de grupo única por materia y periodo | `UNIQUE (id_materia, id_periodo, clave_grupo)` |
| Calificaciones en rango 0-10 | `CHECK (calificacion BETWEEN 0 AND 10)` |
| Periodo de fin posterior a inicio | `CHECK (fecha_fin > fecha_inicio)` |

### Mediante Triggers PL/SQL

| Regla | Trigger |
|---|---|
| PK autogenerada desde secuencia | `TRG_[TABLA]_BI` (9 triggers) |
| Calificación final = promedio de 3 parciales | `TRG_INSCRIPCION_CALCULA_FINAL` |
| Solo un plan activo por carrera | `TRG_PLAN_UN_ACTIVO` |

---

## Normalización

### Primera Forma Normal (1FN)
- Todos los atributos contienen valores atómicos (indivisibles).
- No existen grupos repetidos ni arreglos dentro de columnas.
- Ejemplo: el nombre del profesor está separado en `nombre`, `apellido_paterno`, `apellido_materno`.

### Segunda Forma Normal (2FN)
- Todas las tablas con PK simple cumplen automáticamente.
- En `PLAN_MATERIA` (PK compuesta): `semestre` y `es_obligatoria` dependen de la PK completa `(id_plan, id_materia)`, no solo de una parte.

### Tercera Forma Normal (3FN)
- No existen dependencias transitivas.
- Ejemplo: `GRUPO` no almacena el nombre del profesor ni de la materia; solo las FK. Los datos de cada entidad viven en su propia tabla.
- Ejemplo: `INSCRIPCION` no repite datos del alumno ni del grupo; se obtienen mediante JOIN.

---

## Índices Creados

### En Foreign Keys (obligatorio en Oracle)
Oracle **no crea índices automáticamente** en columnas FK. Sin estos índices, los JOINs son lentos:

```sql
IDX_CARRERA_FACULTAD, IDX_PLAN_CARRERA, IDX_PROFESOR_FACULTAD,
IDX_ALUMNO_PLAN, IDX_GRUPO_MATERIA, IDX_GRUPO_PERIODO,
IDX_GRUPO_PROFESOR, IDX_INS_ALUMNO, IDX_INS_GRUPO
```

### En Columnas de Búsqueda Frecuente
```sql
IDX_ALUMNO_ESTATUS     -- filtrar activos/baja/egresados
IDX_ALUMNO_SEMESTRE    -- filtrar por semestre
IDX_INS_ESTATUS        -- filtrar acreditadas/reprobadas
IDX_PERIODO_ACTIVO     -- encontrar periodo vigente
IDX_INS_CAL_FINAL      -- rangos de calificación
IDX_ALUMNO_NOMBRE      -- búsqueda por apellido
```
