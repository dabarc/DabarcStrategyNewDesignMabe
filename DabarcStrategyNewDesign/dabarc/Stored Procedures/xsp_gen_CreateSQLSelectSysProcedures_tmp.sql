CREATE PROCEDURE [dabarc].[xsp_gen_CreateSQLSelectSysProcedures_tmp]
	(
	@database_id int,
	@table_id int,
	@table_type nchar(3),
	@table_name nvarchar(128),	
	@sqlstr nvarchar(1000) OUTPUT
	)
	
AS
	
	DECLARE @db_name		nvarchar(128),	
			@table_idstr	nchar(5),		
			@local_table_name nchar(5),
			@Sql_query		nvarchar(500)
			
	
	----------------------------------------------------------------------------------------------------------------
	--- Definción de variables
	----------------------------------------------------------------------------------------------------------------
	
	
	SET @db_name		= DB_NAME(@database_id)	
	SET @table_name		= @table_type + '_' + @table_name	
	SET @table_idstr	= CONVERT(nchar(5),@table_id)		
	SET @local_table_name = 't_' + @table_type
	
	----------------------------------------------------------------------------------------------------------------
	--- Tablas temporales
	----------------------------------------------------------------------------------------------------------------
		CREATE TABLE #tmp(	name		NVARCHAR(300),
							create_date	SMALLDATETIME,
							tableid		INT)							
		
		SET @Sql_query = 'SELECT name, create_date, ' + @table_idstr + ' FROM ' + @db_name + '.sys.procedures as cat 
					WHERE (name LIKE ''' + @table_name + '[_]%[_]Act'' OR 
						   name LIKE ''' + @table_name + '[_]%[_]Ins'' OR
					       name LIKE ''' + @table_name + '[_]%[_]Eli'') AND (name + ''Vi'' IN (SELECT name
							FROM ' + @db_name + '.sys.views as cat2
							WHERE name LIKE cat.name + ''Vi''))'
	
	----------------------------------------------------------------------------------------------------------------
	--- Insertar consulta
	----------------------------------------------------------------------------------------------------------------

		INSERT INTO #tmp(name,create_date,tableid)
		EXEC(@Sql_query)
		
	
	----------------------------------------------------------------------------------------------------------------
	--- Insertar en tabla
	----------------------------------------------------------------------------------------------------------------
	
	SET @sqlstr = 'INSERT INTO dabarc.' + @local_table_name + '(name, create_date, table_id)
				   SELECT name, create_date, tableid
				FROM #tmp as cat
				WHERE  name NOT IN (SELECT name 
								FROM dabarc.' + @local_table_name + ' AS t_tmp	
								WHERE table_id = ' + @table_idstr + ')'

    EXEC(@sqlstr)
	
	RETURN
