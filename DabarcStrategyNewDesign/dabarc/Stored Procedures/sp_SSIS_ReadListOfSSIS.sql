CREATE PROCEDURE  [dabarc].[sp_SSIS_ReadListOfSSIS] @typeOfSSIS VARCHAR(5), @table_id INT AS
 
 
 -----------------------------------------------------------------------
 -- Valores de paso 
 -- @TypeOfSSIS = TFF / TDM / TFM
 -- @table_id = 0 / Valor (Si tiene 0 pertenece al modulo de extracción) 
 -----------------------------------------------------------------------


 -----------------------------------------------------------------------
 -- Tabla Interfaz de Trabajo
 -----------------------------------------------------------------------

	CREATE TABLE #t_Objeto(
					Object_id		int NULL,
					name			nvarchar(128) NULL,
					description		nvarchar(256) NULL,
					short_description nvarchar(50) NULL,
					active			bit NULL,
					priority		int NULL,
					report_export	char(10) NULL,
					execute_time	nvarchar(25) NULL,
					path			nvarchar(1000) NULL,
			        execute_rules	bit NULL,
					execute_reports bit NULL,
					execute_ssis	bit NULL,
				    execute_user	nvarchar(15) NULL,
					execute_date	datetime NULL,
					affected_rows int NULL,
					str_status		nvarchar(15) NULL,
					last_error		nvarchar(256)NULL,
					type            nvarchar(10) NULL)
					
					
 -----------------------------------------------------------------------
 -- Carga de tabla Interfaz
 -----------------------------------------------------------------------

	IF (@table_id = 0)
	BEGIN 
	INSERT INTO #t_Objeto		
	  SELECT ssis_id
		  ,name
		  ,description
		  ,short_description
		  ,active
		  ,priority
		  ,NULL
		  ,execute_time
		  ,path
		  ,0
		  ,0
		  ,0
		  ,execute_user
		  ,execute_date
		  ,affected_rows
		  ,status
		  ,last_error
		  ,'SSIS' as type
	  FROM t_SSIS
	  WHERE	registered = 1	and (name NOT LIKE 'SSIS[_]TDM[_]%' ) --AND name NOT LIKE 'SSIS[_]TFM[_]%'
	END
	ELSE
	BEGIN
	INSERT INTO #t_Objeto	
	SELECT ssis_id
		  ,name
		  ,description
		  ,short_description
		  ,active
		  ,priority
		  ,NULL
		  ,execute_time
		  ,path
		  ,0
		  ,0
		  ,0
		  ,execute_user
		  ,execute_date
		  ,affected_rows	
		  ,status
		  ,last_error
		  ,'SSIS' as type	  
	  FROM t_SSIS
	  WHERE	registered = 1	and table_id = @table_id and name like 'SSIS[_]' + @typeOfSSIS + '[_]%'
	END
 
 DECLARE @v XML = (SELECT * FROM #t_Objeto FOR XML AUTO)

    UPDATE #t_Objeto
    SET     str_status  = CASE 
				WHEN RTRIM(str_status) = 4 THEN 'Con error'
				WHEN RTRIM(str_status) = 3 THEN 'Correcto'
				WHEN RTRIM(str_status) = 2 THEN 'Ejecución'
				WHEN RTRIM(str_status) = 1 THEN 'Programado' ELSE 'En espera'
    END
  
   DECLARE @v1 XML = (SELECT * FROM #t_Objeto FOR XML AUTO)
 -----------------------------------------------------------------------
 -- Retorno de Valores
 -----------------------------------------------------------------------
 
	 SELECT	  Object_id
			  ,name
			  ,description
			  ,short_description
			  ,active
			  ,priority
			  ,'CARGA' as report_type
			  ,report_export
			  ,path	
			  ,execute_rules
			  ,execute_reports
			  ,execute_ssis
			  ,execute_user
			  ,execute_date
			  ,execute_time			  
			  ,affected_rows
			  ,str_status
			  ,last_error
			  ,type
	 FROM #t_Objeto
	 ORDER BY active DESC, priority ASC
