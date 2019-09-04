CREATE PROCEDURE [dabarc].[sp_ODBC_DeletedRowOfType_Column2](
  @type_id INT
 ) AS 
 
 
   ----------------------------------------------------------------------------
   -- hay que validar si no se usa en un ODBC
   ----------------------------------------------------------------------------
 
 --	IF (SELECT COUNT(*) FROM dabarc.t_ODBC_driver WHERE UPPER(driver_dbms) = UPPER(@driver_dbms)) > 0
	--BEGIN
	--   RAISERROR('Este driver ya se encuentra registrado.', 16, 1);
	--   RETURN;
	--END

	DELETE FROM dabarc.t_ODBC_ctypes WHERE type_id =   @type_id
