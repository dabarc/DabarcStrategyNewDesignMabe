CREATE PROCEDURE  [dabarc].[sp_INFO_ReadListOfIDM_Reg]  @IsRegister VARCHAR(5), @table_id INT AS


 -----------------------------------------------------------------------
 -- Tabla Interfaz de Trabajo
 -----------------------------------------------------------------------

	CREATE TABLE #t_Objeto(	Object_id		int NULL,
							name		nvarchar(128) NULL,
							description nvarchar(256) NULL,
							type        nvarchar(10)  NULL)


 -----------------------------------------------------------------------
 -- Carga de tabla Interfaz
 -----------------------------------------------------------------------

	IF (@IsRegister = 0)
	BEGIN 
	INSERT INTO #t_Objeto		
	  SELECT report_id
		  ,name
		  ,description
		  ,'Info' as type
	  FROM dabarc.t_IDM
	  WHERE	registered = 0	and table_id = @table_id
	END
	ELSE	
	BEGIN
	INSERT INTO #t_Objeto
	  SELECT report_id
		  ,name
		  ,description
		  ,'Info' as type
	  FROM dabarc.t_IDM
	  WHERE	registered = 1 and table_id = @table_id
	END
 -----------------------------------------------------------------------
 -- Retorno de Valores
 -----------------------------------------------------------------------
	 SELECT	   Object_id as id
			  ,name
	 FROM #t_Objeto
	 ORDER BY name
