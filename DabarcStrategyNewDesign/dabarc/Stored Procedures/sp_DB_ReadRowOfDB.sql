CREATE PROCEDURE  [dabarc].[sp_DB_ReadRowOfDB] @TypeOfDB VARCHAR(5), @database_id INT AS

 -----------------------------------------------------------------------
 -- Carga de tabla Interfaz
 -----------------------------------------------------------------------

 IF (RTRIM(@TypeOfDB) = 'DBF')
 BEGIN 
		
	SELECT database_id
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
		  ,tables_number
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
		  ,db_createzip
	FROM	dabarc.t_BDF
	WHERE database_id = @database_id
	--WHERE	registered = 1
 END
 ELSE
 BEGIN
---IF (RTRIM(@TypeOfDB) = 'DBM')	
	SELECT database_id
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
		  ,tables_number
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
		  ,db_createzip
	FROM	t_BDM
	WHERE database_id = @database_id
	--WHERE	registered = 1
 END
