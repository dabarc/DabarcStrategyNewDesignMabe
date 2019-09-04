CREATE PROCEDURE  [dabarc].[sp_RULE_ReadListOfRFM_Reg_RESP] @IsRegister VARCHAR(5), @table_id INT AS
 

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
	  FROM dabarc.t_RFM
	  WHERE	registered = 0	and table_id = @table_id
    END
	ELSE
	BEGIN 
	INSERT INTO #t_Objeto		
	  SELECT rule_id
		  ,name
		  ,description
	  FROM dabarc.t_RFM
	  WHERE	registered = 1	and  table_id = @table_id	  	  
    END
     
 -----------------------------------------------------------------------
 -- Retorno de Valores
 -----------------------------------------------------------------------
  
	 SELECT	  Object_id
			  ,name
			  ,description		
	 FROM #t_Objeto
	 ORDER BY name
