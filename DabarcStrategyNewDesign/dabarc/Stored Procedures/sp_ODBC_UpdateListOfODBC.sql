CREATE PROCEDURE [dabarc].[sp_ODBC_UpdateListOfODBC]	
	(
	@object_id	INT,	
	@odbc_server	nvarchar(60),
	@odbc_database	nvarchar(30),
	@odbc_esquema	nvarchar(30),
	@odbc_user		nvarchar(30),
	@odbc_pasword	nvarchar(30),
	@modify_user	nvarchar(15)
	)
	
AS
	DECLARE @modify_date datetime

	SET @modify_date = GETDATE()

 	IF (RTRIM(@odbc_server) = '' OR RTRIM(@odbc_user) = '' OR RTRIM(@odbc_pasword) = '')
	BEGIN
	 --  RAISERROR('Es necesario tener los datos del servidor, usuario y password.', 16, 1);
	  RAISERROR (50018,
    16, -- Severity.
    1, -- State.
    '',
    '') -- Second substitution argument.
	  
	  
	  
	  
	   RETURN;
	END

	
	
	
	UPDATE	dabarc.t_ODBC
	SET	  odbc_server	= @odbc_server
		 ,odbc_database = @odbc_database
		 ,odbc_esquema	= @odbc_esquema
		 ,odbc_user		= @odbc_user
		 ,odbc_pasword	= @odbc_pasword
		 ,modify_date	= GETDATE()
		 ,modify_user   = @modify_user
		 ,last_error	= 'Cadena sin probar'
	WHERE odbc_id = @object_id				
				 
	RETURN
