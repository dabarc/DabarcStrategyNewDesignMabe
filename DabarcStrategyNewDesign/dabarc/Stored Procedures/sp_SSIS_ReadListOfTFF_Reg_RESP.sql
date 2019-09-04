CREATE PROCEDURE  [dabarc].[sp_SSIS_ReadListOfTFF_Reg_RESP] @IsRegister INT, @table_id INT  AS
 
 
 -----------------------------------------------------------------------
 -- Valores de paso 
 -- @TypeOfSSIS = TFF / TDM / TFM
 -- @table_id = 0 / Valor (Si tiene 0 pertenece al modulo de extracción) 
 -----------------------------------------------------------------------


 -----------------------------------------------------------------------
 -- Tabla Interfaz de Trabajo
 -----------------------------------------------------------------------

	CREATE TABLE #t_Objeto(
					Object_id	int NULL,
					name		nvarchar(128) NULL,
					description nvarchar(256) NULL)


 -----------------------------------------------------------------------
 -- Carga de tabla Interfaz
 -----------------------------------------------------------------------


   
    IF (@IsRegister = 0)
    BEGIN
	INSERT INTO #t_Objeto	
	SELECT ssis_id
		  ,name
		  ,description
	  FROM dabarc.t_SSIS
	  WHERE	(registered = 0 OR ISNULL(table_id,0) = 0) AND  name like 'SSIS[_]TFF[_]%'
	
   END
   ELSE
   BEGIN
   	INSERT INTO #t_Objeto	
	SELECT ssis_id
		  ,name
		  ,description
	  FROM dabarc.t_SSIS
	  WHERE	registered = 1 and name like 'SSIS[_]TFF[_]%' AND table_id = @table_id
   END
 
 -----------------------------------------------------------------------
 -- Retorno de Valores
 -----------------------------------------------------------------------
 
	 SELECT	  Object_id
			  ,name
			  ,description
	 FROM #t_Objeto
	 ORDER BY name
