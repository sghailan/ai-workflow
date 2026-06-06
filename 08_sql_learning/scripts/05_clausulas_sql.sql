-- 1. TOP 
SELECT * 
FROM Paciente;

SELECT TOP 1 * 
FROM Paciente;

SELECT TOP 2 * 
FROM Paciente;

SELECT TOP 2 nombre, apellido 
FROM Paciente;

-- 2. ORDER BY
SELECT * 
from Paciente;

-- por defecto es ascendente
SELECT * 
FROM Paciente
ORDER BY fNacimiento;

SELECT * 
FROM Paciente
ORDER BY fNacimiento desc;

-- 3. TOP Y ORDER BY (UTIL CUANDO QUIERES UNICO REGISTRO CON ALGUN CAMPO MAS ALTO O  MAS BAJO)
-- asume que tiene asc -> visto
SELECT * 
FROM Paciente 
ORDER BY fNacimiento;

-- Seleccionamos el registro con la fecha de nacimineto mas antigua
SELECT TOP 1 * 
FROM Paciente 
ORDER BY fNacimiento;

-- Seleccionamos el registro con la fehca de nacimiento mas reciente
SELECT top 1 *
FROM Paciente
ORDER BY fNacimiento desc;


-- 4. DISTINCT 
SELECT *
FROM Paciente;

-- Solo queremos los paises disitntos de la tabla
SELECT DISTINCT idPais 
from Paciente;

-- agrupa el campo sin repeticiones
SELECT DISTINCT fNacimiento
from Paciente;


-- 5. GROUP BY

-- ERROR ASTERISCO Y CON GROUP BY 
SELECT * 
FROM Paciente
GROUP BY idPais;

SELECT idPais
FROM Paciente
GROUP BY idPais;

-- Es analogo a 
SELECT DISTINCT idPais 
from Paciente;

-- No obstante su utilidad es para cosas como funciones agregadas etc que se verán

-- 6. WHERE-> filtados de filas 
SELECT * 
FROM Paciente;

-- COMILLAS SIMPLES Y UN UNICO IGUAL =
SELECT * 
FROM Paciente
where idPais = 'COL';

SELECT * 
FROM Paciente
where apellido = 'Perez';

-- ES NUMERICO -> no es necesario las simples 
SELECT * 
FROM Paciente
where idPaciente = 4;

-- FECHAS tambies es en comillas simples
SELECT * 
FROM Paciente
where fNacimiento = '20190118'; -- formato sqlserver

-- analogo
SELECT * 
FROM Paciente
where fNacimiento = '2019-01-18';


