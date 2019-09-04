CREATE PROCEDURE [dabarc].[sp_run_Save_Process_execute_ALLSSIS_Anterior] (
					@database_id		INT,
					@execute_user		NVARCHAR(15), 
					@ppath_unickey		NVARCHAR(80)-- Usuario que Ejecuta
)AS

	DECLARE @path_unickey	NVARCHAR(80),
			@run_date		DATETIME,
			@strNameDB		NVARCHAR(60)
	
	------------------------------------------------------------------------------------------------------------
	--- Definición del Proceso
	--- 0 - Validamos la ejecución
	--- 1 - Creamos tablas temporales > misma estructura de las originales
	--- 2 - Validamos algun elemento existe en proceso de ejecución 
	--- 3 - Si no hay ningún elemento y se insertan in tablas originales
	--- 4 - (0) Error Personalizado -> Existem elemento en ejecución
	------------------------------------------------------------------------------------------------------------

	------------------------------------------------------------------------------------------------------------
	--- Validar el Objeto
	------------------------------------------------------------------------------------------------------------

	EXECUTE sp_run_Validate_Process_execute_ALLSSIS @database_id,@execute_user, @ppath_unickey, 1
	
	IF (@@ERROR <> 0)
	    RETURN

	------------------------------------------------------------------------------------------------------------
	--- Tablas Temporales
	------------------------------------------------------------------------------------------------------------


		CREATE TABLE #tmp_Sql_process_executeH( Path_hKey		NVARCHAR(40) NOT NULL,
												Path_hName		NVARCHAR(100) NOT NULL,
												Path_hType		NVARCHAR(50) NULL,
												Path_hDateInitial SMALLDATETIME NOT NULL,
												Path_hUser		NVARCHAR(100) NOT NULL,
												path_hTypeProcess VARCHAR(50) NULL,
												path_TypeClass	NCHAR(10) NULL) 


		CREATE TABLE #tmp_Sql_process_executeD( path_unickey	NVARCHAR(40) NOT NULL,
												path_table		NVARCHAR(30) NULL,
												path_id			INT NULL,
												path_name		NVARCHAR(150) NULL,
												path_type		NVARCHAR(50) NULL,
												path_date		DATETIME NULL,
												path_dateini	SMALLDATETIME NULL,
												path_status		INT NULL,
												path_executeuser NVARCHAR(15) NULL,
												path_priority	INT NULL,
												path_extra		NVARCHAR(200) NULL,
												path_table_padre_id INT NULL,
												path_id_name	NVARCHAR(50) NULL,
												path_extra2		NVARCHAR(100) NULL)
												
	  --CREATE TABLE #tmp_active_Code			  ( path_unickey	NVARCHAR(40) NOT NULL)
		
------------------------------------------------------------------------------------------------------------
	--- 2) Obtener el nombre de base de datos
	------------------------------------------------------------------------------------------------------------
											
	SELECT @strNameDB = name FROM vw_Active_DB WHERE database_id = @database_id

	------------------------------------------------------------------------------------------------------------
	--- Insertamos el datos
	------------------------------------------------------------------------------------------------------------
	SET		@run_date		= GETDATE()
	
	IF (RTRIM(@ppath_unickey) = '')
		SELECT	@path_unickey	= VALOR_INTER FROM dabarc.fnt_get_KeyUnic()
	ELSE
		SELECT	@path_unickey	= @ppath_unickey
		
	
	INSERT INTO #tmp_Sql_process_executeH
				VALUES(	@path_unickey,
						'Todos SSIS ' + RTRIM(@strNameDB),
						'TSSIS',
						GETDATE(),
						@execute_user,
						CASE WHEN RTRIM(@ppath_unickey) = '' THEN 'Proceso' ELSE 'Interfaz' END, 'BOTH')
				

	INSERT INTO #tmp_Sql_process_executeD
				SELECT	@path_unickey,
						't_SSIS',
						ssis_id,
						name,
						'SSIS',
						@run_date,
						null,
						0,
						@execute_user,
						priority,
						path,
						ISNULL(table_id,0),
						'ssis_id',
						NULL
				  FROM vw_Active_SSIS
				  WHERE	 database_id = @database_id
				  ORDER BY priority ASC
				  
				  
	------------------------------------------------------------------------------------------------------------
	--- Buscamos la tabla destino
	------------------------------------------------------------------------------------------------------------


	UPDATE	d
	SET		d.path_extra2 = b.table_createtable
	FROM   #tmp_Sql_process_executeD d
			INNER JOIN t_PlantillaH h ON d.path_extra = '/' + sql_database
			INNER JOIN t_PlantillaD b ON upper(rtrim(d.path_name)) = upper(rtrim(b.table_createssis))
					  

	------------------------------------------------------------------------------------------------------------
	--- Validamos el estatus de la aplicación 
	------------------------------------------------------------------------------------------------------------

	
	IF (SELECT COUNT(*) FROM #tmp_Sql_process_executeD) = 0
	BEGIN
		--RAISERROR('\r c No se encontraron elementos o no están activos.', 16, 1);
		
  RAISERROR (50005,16,1, '','')
		
		RETURN;
	END
	
	------------------------------------------------------------------------------------------------------------
	--- Se manda a execución
	------------------------------------------------------------------------------------------------------------

		INSERT INTO t_Sql_process_executeH(Path_hKey,Path_hName,Path_hType,Path_hDateInitial,Path_hUser,path_hTypeProcess,path_TypeClass)
		SELECT Path_hKey,Path_hName,Path_hType,Path_hDateInitial,Path_hUser,path_hTypeProcess,path_TypeClass FROM #tmp_Sql_process_executeH
		
		INSERT INTO t_Sql_process_executeD(path_unickey, path_table,path_id,path_name,path_type,path_date,path_dateini,path_status,path_executeuser, path_Priority,path_extra, path_table_padre_id, path_id_name,path_extra2)
		SELECT path_unickey,path_table,path_id,path_name,path_type,path_date,path_dateini,path_status,path_executeuser,path_priority,path_extra, path_table_padre_id,path_id_name,path_extra2 FROM #tmp_Sql_process_executeD
