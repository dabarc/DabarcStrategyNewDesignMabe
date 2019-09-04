CREATE PROCEDURE [dabarc].[sp_run_Save_Process_execute_TABLE] (  
   @path_type		nvarchar(100), --Tipo de Objeto -- t_TFF, t_TDM, t_TFM
   @path_id			int, -- Id   
   @execute_user	nvarchar(15), -- Usuario que Ejecuta
   @ppath_unickey	NVARCHAR(80)
)AS

	DECLARE @path_unickey	NVARCHAR(80),
			@str_sql		VARCHAR(4000),
			@run_date		DATETIME,
			@str_Base		CHAR(2)
	
	DECLARE @str_Rule		CHAR(3),
			@str_Info		CHAR(3)
	

	DECLARE @bolSsis		BIT,
			@bolRule		BIT,
			@bolInfo		BIT



	------------------------------------------------------------------------------------------------------------
	--- Validar 
	------------------------------------------------------------------------------------------------------------	
	EXECUTE [dabarc].[sp_run_Validate_Process_execute_TABLE] @path_type, @path_id, @execute_user, @ppath_unickey, 1
		
	IF (@@ERROR <> 0)
	    RETURN

	------------------------------------------------------------------------------------------------------------
	--- Tablas Temporales
	------------------------------------------------------------------------------------------------------------

	IF (RTRIM(@ppath_unickey) = '')
		SELECT	@path_unickey	= VALOR_INTER FROM fnt_get_KeyUnic()
	ELSE
		SELECT	@path_unickey	= @ppath_unickey
	
	SET @run_date = GETDATE()
	SET @str_Base = SUBSTRING(@path_type,2,2)

	CREATE TABLE #TBL_TMP(	Nombre			VARCHAR(50), 
							BolSsis			BIT, 
							BolRule			BIT, 
							BolInfor		BIT,
							Createzip		INT)
	
	CREATE TABLE #TBL_BASE(	path_id			INT NULL,
							path_table		NVARCHAR(50) NULL,
							path_name		NVARCHAR(150) NULL,
							[priority]		INT,
							path_Order		INT,
							path_Order1		INT,
							path_type		NVARCHAR(50) NULL,
							path_padreId	INT,
							path_NameId		NVARCHAR(50) NULL,
							path_extra		NVARCHAR(200) NULL,
							path_extra2		NVARCHAR(200) NULL)
							
	
	SET @str_Rule = 'R' + @str_Base
	SET @str_Info = 'I' + @str_Base



	------------------------------------------------------------------------------------------------------------
	--- Validamos que la tabla este registrada y activa
	------------------------------------------------------------------------------------------------------------

	SET @str_sql = 'SELECT name,execute_ssis,execute_rules,execute_reports,table_createzip FROM dabarc.t_' + @path_type + ' WHERE registered = 1 and active =  1 and priority > 0 AND rtrim(short_description) <> '''' and table_id =' +  CAST(@path_id AS CHAR(5)) 
	INSERT INTO #TBL_TMP EXECUTE(@str_sql)

	IF (SELECT COUNT(*) FROM #TBL_TMP) = 0
	BEGIN
	--	RAISERROR('La tabla no es válida, es necesario que esté registrada y activa.', 16, 1);
		
  RAISERROR (50037,16,1, '','')
		
		RETURN;
	END
	
	SELECT @bolSsis = BolSsis, @bolRule = BolRule , @bolInfo = BolInfor FROM #TBL_TMP
	
	------------------------------------------------------------------------------------------------------------
	--- Header
	------------------------------------------------------------------------------------------------------------

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
				Nombre,
				'TABLA',
				GETDATE(),
				@execute_user,
				CASE WHEN RTRIM(@ppath_unickey) = '' THEN 'Proceso' ELSE 'Interfaz' END,
				@path_type,
				@path_id,
				Createzip
		FROM	#TBL_TMP


			------------------------------------------------------------------------------------------------------------
			--- EValuamo si hay tablas abajo
			------------------------------------------------------------------------------------------------------------
			
			DECLARE @TableTfm_Id INT 
			
			IF (@path_type = 'TDM')
			BEGIN
			
			
			
				DECLARE TBL_TFM CURSOR FOR	 
			 
				SELECT	table_id 
				FROM	t_TFM 
				WHERE	registered = 1 
						AND active = 1 
						AND tdm_id = @path_id
				ORDER BY [priority]		
				OPEN	TBL_TFM
				FETCH	TBL_TFM INTO @TableTfm_Id
				WHILE (@@FETCH_STATUS = 0 )
				BEGIN
				
				BEGIN TRANSACTION
				
					------------------------------------------------------------------------------------------------------------
					--- Cargamos SSIS
					------------------------------------------------------------------------------------------------------------

						INSERT INTO #TBL_BASE
						SELECT	ssis_id,
								't_SSIS',
								name,
								[priority],
								5,0,
								Type,
								ISNULL(table_id,0),
								'ssis_id',
								path,
								''
						FROM	vw_Active_SSIS
						WHERE	table_id = @TableTfm_Id 
								AND Type_Table = 'TFM'						
								AND @bolSsis = 1
						ORDER BY [priority] ASC						

					------------------------------------------------------------------------------------------------------------
					--- Cargamos REGLAS
					------------------------------------------------------------------------------------------------------------
						INSERT INTO #TBL_BASE
						SELECT	rule_id,
								't_RFM',
								name,
								[priority],
								6,0,
								Type,
								table_id,
								'rule_id',
								'',
								''
						FROM	vw_Active_RULE
						WHERE	Type_Table = 'RFM'
								AND table_id = @TableTfm_Id
								AND @bolRule = 1
						ORDER BY [priority] ASC
					
								
					------------------------------------------------------------------------------------------------------------
					--- Cargamos INFOMES
					------------------------------------------------------------------------------------------------------------
						
						INSERT INTO #TBL_BASE
						SELECT	report_id,
								't_IFM',
								name,
								[priority],
								7,0,
								Type,
								table_id,
								'report_id',
								'F:' + ISNULL(RTRIM(report_export),'') + ',S:' + ISNULL(RTRIM(report_separator),''),
								Separador
						FROM	vw_Active_INFO
						WHERE	Type_Table = 'IFM'
								AND table_id = @TableTfm_Id
								AND @bolInfo = 1
						ORDER BY [priority] ASC

					COMMIT TRANSACTION
					FETCH TBL_TFM INTO @TableTfm_Id
				END
				CLOSE TBL_TFM
				DEALLOCATE TBL_TFM

				
				
			END

	------------------------------------------------------------------------------------------------------------
	--- Cargar SSIS
	------------------------------------------------------------------------------------------------------------

		INSERT INTO #TBL_BASE
		SELECT	ssis_id,
				't_SSIS',
				name,
				[priority],
				1,0,
				Type,
				ISNULL(table_id,0),
				'ssis_id',
				path,
				''
		FROM	vw_Active_SSIS
		WHERE	table_id = @path_id 
				AND Type_Table = @path_type
				AND @bolSsis = 1
		ORDER BY [priority] ASC

	------------------------------------------------------------------------------------------------------------
	--- Cargamos REGLAS
	------------------------------------------------------------------------------------------------------------
		INSERT INTO #TBL_BASE
		SELECT	rule_id,
				't_' + @str_Rule,
				name,
				[priority],
				2,0,
				Type,
				table_id,
				'rule_id',
				'',
				''
		FROM	vw_Active_RULE
		WHERE	Type_Table = @str_Rule
				AND table_id = @path_id
				AND @bolRule = 1
		ORDER BY [priority] ASC
	
	
	
	------------------------------------------------------------------------------------------------------------
	--- Cargamos INFORMES
	------------------------------------------------------------------------------------------------------------

		IF (@str_Info = 'IDM' AND @bolInfo = 1)
		BEGIN
				INSERT INTO #TBL_BASE
				SELECT	rule_id,
						't_' + @str_Rule,
						r.name,
						r.priority,
						3,f.priority,
						r.Type,
						r.table_id,
						'rule_id',
						'',
						''
				FROM	vw_Active_RULE r
						INNER JOIN vw_Active_INFO f ON r.info_id = f.report_id AND f.table_id = @path_id 
				WHERE	r.Type_Table = 'RRF'
						AND r.table_id = @path_id
				ORDER BY r.priority ASC
		END
	
		INSERT INTO #TBL_BASE
		SELECT	report_id,
				't_' + @str_Info,
				name,
				priority,
				4,0,
				Type,
				table_id,
				'report_id',
				'F:' + ISNULL(RTRIM(report_export),'') + ',S:' + ISNULL(RTRIM(report_separator),''),
				Separador
		FROM	vw_Active_INFO
		WHERE	Type_Table = @str_Info
				AND table_id = @path_id
				AND @bolInfo = 1
		ORDER BY priority ASC
		
	------------------------------------------------------------------------------------------------------------
	--- Modificamos Base de Datos Padre
	------------------------------------------------------------------------------------------------------------
	
	UPDATE	t
	SET		t.path_padreId = f.database_id
	FROM #TBL_BASE t
		INNER JOIN t_TFF f ON t.path_padreId = f.table_id
	WHERE RTRIM(t.path_table) in ('t_IFF','t_RFF')
		
	
	UPDATE	t
	SET		t.path_padreId = f.database_id
	FROM #TBL_BASE t
		INNER JOIN t_TDM f ON t.path_padreId = f.table_id
	WHERE RTRIM(t.path_table) in ('t_IDM','t_RDM')
	
	
	UPDATE	t
	SET		t.path_padreId = m.database_id
	FROM #TBL_BASE t
		INNER JOIN t_TFM f ON t.path_padreId = f.table_id
		INNER JOIN t_TDM m ON f.tdm_id = m.table_id
	WHERE RTRIM(t.path_table) in ('t_IFM','t_RFM')
	

	------------------------------------------------------------------------------------------------------------
	--- Insertar paquete completo dentro de la tabla de trabajo
	------------------------------------------------------------------------------------------------------------
	SET @str_sql = 'INSERT INTO dabarc.t_Sql_process_executeD (path_unickey,path_table,path_id,path_name,path_type,path_date,path_dateini,path_status,path_executeuser, path_priority, path_table_padre_id,path_id_name,path_extra,path_extra2) '				
	SET @str_sql = @str_sql + 'SELECT ''' + @path_unickey + ''',path_table,path_id,path_name,path_type,CAST(''' + CONVERT(VARCHAR(12),@run_date,113) + ''' AS DATETIME), null,0,''' + @execute_user + ''',Priority,path_padreId,path_NameId,path_extra,path_extra2 FROM #TBL_BASE '
	EXECUTE(@str_sql)


	------------------------------------------------------------------------------------------------------------
	--- Cambiar de Estado a programado los elementos de esta ejecución
	------------------------------------------------------------------------------------------------------------
    EXECUTE [dabarc].[sp_log_InExecuteUpdateAllProcess] @path_unickey, 'TABLE', @execute_user
