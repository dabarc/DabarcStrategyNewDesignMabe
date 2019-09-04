CREATE PROCEDURE  [dabarc].[sp_SSIS_ReadListOfTDM_Reg] @IsRegister INT, @table_id INT  AS
 
 
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
	INSERT INTO #t_Objeto	
	SELECT ssis_id
		  ,name
		  ,description
		  ,'SSIS' as type
	  FROM dabarc.t_SSIS
	  WHERE	registered = 0 and name like 'SSIS[_]TDM[_]%'
   END
   ELSE
   BEGIN
   	INSERT INTO #t_Objeto	
	SELECT ssis_id
		  ,name
		  ,description
		  ,'SSIS' as type
	  FROM dabarc.t_SSIS
	  WHERE	registered = 1 and name like 'SSIS[_]TDM[_]%' AND table_id = @table_id
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
