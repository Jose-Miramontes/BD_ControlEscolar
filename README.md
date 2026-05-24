# 🎓 Sistema de Gestión de Base de Datos para Control Escolar — UAQ

> Proyecto escolar desarrollado para la **Universidad Autónoma de Querétaro (UAQ)**  
> Diseño e implementación de una base de datos relacional orientada al control escolar,  
> normalizada hasta la **Tercera Forma Normal (3FN)** y optimizada para **Oracle Database**.

---

## 📋 Tabla de Contenidos

- [Descripción](#-descripción)
- [Tecnologías](#-tecnologías)
- [Estructura del Proyecto](#-estructura-del-proyecto)
- [Modelo Entidad-Relación](#-modelo-entidad-relación)
- [Diagrama de Tablas](#-diagrama-de-tablas)
- [Instalación y Uso](#-instalación-y-uso)
- [Scripts Incluidos](#-scripts-incluidos)
- [Autor](#-autor)

---

## 📖 Descripción

Este proyecto implementa un **Sistema de Gestión de Base de Datos para Control Escolar** que cubre los principales procesos académicos y administrativos de una institución universitaria, modelados a partir del contexto de la UAQ.

### Funcionalidades que cubre el modelo:

- Registro de **Facultades, Carreras y Planes de Estudio**
- Gestión del **catálogo de Materias** con asignación a planes curriculares
- Administración de **Profesores** por facultad y tipo de contrato
- Control de **Periodos académicos** (semestres)
- Oferta de **Grupos** por materia, periodo y profesor asignado
- Registro completo de **Alumnos** con expediente y matrícula
- **Inscripciones y Calificaciones** con seguimiento de parciales, ordinario y extraordinario
- Cálculo automático del **promedio final** mediante triggers
- **Vistas consolidadas** para expediente y calificación efectiva

---

## 🛠 Tecnologías

| Tecnología | Uso |
|---|---|
| **Oracle Database 19c** | Motor principal de base de datos |
| **SQL (DDL / DML)** | Creación de esquema y carga de datos |
| **PL/SQL** | Triggers y lógica de negocio |
| **SQL*Plus / SQL Developer** | Ejecución de scripts |

---

## 📁 Estructura del Proyecto

```
📦 uaq-control-escolar-db/
│
├── 📄 README.md                          ← Este archivo
│
├── 📂 sql/
│   ├── 01_DDL_UAQ_Control_Escolar.sql    ← Creación de tablas, secuencias,
│   │                                        triggers, índices y vistas
│   ├── 02_DML_Datos_Prueba.sql           ← Datos ficticios para pruebas
│   └── 03_Consultas_Optimizadas.sql      ← Consultas complejas con JOINs,
│                                            agregaciones y funciones de ventana
│
└── 📂 docs/
    └── DER_Control_Escolar.png           ← Diagrama Entidad-Relación (opcional)
```

---

## 🗂 Modelo Entidad-Relación

El esquema está compuesto por **9 tablas** organizadas jerárquicamente:

```
FACULTAD
  └── CARRERA
        └── PLAN_ESTUDIOS
              └── PLAN_MATERIA ──── MATERIA
                                      └── GRUPO ──── PERIODO
              └── ALUMNO               └── PROFESOR (via FACULTAD)
                    └── INSCRIPCION ───────┘
```

### Entidades principales

| Tabla | Descripción |
|---|---|
| `FACULTAD` | Unidades académicas de la universidad |
| `CARRERA` | Programas académicos por facultad |
| `PLAN_ESTUDIOS` | Versiones del mapa curricular (2010, 2020…) |
| `MATERIA` | Catálogo global de asignaturas |
| `PLAN_MATERIA` | Relación N:M entre plan y materia (con semestre) |
| `PROFESOR` | Docentes adscritos a facultades |
| `PERIODO` | Semestres académicos (2024-A, 2024-B…) |
| `GRUPO` | Oferta de materia en un periodo con profesor asignado |
| `ALUMNO` | Estudiantes con expediente y matrícula |
| `INSCRIPCION` | Registro de inscripción y calificaciones |

---

## ✅ Normalización

El diseño cumple con las tres primeras formas normales:

| Forma Normal | Criterio | Estado |
|---|---|---|
| **1FN** | Atributos atómicos, sin grupos repetidos | ✅ |
| **2FN** | Dependencia funcional total de la PK | ✅ |
| **3FN** | Sin dependencias transitivas entre atributos no clave | ✅ |

---

## ⚙️ Instalación y Uso

### Requisitos previos

- Oracle Database 11g / 12c / 19c (o superior)
- Cliente SQL*Plus o SQL Developer
- Usuario con permisos `CREATE TABLE`, `CREATE SEQUENCE`, `CREATE TRIGGER`, `CREATE VIEW`

### Pasos de instalación

**1. Clonar el repositorio**

```bash
git clone https://github.com/tu-usuario/uaq-control-escolar-db.git
cd uaq-control-escolar-db
```

**2. Conectarse a Oracle**

```sql
-- Desde SQL*Plus
sqlplus usuario/contraseña@localhost:1521/ORCL
```

**3. Ejecutar los scripts en orden**

```sql
-- Paso 1: Crear esquema (tablas, triggers, índices, vistas)
@sql/01_DDL_UAQ_Control_Escolar.sql

-- Paso 2: Insertar datos de prueba
@sql/02_DML_Datos_Prueba.sql

-- Paso 3: Ejecutar consultas de ejemplo
@sql/03_Consultas_Optimizadas.sql
```

> ⚠️ **Importante:** El script DDL incluye un bloque de limpieza al inicio (`DROP TABLE ... CASCADE CONSTRAINTS`). Si ya existe el esquema, lo eliminará y lo recreará desde cero.

---

## 📜 Scripts Incluidos

### `01_DDL_UAQ_Control_Escolar.sql`

Crea la estructura completa del esquema:

- **9 tablas** con sus constraints (`PRIMARY KEY`, `FOREIGN KEY`, `CHECK`, `UNIQUE`, `NOT NULL`)
- **9 secuencias** para PKs autoincrementales
- **12 triggers PL/SQL:**
  - Asignación automática de PK desde secuencia (BEFORE INSERT)
  - Cálculo automático de `calificacion_final` al ingresar los 3 parciales
  - Control de un solo plan activo por carrera
- **16 índices** en columnas FK y de búsqueda frecuente
- **2 vistas:**
  - `VW_EXPEDIENTE_ALUMNO` — datos consolidados del alumno con carrera y facultad
  - `VW_CALIFICACION_EFECTIVA` — calificación definitiva respetando jerarquía (extraordinario → ordinario → final)

### `02_DML_Datos_Prueba.sql`

> *(Próximamente)*  
Datos ficticios realistas para poblar todas las tablas y realizar pruebas funcionales.

### `03_Consultas_Optimizadas.sql`

> *(Próximamente)*  
Consultas SQL avanzadas que incluyen:

- Promedio general y por materia de cada alumno
- Lista de alumnos inscritos por grupo
- Materias con mayor índice de reprobación
- Ranking de alumnos por desempeño académico (funciones de ventana)
- Carga académica por profesor por periodo

---

## 💡 Decisiones de Diseño Destacadas

1. **`MATERIA` desacoplada de `CARRERA`** — una asignatura como *Cálculo Diferencial* puede pertenecer a múltiples carreras y planes sin duplicar datos.

2. **`PLAN_MATERIA` como entidad asociativa** — resuelve la relación N:M entre planes y materias, almacenando además el semestre en que se cursa cada asignatura.

3. **Trigger de cálculo automático** — al registrar el tercer parcial, Oracle calcula `calificacion_final` y actualiza `estatus_inscripcion` automáticamente (`ACREDITADA` / `NO ACREDITADA`).

4. **`PERIODO` como entidad independiente** — evita redundancia de fechas en cada grupo y permite filtrar historial por semestre de forma eficiente.

5. **Índices explícitos en FK** — Oracle no crea índices automáticamente en columnas de clave foránea; se crean manualmente para garantizar rendimiento en JOINs.

---

## 👤 Autor

**[Tu Nombre]**  
Estudiante de [Tu Carrera]  
Universidad Autónoma de Querétaro — UAQ  

[![GitHub](https://img.shields.io/badge/GitHub-tu--usuario-181717?style=flat&logo=github)](https://github.com/tu-usuario)
[![LinkedIn](https://img.shields.io/badge/LinkedIn-tu--perfil-0A66C2?style=flat&logo=linkedin)](https://linkedin.com/in/tu-perfil)

---

## 📄 Licencia

Este proyecto es de uso académico y educativo.  
Desarrollado como proyecto escolar para la materia de **Bases de Datos** — UAQ.

---

<div align="center">
  <sub>Desarrollado con ☕ y SQL en Querétaro, México</sub>
</div>
