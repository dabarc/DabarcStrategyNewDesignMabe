CREATE PROCEDURE [dabarc].[sp_log_InExecuteErrorUpdateTable]
	(
	@table_id		INT,
	@id_name		NCHAR(15),
	@table_type		NCHAR(10),
	@execute_time	NVARCHAR(25),
	@error_message	NVARCHAR(256)
	)
	
AS
	
	DECLARE @table_name nvarchar(128),
			@sqlstr nvarchar(1000)			
	
	--SET @table_name = 't_' + @table_type
	SET @table_name = @table_type
	
		SET @sqlstr = 'UPDATE  dabarc.' + @table_name + '
						SET  execute_time = ''' + @execute_time + ''', 
							 last_error = ''' + @error_message + ''',
							 affected_rows = 0,
							 status = 4
						WHERE ' + @id_name + ' = ' + CONVERT(nchar, @table_id)

	EXEC(@sqlstr)
	
	RETURN
