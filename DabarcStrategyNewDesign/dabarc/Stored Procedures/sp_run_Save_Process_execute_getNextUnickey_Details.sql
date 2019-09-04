CREATE PROCEDURE dabarc.sp_run_Save_Process_execute_getNextUnickey_Details
	@Path_hkey AS NVARCHAR(15) 
	AS
	SET NOCOUNT ON ;
	 DECLARE @STR_SQL NVARCHAR(450)
	 DECLARE @INT_RUN INT
	 
	 --Calculamos cuandos se estan ejecutando 
	 --, @NoExecute INT
	 --SELECT @INT_RUN = ISNULL(COUNT(*),0) 
	 --FROM	dabarc.t_Sql_process_executeD d 
		--	INNER JOIN dabarc.t_Sql_process_executeH h ON d.path_unickey = h.Path_hKey AND h.Path_hStatus = 2
	 --WHERE d.path_status =  2	 
	 
	 --IF (@INT_RUN < @NoExecute)
		--SELECT @NoExecute = @NoExecute - @INT_RUN


	 
     SELECT  f.path_unickey
			,f.path_position
			,f.path_table
			,f.path_id
			,f.path_name
			,f.path_type
			,f.path_status
			,f.path_executeuser
			,f.path_Priority
			,f.path_message
			,f.path_extra
			,f.path_table_padre_id
			,f.path_id_name
			,f.path_extra2
			,CASE WHEN SUBSTRING(RTRIM(h.path_TypeClass),2,2) = 'DM' AND  UPPER(RTRIM(f.path_table)) = 'T_IFM' THEN 'IFM' ELSE h.path_TypeClass END AS path_TypeClass
			,CASE WHEN UPPER(h.Path_hName) = 'TODOS LOS SSIS' THEN 1 ELSE 0 END cicle_continua
     FROM  dabarc.t_Sql_process_executeD f
			INNER JOIN dabarc.t_Sql_process_executeH h ON f.path_unickey = h.Path_hKey
     WHERE path_status = 1 AND path_unickey = RTRIM(@Path_hkey) 
     ORDER BY f.path_position ASC;
