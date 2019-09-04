CREATE PROCEDURE  [dabarc].[sp_TPT_ReadRowOfTemplate] 
@plantilla_id INT
AS
BEGIN 
	SET NOCOUNT ON;
	SELECT plantilla_id
		  ,plan_name
		  ,plan_type
		  ,plan_califica
		  ,plan_description
		  ,odbc_id
		  ,sql_server
		  ,sql_database
		  ,sql_esquema
		  ,sql_user
		  ,sql_pasword
		  ,create_date
		  ,register_user
		  ,modify_date
		  ,modify_user
		  ,last_error
		  ,status
		  ,ISNULL(add_data,0) add_data
		  ,add_where
		  ,instance_source
		  ,affected_row
		  ,execute_date
		  ,execute_time
		  ,execute_user
		  ,porc_equal
	  FROM dabarc.t_PlantillaH
	  WHERE plantilla_id = @plantilla_id;
END
