-- 1. MAX Y MIN
SELECT *
FROM Pago; 

-- fecha mas reciente
SELECT MAX(fecha)
FROM Pago; 


SELECT MIN(monto)
FROM Pago;
-- se pueden usar en campos varchar (orden alfabetico)

-- 2. SUM
SELECT *
FROM Pago;

-- suma de todos los montos
SELECT SUM(monto)
from Pago;

-- notese que no tiene nombre de columna-> uso de ALIAS DE CAMPO
SELECT SUM(monto) as montoTotal
from Pago;

-- Suma 60 no 20, ya que primero hace lo del parentesis y luego los suma
SELECT SUM(monto+20) as montoTotal
from Pago;

-- Para poder hacer solo 20 fuera
SELECT SUM(monto)+20 as montoTotal
from Pago;

-- 3. AVG , promedio
select *
from pago;

-- suma los 3 los divide entre 3-> promedio basico
select AVG(monto) as montoPromedio
from pago;

-- PRIMERO SUMA 20 AL MONTO PARA CADA REGISTRO-> LUEGO LA MEDIA, COMO ES LA MEDIA 20 * 3/3= 20-> LA MEDIA SUBE 20
select AVG(monto+20) as montoPromedio
from pago;

-- al ser el promedio -> ES INDISTINTO DONDE SUMARLO PORQUE SI ESTA DENTRO LOS SUMA TANTAS VECES POR LAS Q DIVIDE-> SUMA EL VALOR A LA MEDIA
-- LO MISMO QUE SUMARLO POR FUERA
select AVG(monto) + 20  as montoPromedio 
from pago;


-- 4. COUNT
-- cantidad de filas que tengo en paciente
SELECT COUNT(*)
FROM Paciente;

-- Cantidad de registros con apellido Perez
SELECT COUNT(idPaciente)
FROM Paciente
WHERE apellido = 'Perez';

-- count de toda la tabla tiene mucho coste -> where es bastante necesario 


-- 5. HAVING-> TRABAJA CONJUNTO CON GROUP BY 

-- WHERE filtra registro a registro.
-- Having lo hace sobre un conjunto de registros
SELECT * from Turno;

-- estoy agrupando por un estado-> tieen que estar en el select-> sino da error
-- esto es lo mismo que un distinct como vimos 
SELECT estado
FROM Turno
GROUP BY estado;

SELECT estado 
FROM Turno
GROUP BY estado
HAVING count(estado) > 2;




