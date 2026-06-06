-- 1. Compruebo que nombre y apellidos de medico son obligatorios

INSERT INTO Medico
VALUES (NULL, NULL);

-- Cannot insert the value NULL into column 'Nombre', table 'CentroMedico.dbo.Medico'; column does not allow nulls. INSERT fails.

-- 2. Hemos puesto que idEstado de la tabal turnoEstado sea identitity vamos a comporbarlo
insert INTO TurnoEstado
VALUES ('Opcional');

select *
FROM TurnoEstado; -- se ha generado un id = 7 siguiendo con la notacion anterior a que fuese identity

-- 3. Comprobamos que hemos eliminado DNI correctamente
SELECT * 
from Paciente;


-- 4. CONSULTA: registros de la tabla Pago ordenado por fecha de pago de manera ascendente
SELECT *
FROM Pago
ORDER BY fecha asc;
-- lo mismo
SELECT *
FROM Pago
ORDER BY fecha;

-- 5. CONSULTA: Paciente mas joven usando top y order by
SELECT top 1 *
from Paciente
ORDER BY fNacimiento desc;