

CREATE PROCEDURE [dabarc].[sp_run_RealRowResultProcess_ES] @ppath_unickey	NVARCHAR(80) AS 



   DECLARE @MessagueDetails NVARCHAR(2000)
   DECLARE @PATH_TYPE NVARCHAR(20)
   DECLARE @PATHID NVARCHAR(100)
   DECLARE @IsType AS CHAR(4)
 
	 --DECLARE @ppath_unickey  AS NVARCHAR(80)
	 --SET @ppath_unickey = '20140623125021'

-- Tipo sencillo (Regla. informe y ssis)
-- Tipo completo (tabla y base de datos)
-- Tipo Interfaz

	------------------------------------------------------------------------------------------------------------------------------------
	---- La notificaciones para TODOS los SSIS se lanza cuando todos terminaron de ejecutarse
	------------------------------------------------------------------------------------------------------------------------------------
		  SET @IsType = 'BASS'

		  IF (SELECT COUNT(*) FROM t_Sql_process_executeH WHERE RTRIM(Path_hType) = 'TSSIS' AND Path_hKey = @ppath_unickey) > 0
		  BEGIN
			-- Obtenemos el objeto clave que agrupa el objeto 
			IF	(SELECT	COUNT(*) - SUM(CASE WHEN path_status >=3 THEN 1 ELSE 0 END) 
				FROM	t_Sql_process_executeD d
				WHERE	tssis_pathid = (	SELECT	tssis_pathid 
											FROM	t_Sql_process_executeD 
											WHERE	path_unickey = @ppath_unickey)) > 0
				RETURN
			ELSE
			BEGIN
				SET @IsType = 'TSIS'
				SELECT	@ppath_unickey = tssis_pathid FROM	t_Sql_process_executeD WHERE	path_unickey = @ppath_unickey
			END
		  END

	------------------------------------------------------------------------------------------------------------------------------------
	---- Para la interfaces tambien se valida que todo proceso termino
	------------------------------------------------------------------------------------------------------------------------------------


		  IF (SELECT COUNT(*) FROM t_Sql_process_executeH WHERE UPPER(RTRIM(path_hTypeProcess)) = 'INTERFAZ' AND Path_hKey = @ppath_unickey) > 0
		  BEGIN
		   
		  IF (SELECT COUNT(*) - SUM(CASE WHEN d.Path_hStatus >=3 THEN 1 ELSE 0 END) 
		   FROM t_Sql_process_executeH d
				INNER JOIN t_LogInterfacesN l  ON d.Path_hKey = l.execute_unickey
				INNER JOIN t_LogInterfacesN l1 ON l.tssis_pathid = l1.tssis_pathid AND l1.execute_unickey = @ppath_unickey) > 0
			RETURN
		  ELSE
			 SET @IsType = 'INTE'
		  END

	------------------------------------------------------------------------------------------------------------------------------------
	---- Si el elemento no pertenece a una interfaz , verificamos is no  un agrupador 
	------------------------------------------------------------------------------------------------------------------------------------

	IF (SELECT COUNT(*) FROM t_Sql_process_executeH WHERE UPPER(RTRIM(path_hTypeProcess)) <> 'INTERFAZ' AND RTRIM(Path_hType) IN ('BASE DE DATOS','TABLA') AND RTRIM(Path_hKey) = @ppath_unickey ) > 0
		SET @IsType = 'COMP'
		    

 -------------------------------------------------------------------------------------------------------------------
  -- Crear una tabla de salida y temporales 
 -------------------------------------------------------------------------------------------------------------------

   CREATE TABLE #tempResultUSE (object_id		nvarchar(12),
   								object_position	int,
								object_type		nvarchar(12),
								object_str		nvarchar(max),
								mail_message	nvarchar(max),
								object_status	nvarchar(2000),
								object_link		nvarchar(max))							

  CREATE TABLE #tempMessageH (Time_string nvarchar(100), Count_string nvarchar(100))	
 
  -------------------------------------------------------------------------------------------------------------------
  -- Verificamos se es una ejecución de Todos los SSIS o Normal
  ------------------------------------------------------------------------------------------------------------------

	
	IF (RTRIM(@IsType) <> 'INTE')
	BEGIN
		-- Agregamos el Titulo
			INSERT INTO #tempResultUSE	 
			SELECT Obj, 0, 'HEAD', Objeto, Ejecuto, Objeto_Type,NULL 
			FROM (	 
				 SELECT			DISTINCT	
								dabarc.fnt_ObjectIdAndType(path_id, CASE WHEN RTRIM(Path_hType) = 'SSIS' THEN Path_hType ELSE path_TypeClass END) as Obj, 
								Path_hName + ' (' + Path_hType + ')'	AS Objeto,
								Path_hType								AS Objeto_Type,
								'<b>Solicitó:</b> ' + RTRIM(Path_hUser)		AS Ejecuto
				 FROM			t_Sql_process_executeH 
				 WHERE			Path_hKey = @ppath_unickey) AS X
	END
	ELSE
	BEGIN
	
		INSERT INTO #tempResultUSE	
		SELECT Obj, 0, 'HEAD', Objeto, Ejecuto, Objeto_Type,NULL 
		FROM (	
			SELECT DISTINCT	
							dabarc.fnt_ObjectIdAndType(path_id, CASE WHEN RTRIM(Path_hType) = 'SSIS' THEN Path_hType ELSE path_TypeClass END) as Obj, 
							Path_hName + ' (' + Path_hType + ')'	AS Objeto,
							Path_hType								AS Objeto_Type,
							'<b>Solicitó:</b> ' + RTRIM(Path_hUser)		AS Ejecuto,
							d.Path_hKey								AS Orden
			FROM t_Sql_process_executeH d
					INNER JOIN t_LogInterfacesN l  ON d.Path_hKey = l.execute_unickey
					INNER JOIN t_LogInterfacesN l1 ON l.tssis_pathid = l1.tssis_pathid AND l1.execute_unickey = @ppath_unickey  ) AS X ORDER BY Orden ASC
	END
				 
				 
  ---------------------------------------------------------------------------------------------------------------------
  --  Identificar tipo de objeto es TSSIS
  ---------------------------------------------------------------------------------------------------------------------
 		SELECT @PATHID	= object_status  FROM #tempResultUSE
 		
   ---------------------------------------------------------------------------------------------------------------------
  --  Contar Elementos Correctos
  ----------------------------------------------------------------------------------------------------------------------
  
  IF (RTRIM(@IsType) <> 'INTE')
	BEGIN
	INSERT INTO #tempMessageH
		SELECT	'<b>Tiempo de ejecución:</b> ' + 
				UPPER(CONVERT( NVARCHAR(22),MIN(path_dateini),100)) + ' - ' + 
				UPPER(CONVERT( NVARCHAR(22), MAX(path_datefin),100)) AS Mensaje, 
				'<b>Elementos correctos:</b> ' + 
				RTRIM(CAST(SUM(CASE WHEN path_status = 4 THEN 1 ELSE 0 END) AS CHAR(4))) + ' de ' + 
				RTRIM(CAST(COUNT(path_status) AS CHAR(4))) AS Mensaje2
		FROM	t_Sql_process_executeD  
		WHERE	((@PATHID = 'TSSIS' AND RTRIM(tssis_pathid) = @ppath_unickey) OR 
				(@PATHID <> 'TSSIS' AND RTRIM(path_unickey) = @ppath_unickey))
	END
 ELSE
   BEGIN
       INSERT INTO	 #tempMessageH
			SELECT	'<b>Tiempo de ejecución:</b> ' + 
					UPPER(CONVERT( NVARCHAR(22),MIN(d.path_dateini),100)) + ' - ' + 
					UPPER(CONVERT( NVARCHAR(22), MAX(d.path_datefin),100)) AS Mensaje,
					'<b>Elementos correctos:</b> ' + 
					RTRIM(CAST(SUM(CASE WHEN d.path_status = 4 THEN 1 ELSE 0 END) AS CHAR(4))) + ' de ' + 
					RTRIM(CAST(COUNT(d.path_status) AS CHAR(4))) AS Mensaje1
			FROM t_Sql_process_executeD d
					INNER JOIN t_LogInterfacesN l  ON d.path_unickey = l.execute_unickey
					INNER JOIN t_LogInterfacesN l1 ON l.tssis_pathid = l1.tssis_pathid AND l1.execute_unickey = @ppath_unickey 

   END
   
	INSERT INTO	 #tempResultUSE
	   SELECT null,2,'DET', NULL, Time_string , null , null FROM #tempMessageH
	   UNION
	   SELECT null,3,'DET', NULL, Count_string , null , null FROM #tempMessageH

   ---------------------------------------------------------------------------------------------------------------------
  --  Detalle de Ejecución
  ----------------------------------------------------------------------------------------------------------------------

  IF (RTRIM(@IsType) <> 'INTE')
	BEGIN
		INSERT INTO	 #tempResultUSE
		SELECT	o.objectid, 
				d.path_position, 
				o.object_type ,
				d.path_name + CASE WHEN o.object_type = 'IFF' OR o.object_type = 'IDM' OR o.object_type = 'IFM'  THEN '.' + SUBSTRING(LOWER(d.path_extra),3, LEN(d.path_extra)-2) ELSE '' END, 
				o.short_description, 
				path_message,
				NULL 
		FROM	t_Sql_process_executeD  d
				LEFT OUTER JOIN vw_Active_Objects o ON d.path_id = o.objectid AND UPPER(RTRIM(d.path_table)) = UPPER(RTRIM(o.table_name))
		WHERE	(@PATHID = 'TSSIS' AND RTRIM(tssis_pathid) = @ppath_unickey ) OR (@PATHID <> 'TSSIS' AND RTRIM(path_unickey) = @ppath_unickey)
   END
   ELSE
   BEGIN
   
   		INSERT INTO	 #tempResultUSE
		SELECT	o.objectid, 
				d.path_position, 
				o.object_type ,
				d.path_name + CASE WHEN o.object_type = 'IFF' OR o.object_type = 'IDM' OR o.object_type = 'IFM'  THEN '.' + SUBSTRING(LOWER(d.path_extra),3, LEN(d.path_extra)-2) ELSE '' END, 
				o.short_description, 
				path_message,
				NULL 
		FROM	t_Sql_process_executeD  d
				LEFT OUTER JOIN vw_Active_Objects o ON d.path_id = o.objectid AND UPPER(RTRIM(d.path_table)) = UPPER(RTRIM(o.table_name))
				INNER JOIN t_LogInterfacesN l  ON d.path_unickey = l.execute_unickey
				INNER JOIN t_LogInterfacesN l1 ON l.tssis_pathid = l1.tssis_pathid AND l1.execute_unickey = @ppath_unickey 
		ORDER BY d.path_unickey, d.path_position ASC				

   END
	
	-- Colocamos la extencion a los nombres de los objetos para forma los reportes
	UPDATE	#tempResultUSE 
	SET		object_str = SUBSTRING(object_str,1,CHARINDEX(',',object_str,1)-1)
	WHERE   RTRIM(object_type) IN ('IFF','IDM','IFM')
	
	-- Cambiamos la extension xml o xls que es el formato de salida
	UPDATE	#tempResultUSE 
	SET		object_str = REPLACE(object_str,'.xml','.xls')
	WHERE   RTRIM(object_type) IN ('IFF','IDM','IFM')
	
  ---------------------------------------------------------------------------------------------------------------------
  --  Obtenemos el Link donde debio de quedar los reportes 
  ----------------------------------------------------------------------------------------------------------------------

	UPDATE t
	SET t.object_link = b.name + '\' + f.name FROM t_BDF b
		INNER JOIN t_TFF f ON b.database_id = f.database_id
		INNER JOIN t_IFF i ON f.table_id    = i.table_id
		INNER JOIN #tempResultUSE t ON i.report_id = t.object_id AND RTRIM(t.object_type) = 'IFF'
		


	UPDATE t
	SET t.object_link = b.name + '\' + f.name FROM t_BDM b
		INNER JOIN t_TDM f ON b.database_id = f.database_id
		INNER JOIN t_IDM i ON f.table_id    = i.table_id
		INNER JOIN #tempResultUSE t ON i.report_id = t.object_id AND RTRIM(t.object_type) = 'IDM'
		
		
	UPDATE t
	SET t.object_link = b.name + '\' + f.name FROM t_BDM b
		INNER JOIN t_TDM d ON b.database_id = d.database_id
		INNER JOIN t_TFM f ON d.table_id = f.tdm_id
		INNER JOIN t_IFM i ON f.table_id = i.table_id
		INNER JOIN #tempResultUSE t ON i.report_id = t.object_id AND RTRIM(t.object_type) = 'IFM'
				
		SELECT * FROM #tempResultUSE ORDER BY object_position
		
	RETURN
