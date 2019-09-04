CREATE PROCEDURE [dabarc].[sp_ODBC_InsertRowOfType](
  @driver_dbms NVARCHAR(50),
  @driver_text NVARCHAR(50),     
  @driver_cva NCHAR(10)
 ) AS 
 
 	IF (SELECT COUNT(*) FROM dabarc.t_ODBC_driver WHERE UPPER(driver_dbms) = UPPER(@driver_dbms)) > 0
	BEGIN
	 --  RAISERROR('Este driver ya se encuentra registrado.', 16, 1);
RAISERROR (50020,
    16, -- Severity.
    1, -- State.
    '',
    '') -- Second substitution argument.
	   
	   
	   
	   RETURN;
	END

	
 INSERT INTO dabarc.t_ODBC_driver (driver_dbms,driver_text,create_date,driver_cva)
     VALUES (@driver_dbms, @driver_text,GETDATE(), @driver_cva)
