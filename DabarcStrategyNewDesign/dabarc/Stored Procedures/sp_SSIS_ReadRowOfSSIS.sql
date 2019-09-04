CREATE PROCEDURE  [dabarc].[sp_SSIS_ReadRowOfSSIS] @TypeOfSSIS VARCHAR(5), @ssis_id INT AS

 -----------------------------------------------------------------------

	SELECT ssis_id
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
		  ,execute_time
		  ,affected_rows
		  ,modify_date
		  ,modify_user
		  ,registered
		  ,last_error
		  ,status
		  ,table_id
		  ,path
		  ,database_id
	FROM	t_SSIS
	WHERE ssis_id = @ssis_id
