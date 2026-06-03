-- Al conectarse al servidor, SQL Server carga por defecto la base de datos 'master'.
-- 'master' es la base de datos del sistema que almacena toda la configuración del servidor:
-- logins, bases de datos existentes, configuraciones globales, etc. No se debe usar para datos propios.

-- Consultamos cuál es la base de datos por defecto del login 'sa':
SELECT default_database_name FROM sys.server_principals WHERE name = 'sa';

-- Cambiamos la base de datos por defecto de 'sa' a 'CentroMedico',
-- de forma que al conectarse ya cae directamente en nuestra base de datos:
ALTER LOGIN sa WITH DEFAULT_DATABASE = CentroMedico;
