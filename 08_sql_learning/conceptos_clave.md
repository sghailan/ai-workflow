# Fundamentos de Bases de Datos

---

## 1. ¿Qué es una Base de Datos?

Una base de datos es un sistema organizado para almacenar, gestionar y recuperar información de forma estructurada. En lugar de guardar datos en ficheros sueltos, una base de datos permite consultarlos, filtrarlos y relacionarlos de manera eficiente.

SQL Server es un **Sistema Gestor de Bases de Datos Relacionales (RDBMS)** — gestiona múltiples bases de datos y garantiza que los datos sean consistentes, seguros y accesibles.

> Nota: SQL es el lenguaje con el que se interactúa con una base de datos (SELECT, INSERT, CREATE TABLE...). SQL Server, PostgreSQL y MySQL son los sistemas gestores (RDBMS) — el software que almacena y gestiona los datos, y que entiende ese lenguaje. Son motores distintos que hablan el mismo idioma con pequeñas diferencias de dialecto. Azure Data Studio es el cliente gráfico desde el que se escribe SQL y se envía al servidor para su ejecución.

---

## 2. Tablas, Campos y Registros

Una base de datos relacional organiza la información en **tablas**, que funcionan como hojas de cálculo estructuradas.

- **Tabla** — estructura que agrupa datos del mismo tipo (ej. `Clientes`, `Pedidos`).
- **Campo (columna)** — cada atributo que describe una entidad (ej. `nombre`, `email`, `fecha_nacimiento`).
- **Registro (fila)** — cada entrada individual de datos, es decir, una instancia concreta (ej. un cliente específico).

```
Tabla: Clientes
┌────┬──────────────┬─────────────────────┬───────────────┐
│ id │ nombre       │ email               │ ciudad        │
├────┼──────────────┼─────────────────────┼───────────────┤
│  1 │ Ana García   │ ana@mail.com        │ Madrid        │
│  2 │ Luis Martín  │ luis@mail.com       │ Barcelona     │
└────┴──────────────┴─────────────────────┴───────────────┘
  ↑ campo            ↑ campo                ↑ campo
  ←————————————— registro ————————————————→
```

---

## 3. Valor NULL

`NULL` representa la **ausencia de valor** — no es cero, no es una cadena vacía, es simplemente que el dato no existe o no se conoce.

```sql
-- Un cliente sin teléfono registrado
INSERT INTO Clientes (nombre, telefono) VALUES ('Ana García', NULL);
```

Es importante distinguir:
- `0` → el valor es cero.
- `''` → el valor es una cadena vacía.
- `NULL` → no hay valor.

En SQL, comparar con NULL requiere `IS NULL` o `IS NOT NULL`, no `= NULL`.

---

## 3. Primary Key

La **Primary Key (PK)** es el campo que identifica de forma única cada registro de una tabla. No puede repetirse ni ser NULL.

```
Tabla: Clientes
┌────┬──────────────┬─────────────────────┐
│ id │ nombre       │ email               │
├────┼──────────────┼─────────────────────┤
│  1 │ Ana García   │ ana@mail.com        │
│  2 │ Luis Martín  │ luis@mail.com       │
│  3 │ Ana García   │ ana2@mail.com       │
└────┴──────────────┴─────────────────────┘
↑ PK — único e irrepetible
```

Dos clientes pueden llamarse igual, pero su `id` siempre es distinto. La PK es la referencia que usa el resto de tablas para relacionarse con esta — es lo que referencia una Foreign Key.

En SQL Server se suele usar `INT IDENTITY` para que el valor se genere automáticamente:

```sql
CREATE TABLE Clientes (
    id     INT IDENTITY(1,1) PRIMARY KEY,
    nombre VARCHAR(100),
    email  VARCHAR(100)
);
```

`IDENTITY(1,1)` significa que empieza en 1 y se incrementa de 1 en 1 automáticamente.

## 4. Foreign Key (Clave Foránea)

Una **Primary Key (PK)** identifica de forma única cada registro de una tabla. Una **Foreign Key (FK)** es un campo que referencia la PK de otra tabla, estableciendo una relación entre ambas. 

Debe ser del mismo TIPO que el tipo de la primary key con la que se relaciona

