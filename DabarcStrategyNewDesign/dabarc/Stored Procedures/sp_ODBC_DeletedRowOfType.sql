﻿CREATE PROCEDURE [dabarc].[sp_ODBC_DeletedRowOfType](
  @driver_id INT
 ) AS 
 
 
   ----------------------------------------------------------------------------
   -- hay que validar si no se usa en un ODBC
   ----------------------------------------------------------------------------
 
 --	IF (SELECT COUNT(*) FROM dabarc.t_ODBC_driver WHERE UPPER(driver_dbms) = UPPER(@driver_dbms)) > 0
	--BEGIN
	--   RAISERROR('Este driver ya se encuentra registrado.', 16, 1);
	--   RETURN;
	--END

	DELETE FROM dabarc.t_ODBC_driver WHERE	driver_id =   @driver_id
