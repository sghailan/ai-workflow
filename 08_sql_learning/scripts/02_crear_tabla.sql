-- CREAR TABLA CON TRANSACT SQL
-- Como tabla en singular -> son pacientes -> Paciente

-- dbo (Database Owner): esquema por defecto en SQL Server.
-- La jerarquía es: Servidor → Base de datos → Esquema → Tabla
-- Un esquema es un contenedor lógico dentro de una base de datos que agrupa objetos
-- como tablas, vistas o procedimientos. No tiene existencia física, es solo organización.
-- 
-- Por defecto SQL Server usa 'dbo' para todo, pero se pueden crear esquemas propios
-- para organizar por áreas (rrhh, facturacion, clinica...) y controlar permisos
-- a nivel de esquema en lugar de objeto a objeto.
--
-- [dbo].[Paciente] se lee como: esquema 'dbo', tabla 'Paciente',
-- dentro de la base de datos activa (en nuestro caso CentroMedico).
-- La ruta completa sería: CentroMedico.dbo.Paciente

CREATE TABLE Paciente1(
    idPaciente int NOT NULL,
    nombre varchar(50) NOT NULL, 
    apellido varchar(50) NULL, 
    fNacimiento date NULL, 
    domicilio varchar(50) NULL, 
    idPais char(3) NULL, 
    telefono varchar(20) NULL, 
    email varchar(30) NULL, 
    observacion varchar(1000) NULL,
    fechaAlta datetime NOT NULL,
    CONSTRAINT PK_idpaciente PRIMARY KEY (idPaciente)
);

-- Eliminar tabla ya que era de ejemplo
DROP TABLE Paciente1;

-- No cumple con la normalización de la tabla (SE ELIMINAN LAS DOS ULTIMAS POR LA INTERFAZ VISUAL y se crea HistoriaPaciente)
CREATE TABLE HistoriaClinica(
    idHistoria int NOT NULL, 
    fechaHistoria datetime NULL, 
    observacion varchar(2000) NULL, 
    idPaciente int NULL, 
    idMedico int NULL,
    CONSTRAINT PK_idhistoria PRIMARY KEY (idHistoria)
);


-- Tiene que ser una compuesta ya que puede que haya varias historias clinicas en las cuales hay varios especialistas que intervienen 
-- (cada uno cuenta con su parte de detalle)
CREATE TABLE HistoriaPaciente(
    idHistoria int NOT NULL,
    idPaciente int NOT NULL, 
    idMedico int NOT NULL
    CONSTRAINT PK_historiapaciente  PRIMARY KEY (idHistoria, idPaciente, idMedico)
);

-- Se definen primary key compuestas-> CONSTRAINT alias PRIMARY KEY (campos envueltos)


-- Crear tabla pais
-- Sabemos que los paises como maximo tienen 3 -> usamos char mas optimizado con char(3)
-- Pais no es fijo-> varchar- Como maximo 30-> varchar(30)
CREATE TABLE Pais(
    idPais char(3) NOT NULL, 
    Pais varchar(30) NOT NULL, 
    CONSTRAINT PK_idpais PRIMARY KEY (idPais)
);

-- Los estados serán numeros pero no hay tantos estados posibles-> smallint o como TINYINT (hasta el 255)
-- Sera un identity(1,1), se explcia como se define al crear el campo-> seria mejor idTurno int IDENTITY (1,1) NOT NULL
CREATE TABLE Turno(
    idTurno int NOT NULL IDENTITY(1,1), 
    fechaTurno datetime NULL, 
    estado smallint NULL,
    observacion varchar(300) NULL, 
    CONSTRAINT PK_idturno PRIMARY KEY (idTurno)
);

-- en el mismo turno el paciente puede haber sido atendido por dos medicos distintos
-- Pueden haber turnos repetidos -> pk turno solo no
-- Puede haber turnos y pacientes repetidos -> pk compuesta de turno + paciente falla pues hay repes
-- La primary key se forma con las 3 juntas 
-- PREGUNTA A REALIZARSE ¿QUÉ COMBINACIÓN ES UNICA EN LA TABLA?-> SACAS LA PRIMARY KEY
CREATE TABLE TurnoPaciente(
    idTurno int NOT NULL, 
    idPaciente int NOT NULL, 
    idMedico int NOT NULL,
    CONSTRAINT PK_turnopaciente PRIMARY KEY (idTurno, idPaciente, idMedico)
);

