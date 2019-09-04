CREATE PROCEDURE  [dabarc].[sp_RULE_ReadListOfRRF_Reg] @IsRegister VARCHAR(5), @table_id  INT, @info_Id INT AS
 

 -----------------------------------------------------------------------
 -- Tabla Interfaz de Trabajo
 -----------------------------------------------------------------------

	CREATE TABLE #t_Objeto(	Object_id		int NULL,
							name		nvarchar(128) NULL,
							description nvarchar(256) NULL)


 -----------------------------------------------------------------------
 -- Carga de tabla Interfaz
 -----------------------------------------------------------------------

	IF (@IsRegister = 0)
	BEGIN 
	INSERT INTO #t_Objeto		
	  SELECT rule_id
		  ,name
		  ,description
	  FROM t_RRF
	  WHERE	registered = 0	and table_id = @table_id --and info_id = @info_Id
    END
	ELSE
	BEGIN 
	INSERT INTO #t_Objeto		
	  SELECT rule_id
		  ,name
		  ,description
	  FROM t_RRF
	  WHERE	registered = 1	and table_id = @table_id and info_id = @info_Id	  	  
    END
     
 -----------------------------------------------------------------------
 -- Retorno de Valores
 -----------------------------------------------------------------------
 
	 SELECT	  Object_id
			  ,name
			  ,description		
	 FROM #t_Objeto
	 ORDER BY name
