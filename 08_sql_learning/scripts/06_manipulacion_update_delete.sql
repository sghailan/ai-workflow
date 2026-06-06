-- 1. UPDATE
-- UPDATE TABLA
-- SET CAMPO = VALOR NUEVO
-- WHERE FILTRADO DEL CAMBIO

SELECT * FROM Paciente;

-- se van a actualizar todos los registros de paciente con observación-> CUIDADO !! CAMBIO MASIVO 
UPDATE Paciente 
SET observacion = 'sin observación';


select email
from Paciente
where idPaciente = 4;

-- RECORDATORIO SIEMPRE UPDATE CON WHERE
UPDATE Paciente
SET email = 'correo@mail.com'
WHERE idPaciente = 4;



select *
from Paciente
where idPaciente = 4;

-- UPDATE MULTIPLE
UPDATE Paciente 
SET Dni = '458256965', domicilio = 'Calle 23'
WHERE idPaciente = 4

-- 2. DELETE
-- DELETE FROM TABLA
-- WHERE

SELECT * 
FROM Paciente;

-- va a ELIMINAR TODOS LOS REGISTROS DE LA TABLA
DELETE FROM Paciente;

-- SIEMPRE CON WHERE IGUAL QUE UPDATE PARA NO ELIMINACIONES MASIVAS
DELETE FROM Paciente
WHERE idPaciente = 2;

-- NOTESE QUE SI hubiese querido eliminar algun registro que tenga idPaciente un id que aparezca en idPaciente de Pago fallaria la integridad referencial.
-- Pago paciente apunta y depende de la PK de Paciente. Como el 2 no esta usado-> no pasa nada 
SELECT * FROM PagoPaciente;


SELECT * from Turno;

INSERT INTO Turno 
VALUES ('2019-01-22', 0, 'Turno pendiente de aprobación');

INSERT into TurnoPaciente
VALUES (9, 1, 1);


--3. DELETE CUANDO HAY FOREIGN KEY

SELECT * from TurnoPaciente;
-- Vamos a intentar eliminar el paciente con id 7

-- NO NOS DEJA PORQUE SI ELIMINO ESTE PACIENTE-> QUE OCURRE CON EL REGISTRO DE TURNO PACIENTE QUE DEPENDE DE  ESTE ID DE PACIENTE ?? 
-- SI me deja eliminar el 7, los registros de turno paciente con este id se quedan colgados
DELETE FROM Paciente
WHERE idPaciente = 7;


-- Despues de eliminar los registros de Turno Paciente que corresponden al idPaciente = 7 
DELETE FROM TurnoPaciente 
where idPaciente = 7;
-- puedo eliminar el registro de paciente 7 porque ya nada depende de él y la integridad referencial se cumple
DELETE FROM Paciente
WHERE idPaciente= 7;

