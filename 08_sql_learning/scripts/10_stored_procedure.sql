-- stored procedure necesita un objetivo
-- DENTRO DE PROGRAMMABILITY ESTA STORED PROCEDURES DONDE SE CREA
-- PROC O PROCEDURE
CREATE PROC S_paciente (
    @idpaciente  int 
)
AS

SELECT *
FROM Paciente
where idPaciente = @idpaciente

GO
-- siempre GO sino da error 