-- Nótese que no hemos creado el identity en turnopaciente mientras que en la tabla turno si. ¿Por qué?
--Mantenemos la integridad de los datos ya que estos ids vienen de otras tablas y deben existir ya. 
-- Lo mismo ocurre con pacientes y la historia -> ya existen y por tanto no podemos crear registros de repente que se relacionen q no
-- Muy similar a lo explicado con las foreign key

CREATE TABLE TurnoEstado(
    idEstado SMALLINT not null,
    Descripcion varchar(50) NULL, 
    CONSTRAINT PK_idestado PRIMARY KEY (idEstado)
);

CREATE TABLE Especialidad(
    idEspecialidad int NOT NULL IDENTITY(1,1), 
    Especialidad varchar(30) NOT NULL, 
    CONSTRAINT PK_idespecialidad PRIMARY KEY (idEspecialidad)
);





-- Buenas practicas en primary key simple y identity ordenada puesta
-- conceptos que no van a ser muchos -> tinyint habrá tabla con las definiciones
CREATE TABLE Pago (
    idPago int IDENTITY (1,1) NOT NULL PRIMARY KEY,
    concepto tinyint NOT NULL, 
    fecha datetime NOT NULL, 
    monto money NOT NULL, 
    estado tinyint, 
    observacion varchar(1000) 
);

-- EL pago con que paciente y turno está relacionado-> 
CREATE TABLE PagoPaciente (
    idpago int NOT NULL,
    idpaciente int not null, 
    idturno int not null, 
    PRIMARY KEY (idpago, idpaciente, idturno)
);
-- primary key compuesta sin alias-> lo crea solo
-- a pesar de que el idpago es unico y por tanto todo es unico-> todas son pk en sus tablas-> más rapido


CREATE TABLE Medico(
    idMedico int IDENTITY (1,1) NOT NULL PRIMARY KEY,
    Nombre varchar(50) NOT NULL, 
    Apellido varchar(50) not null
);


CREATE TABLE MedicoEspecialidad (
    idMedico int NOT NULL, 
    idEspecialidad int not null, 
    Descripcion varchar(50) not null,
    PRIMARY KEY (idMedico, idEspecialidad, Descripcion)

);


CREATE TABLE Concepto(
    idconcepto tinyint IDENTITY (1,1) NOT NULL PRIMARY KEY,
    descripcion VARCHAR(100)
);



--- recordemos el tipo BIT
-- Es información adicional que no esta en pacientes y que además sirve para ilustrar relacion 1 a 1
-- Notese que la foreign key se puede definir en cualquiera de los dos lados porque es de 1 a 1. PERO CUIDADO PORQUE SI HAY ALGUNA QUE TIENE DATOS QUE OTRA NO PUEDE GENERAR 
-- ERORRES POR INTEGRIDAD REFERENCIAL. POR EJEMPLO SI PACIENTE INFO ESTA VACIA Y PACIENTE TIENE REGISTROS, SI INTENTO CREAR LA FOREIGN KEY DESDE PACIENTE Y QUE
-- APUNTE A LA PK DE PACIENTE INFO VA A FALLAR. YA QUE ESTOY DICIENDO QUE TODO ID QUE APAREZCA EN PACIENTE DEBE ESTAR EN INFO Y NO SE ESTÁ CUMPLIENDO.
-- COMO AHORA AMBAS ESTAN VACIAS SE PUEDE CREAR PARA AMBOS LADOS.
-- IGUALEMNTE COMO SE QUE PACIENTE INFO ES UNA TABLA OPCIONAL QUE NO VOY A RELLENAR-> APUNTO DESDE PACIENTE INFO A PACIENTE->
-- supongo que todo regustro en paceinte info existe en paciente-> siempre se cumplirá al estar vacia
CREATE TABLE PacienteInfo(
    idPaciente paciente NOT NULL PRIMARY KEY,
    diabetico BIT, 
    implantes BIT
);


-- Notese que las relaciones muchos a muchos siguiendo la normalización de tablas se ve como Medico-MedicoEspecialidad-Especialidad 
--(tabla intermedia que permite el muchos a muchos con primary compeusta)
