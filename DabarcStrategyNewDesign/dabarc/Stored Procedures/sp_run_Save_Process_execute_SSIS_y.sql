CREATE PROCEDURE [dabarc].[sp_run_Save_Process_execute_SSIS_y] 
(   
   @path_id			int, -- Id
   @execute_user	nvarchar(15), -- Usuario que Ejecuta
   @ppath_unickey	NVARCHAR(80)

)AS

	-----------------------------------------------------------------------------------------
	---- DECLARACIONES
	-----------------------------------------------------------------------------------------
	
	DECLARE @path_unickey	NVARCHAR(80)
	DECLARE @str_sql	VARCHAR(3000)
	DECLARE @run_date	DATETIME

	-----------------------------------------------------------------------------------------
	---- ASIGNACIONEs
	-----------------------------------------------------------------------------------------
	
	IF (RTRIM(@ppath_unickey) = '')
		SELECT	@path_unickey	= VALOR_INTER FROM dabarc.fnt_get_KeyUnic()
	ELSE
		SELECT	@path_unickey	= @ppath_unickey
		
	SET		@run_date = GETDATE()

	INSERT INTO dabarc.t_Sql_process_executeH(	 Path_hKey
												,Path_hName
												,Path_hType
												,Path_hDateInitial
												,Path_hUser
												,path_hTypeProcess
												,path_TypeClass)
		SELECT	@path_unickey,
			name,
			'SSIS',
			GETDATE(),
			@execute_user,
			CASE WHEN RTRIM(@ppath_unickey) = '' THEN 'Proceso' ELSE 'Interfaz' END,
			Type_Table
	FROM	dabarc.vw_Active_SSIS	
	WHERE	ssis_id = @path_id
	
	
	-----------------------------------------------------------------------------------------
	---- EJECUCIONES
	-----------------------------------------------------------------------------------------
	
	
	
	
	INSERT INTO dabarc.t_Sql_process_executeD 
									(path_unickey,
									 path_table,
									 path_id,
									 path_name,
									 path_type,
									 path_date,
									 path_dateini,
									 path_status,
									 path_executeuser,
									 path_Priority,
									 path_extra,
									 path_table_padre_id,
									 path_id_name)
	SELECT	@path_unickey,
			't_SSIS',
			ssis_id,
			name,
			'SSIS',
			GETDATE(),
			NULL,		
			0,
			@execute_user,
			priority,
			path,
			ISNULL(table_id,0),
			'ssis_id'
	FROM	dabarc.vw_Active_SSIS	
	WHERE	ssis_id = @path_id



	
	
RETURN
