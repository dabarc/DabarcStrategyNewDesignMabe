--EXECUTE dabarc.sp_DB_ReadListOfDB 'DBF'

 CREATE PROCEDURE  [dabarc].[sp_DB_ReadListOfDB] @TypeOfDB VARCHAR(5) AS
 
  -----------------------------------------------------------------------
 -- Definición de Estado
 -----------------------------------------------------------------------
 
-- En Espera				0
-- Programados				1
-- En Ejecución				2
-- Terminado Correcto		3
-- Terminado con Error		4

 -----------------------------------------------------------------------
 -- Tabla Interfaz de Trabajo
 -----------------------------------------------------------------------
 
 CREATE TABLE #tt_BDF(	database_id int NULL,
						active		bit NULL,		
						priority	int NULL,
						name		nvarchar(128) NULL,
						description nvarchar(256) NULL,
						short_description nvarchar(50) NULL,						
						tables_number	int NULL,	
						ssis_number		int NULL,		
						rules_number	int NULL,
						reports_number	int NULL,
						execute_rules	bit NULL,
						execute_reports bit NULL,
						execute_ssis	bit NULL,
						execute_date	datetime NULL,
						execute_user	nvarchar(15) NULL,
						execute_time	nvarchar(25) NULL,
						str_status		nvarchar(15) NULL,
						last_error		nvarchar(256)NULL)

 -----------------------------------------------------------------------
 -- Carga de tabla Interfaz
 -----------------------------------------------------------------------

 IF (RTRIM(@TypeOfDB) = 'BDF')
 BEGIN 
	INSERT INTO #tt_BDF
	SELECT	database_id,
			active,
			priority,
			name,
			description,
			short_description,
			tables_number,
			ssis_number,
			rules_number,
			reports_number,
			execute_rules,
			execute_reports,
			execute_ssis,
			execute_date,
			execute_user,
			execute_time,
			status,
			last_error					
	FROM	t_BDF
	WHERE	registered = 1
 END
 
 
 IF (RTRIM(@TypeOfDB) = 'BDM')
 BEGIN
	INSERT INTO #tt_BDF
	SELECT	database_id,
			active,
			priority,
			name,
			description,
			short_description,
			tables_number,
			ssis_number,
			rules_number,
			reports_number,
			execute_rules,
			execute_reports,
			execute_ssis,
			execute_date,
		    execute_user,
			execute_time,
			status,
			last_error					
	FROM	t_BDM
	WHERE	registered = 1
 END
 
  UPDATE #tt_BDF
  SET     str_status = dabarc.fnt_get_TextStatus(str_status)
  
 -----------------------------------------------------------------------
 -- Retorno de Valores
 -----------------------------------------------------------------------
 
	 SELECT database_id,
			active,
			priority,
			name,
			description,
			short_description,
			tables_number,
			ssis_number,
			rules_number,
			reports_number,
			execute_ssis,
			execute_rules,
			execute_reports,
			execute_user,
			execute_date,
			execute_time,
			str_status, 
			last_error			
	 FROM #tt_BDF
	 ORDER BY active DESC,  priority ASC
