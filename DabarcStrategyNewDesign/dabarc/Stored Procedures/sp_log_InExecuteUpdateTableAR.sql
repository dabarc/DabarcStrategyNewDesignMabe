CREATE PROCEDURE [dabarc].[sp_log_InExecuteUpdateTableAR]
	(
	@row_id		    INT,
	@name_col		NCHAR(15),
	@name_table		NCHAR(50),
	@int_status		INT,
	@execute_user	NVARCHAR(15),
	@execute_date	DATETIME,
	@execute_time	NVARCHAR(25),
	@affected_rows	INT
	)
	
AS
	-- Programado   (usuario, estado = 1)
	-- En ejecución (usuario, fecha ejecución, estado = 2)
	-- Correcto     (usuario, fecha ejecución, Tiempo, Afectados, estado = 3)

	---------------------------------------------------------------------------------------------------------------------
	--- Declaraciones de variables
	---------------------------------------------------------------------------------------------------------------------
	
	DECLARE @table_name NVARCHAR(128),
			@sqlstr		NVARCHAR(1000),
			@str_date	NVARCHAR(40)
				
	
	
	---------------------------------------------------------------------------------------------------------------------
	--- Declaraciones de variables
	---------------------------------------------------------------------------------------------------------------------
	
		
	--SET @table_name = 't_' + @table_type
	SET @table_name = 'dabarc.'+ @name_table
	SET @sqlstr = 'UPDATE  ' + @table_name + ''
	
	SET @str_date = GETDATE()
	--SET @str_date = RTRIM(CONVERT(nvarchar(30), @execute_date, 103)) + ' ' + RTRIM(CONVERT(nvarchar(30), @execute_date, 108))
	
	
	if (@int_status = 1)
	BEGIN
		SET @sqlstr = @sqlstr + ' SET execute_date = ''' + @str_date + ''', 
							execute_user = ''' + @execute_user + ''', 
							execute_time = NULL, 
							affected_rows = 0,
							last_error = NULL,
							status = 1'
	END
	
	if (@int_status = 2)
	BEGIN
			SET @sqlstr = @sqlstr + ' SET execute_date = ''' + @str_date + ''', 
							execute_time = NULL, 
							affected_rows = 0,
							last_error = NULL,
							status = 2'
	END
		
	if (@int_status = 3)
	BEGIN
			SET @sqlstr = @sqlstr + ' SET execute_time = ''' + @execute_time + ''', 
							affected_rows = ' + CONVERT(nchar,@affected_rows) + ',
							last_error = ''Ejecución satisfactoria'',
							status = 3'
	END
		

	SET @sqlstr = @sqlstr + ' WHERE ' + @name_col + ' = ' + CONVERT(nchar, @row_id)
						

	EXEC(@sqlstr)
	
	RETURN
