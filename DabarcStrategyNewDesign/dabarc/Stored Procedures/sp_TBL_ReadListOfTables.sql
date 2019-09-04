CREATE PROCEDURE  [dabarc].[sp_TBL_ReadListOfTables] @TypeOfTBL VARCHAR(5), @database_id INT, @tableId INT = 0 AS
 
 --EXEC  [dabarc].[sp_TBL_ReadListOfTables] 'TFM', 52;
 -----------------------------------------------------------------------
 -- Tabla Interfaz de Trabajo
 -----------------------------------------------------------------------

	CREATE TABLE #t_Tabla(
					table_id		int NULL,
					name			nvarchar(128) NULL,
					description		nvarchar(256) NULL,
					short_description nvarchar(50) NULL,
					active			bit NOT NULL,
					priority		int NULL,
					report_export   nchar(10) NULL,
					rules_number	int NULL,
					reports_number	int NULL,
					ssis_number		int NULL,	
					execute_rules	bit NOT NULL,
					execute_reports bit NOT NULL,
					execute_ssis	bit NOT NULL,
					execute_user	nvarchar(15) NULL,
					execute_date	datetime NULL,
					execute_time	nvarchar(25) NULL,
					str_status		nvarchar(15) NULL,
					last_error		nvarchar(256)NULL)	
 -----------------------------------------------------------------------
 -- Carga de tabla Interfaz
 -----------------------------------------------------------------------

IF (RTRIM(@TypeOfTBL) = 'TFF')
BEGIN 
	INSERT INTO #t_Tabla		
		SELECT table_id 
		  ,name
		  ,description
		  ,short_description
		  ,active
		  ,priority
		  ,null
		  ,rules_number
		  ,reports_number
		  ,ssis_number
		  ,execute_rules
		  ,execute_reports
		  ,execute_ssis
		  ,execute_user
		  ,execute_date
		  ,execute_time
		  ,status
		  ,last_error    
	  FROM t_TFF
	  WHERE	registered = 1	and database_id = @database_id
END
 
IF (RTRIM(@TypeOfTBL) = 'TDM')
BEGIN
	INSERT INTO #t_Tabla		
		SELECT table_id
		  ,name
		  ,description
		  ,short_description
		  ,active
		  ,priority
		  ,null
		  ,rules_number
		  ,reports_number
		  ,ssis_number
		  ,execute_rules
		  ,execute_reports
		  ,execute_ssis    
		  ,execute_user
		  ,execute_date
		  ,execute_time
		  ,status
		  ,last_error  
	  FROM t_TDM 
	  WHERE	registered = 1	and database_id = @database_id
END
 
IF (RTRIM(@TypeOfTBL) = 'TFM')
BEGIN
	SELECT     table_id
			  ,name
			  ,description
			  ,short_description
			  ,active
			  ,priority
			  ,null  as report_export
			  ,rules_number
			  ,reports_number
			  ,ssis_number
			  ,execute_rules
			  ,execute_reports
			  ,execute_ssis 
			  ,execute_user
			  ,execute_date
			  ,execute_time
			  , dabarc.fnt_get_TextStatus(status)  as str_status
			  ,last_error
	  FROM t_TFM 
	  WHERE	registered = 1	and tdm_id = @tableId
	  ORDER BY active DESC, priority ASC
	RETURN
END
 
UPDATE #t_Tabla
  SET     str_status = dabarc.fnt_get_TextStatus(str_status)
  			
 -----------------------------------------------------------------------
 -- Retorno de Valores
 -----------------------------------------------------------------------
	 SELECT	   table_id
			  ,name
			  ,description
			  ,short_description
			  ,active
			  ,priority
			  ,report_export
			  ,rules_number
			  ,reports_number
			  ,ssis_number
			  ,execute_rules
			  ,execute_reports
			  ,execute_ssis 
			  ,execute_user
			  ,execute_date
			  ,execute_time
			  ,str_status
			  ,last_error
	 FROM #t_Tabla
	 ORDER BY active DESC, priority ASC
