CREATE PROCEDURE [dabarc].[sp_gen_CreateSQLSelectSysProcedures]
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
			@Sql_query			NVARCHAR(800)
			
	----------------------------------------------------------------------------------------------------------------
	--- Obtenemos nombre completo de la base en la tabla que le corresponde
	----------------------------------------------------------------------------------------------------------------
	
	IF (UPPER(RTRIM(@table_type)) ='RFF')
	   SELECT @db_name = RTRIM(f.name) FROM dabarc.t_BDF f WHERE f.database_id = @database_id
	ELSE
	   SELECT @db_name = RTRIM(m.name) FROM dabarc.t_BDM m WHERE m.database_id = @database_id
		
	----------------------------------------------------------------------------------------------------------------
	--- Definción de variables
	----------------------------------------------------------------------------------------------------------------
	
	
	--SET @db_name		= DB_NAME(@database_id)	
	SET @table_name		= @table_type + '_' + @table_name	
	SET @table_idstr	= CONVERT(NCHAR(5),@table_id)		
	SET @local_table_name = 't_' + @table_type
	
	----------------------------------------------------------------------------------------------------------------
	--- Tablas temporales
	----------------------------------------------------------------------------------------------------------------
		CREATE TABLE #tmp(	name			NVARCHAR(300),
							create_date		SMALLDATETIME,
							tableid			INT,
							isnamedabarc	BIT)							

	
	----------------------------------------------------------------------------------------------------------------
	--- Insertar consulta
	----------------------------------------------------------------------------------------------------------------
		
			
		SET @Sql_query = 'SELECT name, create_date, ' + RTRIM(@table_idstr) + ',1 FROM ' + @db_name + '.sys.procedures as cat 
					WHERE (name LIKE ''' + @table_name + '[_]%[_]Act'' OR 
						   name LIKE ''' + @table_name + '[_]%[_]Ins'' OR
					       name LIKE ''' + @table_name + '[_]%[_]Eli'') AND (name + ''Vi'' IN (SELECT name
							FROM ' + @db_name + '.sys.views as cat2
							WHERE name LIKE cat.name + ''Vi''))'
	
		INSERT INTO #tmp(name,create_date,tableid,isnamedabarc)
		EXEC(@Sql_query)
		
		--select @Sql_query 
		--SELECT * FROM #tmp
	    
	    
	    SET @Sql_query = 'SELECT name, create_date, ' + RTRIM(@table_idstr) + ',0 FROM ' + @db_name + '.sys.procedures as cat 
							WHERE name NOT IN (SELECT name FROM #tmp)'
	
		INSERT INTO #tmp(name,create_date,tableid,isnamedabarc)
		EXEC(@Sql_query)
		--select @Sql_query
		

		----------------------------------------------------------------------------------------------------------
	-- Verifica el estatus de la tablas que ya estan en el sistemas
	----------------------------------------------------------------------------------------------------------

	--- Borramos banderas
		SET @Sql_query = 'UPDATE dabarc.' + @local_table_name + ' SET name = replace(name,''(No Existe)'','''') WHERE table_id = ' + RTRIM(@table_idstr) + ' AND  name like ''(No Existe)%'''
		PRINT @Sql_query
		EXEC(@Sql_query)
		
	--- Elimianos las tablas que no estan en base y no tiene hijos (procedure o vistas)
		--SET @Sql_query = 'DELETE FROM ' + @local_table_name + ' WHERE table_id = ' + RTRIM(@table_idstr) + ' AND registered = 0 AND RTRIM(name) NOT IN(SELECT RTRIM(name) FROM #tmp)'
		--EXEC(@Sql_query)
			
	--- Etiquetamos (No Existe) si la tabla esta registrada y ya no esta en base de datos			
		SET @Sql_query = 'UPDATE dabarc.' + @local_table_name + ' SET name = ''(No Existe)'' + name WHERE table_id = ' + RTRIM(@table_idstr) + ' AND  RTRIM(name) NOT IN (SELECT RTRIM(name) FROM #tmp)'
		PRINT @Sql_query
		EXEC(@Sql_query)
				
		
	----------------------------------------------------------------------------------------------------------------
	--- Insertar en tabla
	----------------------------------------------------------------------------------------------------------------
	
	
	--SELECT * FROM #tmp
	
	SET @sqlstr = 'INSERT INTO dabarc.' + @local_table_name + '(name, create_date, table_id, status, report_type)
				   SELECT name, create_date, tableid, 0,''''
				FROM #tmp as cat
				WHERE  isnamedabarc = 1 AND name NOT IN (SELECT name 
								FROM dabarc.' + @local_table_name + ' AS t_tmp	
								WHERE table_id = ' + @table_idstr + ')'

   PRINT @sqlstr
   EXEC(@sqlstr)
	
	RETURN
