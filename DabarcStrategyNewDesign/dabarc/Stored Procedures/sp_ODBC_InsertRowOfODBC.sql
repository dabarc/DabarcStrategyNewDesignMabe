CREATE PROCEDURE [dabarc].[sp_ODBC_InsertRowOfODBC](						
						@driver_id int,
						@odbc_name		nvarchar(60),
						@odbc_server	nvarchar(60),
						@odbc_database	nvarchar(30),
						@odbc_esquema	nvarchar(30),
						@odbc_user		nvarchar(30),
						@odbc_pasword	nvarchar(30),
						@odbc_port		nvarchar(30),
						@odbc_protocol	nvarchar(30),	
						@odbc_notcolname bit,												
						@file_path		nvarchar(200),
						@file_separation nchar(5),
						@odbc_type		nchar(10),
						@file_dll		nvarchar(200),
						@odbc_alias		nvarchar(60),
						@register_user	nvarchar(15)

 ) AS 
 
 	IF (SELECT COUNT(*) FROM t_ODBC WHERE UPPER(odbc_name) = UPPER(@odbc_name)) > 0
	BEGIN
	 --  RAISERROR('Un ODBC con el mismo nombre ya existe.', 16, 1);
	   
 RAISERROR (50061,
    16, -- Severity.
    1, -- State.
    '',
    '') -- Second substitution argument.
	   
	   
	   
	   
	   RETURN;
	END



INSERT INTO t_ODBC
           (driver_id
           ,odbc_name
           ,odbc_server
           ,odbc_database
           ,odbc_esquema
           ,odbc_user
           ,odbc_pasword
           ,odbc_port
           ,odbc_protocol
           ,odbc_notcolname
           ,create_date
           ,register_user
           ,last_error
           ,status
           ,file_path
           ,file_separation
           ,odbc_type
           ,odbc_alias
           ,file_dll)
     VALUES(@driver_id,
           @odbc_name,
           @odbc_server,
           @odbc_database,
           @odbc_esquema,
           @odbc_user,
           @odbc_pasword,
           @odbc_port,
           @odbc_protocol,
           @odbc_notcolname,
           GETDATE(),
           @register_user,
           'Cadena sin probar',
           0,
           @file_path,
           @file_separation,
           @odbc_type,
           @odbc_alias,
           @file_dll)
