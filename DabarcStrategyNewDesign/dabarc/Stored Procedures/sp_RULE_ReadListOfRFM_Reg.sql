CREATE PROCEDURE  [dabarc].[sp_RULE_ReadListOfRFM_Reg] @IsRegister VARCHAR(5), @table_id INT AS
 
 
 DECLARE @Sql_query			NVARCHAR(800),
        @db_name            VARCHAR(128),
        @db_id              INT,
        @table_name         VARCHAR(128)
        
 -----------------------------------------------------------------------
 -- Obtener nombre de BDM y TDM
 -----------------------------------------------------------------------       
        
  
 SELECT @db_id = database_id FROM t_TDM WHERE table_id = (SELECT tdm_id
 FROM t_TFM F  WHERE table_id = @table_id)
  
 SELECT @table_name = RTRIM(SUBSTRING(name,5,LEN(name))) FROM t_TFM WHERE table_id = @table_id
 
 SELECT @db_name = RTRIM(m.name) FROM t_BDM m WHERE m.database_id = @db_id
 

 -----------------------------------------------------------------------
 -- Tabla Interfaz de Trabajo
 -----------------------------------------------------------------------

	CREATE TABLE #t_Objeto(	Object_id		int NULL,
							name		nvarchar(128) NULL,
							description nvarchar(256) NULL,
							type nvarchar (10) NULL)


 -----------------------------------------------------------------------
 -- Carga de tabla Interfaz
 -----------------------------------------------------------------------

	IF (@IsRegister = 0)
	BEGIN 
	SET @Sql_query = '		
	  SELECT rule_id
		  ,name
		  ,description
		  ,''Regla''
	  FROM dabarc.t_RFM
	  WHERE	registered = 0	and table_id =''' + CONVERT(varchar(10), @table_id)  + '''
	  UNION
			SELECT object_id, name, ''[Nuevo valor]'' ,''Vista'' FROM ' + @db_name + '.sys.views as cat 
				    	WHERE (name LIKE ''RFM[_]' + @table_name + '[_]%[_]ActVi'' OR 
					    name LIKE ''RFM[_]' + @table_name + '[_]%[_]InsVi'' OR
					    name LIKE ''RFM[_]' + @table_name + '[_]%[_]EliVi'') AND (SUBSTRING(name, 1, Len(name)-2) NOT IN (SELECT name
						FROM ' + @db_name + '.sys.procedures as cat2
						WHERE name LIKE SUBSTRING(cat.name, 1, Len(cat.name)-2)))'
        INSERT INTO #t_Objeto
		EXEC(@Sql_query)						
    END
	ELSE
	BEGIN 
	INSERT INTO #t_Objeto		
	  SELECT rule_id
		  ,name
		  ,description
		  ,'Regla'
	  FROM dabarc.t_RFM
	  WHERE	registered =1	and  table_id = @table_id	  
    END
    
 -----------------------------------------------------------------------
 -- Retorno de Valores
 -----------------------------------------------------------------------
    
	 SELECT	  Object_id
			  ,name
			  ,description
			  ,type		
	 FROM #t_Objeto
	 ORDER BY type, name
