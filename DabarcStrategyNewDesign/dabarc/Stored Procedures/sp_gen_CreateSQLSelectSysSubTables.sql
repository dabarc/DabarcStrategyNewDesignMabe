CREATE PROCEDURE [dabarc].[sp_gen_CreateSQLSelectSysSubTables]
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
			@Sql_query			NVARCHAR(600)
	

	SELECT @db_name		= RTRIM(name) FROM dabarc.t_BDM WHERE database_id = @database_id 			
	--SET @db_name		= DB_NAME(@database_id)	
	SET @table_name		= @table_type + '_' + @table_name	
	SET @table_idstr	= CONVERT(NCHAR(5),@table_id)		
	SET @local_table_name = 't_' + @table_type
	
	----------------------------------------------------------------------------------------------------------
	-- Creamos una tabla temporal para no tener problema con el colletion
	----------------------------------------------------------------------------------------------------------
	----------------------------------------------------------------------------------------------------------
	-- Tabla Temporal
	----------------------------------------------------------------------------------------------------------
	
		CREATE TABLE #tmp(	name		  NVARCHAR(300),
							create_date	  SMALLDATETIME,
							tableid		  INT,
							isnamedabarc  BIT)		
							
	
	----------------------------------------------------------------------------------------------------------
	-- Llenado // Se debe mostrar las tablas y vistas que correspondan con la nomenclatura
	----------------------------------------------------------------------------------------------------------	
		SET @Sql_query = 'SELECT name, create_date, ' + RTRIM(@table_idstr) + ',0 FROM ' + @db_name + '.sys.tables as cat'
		SET @Sql_query = @Sql_query + ' UNION '
		SET @Sql_query = @Sql_query + 'SELECT name, create_date, ' + RTRIM(@table_idstr) + ',0 FROM ' + @db_name + '.sys.views as cat1'
	
		INSERT INTO #tmp(name,create_date,tableid,isnamedabarc)
		EXEC(@Sql_query)
		
		DECLARE @v XML = (SELECT * FROM #tmp FOR XML AUTO)
		
	----------------------------------------------------------------------------------------------------------
	-- Validación
	---------------------------------------------------------------------------------------------------------		
		
		SET @Sql_query = 'UPDATE #tmp SET isnamedabarc = 1 WHERE (name LIKE ''' + @table_name + '[_]%'')'
		EXEC(@Sql_query)

		DECLARE @v1 XML = (SELECT * FROM #tmp FOR XML AUTO)
	----------------------------------------------------------------------------------------------------------
	-- Verifica el estatus de la tablas que ya estan en el sistemas
	----------------------------------------------------------------------------------------------------------

	--- Borramos banderas
		SET @Sql_query = 'UPDATE dabarc.' + @local_table_name + ' SET name = replace(name,''(No existe)'','''') WHERE tdm_id = ' + RTRIM(@table_idstr) + ' AND  name like ''(No Existe)%'''
		EXEC(@Sql_query)
		
	--- Elimianos las tablas que no estan en base y no tiene hijos (procedure o vistas)
		--SET @Sql_query = 'DELETE FROM ' + @local_table_name + ' WHERE tdm_id = ' + RTRIM(@table_idstr) + ' AND registered = 0 AND RTRIM(name) NOT IN(SELECT RTRIM(name) FROM #tmp)'
		--EXEC(@Sql_query)
		
	
	--- Etiquetamos (No Existe) si la tabla esta registrada y ya no esta en base de datos			
		SET @Sql_query = 'UPDATE dabarc.' + @local_table_name + ' SET name = ''(No existe)'' + name WHERE tdm_id = ' + RTRIM(@table_idstr) + ' AND  RTRIM(name) NOT IN (SELECT RTRIM(name) FROM #tmp)'
		EXEC(@Sql_query)
				
	----------------------------------------------------------------------------------------------------------
	-- Consulta
	----------------------------------------------------------------------------------------------------------
		SET @sqlstr = 'INSERT INTO dabarc.' + @local_table_name + ' (name, create_date, tdm_id, status)
					SELECT name, create_date, tableid, 0
					FROM #tmp as cat
					WHERE isnamedabarc = 1 AND  name NOT IN (SELECT name 
								FROM dabarc.' + @local_table_name + ' AS t_tmp
								WHERE tdm_id = ' + @table_idstr + ')'
		EXEC(@sqlstr)
	
	RETURN
