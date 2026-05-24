# Sistema de Gestión de Base de Datos para Control Escolar

## Tabla de Contenidos

- [Descripción](#-descripción)
- [Tecnologías](#-tecnologías)
- [Estructura del Proyecto](#-estructura-del-proyecto)
- [Modelo Entidad-Relación](#-modelo-entidad-relación)
- [Diagrama de Tablas](#-diagrama-de-tablas)
- [Instalación y Uso](#-instalación-y-uso)




## Descripción

Este proyecto implementa un Sistema de Gestión de Base de Datos para Control Escolar que cubre los principales procesos académicos y administrativos de una institución

### Funcionalidades que cubre el modelo:

- Registro de Facultades, Carreras y Planes de Estudio
- Gestión del catálogo de Materias con asignación a planes curriculares
- Administración de Profesores por facultad y tipo de contrato
- Control de semestres
- Oferta de Grupos por materia, periodo y profesor asignado
- Registro completo de Alumnos con expediente y matrícula
- Inscripciones y Calificaciones con seguimiento
- Cálculo automático del promedio final
- Vistas para expediente y calificación



## Tecnologías

Oracle Database
SQL (DDL / DML)
PL/SQL
SQL*Plus / SQL Developer



## Estructura del Proyecto

```
 uaq-control-escolar-db/

README.md                          ← Este archivo

sql/
01_DDL_UAQ_Control_Escolar.sql    ← Creación de tablas, secuencias,triggers, índices y vistas
                                        
02_DML_Datos_Prueba.sql           ← Datos ficticios para pruebas
03_Consultas_Optimizadas.sql      ← Consultas complejas con JOINs,agregaciones y funciones de ventana
                                          

docs/
-----─DER_Control_Escolar.png           ← Diagrama Entidad-Relación (opcional)
```



## Modelo Entidad-Relación

El esquema está compuesto por **9 tablas** organizadas jerárquicamente:

```
FACULTAD
  ── CARRERA
        ── PLAN_ESTUDIOS
              ── PLAN_MATERIA ──── MATERIA
                                      ── GRUPO ──── PERIODO
              ── ALUMNO               ── PROFESOR (via FACULTAD)
                    ── INSCRIPCION ───────
```

### Entidades principales

 Tabla

`FACULTAD` 
`CARRERA`
`PLAN_ESTUDIOS`
`MATERIA`
`PLAN_MATERIA`
`PROFESOR` 
`PERIODO`
`GRUPO`
`ALUMNO`
`INSCRIPCION`



## Normalización

El diseño cumple con las tres primeras formas normales:

Forma Normal | Criterio

**1FN** | Atributos atómicos, sin grupos repetidos
**2FN** | Dependencia funcional total de la PK
**3FN** | Sin dependencias transitivas entre atributos no clave


## Instalación y Uso

### Requisitos previos

- Oracle Database 11g / 12c / 19c (o superior)
- Cliente SQL*Plus o SQL Developer
- Usuario con permisos `CREATE TABLE`, `CREATE SEQUENCE`, `CREATE TRIGGER`, `CREATE VIEW`

### Pasos de instalación

**1. Clonar el repositorio**

**2. Conectarse a Oracle**

**3. Ejecutar los scripts en orden**

```sql
-- Paso 1: Crear esquema (tablas, triggers, índices, vistas)
@sql/01_DDL_UAQ_Control_Escolar.sql

-- Paso 2: Insertar datos de prueba
@sql/02_DML_Datos_Prueba.sql

-- Paso 3: Ejecutar consultas de ejemplo
@sql/03_Consultas_Optimizadas.sql
```

> **Importante:** El script DDL incluye un bloque de limpieza al inicio (`DROP TABLE ... CASCADE CONSTRAINTS`). Si ya existe el esquema, lo eliminará y lo recreará desde cero.