CREATE PROCEDURE [dabarc].[sp_ODBC_DeletedRowOfODBC](
  @odbc_id INT
 ) AS 
 
 
   ----------------------------------------------------------------------------
   -- hay que validar si no se usar en un ODBC
   ----------------------------------------------------------------------------
 
    IF (SELECT COUNT(*) FROM t_PlantillaH WHERE odbc_id = @odbc_id) > 0
	BEGIN
	 --  RAISERROR('Este ODBC está asignado a una plantilla.', 16, 1);
	  
	  
 RAISERROR (50023,
    16, -- Severity.
    1, -- State.
    '',
    '') -- Second substitution argument.
	  
	  
	   RETURN;
	END

	DELETE FROM t_ODBC WHERE	odbc_id = @odbc_id
