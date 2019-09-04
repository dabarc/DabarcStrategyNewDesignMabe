
CREATE PROCEDURE [dabarc].[sp_run_Save_Process_execute_ALLSSIS] (
					@database_id		INT,
					@execute_user		NVARCHAR(15), 
					@ppath_unickey		NVARCHAR(80),-- Usuario que Ejecuta
					@idFilter           NVARCHAR(MAX)
)AS

	DECLARE @path_unickey	NVARCHAR(80),
			@run_date		DATETIME,
			@strNameDB		NVARCHAR(60),
			@Id_SSIS_Int	INT
			
	
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
												path_TypeClass	NCHAR(10) NULL,
												path_id			INT NULL)


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
												path_extra2		NVARCHAR(100) NULL,
												tssis_pathid BIGINT NULL)
												
	  --CREATE TABLE #tmp_active_Code			  ( path_unickey	NVARCHAR(40) NOT NULL)
	  
	    CREATE TABLE #tmp_filter     			  ( idFilter	int NOT NULL)
		
------------------------------------------------------------------------------------------------------------
	--- 2) Obtener el nombre de base de datos 
	------------------------------------------------------------------------------------------------------------
											
	SELECT @strNameDB = ISNULL(name,'BASE NO ACTIVA') FROM vw_Active_DB WHERE database_id = @database_id
	
	IF(@strNameDB IS NULL)
	BEGIN
		--RAISERROR('\r c Es necesario activar la Base de Datos.', 16, 1);
		
  RAISERROR (50004,16,1, '','')
		RETURN;
	END
	
	------------------------------------------------------------------------------------------------------------
	--- Insertar temporal de ID
	------------------------------------------------------------------------------------------------------------
	
	IF @idFilter = ''
	BEGIN
		INSERT INTO #tmp_filter 
		SELECT	ssis_id
		FROM dabarc.vw_Active_SSIS
		WHERE	 database_id = @database_id
		ORDER BY priority ASC
	END
	ELSE
	BEGIN
		SET @idFilter = SUBSTRING (@idFilter, 1, Len(@idFilter) - 1 )
		INSERT INTO #tmp_filter 
		   SELECT * FROM dabarc.splitstring(@idFilter)
	END   
	
			
	------------------------------------------------------------------------------------------------------------
	--- Insertamos los datos
	------------------------------------------------------------------------------------------------------------
	SET		@run_date		= GETDATE()
	
	IF (RTRIM(@ppath_unickey) = '')
		SELECT	@path_unickey	= VALOR_INTER FROM fnt_get_KeyUnic()
	ELSE
		SELECT	@path_unickey	= @ppath_unickey

				
	
	INSERT INTO #tmp_Sql_process_executeH
				VALUES(	@path_unickey,
						'Todos SSIS ' + RTRIM(@strNameDB),
						'TSSIS',
						GETDATE(),
						@execute_user,
						CASE WHEN RTRIM(@ppath_unickey) = '' THEN 'Proceso' ELSE 'Interfaz' END, 'DBSS',
						@database_id)
								

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
						NULL,
						@path_unickey
				  FROM vw_Active_SSIS v
				  INNER JOIN #tmp_filter f
				  ON f.idFilter = v.ssis_id
				  WHERE	 database_id = @database_id
				  ORDER BY priority ASC
				  
				  
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
	--- Validamos el estatus de la aplicación 
	------------------------------------------------------------------------------------------------------------

	
	IF (SELECT COUNT(*) FROM #tmp_Sql_process_executeD) = 0
	BEGIN
	--	RAISERROR('\r c No se encontraron elementos o no están activos.', 16, 1);
		
		
  RAISERROR (50005,16,1, '','')
		
		RETURN;
	END
	
	------------------------------------------------------------------------------------------------------------
	--- Mandamos a ejecutarlo de uno en uno para 
	------------------------------------------------------------------------------------------------------------

		DECLARE TBL_SSIS CURSOR FOR	 
	 
		SELECT	path_id 
		FROM	#tmp_Sql_process_executeD 
		ORDER BY path_priority ASC
		
		OPEN	TBL_SSIS
		FETCH	TBL_SSIS INTO @Id_SSIS_Int
		WHILE (@@FETCH_STATUS = 0 )
		BEGIN		
		  BEGIN TRANSACTION
		
		
				SELECT	@path_unickey	= VALOR_INTER FROM fnt_get_KeyUnic()
				
				INSERT INTO t_Sql_process_executeH(Path_hKey,Path_hName,Path_hType,Path_hDateInitial,Path_hUser,path_hTypeProcess,path_TypeClass,path_id)
				SELECT @path_unickey,Path_hName,Path_hType,Path_hDateInitial,Path_hUser,path_hTypeProcess,path_TypeClass,path_id FROM #tmp_Sql_process_executeH
				
				INSERT INTO t_Sql_process_executeD(path_unickey, path_table,path_id,path_name,path_type,path_date,path_dateini,path_status,path_executeuser, path_priority,path_extra, path_table_padre_id, path_id_name,path_extra2, tssis_pathid)
				SELECT @path_unickey,path_table,path_id,path_name,path_type,path_date,path_dateini,path_status,path_executeuser,path_priority,path_extra, path_table_padre_id,path_id_name,path_extra2, path_unickey FROM #tmp_Sql_process_executeD WHERE path_id = @Id_SSIS_Int

				------------------------------------------------------------------------------------------------------------
				--- Cambiar de Estado a programado los elementos de esta ejecución
				------------------------------------------------------------------------------------------------------------

				EXECUTE [sp_log_InExecuteUpdateAllProcess] @path_unickey, 'SSIS', @execute_user
			    
					COMMIT TRANSACTION
			FETCH TBL_SSIS INTO @Id_SSIS_Int
		END
		CLOSE TBL_SSIS
		DEALLOCATE TBL_SSIS
