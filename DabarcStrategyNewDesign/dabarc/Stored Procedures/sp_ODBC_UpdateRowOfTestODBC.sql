CREATE PROCEDURE [dabarc].[sp_ODBC_UpdateRowOfTestODBC](
						@object_id		int,
						@last_error		nvarchar(256),
						@status			INT,
						@modify_user	nvarchar(15)

 ) AS 
 
 -- status 0 --> sin Probar
 -- status 1 --> existo
 -- status 2 --> Error

	UPDATE dabarc.t_ODBC
	SET   last_error = @last_error
		 ,modify_date	= GETDATE()
		 ,status = @status
		 ,modify_user  = @modify_user
	WHERE odbc_id = @object_id
