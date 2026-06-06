-- 1. AND-> y 
SELECT * 
FROM Paciente;

SELECT *
FROM Paciente
WHERE apellido = 'Perez' and nombre = 'José' and idPaciente = 6;


-- 2. OR-> o 
SELECT * 
FROM Paciente 
where apellido = 'Perez' or nombre = 'Jorge';


-- 3. IN
SELECT * 
FROM Turno
where estado IN (2,1);


SELECT *
FROM Paciente
where apellido in ('Perez', 'Ramirez', 'Paredes');


-- 4. LIKE
-- no quiero usar = ya que necesito buscar indistintamente con mayusculas o minusculas
SELECT * 
FROM Paciente
WHERE nombre LIKE 'claudio';


-- necesito buscar a parte de sin tener en cuenta mayusculas, partes del texto 
SELECT * 
FROM Paciente
WHERE nombre LIKE 'claud%';

SELECT * 
FROM Paciente
WHERE nombre LIKE '%claud%';


-- 5. NOT
SELECT *
FROM Paciente
where nombre not like '%clau%';

-- sql es Case insensitive-> no distingue mayusculas
select *
from Paciente
where apellido not in ('Perez', 'ramirez')


-- 6. BETWEEN ... AND
-- POR DEFECTO TOMA LA HORA A LAS 00:00:00
SELECT *
FROM Turno
where fechaTurno BETWEEN '20190102' AND '20190506';


SELECT * 
FROM Turno 
WHERE estado BETWEEN 1 AND 4;


-- COMBINAMOS OPERADORES-> CUIDADO CON LOS PARENTESIS
SELECT *
FROM Paciente 
WHERE (apellido = 'Perez') and (nombre = 'josé' or idPais = 'MEX') AND (idPaciente not in (7,9));