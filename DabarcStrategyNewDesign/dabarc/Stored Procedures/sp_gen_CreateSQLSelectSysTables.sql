CREATE PROCEDURE [dabarc].[sp_gen_CreateSQLSelectSysTables]
	(
	@database_id	INT,
	@table_type		NCHAR(3),
	@sqlstr			NVARCHAR(1000) OUTPUT
	)
	
AS
	
	DECLARE @db_name		NVARCHAR(128),			
			@database_idstr NCHAR(5),
			@table_name		NVARCHAR(128),
			@Sql_query		NVARCHAR(600)
		
	IF (UPPER(RTRIM(@table_type)) ='TFF')
	   SELECT @db_name = RTRIM(f.name) FROM t_BDF f WHERE f.database_id = @database_id
	ELSE
	   SELECT @db_name = RTRIM(m.name) FROM t_BDM m WHERE m.database_id = @database_id
				
	--SET @db_name		= DB_NAME(@database_id)
	SET @database_idstr = CONVERT(NCHAR(5),@database_id)
	SET @table_name		= 'dabarc.t_' + @table_type
	
	
	----------------------------------------------------------------------------------------------------------
	-- Creamos una tabla temporal para no tener problema con el colletion
	----------------------------------------------------------------------------------------------------------
	----------------------------------------------------------------------------------------------------------
	-- Tabla Temporal
	----------------------------------------------------------------------------------------------------------
		
		CREATE TABLE #tmp(	name		  NVARCHAR(300),
							create_date	  SMALLDATETIME,
							databaseid	  INT,
							isnamedabarc  BIT)-- Tiene el nombre acordado		
	----------------------------------------------------------------------------------------------------------
	-- Llenado 
	----------------------------------------------------------------------------------------------------------
		SET @Sql_query = 'SELECT name, create_date, ' + RTRIM(@database_idstr)  + ',0 FROM ' + @db_name + '.sys.tables as cat'
		SET @Sql_query = @Sql_query + ' UNION '
		SET @Sql_query = @Sql_query + 'SELECT name, create_date, ' + RTRIM(@database_idstr) + ',0 FROM ' + @db_name + '.sys.views as cat1'
		
		INSERT INTO #tmp(name,create_date,databaseid,isnamedabarc)		
		EXEC(@Sql_query)	
		

	----------------------------------------------------------------------------------------------------------
	-- Validación
	----------------------------------------------------------------------------------------------------------
		SET @Sql_query = 'UPDATE #tmp SET isnamedabarc = 1 WHERE (name LIKE ''' + @table_type + '_%'')'
		EXEC(@Sql_query)
		
	----------------------------------------------------------------------------------------------------------
	-- Verifica el estatus de la tablas que ya estan en el sistemas
	----------------------------------------------------------------------------------------------------------
	
	--- Borramos banderas
		SET @Sql_query = 'UPDATE ' + @table_name + ' SET name = replace(name,''(No existe)'','''') WHERE database_id = ' + RTRIM(@database_idstr) + ' AND  name like ''(No existe)%'''
		EXEC(@Sql_query)
		
	--- Eliminanos las tablas que no estan en base y no tiene hijos (procedure o vistas)
		--SET @Sql_query = 'DELETE FROM ' + @table_name + ' WHERE database_id = ' + RTRIM(@database_idstr) + ' AND registered = 0 AND RTRIM(name) NOT IN(SELECT RTRIM(name) FROM #tmp)'
		--EXEC(@Sql_query)
		
	
	--- Etiquetamos (No Existe) si la tabla esta registrada y ya no esta en base de datos			
		SET @Sql_query = 'UPDATE ' + @table_name + ' SET name = ''(No existe)'' + name WHERE database_id = ' + RTRIM(@database_idstr) + ' AND RTRIM(name) NOT IN (SELECT RTRIM(name) FROM #tmp)'
		EXEC(@Sql_query)
		
	----------------------------------------------------------------------------------------------------------
	-- Consulta
	----------------------------------------------------------------------------------------------------------

	
		SET @sqlstr = 'INSERT INTO ' + @table_name + '(name, create_date, database_id, status)
				SELECT name, create_date, databaseid, 0
				FROM #tmp as cat 
				WHERE isnamedabarc = 1 AND (name NOT IN (SELECT name 
														 FROM ' + @table_name + ' AS t_tmp
														 WHERE database_id = ' + RTRIM(@database_idstr) + '))'	

		EXEC(@sqlstr)


	
		
	RETURN
