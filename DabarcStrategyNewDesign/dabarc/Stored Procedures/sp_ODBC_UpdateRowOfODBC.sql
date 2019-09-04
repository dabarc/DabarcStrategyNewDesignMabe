CREATE PROCEDURE [dabarc].[sp_ODBC_UpdateRowOfODBC](
						@odbc_id	INT,
						@driver_id	INT,
						@odbc_server	nvarchar(60),
						@odbc_database	nvarchar(30),
						@odbc_esquema	nvarchar(30),
						@odbc_user		nvarchar(30),
						@odbc_password	nvarchar(30),
						@odbc_port		nvarchar(30),
						@odbc_protocol	nvarchar(30),
						@odbc_notcolname bit,
						@file_path		nvarchar(100),
						@file_separation nchar(5),
						@odbc_type		nchar(10),	
						@odbc_alias		nvarchar(60),					
						@modify_user	nvarchar(15)

 ) AS 
 
 --	IF (SELECT COUNT(*) FROM dabarc.t_ODBC WHERE UPPER(odbc_name) = UPPER(@odbc_name)) > 0
	--BEGIN
	--   RAISERROR('Un ODBC con el mismo nombre ya existe.', 16, 1);
	--   RETURN;
	--END


	UPDATE dabarc.t_ODBC
	SET   driver_id		= @driver_id
		 ,odbc_server	= @odbc_server
		 ,odbc_database = @odbc_database
		 ,odbc_esquema	= @odbc_esquema
		 ,odbc_user		= @odbc_user
		 ,odbc_pasword	= @odbc_password
		 ,odbc_port		= @odbc_port
		 ,odbc_protocol	= @odbc_protocol
		 ,odbc_notcolname = @odbc_notcolname
		 ,modify_date	= GETDATE()
		 ,modify_user  = @modify_user
		 ,file_path		  = @file_path
		 ,file_separation = @file_separation
		 ,odbc_type		  = @odbc_type
		 ,odbc_alias	  = @odbc_alias
	WHERE odbc_id = @odbc_id
