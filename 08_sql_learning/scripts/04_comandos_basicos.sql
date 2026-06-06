--1. Empezamos por select
SELECT * FROM Paciente;

SELECT idPaciente, nombre, apellido FROM Paciente;



---2. Insert registros a pacientes
--INSERT INTO TABLA (CAMPOS)
--VALUES (VALORES);
INSERT INTO Paciente (Dni, nombre, apellido, fNacimiento, domicilio, idPais, telefono, email, observacion)
VALUES ('33521569', 'Leandro', 'Paredes', '1982-05-20', 'Piedras 150', 'ARG', NULL, 'leandro@gmail.com', '');

-- Interesante darte cuenta de 1. Solo idPais que esten en la PK de tabla Pais ya que es una foreign key que depende de la Pk-> Integridad referencial
-- Para poner un valor en nulo se pone NULL
-- Formato date YYYY-MM-DD
-- Si es NOT NULL-> obviamente hay que añadirlo sino da erros 
-- Como idPaciente es autoincremental-> no se pone ni en los campos ni en los valores
SELECT * FROM Paciente;
-- Ahora aparece el registro nuevo

-- 3. INSERT MULTIPLE: dos registros a la vez
--INSERT INTO TABLA (CAMPOS)
--VALUES (registro 1), (registro2);
INSERT INTO Paciente (Dni, nombre, apellido, fNacimiento, domicilio, idPais, telefono, email, observacion)
VALUES ('33578126', 'José', 'Perez', '1999-04-15', 'Lavalle 2563', 'COL', NULL, 'jose@gmail.com', 'paciente derivado'),
('20485781', 'Marcela', 'Torres', '1978-02-15', 'Belgrano 1563', 'MEX', '156847523', 'marcela@gmail.com', '');


-- 4. Primary key y INSERT
SELECT * FROM Pais;

-- Nótese como españa existe ya en paises, vamos a violar la PK y por tanto hay error. ¡Ya existe y debe ser unica!
-- Nota como se pueden no especificar los campos en el insert (tienes que añadir todos porq sino no sabe que orden es)
--INSERT INTO TABLA 
--VALUES (TODOS LOS CAMPOS);
INSERT INTO Pais
VALUES ('ESP', 'España');



-- 5. Practicando comando insert

SELECT * FROM TurnoEstado;

INSERT INTO TurnoEstado
VALUES (0,'Pendiente'),
 (1,'Realizado'),
 (2,'Cancelado'),
 (3,'Rechazado'),
 (4,'Postergado'),
 (5,'Anulado'),
 (6,'Derivado');


 -- Vamos a comprobar que la PK esta definida en la tabla TurnoEstado-> vemos si falla al añadir algo que ya existe
 -- NOTA QUE NOS DAMOS CUENTA EN ESTE PUNTO -> ' comillas simples → para valores de texto ('Madrid', 'Ana')
 INSERT INTO TurnoEstado
 VALUES (6, 'Ayuda');



-- Notese que idTurno es identity-> no se inserta-> se entiende que no esta en la lista de campos no especificados
 INSERT INTO Turno 
 VALUES (2023-03-15, 0, 'Paciente en ayunas');

 INSERT INTO Turno 
 VALUES (2023-03-16, 1, 'Paciente con fiebre'),(2023-04-20, 0, 'Paciente con tos') ;


SELECT * FROM Turno;
SELECT * FROM Paciente;
Select * from Medico;

-- Insertamos un turno paciente con el turno, paciente y medico existente (son foreign key que apuntan a su respectiva tabla-> solo va a dejar
-- crearlas si realmente existe)
INSERT INTO TurnoPaciente
VALUES (1, 7, 1);

INSERT INTO TurnoPaciente
VALUES (2, 3, 1);

INSERT INTO TurnoPaciente
VALUES (3, 6, 1);

SELECT * FROM TurnoPaciente;


-- COMPROBAR INTEGRIDAD REFERENCIAL DE LAS FK
INSERT INTO Turno
 VALUES (2023-03-30, 8, 'ayuda');
 -- Notese que estado de la tabla turno es foreign key y apunta directamente a los valores de 
 select * from TurnoEstado;
 -- claramente el turno 8 no existe en esta tabla-> ERROR


INSERT into TurnoPaciente
values (10000, 3, 1);
--De nuevo hay 3 foreign key en esta tabla que apuntan a 3 PK de 3 tablas distintas-> en este caso pusimos un idTurno que no existe en
Select * from Turno;




SELECT * FROM Concepto;
-- idconcepto es identity-> se genera solo
-- descripcion -> es un varchar -> comillas simples 
INSERT INTO Concepto 
VALUES ('Laboratorio'), ('Radiografía');

-- El concepto en pago es una FK que apunta al id de la tabla Concepto-> hay que poner id autogenerados que existan en la tabla Concepto (1,2)
SELECT * FROM Pago;
INSERT INTO Pago
VALUES (1, 2019-02-15, 4500, 0, 'Pago pendiente'), (2, 2019-05-20, 6800, 0, 'Pago pendiente'), (1, 2019-09-27, 5600, 0, 'Pago pendiente');




Select * from PagoPaciente;

INSERT INTO PagoPaciente
VALUES (1,3, 3), (2,4, 2), (3,6, 1);


Select * from Especialidad;

INSERT INTO Especialidad 
VALUES ('Traumatología'), ('Clínica Médica'), ('Gastroenterología'), ('Pediatría');

