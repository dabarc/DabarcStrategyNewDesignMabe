CREATE PROCEDURE [dabarc].[sp_run_Save_Process_execute_RULE] 
(
   @path_type		nvarchar(100), --Tipo de Objeto --RDM, RFF, RFM
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


	-----------------------------------------------------------------------------------------
	---- VALIDACION
	-----------------------------------------------------------------------------------------
	
	
	EXECUTE sp_run_Validate_Process_execute_RULE @path_type,@path_id,@execute_user,@ppath_unickey,1
	
	IF (@@ERROR <> 0)
	    RETURN
	
	IF (SELECT	COUNT(*) FROM vw_Active_RULE WHERE Type_Table	= @path_type AND rule_id = @path_id) = 0
	BEGIN
	--	RAISERROR('La regla no es válida, debe estar activa, tener prioridad y una descripción corta.', 16, 1);
	
	 RAISERROR (50034,16,1, '','')
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
										,path_id)
	SELECT	@path_unickey,
			name,
			'RULE',
			GETDATE(),
			@execute_user,
			CASE WHEN RTRIM(@ppath_unickey) = '' THEN 'Proceso' ELSE 'Interfaz' END,
			@path_type,
			@path_id
	FROM	vw_Active_RULE
	WHERE	Type_Table	= @path_type
	AND		rule_id		= @path_id
	

	
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
			't_' + @path_type,
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
	WHERE	Type_Table	= @path_type
	AND		rule_id		= @path_id
	
	
	SET @mIdentity = @@IDENTITY
	
	
	IF (RTRIM(@path_type) = 'RFF')
	BEGIN
	  UPDATE d
	  SET	 d.path_table_padre_id = t.database_id
	  FROM	t_Sql_process_executeD d
			INNER JOIN t_TFF t ON d.path_table_padre_id = t.table_id AND d.path_position = @mIdentity		    
	END
	
	
	IF (RTRIM(@path_type) = 'RDM')
	BEGIN
		
	UPDATE d
	  SET	 d.path_table_padre_id = t.database_id
	  FROM	t_Sql_process_executeD d
			INNER JOIN t_TDM t ON d.path_table_padre_id = t.table_id AND d.path_position = @mIdentity	
	END
	
	
	IF (RTRIM(@path_type) = 'RFM')
	BEGIN
	
	  UPDATE d
	  SET 	 d.path_table_padre_id = t.database_id		 
	  FROM	 t_Sql_process_executeD d
		INNER JOIN t_TFM m ON d.path_table_padre_id = m.table_id AND d.path_position = @mIdentity	
		INNER JOIN t_TDM t ON m.tdm_id = t.table_id

	END


	IF (RTRIM(@path_type) = 'RRF')
	BEGIN
	
	 -- UPDATE d
	 -- SET 	 d.path_table_padre_id = t.database_id		 
	 -- FROM	 t_Sql_process_executeD d
		--INNER JOIN t_TFM m ON d.path_table_padre_id = m.table_id 	AND d.path_position = @mIdentity
		--INNER JOIN t_TDM t ON m.tdm_id = t.table_id
		
	 UPDATE	 d
	 SET 	 d.path_table_padre_id = t.database_id		 
	 FROM	 t_Sql_process_executeD d
		INNER JOIN t_TDM t ON d.path_table_padre_id = t.table_id AND d.path_position = @mIdentity
	END
	
		------------------------------------------------------------------------------------------------------------
	--- Cambiar de Estado a programado los elementos de esta ejecución
	------------------------------------------------------------------------------------------------------------

    EXECUTE [sp_log_InExecuteUpdateAllProcess] @path_unickey, 'RULE', @execute_user
    
RETURN
