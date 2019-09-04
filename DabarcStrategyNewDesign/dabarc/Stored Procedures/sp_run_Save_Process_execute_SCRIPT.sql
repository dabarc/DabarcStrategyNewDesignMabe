CREATE PROCEDURE [dabarc].[sp_run_Save_Process_execute_SCRIPT] 
(
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
	
	--EXECUTE sp_run_Validate_Process_execute_INFO @path_type,@path_id,@execute_user,@ppath_unickey,1
	
	--IF (@@ERROR <> 0)
	--    RETURN
	    
	IF (SELECT	COUNT(*) FROM vw_Active_TRANS WHERE script_id = @path_id) = 0
	BEGIN
		--RAISERROR('La transacción no está activa.', 16, 1);
		 RAISERROR (50044,16,1, '','')
		RETURN;
	END

	--Validamos que no tenga campos no asigando , ni pantallas sin campos
	If (SELECT COUNT(*) FROM t_recording_screen s 
				INNER JOIN   t_recording_fields f ON s.screen_id = f.screen_id 
				AND s.script_id = @path_id AND RTRIM(f.field_fieldview) = '[NA]' ) > 0
	BEGIN
		--RAISERROR('No puedes tener elementos no asignados.', 16, 1);
		 RAISERROR (50046,16,1, '','')
		RETURN;
	END
	
	
	If (SELECT COUNT(*) FROM t_recording_screen s WHERE s.script_id = @path_id AND s.screen_nofields = 0) > 0
	BEGIN
		--RAISERROR('No puedes tener pantallas sin elementos.', 16, 1);
		 RAISERROR (50047,16,1, '','')
		RETURN;
	END
	-----------------------------------------------------------------------------------------
	---- ASIGNACIONES
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
												,path_id
												,path_Zip)
	SELECT	@path_unickey,
			script_name,
			'TRANS',
			GETDATE(),
			@execute_user,
			CASE WHEN RTRIM(@ppath_unickey) = '' THEN 'Proceso' ELSE 'Interfaz' END,
			'RBDM',
			@path_id,
			NULL
	FROM	vw_Active_TRANS 
	WHERE	script_id = @path_id
		

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
			't_recording_script',
			script_id,
			script_name,
			'TRANS',
			GETDATE(),
			NULL,		
			0,
			@execute_user,
			0,
			team_name,
			team_id,
			'script_id',
			Separador
	FROM	vw_Active_TRANS
	WHERE	script_id = @path_id

	SET @mIdentity = @@IDENTITY
	

RETURN
