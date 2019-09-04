CREATE PROCEDURE [dabarc].[sp_run_Validate_Process_execute_SSIS] 
(   
   @path_id			int, -- Id
   @execute_user	nvarchar(15), -- Usuario que Ejecuta
   @ppath_unickey	NVARCHAR(80),
   @IsOnlyError		BIT

)AS

	-----------------------------------------------------------------------------------------
	---- DECLARACIONES
	-----------------------------------------------------------------------------------------
	
	DECLARE @strSql_return	NVARCHAR(900)
	DECLARE @str_sql	VARCHAR(3000)
	DECLARE @run_date	DATETIME


	SELECT @strSql_return = ''
		
	--IF (SELECT COUNT(*) FROM vw_Active_SSIS WHERE ssis_id = @path_id )	= 0
	--BEGIN
	--	RAISERROR('! No se puede ejecutar el SSIS, es necesario que se active, tenga prioridad y una descripción corta¡', 16, 1);
	--	RETURN;
	--END	
	
	------------------------------------------------------------------------------------------------------------
	--- Tablas Temporales
	------------------------------------------------------------------------------------------------------------

		CREATE TABLE #tmp_Sql_process_executeH( Path_hKey			NVARCHAR(40) NOT NULL,
												Path_hName			NVARCHAR(100) NOT NULL,
												Path_hType			NVARCHAR(50) NULL,
												Path_hDateInitial	SMALLDATETIME NOT NULL,
												Path_hUser			NVARCHAR(100) NOT NULL,
												path_hTypeProcess	VARCHAR(50) NULL,
												path_TypeClass		NCHAR(10) NULL) 


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
												path_id_name		NVARCHAR(50) NULL)
												
	CREATE TABLE #tmp_active_Code			  ( path_unickey		NVARCHAR(40) NOT NULL)	

	-----------------------------------------------------------------------------------------
	---- ASIGNACIONEs
	-----------------------------------------------------------------------------------------

		SET		@run_date = GETDATE()

		INSERT INTO #tmp_Sql_process_executeH
			SELECT	'temporal_01',
				name,
				'SSIS',
				GETDATE(),
				@execute_user,
				CASE WHEN RTRIM(@ppath_unickey) = '' THEN 'Proceso' ELSE 'Interfaz' END,
				Type_Table
		FROM	vw_Active_SSIS	
		WHERE	ssis_id = @path_id
		

		
		INSERT INTO #tmp_Sql_process_executeD
		SELECT	'temporal_01',
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
		FROM	vw_Active_SSIS	
		WHERE	ssis_id = @path_id

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
			
--   --Traduce de acuerdo al lenguaje
            EXECUTE dabarc.sp_run_Validate_Process_traduction  @strSql_return OUTPUT 

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
			
			RETURN
