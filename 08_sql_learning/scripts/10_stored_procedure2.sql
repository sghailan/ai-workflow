-- 
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- stored procedure necesita un objetivo
-- PROC O PROCEDURE
ALTER PROC [dbo].[S_paciente] (
    @idpaciente  int 
)
AS


SELECT *
FROM Paciente
where domicilio = NULL

GO
