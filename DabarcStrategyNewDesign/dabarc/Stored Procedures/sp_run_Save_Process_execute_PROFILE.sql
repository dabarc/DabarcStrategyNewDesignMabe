CREATE PROCEDURE [dabarc].[sp_run_Save_Process_execute_PROFILE] 
(
   @path_type		nvarchar(100), -- TFF / TDM / TFM
   @path_id			int, -- Id de la tabla
   @intPorcent		int,
   @execute_user	nvarchar(15), -- Usuario que Ejecuta
   @ppath_unickey	nvarchar(80)
)AS


	-----------------------------------------------------------------------------------------
	---- DECLARACIONES
	-----------------------------------------------------------------------------------------
	
	DECLARE @path_unickey	NVARCHAR(80)
	DECLARE @str_sql		VARCHAR(3000)
	DECLARE @run_date		DATETIME
	DECLARE @mIdentity		INT
	
	
	DECLARE @Rule_Id		INT
	

	-----------------------------------------------------------------------------------------
	---- ASIGNACIONEs
	-----------------------------------------------------------------------------------------
	
	IF (RTRIM(@ppath_unickey) = '')
		SELECT	@path_unickey	= VALOR_INTER FROM dabarc.fnt_get_KeyUnic()
	ELSE
		SELECT	@path_unickey	= @ppath_unickey
		
		
	SET		@run_date = GETDATE()

	-----------------------------------------------------------------------------------------
	---- EJECUCIONES
	-----------------------------------------------------------------------------------------

	INSERT INTO t_Sql_process_executeH(	 Path_hKey
												,Path_hName
												,Path_hType
												,Path_hDateInitial
												,Path_hUser
												,path_hTypeProcess
												,path_TypeClass
												,path_id)
	SELECT	@path_unickey,
			name,
			'PROFILE',
			GETDATE(),
			@execute_user,
			CASE WHEN RTRIM(@ppath_unickey) = '' THEN 'Proceso' ELSE 'Interfaz' END,
			@path_type,
			@path_id
			FROM	vw_Active_TABLE
	WHERE	RTRIM(Type_Table) = RTRIM(@path_type)
	AND		table_id	= @path_id
		
	-----------------------------------------------------------------------------------------
	---- INSERTAR DETALLE DE INFORME
	-----------------------------------------------------------------------------------------


	INSERT INTO t_Sql_process_executeD 
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
									 path_extra2,
									 path_table_padre_id)
	SELECT  @path_unickey,
			't_' + @path_type,
			table_id,
			name,
			'PROFILE',
			GETDATE(),
			NULL,		
			0,
			@execute_user,
			priority,
			CAST(@intPorcent AS NCHAR(3)),
			Type_Table,
			database_id
			FROM	dabarc.vw_Active_TABLE
	WHERE	RTRIM(Type_Table) = RTRIM(@path_type)
	AND		table_id	= @path_id

	
	UPDATE	d
	SET		d.path_extra = RTRIM(d.path_extra) + ',' + f.name
	FROM	dabarc.t_Sql_process_executeD d
			INNER JOIN t_BDF f ON d.path_table_padre_id = f.database_id
	WHERE	path_unickey = @path_unickey AND RTRIM(path_extra2) = 'TFF'
	
	
	UPDATE	d
	SET		d.path_extra = RTRIM(d.path_extra) + ',' + f.name
	FROM	dabarc.t_Sql_process_executeD d
			INNER JOIN t_BDM f ON d.path_table_padre_id = f.database_id
	WHERE	path_unickey = @path_unickey AND RTRIM(path_extra2) = 'TDM'
	
	
	UPDATE	d
	SET		d.path_extra = RTRIM(d.path_extra) + ',' + m.name
	FROM	dabarc.t_Sql_process_executeD d
			INNER JOIN t_TDM f ON f.database_id    = d.path_table_padre_id 
			INNER JOIN t_BDM m ON m.database_id = f.database_id
	WHERE	path_unickey = @path_unickey AND RTRIM(path_extra2) = 'TFM'
	
	
RETURN
