CREATE PROCEDURE [dabarc].[sp_ODBC_UpdateRowOfType](
  @driver_id INT,
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

	UPDATE	dabarc.t_ODBC_driver
	SET		driver_dbms = @driver_dbms,
			driver_text = @driver_text,
			driver_cva  = @driver_cva
	WHERE	driver_id =   @driver_id
