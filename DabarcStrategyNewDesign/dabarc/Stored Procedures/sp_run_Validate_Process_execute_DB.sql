--EXECUTE [dabarc].[sp_run_Validate_Process_execute_DB] 'BDF',10,'admin',null,0

	
	
CREATE PROCEDURE [dabarc].[sp_run_Validate_Process_execute_DB] (
   @path_type		NVARCHAR(10), --Tipo de Objeto -- t_DBF, t_DBM
   @path_id			INt, -- Id   
   @execute_user	NVARCHAR(15), -- Usuario que Ejecuta
   @ppath_unickey	NVARCHAR(80),
   @IsOnlyError		BIT -- Si es true, solo muestra mensaje de errror si esta bloqueado
)AS

	DECLARE @strSql_return	NVARCHAR(900),
			@path_unickey	NVARCHAR(80),
			@name			NVARCHAR(200),
			@str_sql		VARCHAR(4000),
			@run_date		DATETIME,
			@Table_Id		INT
	
	DECLARE @str_TBLE		CHAR(3),
			@str_Rule		CHAR(3),
			@str_Info		CHAR(3)

	DECLARE @bolSsis		BIT,
			@bolRule		BIT,
			@bolInfo		BIT
	------------------------------------------------------------------------------------------------------------
	--- Tablas Temporales
	------------------------------------------------------------------------------------------------------------
	
	SELECT	@strSql_return = ''
	SET		@run_date = GETDATE()
	

		CREATE TABLE #TBL_TMP ( Nombre			VARCHAR(50),
								BolSsis			BIT, 
								BolRule			BIT, 
								BolInfo			BIT)
		
		CREATE TABLE #TBL_BASE(	path_id			int NULL,
								path_table		nvarchar(50) NULL,
								path_name		nvarchar(150) NULL,
								Priority		int,
								path_Order		int,
								path_type		nvarchar(50) NULL,
								path_padreId	int,
								path_NameId		nvarchar(50) NULL,
								path_extra		nvarchar(200) NULL)
							
		CREATE TABLE #tmp_Sql_process_executeH( Path_hKey			NVARCHAR(40) NULL,
												Path_hName			NVARCHAR(100) NOT NULL,
												Path_hType			NVARCHAR(50) NULL,
												Path_hDateInitial	SMALLDATETIME NOT NULL,
												Path_hUser			NVARCHAR(100) NOT NULL,
												path_hTypeProcess	VARCHAR(50) NULL,
												path_TypeClass		NCHAR(10)	NULL) 


		CREATE TABLE #tmp_Sql_process_executeD( path_unickey		NVARCHAR(40) NULL,
												path_table			NVARCHAR(30) NULL,
												path_id				INT NULL,
												path_name			NVARCHAR(150) NULL,
												path_type			NVARCHAR(50) NULL,
												path_date			DATETIME	 NULL,
												path_dateini		SMALLDATETIME NULL,
												path_status			INT NULL,
												path_executeuser	NVARCHAR(15) NULL,
												path_priority		INT NULL,
												path_extra			NVARCHAR(200) NULL,
												path_table_padre_id INT NULL,
												path_id_name		NVARCHAR(50) NULL)							
							
	IF (@path_type = 'BDF')
	BEGIN
		SET @str_TBLE = 'TFF'
	  	SET @str_Rule = 'RFF'
		SET @str_Info = 'IFF'
	END
	ELSE
	BEGIN
		SET @str_TBLE = 'TDM'
	  	SET @str_Rule = 'RDM'
		SET @str_Info = 'IDM'
	END


	------------------------------------------------------------------------------------------------------------
	--- Validamos que la tabla este registrada y activa
	------------------------------------------------------------------------------------------------------------

	SET @str_sql = 'SELECT name,execute_ssis,execute_rules,execute_reports FROM dabarc.t_' + @path_type + ' WHERE registered = 1 and active =  1 and database_id =' +  CAST(@path_id AS CHAR(5)) 	

	INSERT INTO #TBL_TMP EXECUTE(@str_sql)
	
	IF (SELECT COUNT(*) FROM #TBL_TMP) = 0
	BEGIN
	--	RAISERROR('La Base de Datos no es válida, es necesario que esté activa, tenga prioridad y una descripción corta.', 16, 1);
		RAISERROR (50027,16,1, '','')
		RETURN;
	END
	
	SELECT @bolSsis = BolSsis, @bolRule = BolRule , @bolInfo = BolInfo FROM #TBL_TMP
	
	------------------------------------------------------------------------------------------------------------
	--- Ejecución
	------------------------------------------------------------------------------------------------------------


	INSERT INTO 
			#tmp_Sql_process_executeH
	SELECT	@path_unickey,
			Nombre,
			'BASE DE DATOS',
			GETDATE(),
			@execute_user,
			CASE WHEN RTRIM(@ppath_unickey) = '' THEN 'Proceso' ELSE 'Interfaz' END,
			@path_type
	FROM	#TBL_TMP


	DECLARE TBL_DB CURSOR FOR	 
			 
	SELECT	 table_id 
	FROM	 vw_Active_TABLE
	WHERE	 database_id = @path_id 
		 AND Type_Table =  @str_TBLE
	ORDER BY priority		
	
	OPEN	TBL_DB
	FETCH	TBL_DB INTO @Table_Id
	WHILE   (@@FETCH_STATUS = 0 )
	BEGIN
				
	BEGIN TRANSACTION
				

					------------------------------------------------------------------------------------------------------------
					--- Cargamos SSIS
					------------------------------------------------------------------------------------------------------------

						INSERT INTO #TBL_BASE
						SELECT	ssis_id,'t_SSIS',name,priority,1,Type,ISNULL(table_id,0),'ssis_id',path
						FROM	vw_Active_SSIS
						WHERE	table_id = @Table_Id 
								AND Type_Table = @str_TBLE
								AND @bolSsis = 1
					------------------------------------------------------------------------------------------------------------
					--- Cargamos REGLAS
					------------------------------------------------------------------------------------------------------------
						INSERT INTO #TBL_BASE
						SELECT	rule_id,'t_' + @str_Rule,name,priority,2,Type,table_id,'rule_id',''
						FROM	vw_Active_RULE
						WHERE	Type_Table = @str_Rule
								AND table_id = @Table_Id
								AND @bolRule = 1
					
					------------------------------------------------------------------------------------------------------------
					--- Cargamos INFOMES
					------------------------------------------------------------------------------------------------------------
					
						INSERT INTO #TBL_BASE
						SELECT	report_id,'t_' + @str_Info,name,priority,3,Type,table_id,'report_id',''
						FROM	vw_Active_INFO
						WHERE	Type_Table = @str_Info
								AND table_id = @Table_Id
								AND @bolInfo = 1

					------------------------------------------------------------------------------------------------------------
					--- EValuamo si hay tablas abajo
					------------------------------------------------------------------------------------------------------------
					
					DECLARE @TableTfm_Id INT 
					
					IF (@str_TBLE = 'TDM')
					BEGIN

					
						DECLARE TBL_TFM CURSOR FOR	 
					 
						SELECT	table_id 
						FROM	dabarc.vw_Active_TABLE  
						WHERE	Type_Table = 'TFM'						
								AND tdm_id = @Table_Id
						ORDER BY priority		
						OPEN	TBL_TFM
						FETCH	TBL_TFM INTO @TableTfm_Id
						WHILE (@@FETCH_STATUS = 0 )
						BEGIN
						
						BEGIN TRANSACTION

							------------------------------------------------------------------------------------------------------------
							--- Cargamos SSIS
							------------------------------------------------------------------------------------------------------------

								INSERT INTO #TBL_BASE
								SELECT	ssis_id,'t_SSIS',name,priority,4,Type,ISNULL(table_id,0),'ssis_id',path
								FROM	vw_Active_SSIS
								WHERE	table_id = @TableTfm_Id 
										AND Type_Table = 'TFM'
										AND @bolSsis = 1
										
							------------------------------------------------------------------------------------------------------------
							--- Cargamos REGLAS
							------------------------------------------------------------------------------------------------------------
								INSERT INTO #TBL_BASE
								SELECT	rule_id,'t_RFM',name,Priority,5,Type,table_id,'rule_id',''
								FROM	vw_Active_RULE
								WHERE	Type_Table = 'RFM'
										AND table_id = @TableTfm_Id
										AND @bolRule = 1
							
							------------------------------------------------------------------------------------------------------------
							--- Cargamos INFOMES
							------------------------------------------------------------------------------------------------------------										
								INSERT INTO #TBL_BASE
								SELECT	report_id,'t_IFM',name,priority,3,Type,table_id,'report_id',''
								FROM	vw_Active_INFO
								WHERE	Type_Table = 'IFM'
										AND table_id = @TableTfm_Id
										AND @bolInfo = 1

							COMMIT TRANSACTION
							FETCH TBL_TFM INTO @TableTfm_Id
						END
						CLOSE TBL_TFM
						DEALLOCATE TBL_TFM

					END

		COMMIT TRANSACTION
		FETCH TBL_DB INTO @Table_Id
	END
	CLOSE TBL_DB
	DEALLOCATE TBL_DB


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
	--- Validación de Datos / si no hay detalles
	------------------------------------------------------------------------------------------------------------
	
	IF (SELECT COUNT(*) FROM #TBL_BASE) = 0
	BEGIN	
	  --SELECT @name = Path_hName FROM dabarc.t_sql_process_executeH WHERE Path_hKey = @path_unickey	  
	  DELETE FROM t_Sql_process_executeH WHERE Path_hKey = @path_unickey
	--  RAISERROR('La Base de Datos no tiene objetos relacionados.', 16, 1);
	  
	  RAISERROR (50028,16,1, '','')
	END
	
	------------------------------------------------------------------------------------------------------------
	--- Insertar paquete completo dentro de la tabla de trabajo
	------------------------------------------------------------------------------------------------------------
	SET @str_sql = 'INSERT INTO #tmp_Sql_process_executeD(path_unickey,path_table,path_id,path_name,path_type,path_date,path_dateini,path_status,path_executeuser, path_priority, path_table_padre_id,path_id_name,path_extra) '				
	SET @str_sql = @str_sql + 'SELECT ''temporal_01'',path_table,path_id,path_name,path_type,CAST(''' + CONVERT(VARCHAR(12),@run_date,113) + ''' AS DATETIME), null,0,''' + @execute_user + ''',Priority,path_padreId,path_NameId,path_extra FROM #TBL_BASE '
	EXECUTE(@str_sql)

------------------------------------------------------------------------------------------------------------
	--- Validamos el estatus de la ultima aplicación ejecutada y estatus de algun elemento atorado 
	--- Fecha / Usuario / Estatus / Usuario 
	------------------------------------------------------------------------------------------------------------
			
			SELECT		TOP 1 @strSql_return = '\r c Elemento que bloquea' +
						+ ' Proceso: ' + h1.Path_hName 
						+ ' Fecha: ' + convert(varchar(13),h1.Path_hDateInitial,101)
						+ ' Usuario: ' + h1.Path_hUser
						+ ' Estado: (' + RTRIM(CAST(h1.Path_hStatus AS CHAR(2))) + ')' + h1.path_hTypeProcess
						+ ' Tabla: ' + d1.path_table
						+ ' Nombre elemento: ' + d1.path_name
						+ ' Tipo: ' + d1.path_type
						+ ' Estado elemento: ' + RTRIM(SUBSTRING(ISNULL(d1.path_message,'Inicial'),1,500))
			FROM		#tmp_Sql_process_executeD d 
			INNER JOIN 	t_Sql_process_executeD d1 
				ON  d.path_table = d1.path_table 
				AND d.path_id    = d1.path_id 
				AND d.path_type  = d1.path_type 
				AND d.path_extra = d1.path_extra 
				AND d.path_table_padre_id = d1.path_table_padre_id 
				AND d.path_id_name = d1.path_id_name 
			INNER JOIN t_Sql_process_executeH  h1
				ON  d1.path_unickey = h1.Path_hKey	
			WHERE h1.Path_hStatus <= 1 OR h1.Path_hStatus = 3
			ORDER BY d1.path_status DESC
			 --Traduce de acuerdo al lenguaje
            EXECUTE dabarc.sp_run_Validate_Process_traduction  @strSql_return OUTPUT 

--  
	------------------------------------------------------------------------------------------------------------
	--- Estado del ultimo concepto ejecutado 
	--- Fecha / Usuario / Estatus / Usuario 
	------------------------------------------------------------------------------------------------------------
	
			IF (@IsOnlyError = 0)
			BEGIN							
				SELECT		TOP 1 
							@strSql_return = ISNULL(@strSql_return,'') + '\r b Último proceso ' + h1.Path_hName + 
							' Fecha: ' + convert(varchar(13),h1.Path_hDateInitial,101) + 
							' Usuario: ' + h1.Path_hUser + 
							' Estado: ' + ISNULL(h1.path_message,'Inicial')
				FROM #tmp_Sql_process_executeH h 
				INNER JOIN 	t_Sql_process_executeH h1 
							ON  h.Path_hName = h.Path_hName 
							AND h.Path_hType = h1.Path_hType 
							AND h.Path_hType = h1.Path_hType 
				ORDER BY h1.Path_hDateInitial DESC
				 --Traduce de acuerdo al lenguaje
            EXECUTE dabarc.sp_run_Validate_Process_traduction  @strSql_return OUTPUT 

			END
			

			IF(RTRIM(@strSql_return) <> '')
			BEGIN
				   RAISERROR(@strSql_return, 16, 1);
				   RETURN;
			END
