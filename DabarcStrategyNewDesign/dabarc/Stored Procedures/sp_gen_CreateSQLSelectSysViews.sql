CREATE PROCEDURE [dabarc].[sp_gen_CreateSQLSelectSysViews]
	(
	@database_id	INT,
	@table_id		INT,
	@table_type		NCHAR(3),
	@table_name		NVARCHAR(128),	
	@sqlstr			NVARCHAR(1000) OUTPUT
	)
	
AS
	
	DECLARE @db_name			NVARCHAR(128),	
			@table_idstr		NCHAR(5),		
			@local_table_name	NCHAR(5),
			@Sql_query			NVARCHAR(400)
	
	
	IF (UPPER(RTRIM(@table_type)) = 'IFF')
	   SELECT @db_name = RTRIM(f.name) FROM dabarc.t_BDF f WHERE f.database_id = @database_id
	ELSE
	   SELECT @db_name = RTRIM(m.name) FROM dabarc.t_BDM m WHERE m.database_id = @database_id
			
			
	----------------------------------------------------------------------------------------------------------------
	--- Definción de variables
	----------------------------------------------------------------------------------------------------------------						
	--SET @db_name			= DB_NAME(@database_id)	
	SET @table_name			= @table_type + '_' + @table_name	
	SET @table_idstr		= CONVERT(NCHAR(5),@table_id)	
	SET @local_table_name	= 't_' + @table_type
	
	----------------------------------------------------------------------------------------------------------------
	--- Tablas temporales
	----------------------------------------------------------------------------------------------------------------
		CREATE TABLE #tmp(	name			NVARCHAR(300),
							create_date		SMALLDATETIME,
							tableid			INT,
							isnamedabarc	BIT)							
	----------------------------------------------------------------------------------------------------------
	-- Llenado 
	----------------------------------------------------------------------------------------------------------	
		
	    SET @Sql_query = 'SELECT name, create_date, ' + RTRIM(@table_idstr) + ',0 FROM ' + @db_name + '.sys.views as cat '
	    
		INSERT INTO #tmp(name,create_date,tableid,isnamedabarc)
		EXEC(@Sql_query)
		
	----------------------------------------------------------------------------------------------------------
	-- Validación
	---------------------------------------------------------------------------------------------------------		
		
		SET @Sql_query = 'UPDATE #tmp SET isnamedabarc = 1 WHERE (name LIKE ''' + RTRIM(@table_name) + '[_]%'')'
		PRINT @Sql_query
		EXEC(@Sql_query)		
		
		----------------------------------------------------------------------------------------------------------
	-- Verifica el estatus de la tablas que ya estan en el sistemas
	----------------------------------------------------------------------------------------------------------

	--- Borramos banderas
		SET @Sql_query = 'UPDATE dabarc.' + @local_table_name + ' SET name = replace(name,''(No existe)'','''') WHERE table_id = ' + RTRIM(@table_idstr) + ' AND  name like ''(No Existe)%'''
		EXEC(@Sql_query)
		
	--- Elimianos las tablas que no estan en base y no tiene hijos (procedure o vistas)
		--SET @Sql_query = 'DELETE FROM ' + @local_table_name + ' WHERE table_id = ' + RTRIM(@table_idstr) + ' AND registered = 0 AND RTRIM(name) NOT IN(SELECT RTRIM(name) FROM #tmp)'
		--EXEC(@Sql_query)
		
	
	--- Etiquetamos (No Existe) si la tabla esta registrada y ya no esta en base de datos			
		SET @Sql_query = 'UPDATE dabarc.' + @local_table_name + ' SET name = ''(No existe)'' + name WHERE table_id = ' + RTRIM(@table_idstr) + ' AND  RTRIM(name) NOT IN (SELECT RTRIM(name) FROM #tmp)'
		EXEC(@Sql_query)
					
	----------------------------------------------------------------------------------------------------------------
	--- Insertar en tabla
	----------------------------------------------------------------------------------------------------------------

	SET @sqlstr = 'INSERT INTO dabarc.' + @local_table_name + '(name, create_date, table_id, report_export, report_separator, status, report_type)
				SELECT name, create_date, tableid,''TXT'',''|'',0,''''
				FROM #tmp as cat
				WHERE isnamedabarc = 1 AND name NOT IN (SELECT name 
								FROM dabarc.' + @local_table_name + ' AS t_tmp
								WHERE table_id = ' + @table_idstr + ')'
	EXEC(@sqlstr)
	 
	RETURN
