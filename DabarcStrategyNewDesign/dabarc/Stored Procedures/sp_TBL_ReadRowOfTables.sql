CREATE PROCEDURE  [dabarc].[sp_TBL_ReadRowOfTables] @TypeOfTBL VARCHAR(5), @Table_id INT AS

 -----------------------------------------------------------------------
 -- Carga de tabla Interfaz
 -----------------------------------------------------------------------

 IF (RTRIM(@TypeOfTBL) = 'TFF')
 BEGIN 
		
	SELECT table_id
		  ,name
		  ,description
		  ,short_description
		  ,active
		  ,priority
		  ,create_date
		  ,register_date
		  ,execute_date
		  ,register_user
		  ,execute_user
		  ,rules_number
		  ,reports_number
		  ,execute_time
		  ,modify_date
		  ,modify_user
		  ,registered
		  ,last_error
		  ,status
		  ,execute_rules
		  ,execute_reports
		  ,execute_ssis
		  ,ssis_number
		  ,database_id
		  ,table_createzip
	FROM	dabarc.t_TFF
	WHERE table_id = @Table_id	
 END
 
 IF (RTRIM(@TypeOfTBL) = 'TDM')	
 BEGIN
	SELECT table_id
		  ,name
		  ,description
		  ,short_description
		  ,active
		  ,priority
		  ,create_date
		  ,register_date
		  ,execute_date
		  ,register_user
		  ,execute_user		  
		  ,rules_number
		  ,reports_number
		  ,execute_time
		  ,modify_date
		  ,modify_user
		  ,registered
		  ,last_error
		  ,status
		  ,execute_rules
		  ,execute_reports
		  ,execute_ssis
		  ,ssis_number	
		  ,database_id
		  ,table_createzip
	FROM  dabarc.t_TDM
	WHERE table_id = @Table_id	
	--WHERE	registered = 1
 END

 IF (RTRIM(@TypeOfTBL) = 'TFM')	
 BEGIN
	SELECT table_id
		  ,name
		  ,description
		  ,short_description
		  ,active
		  ,priority
		  ,create_date
		  ,register_date
		  ,execute_date
		  ,register_user
		  ,execute_user		  
		  ,rules_number
		  ,reports_number
		  ,execute_time
		  ,modify_date
		  ,modify_user
		  ,registered
		  ,last_error
		  ,status
		  ,execute_rules
		  ,execute_reports
		  ,execute_ssis
		  ,ssis_number	
		  ,tdm_id	
		  ,table_createzip	  
	FROM  dabarc.t_TFM 
	WHERE table_id = @Table_id	
 END
