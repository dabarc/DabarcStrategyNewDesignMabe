
 CREATE PROCEDURE [dabarc].[xsp_SAP_RealListOfTableFilter] @intModule INT, @intSubModule INT, 
 @var_table NVARCHAR(50), @var_Field NVARCHAR(50) AS
 
 DECLARE @str_sql	NVARCHAR(2000)
 DECLARE @str_where NVARCHAR(100)
 
	---------------------------------------------------------------------------------------------------
	-- creamo una tabla temporal con las tablas que contiene campos con el nombre
	---------------------------------------------------------------------------------------------------
	
		CREATE TABLE #tmpTabla(id_tabla INT)	
		SET @str_where = ''
	
	---------------------------------------------------------------------------------------------------
	-- creamo una tabla temporal con las tablas que contiene campos con el nombre
	---------------------------------------------------------------------------------------------------

	
	IF (@var_Field <> '' AND @var_Field IS NOT NULL)
	BEGIN 
	   SET @str_sql = 'SELECT t.id_tabla FROM dabarc.t_sap_tabla t
						INNER JOIN dabarc.t_sap_tabla_campos c ON t.id_tabla = c.id_tabla
						WHERE c.sap_descripcion_es like ''%' + RTRIM(@var_Field) + '%'''
						
		INSERT INTO #tmpTabla EXECUTE(@str_sql)
	END 
		
	
	---------------------------------------------------------------------------------------------------
	-- creamo una tabla temporal con las tablas que contiene campos con el nombre
	---------------------------------------------------------------------------------------------------
	
 
	 SET @str_sql = 'SELECT t.id_tabla,sap_modulo + '' / '' + m.sap_descripcion as sap_modulo,  
				sap_sub_modulo + '' / '' + sm.sap_descripcion as sap_submodulo,
				sap_table + '' / '' + t.sap_descripcion as sap_tabla
			FROM dabarc.t_sap_modulo m
			INNER JOIN dabarc.t_sap_submodulo sm ON m.id_modulo = sm.id_modulo
			INNER JOIN dabarc.t_sap_submodulo_tabla smt ON sm.id_submodulo = smt.id_submodulo
			INNER JOIN dabarc.t_sap_tabla t ON smt.id_tabla = t.id_tabla'
		
	
	IF (@var_Field <> '' AND @var_Field IS NOT NULL)
	  SET @str_sql = @str_sql + ' INNER JOIN #tmpTabla tmp ON t.id_tabla = tmp.id_tabla'
	

	IF (@intModule > 0 AND @intModule IS NOT NULL)
		SET @str_where = @str_where + 'AND m.id_modulo = ' +  CAST(@intModule as CHAR(4))
	
	IF (@intSubModule > 0 AND @intSubModule IS NOT NULL)
	    SET @str_where = @str_where + 'AND sm.id_submodulo = ' +  CAST(@intSubModule as CHAR(4))
	
	IF (RTRIM(@var_table) <> '' AND @var_table  IS NOT NULL)
		SET @str_where = @str_where + 'AND t.sap_descripcion like ''%' +  RTRIM(@var_table) + '%'''
	
	
	If (@str_where <> '')
		SET @str_sql = @str_sql + ' WHERE ' + SUBSTRING(RTRIM(@str_where),4,LEN(@str_where))
	
	PRINT @str_sql
	EXECUTE(@str_sql)
