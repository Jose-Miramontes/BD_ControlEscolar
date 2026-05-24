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
