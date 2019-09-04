CREATE PROCEDURE [dabarc].[sp_run_Save_Process_execute_INFO] 
(
   @path_type		nvarchar(100), --Tipo de Objeto --SSIS, RULE, INFO, TBL, DB
   @path_id			int, -- Id 
   @execute_user	nvarchar(15), -- Usuario que Ejecuta
   @ppath_unickey	NVARCHAR(80)
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
	---- VALIDACION
	-----------------------------------------------------------------------------------------
	
	
	EXECUTE sp_run_Validate_Process_execute_INFO @path_type,@path_id,@execute_user,@ppath_unickey,1
	
	IF (@@ERROR <> 0)
	    RETURN
	    
	IF (SELECT	COUNT(*) FROM vw_Active_INFO WHERE Type_Table = @path_type AND report_id	= @path_id) = 0
	BEGIN
		--RAISERROR('El informe no es válido, debe estar activo, tener prioridad y una descripción corta.', 16, 1);
		
  RAISERROR (50007,16,1, '','')
		
		RETURN;
	END

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
												,Path_hTypeProcess
												,path_TypeClass
												,path_id
												,path_Zip)
	SELECT	@path_unickey,
			name,
			'INFO',
			GETDATE(),
			@execute_user,
			CASE WHEN RTRIM(@ppath_unickey) = '' THEN 'Proceso' ELSE 'Interfaz' END,
			@path_type,
			@path_id,
			CAST(SUBSTRING(Separador,3,1) AS INT)
	FROM	vw_Active_INFO
	WHERE	Type_Table	= @path_type
	AND		report_id	= @path_id
		
	-----------------------------------------------------------------------------------------
	---- SI ES UN INFOMR IFM, AGREGAR REGLA
	-----------------------------------------------------------------------------------------

	IF (@path_type = 'IDM')
	BEGIN	
			
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
										 path_table_padre_id,
										 path_id_name)									 
		SELECT  @path_unickey,
				't_RRF',
				rule_id,
				name,
				'RULE',
				GETDATE(),
				NULL,		
				0,
				@execute_user,
				priority,
				null,
				table_id,
				'rule_id'			
		FROM	vw_Active_RULE
		WHERE	info_id = @path_id
		ORDER BY priority ASC
		
		SET @mIdentity = @@IDENTITY
		
		--UPDATE	d
		--SET 	 d.path_table_padre_id = t.database_id		 
		--FROM	 t_Sql_process_executeD d
		--	INNER JOIN t_TFM m ON d.path_table_padre_id = m.table_id 	AND d.path_position = @mIdentity
		--	INNER JOIN t_TDM t ON m.tdm_id = t.table_id
	    
	    UPDATE	 d
		SET 	 d.path_table_padre_id = t.database_id		 
		FROM	 t_Sql_process_executeD d
			INNER JOIN t_TDM t ON d.path_table_padre_id = t.table_id AND d.path_position = @mIdentity
	    
	END
	
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
									 path_table_padre_id,
									 path_id_name,
									 path_extra2)
	SELECT  @path_unickey,
			't_' + @path_type,
			report_id,
			name,
			'INFO',
			GETDATE(),
			NULL,		
			0,
			@execute_user,
			priority,
			'F:' + ISNULL(RTRIM(report_export),'') + ',S:' + ISNULL(RTRIM(report_separator),'') ,
			table_id,
			'report_id',
			Separador
	FROM	dabarc.vw_Active_INFO
	WHERE	Type_Table	= @path_type
	AND		report_id	= @path_id

	SET @mIdentity = @@IDENTITY
	
	
	IF (RTRIM(@path_type) = 'IFF')
	BEGIN
	  UPDATE d
	  SET	 d.path_table_padre_id = t.database_id
	  FROM	t_Sql_process_executeD d
			INNER JOIN t_TFF t ON d.path_table_padre_id = t.table_id AND d.path_position = @mIdentity		    
	END
	
	
	IF (RTRIM(@path_type) = 'IDM')
	BEGIN
		
	UPDATE d
	  SET	 d.path_table_padre_id = t.database_id
	  FROM	t_Sql_process_executeD d
			INNER JOIN t_TDM t ON d.path_table_padre_id = t.table_id AND d.path_position = @mIdentity	
	END
	
	
	IF (RTRIM(@path_type) = 'IFM')
	BEGIN
	
	  UPDATE d
	  SET 	 d.path_table_padre_id = t.database_id		 
	  FROM	 t_Sql_process_executeD d
		INNER JOIN t_TFM m ON d.path_table_padre_id = m.table_id AND d.path_position = @mIdentity	
		INNER JOIN t_TDM t ON m.tdm_id = t.table_id

	END

	------------------------------------------------------------------------------------------------------------
	--- Cambiar de Estado a programado los elementos de esta ejecución
	------------------------------------------------------------------------------------------------------------

    EXECUTE [sp_log_InExecuteUpdateAllProcess] @path_unickey, 'INFO', @execute_user

RETURN
