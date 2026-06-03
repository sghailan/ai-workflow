-- CREAR BASE DE DATOS CON TRANSACT SQL

-- Crea los ficheros CentroMedico.mdf y CentroMedico_log.ldf en /var/opt/mssql/data/ dentro del contenedor
-- MDF (Master Data File): fichero principal de la base de datos — almacena tablas, índices y procedimientos
-- LDF (Log Data File): fichero de registro de transacciones — base para backups y recuperación ante fallos
CREATE DATABASE CentroMedico;

-- Se puede especificar una ruta personalizada para MDF y LDF en lugar de la ruta por defecto.
-- Esto permite centralizar los ficheros de todas las bases de datos en una carpeta concreta,
-- de forma que los backups sean más sencillos (solo hay que apuntar a esa carpeta) y que,
-- en caso de fallo, la recuperación sea más rápida al tener todo localizado.
-- Además, si se monta esa carpeta como volumen de Docker, los datos persisten aunque
-- se elimine el contenedor, ya que estarían almacenados en el host y no dentro del contenedor.
--
--   CREATE DATABASE CentroMedico
--   ON (
--       NAME = CentroMedico,
--       FILENAME = '/var/opt/mssql/data/backups/CentroMedico.mdf'
--   )
--   LOG ON (
--       NAME = CentroMedico_log,
--       FILENAME = '/var/opt/mssql/data/backups/CentroMedico_log.ldf'
--   );
--
--   La carpeta debe existir previamente: docker exec -it sqlserver mkdir /var/opt/mssql/data/backups


CREATE DATABASE Ejemplo;
