--EXEC dabarc.sp_run_Save_Process_execute_SSIS 94, 'admin', '';
CREATE PROCEDURE [dabarc].[sp_run_Save_Process_execute_SSIS] 
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

    -----------------------------------------------------------------------------------------  
	---- VALIDAR PERMISOS DE USUARIO
	-----------------------------------------------------------------------------------------
	
	--DECLARE @permiso BIT
	--EXEC dabarc.sp_SecurityDB @execute_user, 'EXECUTE', @path_id
	--IF (@permiso = 1)
	--RETURN	
	
	-----------------------------------------------------------------------------------------
	---- VALIDAR 
	-----------------------------------------------------------------------------------------
	
	EXECUTE dabarc.sp_run_Validate_Process_execute_SSIS @path_id,@execute_user,@ppath_unickey,1
	
	IF (@@ERROR <> 0)
		RETURN

	IF (SELECT COUNT(*) FROM vw_Active_SSIS WHERE ssis_id = @path_id )	= 0
	BEGIN
		-- RAISERROR('No se puede ejecutar el SSIS, es necesario que se active, tenga prioridad y una descripción corta.', 16, 1);
		
  RAISERROR (50003,16,1, '','')
		RETURN;
	END	
	
	------------------------------------------------------------------------------------------------------------
	--- Tablas Temporales
	------------------------------------------------------------------------------------------------------------

		CREATE TABLE #tmp_Sql_process_executeH( Path_hKey			NVARCHAR(40) NOT NULL,
												Path_hName			NVARCHAR(100) NOT NULL,
												Path_hType			NVARCHAR(50) NULL,
												Path_hDateInitial	SMALLDATETIME NOT NULL,
												Path_hUser			NVARCHAR(100) NOT NULL,
												path_hTypeProcess	VARCHAR(50) NULL,
												path_TypeClass		NCHAR(10) NULL,
												path_id				INT NULL) 


		CREATE TABLE #tmp_Sql_process_executeD(
												path_unickey		NVARCHAR(40) NOT NULL,
												path_table			NVARCHAR(30) NULL,
												path_id				INT NULL,
												path_name			NVARCHAR(150) NULL,
												path_type			NVARCHAR(50) NULL,
												path_date			DATETIME NULL,
												path_dateini		SMALLDATETIME NULL,
												path_status			INT NULL,
												path_executeuser	NVARCHAR(15) NULL,
												path_priority		INT NULL,
												path_extra			NVARCHAR(200) NULL,
												path_table_padre_id INT NULL,
												path_id_name		NVARCHAR(50) NULL,
												path_extra2			NVARCHAR(100) NULL,)
																						
												
	-----------------------------------------------------------------------------------------
	---- ASIGNACIONEs
	-----------------------------------------------------------------------------------------
	
	IF (RTRIM(@ppath_unickey) = '')
		SELECT	@path_unickey	= VALOR_INTER FROM dabarc.fnt_get_KeyUnic()
	ELSE
		SELECT	@path_unickey	= @ppath_unickey
		
	SET		@run_date = GETDATE()

	INSERT INTO #tmp_Sql_process_executeH
		SELECT	@path_unickey,
			name,
			'SSIS',
			GETDATE(),
			@execute_user,
			CASE WHEN RTRIM(@ppath_unickey) = '' THEN 'Proceso' ELSE 'Interfaz' END,
			Type_Table,
			@path_id
	FROM	vw_Active_SSIS	
	WHERE	ssis_id = @path_id
	

	
	INSERT INTO #tmp_Sql_process_executeD
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
			'ssis_id',
			NULL
	FROM	vw_Active_SSIS	
	WHERE	ssis_id = @path_id

	------------------------------------------------------------------------------------------------------------
	--- Buscamos la tabla destino
	------------------------------------------------------------------------------------------------------------


	--UPDATE	d
	--SET		d.path_extra2 = b.table_createtable
	--FROM   #tmp_Sql_process_executeD d
	--		INNER JOIN t_PlantillaH h ON d.path_extra = '/' + sql_database
	--		INNER JOIN t_PlantillaD b ON upper(rtrim(d.path_name)) = upper(rtrim(b.table_createssis))
	
	
	  UPDATE  d
  SET  d.path_extra2 = i.table_createtable
  FROM #tmp_Sql_process_executeD d 
  INNER JOIN (
    SELECT distinct d.table_createtable, 
    d.table_createssis, 
    ('/' + h.sql_database) as sql_database  
    FROM  dabarc.t_PlantillaH h
  INNER JOIN dabarc.t_PlantillaD d ON h.plantilla_id = d.plantilla_id ) i ON i.table_createssis = d.path_name AND i.sql_database = d.path_extra
		
	
	
	
	------------------------------------------------------------------------------------------------------------
	--- Se manda a execución
	------------------------------------------------------------------------------------------------------------

		INSERT INTO t_Sql_process_executeH(Path_hKey,Path_hName,Path_hType,Path_hDateInitial,Path_hUser,path_hTypeProcess,path_TypeClass,path_id)
		SELECT Path_hKey,Path_hName,Path_hType,Path_hDateInitial,Path_hUser,path_hTypeProcess,path_TypeClass,@path_id FROM #tmp_Sql_process_executeH
		
		INSERT INTO t_Sql_process_executeD (	path_unickey, path_table,path_id,path_name,path_type,path_date,path_dateini,path_status,path_executeuser, path_priority,path_extra, path_table_padre_id, path_id_name,path_extra2)
		SELECT path_unickey,path_table,path_id,path_name,path_type,path_date,path_dateini,path_status,path_executeuser,path_priority,path_extra, path_table_padre_id,path_id_name,path_extra2 FROM #tmp_Sql_process_executeD
		
		
			------------------------------------------------------------------------------------------------------------
	--- Cambiar de Estado a programado los elementos de esta ejecución
	------------------------------------------------------------------------------------------------------------
	SELECT @path_unickey
    EXECUTE dabarc.sp_log_InExecuteUpdateAllProcess @path_unickey, 'SSIS', @execute_user

RETURN
