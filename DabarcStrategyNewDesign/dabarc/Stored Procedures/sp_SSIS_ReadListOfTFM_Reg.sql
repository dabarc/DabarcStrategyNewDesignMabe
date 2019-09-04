CREATE PROCEDURE  [dabarc].[sp_SSIS_ReadListOfTFM_Reg] @IsRegister INT, @table_id INT  AS
 
 
 -----------------------------------------------------------------------
 -- Tabla Interfaz de Trabajo
 -----------------------------------------------------------------------

	CREATE TABLE #t_Objeto(
					Object_id	int NULL,
					name		nvarchar(128) NULL,
					description nvarchar(256) NULL,
					type        nvarchar(10) NULL)


 -----------------------------------------------------------------------
 -- Carga de tabla Interfaz
 -----------------------------------------------------------------------


   
    IF (@IsRegister = 0)
    BEGIN
    
		IF (@table_id = 0)
		BEGIN
			INSERT INTO #t_Objeto	
			SELECT ssis_id
				  ,name
				  ,description
				  ,'SSIS' as type
			  FROM t_SSIS
			  WHERE	name like 'SSIS[_]TFM[_]%' and registered = 0
		END
		ELSE
		BEGIN
		
			INSERT INTO #t_Objeto	
			SELECT ssis_id
				  ,name
				  ,description
				  ,'SSIS' as type
			  FROM t_SSIS
			  WHERE	name like 'SSIS[_]TFM[_]%' and ISNULL(table_id,0) = 0
			  
		END
	
   END
   ELSE
   BEGIN
   	INSERT INTO #t_Objeto	
	SELECT ssis_id
		  ,name
		  ,description
		  ,'SSIS' as type
	  FROM t_SSIS
	  WHERE	registered = 1 and name like 'SSIS[_]TFM[_]%' AND table_id = @table_id
   END
 
 -----------------------------------------------------------------------
 -- Retorno de Valores
 -----------------------------------------------------------------------
 
	 SELECT	  Object_id
			  ,name
			  ,description
			  ,type
	 FROM #t_Objeto
	 ORDER BY name
