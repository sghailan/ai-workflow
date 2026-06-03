-- Un User Defined Data Type (UDDT) es un tipo de dato personalizado basado en uno existente.
-- Permite definir una vez el tipo con sus restricciones y reutilizarlo en varias tablas,
-- asegurando consistencia — si el tipo cambia, cambia en todos los sitios a la vez (MENOS ERRORES)
-- Se ven en Programmability- types-..


-- Creamos un tipo para los nombres de pacientes basado en VARCHAR(50):
CREATE TYPE paciente FROM int

DROP TYPE paciente;

-- dbo es el esquema por defecto — cuando no lo especificas, SQL Server lo asigna automáticamente. Es lo mismo que escribirlo explícitamente.
CREATE TYPE paciente FROM int NOT NULL;



-- OTROs
CREATE TYPE medico FROM int NOT NULL;

-- tened cuidado en la tabla turno el idTUrno era literalmente identity por la interfaz no sale la opcion-> sol quitar identity guardar, poner user
-- type y luego identity
CREATE TYPE turno FROM int NOT NULL;


CREATE TYPE historia from int NOT NULL;

CREATE TYPE observacion from varchar(1000) NULL;
