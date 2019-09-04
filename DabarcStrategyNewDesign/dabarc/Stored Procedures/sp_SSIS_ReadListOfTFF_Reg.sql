CREATE PROCEDURE  [dabarc].[sp_SSIS_ReadListOfTFF_Reg] @IsRegister INT, @table_id INT  AS
 --exec [dabarc].[sp_SSIS_ReadListOfTFF_Reg] 0, 1;
 DECLARE @database_id INT = 0;
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
					description nvarchar(256) NULL,
					type nvarchar(10) NULL)


 -----------------------------------------------------------------------
 -- Carga de tabla Interfaz
 -----------------------------------------------------------------------
	SELECT @database_id = [database_id] FROM dabarc.t_TFF
	WHERE table_id = @table_id
   
    IF (@IsRegister = 0)
    BEGIN
	INSERT INTO #t_Objeto	
	SELECT ssis_id
		  ,name
		  ,description
		  ,'SSIS' as type
	  FROM dabarc.t_SSIS
	  INNER JOIN (
		SELECT database_id AS id, '/' + REPLACE(name, '(No Existe)', '') AS db_path 
		FROM [dabarc].[t_BDF]
		WHERE database_id = @database_id
	  ) tmp ON tmp.db_path = path
	  --WHERE	(registered = 0 OR ISNULL(table_id,0) = 0) AND  name like 'SSIS[_]TFF[_]%'
	  WHERE	registered = 0 AND  name like 'SSIS[_]TFF[_]%' AND table_id IS NULL
	
   END
   ELSE
   BEGIN
   	INSERT INTO #t_Objeto	
	SELECT ssis_id
		  ,name
		  ,description
		  ,'SSIS' as type
	  FROM dabarc.t_SSIS
	  WHERE	registered = 1 and name like 'SSIS[_]TFF[_]%' AND table_id = @table_id
   END
 
 -----------------------------------------------------------------------
 -- Retorno de Valores
 -----------------------------------------------------------------------
 
	 SELECT	  Object_id
			  ,name
			  ,description
			  ,type
			  ,'' AS Path
	 FROM #t_Objeto
	 ORDER BY name

