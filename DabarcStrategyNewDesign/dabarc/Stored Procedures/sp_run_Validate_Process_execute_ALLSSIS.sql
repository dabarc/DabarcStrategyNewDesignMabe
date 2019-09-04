CREATE PROCEDURE [dabarc].[sp_run_Validate_Process_execute_ALLSSIS] (
							@database_id		INT,
							@execute_user	NVARCHAR(15), 
							@ppath_unickey	NVARCHAR(80),
							@IsOnlyError	BIT -- Si es true, solo muestra mensaje de errror si esta bloqueado
)AS

	DECLARE @strSql_return	NVARCHAR(900),
			@strNameDB		NVARCHAR(60)	
	------------------------------------------------------------------------------------------------------------
	--- Definición del Proceso
	--- 1 - Creamos tablas temporales > misma estructura de las originales
	--- 2 - @IsOnlyError(True) Validamos si exite algun proceso bloqueado 
	--- 2 - @IsOnlyError(False) Validamos en que estatus quedo el ultimo proceso ejecutado que contenga el objeto
	------------------------------------------------------------------------------------------------------------

	SELECT @strSql_return = ''
	------------------------------------------------------------------------------------------------------------
	--- (1) Paso --> Tablas Temporales
	------------------------------------------------------------------------------------------------------------


		CREATE TABLE #tmp_Sql_process_executeH( Path_hKey			NVARCHAR(40) NOT NULL,
												Path_hName			NVARCHAR(100) NULL,
												Path_hType			NVARCHAR(50) NULL,
												Path_hDateInitial	SMALLDATETIME NOT NULL,
												Path_hUser			NVARCHAR(100) NOT NULL,
												path_hTypeProcess	VARCHAR(50) NULL,
												path_TypeClass		NCHAR(10)	NULL) 


		CREATE TABLE #tmp_Sql_process_executeD( path_unickey		NVARCHAR(40) NOT NULL,
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
	------------------------------------------------------------------------------------------------------------
	--- 2) Obtener el nombre de base de datos
	------------------------------------------------------------------------------------------------------------

			SELECT @strNameDB = ISNULL(name,'') FROM dabarc.vw_Active_DB WHERE database_id = @database_id
		
			IF(@strNameDB IS NULL AND @database_id IS NOT NULL)
			BEGIN
				--   RAISERROR('\r c Es necesario activar la Base de Datos.', 16, 1);
				  RAISERROR (50004,16,1, '','')
				   RETURN;
			END

	
	------------------------------------------------------------------------------------------------------------
	--- 2) Paso --> Insertamos el datos
	------------------------------------------------------------------------------------------------------------

	INSERT INTO #tmp_Sql_process_executeH
				VALUES(	'temporal_01',
						'Todos SSIS ' + RTRIM(@strNameDB),
						'SSIS',
						GETDATE(),
						@execute_user,
						CASE WHEN RTRIM(@ppath_unickey) = '' THEN 'Proceso' ELSE 'Interfaz' END, 'BOTH')
				

	INSERT INTO #tmp_Sql_process_executeD
				SELECT	'temporal_01',
						't_SSIS',
						ssis_id,
						name,
						'TSSIS',
						GETDATE(),
						null,
						0,
						@execute_user,
						priority,
						path,
						ISNULL(table_id,0),
						'ssis_id'
				  FROM vw_Active_SSIS
				  WHERE	 database_id = @database_id
				  ORDER BY priority,name ASC

		
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
						+ ' Nombre elemento:' + d1.path_name
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
			INNER JOIN dabarc.t_Sql_process_executeH  h1
				ON  d1.path_unickey = h1.Path_hKey	
			WHERE h1.Path_hStatus <= 1
			ORDER BY d1.path_status DESC
			
           --Traduce de acuerdo al lenguaje
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