```
Tabla: Clientes          Tabla: Pedidos
┌────┬──────────┐        ┌────┬────────────┬───────────┐
│ id │ nombre   │        │ id │ fecha      │ cliente_id│
├────┼──────────┤        ├────┼────────────┼───────────┤
│  1 │ Ana      │◄───────│  1 │ 2024-01-10 │     1     │
│  2 │ Luis     │        │  2 │ 2024-01-12 │     1     │
└────┴──────────┘        └────┴────────────┴───────────┘
      PK                                        FK
```

La FK garantiza **integridad referencial** — no se puede crear un pedido con un `cliente_id`(campo de FK) que no exista en `Clientes`(campo de la PK).

Una tabla evidentemente puede tener varias FK. Y los valores del campo FK a priori podrían ser NULL (no incumples la integridad referencial)

---

## 5. Normalización

La normalización es el proceso de estructurar una base de datos para **eliminar redundancias** y evitar inconsistencias. Se organiza en formas normales (FN):

**1FN — Primera Forma Normal**
Cada celda contiene un único valor atómico. No hay listas ni grupos repetidos dentro de un campo. NO PERMITE DUPLICADOS entre fila-> cada registro se debe identificar de manera única-> por ejemplo, una práctica es generar una PK que identifique el registro 

**2FN — Segunda Forma Normal**
Cumple 1FN y todos los campos dependen completamente de la PK, no de una parte de ella. Por ejemplo si hay un campo idMedico que se relaciona de manera que dado un paciente este es su medico no estaria en segunda forma normal. Esto se debe a que el idmedico es el ID DEL MEDICO DEL PACIENTE-> se ve como no es directa la relación. Por ejemplo, si solo hubiese el campo Nombre si que estaría en segunda forma al ser el NOMBRE DEL PACIENTE-> relación directa

**3FN — Tercera Forma Normal**
Cumple 2FN y no hay dependencias transitivas — los campos no clave no dependen entre sí, solo de la PK. SOLO DEPENDEN DE LA PK (SEGUNDA FORMA) y además no debe depender de ninguna otra que sea no clave-> se evitan inconsistencias ante cambios

En la práctica, llegar a 3FN es suficiente para la mayoría de sistemas. Conseguimos que todos los campos de la tabla dependan de la PK y de ningun otro campo. En caso de que se intuya que algo depende de otro campo a parte -> replantearse dividir tablas y la estructura de tablas.

---

## 6. Tipos de Datos en SQL Server

SQL Server define el tipo de dato de cada campo al crear la tabla. Elegir el tipo correcto afecta al rendimiento y al espacio en disco.

### Numéricos

| Tipo | Descripción |
|---|---|
| `TINYINT` | numero entero de 0 a 255 -> 1 byte|
| `INT` | Entero de 32 bits (-2.1B a 2.1B)-> 4 bytes |
| `MONEY` | Decimal con no mas de 4 decimales y restringido -> 8 bytes |
| `DECIMAL(p,s)` | Número exacto con precisión y escala (ej. precios) |

| `BIGINT` | Entero de 64 bits, para IDs grandes -> 8 bytes |
| `FLOAT` | Número en coma flotante, aproximado |

### Texto

| Tipo | Descripción |
|---|---|
| `CHAR(n)` | Cadena de longitud fija -> sé cantidad exacta |
| `VARCHAR(n)` | Cadena de longitud variable, hasta n caracteres |

| `NVARCHAR(n)` | Como VARCHAR pero soporta Unicode (tildes, árabe, etc.) |
| `TEXT` | Texto largo, obsoleto — mejor usar `VARCHAR(MAX)` |

### Fechas

| Tipo | Descripción |
|---|---|
| `DATETIME` | Fecha y hora |


| `DATE` | Solo fecha (2024-01-10) |
| `TIME` | Solo hora (14:30:00) |
| `DATETIME2` | Mayor precisión que DATETIME |

### Otros

| Tipo | Descripción |
|---|---|
| `BIT` | Booleano (0 o 1) |
| `UNIQUEIDENTIFIER` | GUID, identificador único global |

## Recordando Tipos de Datos más utilizados


Numéricos:

    Enteros: INT, TINYINT, BIT

    Decimales: MONEY, DECIMAL


Texto:

     CHAR, VARCHAR


Fecha y Hora:

     DATETIME


Este es un recordatorio de lo visto anteriormente, resumido a los Tipos de Datos más utilizados