
CREATE PROCEDURE [dabarc].[sp_run_RealRowResultProcess_anterior] @ppath_unickey	NVARCHAR(80) AS 


 
 -------------------------------------------------------------------------------------------------------------------
  -- Crear una tabla de salida 
 -------------------------------------------------------------------------------------------------------------------
  
 -- DROP TABLE #tempResultUSE
  
   CREATE TABLE #tempResultUSE (object_id		nvarchar(12),
   								object_position	int,
								object_type		nvarchar(12),
								object_str		nvarchar(max),
								mail_message	nvarchar(max),
								object_status	nvarchar(30),
								object_link		nvarchar(max))							

 DECLARE @MessagueDetails NVARCHAR(2000)
 DECLARE @PATH_TYPE NVARCHAR(20)
 DECLARE @PATHID NVARCHAR(100)
 
	 ----DECLARE @ppath_unickey  AS NVARCHAR(80)
  ----   SET @ppath_unickey = '20140602150404'
	--SET @ppath_unickey = '20140519182620'


  -------------------------------------------------------------------------------------------------------------------
  -- Verificamos se es una ejecución de Todos los SSIS o Normal
  ------------------------------------------------------------------------------------------------------------------
 
		-- Agregamos el Titulo
			INSERT INTO #tempResultUSE	 
			SELECT Obj, 0, 'HEAD', Objeto, Ejecuto, Objeto_Type,NULL 
			FROM (	 
				 SELECT			DISTINCT	
								dabarc.fnt_ObjectIdAndType(path_id, CASE WHEN RTRIM(Path_hType) = 'SSIS' THEN Path_hType ELSE path_TypeClass END) as Obj, 
								Path_hName + ' (' + Path_hType + ')'	AS Objeto,
								Path_hType								AS Objeto_Type,
								'Solicito : ' + RTRIM(Path_hUser)		AS Ejecuto
				 FROM			dabarc.t_Sql_process_executeH 
				 WHERE			Path_hKey = @ppath_unickey) AS X

  ---------------------------------------------------------------------------------------------------------------------
  --  Identificar tipo de objeto (TSSIS, Sencillo y complejo)
  ---------------------------------------------------------------------------------------------------------------------
 		SELECT @PATHID	= object_status  FROM #tempResultUSE
 		
   ---------------------------------------------------------------------------------------------------------------------
  --  Contar Elementos Correctos
  ----------------------------------------------------------------------------------------------------------------------
  
     INSERT INTO #tempResultUSE
			 SELECT null,1,'DET', NULL, Mensaje, null , null
			 FROM (	
					SELECT	'Tiempo de ejecución:  ' + UPPER(CONVERT( NVARCHAR(22),MIN(path_dateini),100)) + ' - ' + 
							UPPER(CONVERT( NVARCHAR(22), MAX(path_datefin),100)) AS Mensaje
					FROM	dabarc.t_Sql_process_executeD  
					WHERE	path_status = 4 AND ((@PATHID = 'TSSIS' AND RTRIM(tssis_pathid) = @ppath_unickey ) 
							OR (@PATHID <> 'TSSIS' AND RTRIM(path_unickey) = @ppath_unickey))) AS X
	
	
    INSERT INTO	 #tempResultUSE
			 SELECT null,2,'DET', NULL, Mensaje, null , null
			 FROM (	
					SELECT	'Elementos Correctos : ' + RTRIM(CAST(SUM(CASE WHEN path_status = 4 THEN 1 ELSE 0 END) AS CHAR(4))) + ' de ' + 
							RTRIM(CAST(COUNT(path_status) AS CHAR(4))) AS Mensaje
					FROM	dabarc.t_Sql_process_executeD  
					WHERE	(@PATHID = 'TSSIS' AND RTRIM(tssis_pathid) = @ppath_unickey ) OR (@PATHID <> 'TSSIS' AND RTRIM(path_unickey) = @ppath_unickey)) AS X

   ---------------------------------------------------------------------------------------------------------------------
  --  Detalle de Ejecución
  ----------------------------------------------------------------------------------------------------------------------

	INSERT INTO	 #tempResultUSE
	SELECT	o.objectid, 
			d.path_position, 
			o.object_type ,
			d.path_name + CASE WHEN o.object_type = 'IFF' OR o.object_type = 'IDM' OR o.object_type = 'IFM'  THEN '.' + SUBSTRING(LOWER(d.path_extra),3, LEN(d.path_extra)-2) ELSE '' END, 
			o.short_description, 
			path_message,
			NULL 
	FROM	dabarc.t_Sql_process_executeD  d
			LEFT OUTER JOIN dabarc.vw_Active_Objects o ON d.path_id = o.objectid AND UPPER(RTRIM(d.path_table)) = UPPER(RTRIM(o.table_name))
	WHERE	(@PATHID = 'TSSIS' AND RTRIM(tssis_pathid) = @ppath_unickey ) OR (@PATHID <> 'TSSIS' AND RTRIM(path_unickey) = @ppath_unickey)
	
	UPDATE	#tempResultUSE 
	SET		object_str = SUBSTRING(object_str,1,CHARINDEX(',',object_str,1)-1)
	WHERE   RTRIM(object_type) IN ('IFF','IDM','IFM')
	
	UPDATE	#tempResultUSE 
	SET		object_str = REPLACE(object_str,'.xml','.xls')
	WHERE   RTRIM(object_type) IN ('IFF','IDM','IFM')
	
  ---------------------------------------------------------------------------------------------------------------------
  --  Obtenemos el Link donde debio de quedar los reportes 
  ----------------------------------------------------------------------------------------------------------------------

	UPDATE t
	SET t.object_link = b.name + '\' + f.name FROM dabarc.t_BDF b
		INNER JOIN dabarc.t_TFF f ON b.database_id = f.database_id
		INNER JOIN dabarc.t_IFF i ON f.table_id    = i.table_id
		INNER JOIN #tempResultUSE t ON i.report_id = t.object_id AND RTRIM(t.object_type) = 'IFF'
		


	UPDATE t
	SET t.object_link = b.name + '\' + f.name FROM dabarc.t_BDM b
		INNER JOIN dabarc.t_TDM f ON b.database_id = f.database_id
		INNER JOIN dabarc.t_IDM i ON f.table_id    = i.table_id
		INNER JOIN #tempResultUSE t ON i.report_id = t.object_id AND RTRIM(t.object_type) = 'IDM'
		
		
	UPDATE t
	SET t.object_link = b.name + '\' + f.name FROM dabarc.t_BDF b
		INNER JOIN dabarc.t_TDM d ON b.database_id = d.database_id
		INNER JOIN dabarc.t_TFM f ON d.table_id = f.tdm_id
		INNER JOIN dabarc.t_IFM i ON f.table_id = i.table_id
		INNER JOIN #tempResultUSE t ON i.report_id = t.object_id AND RTRIM(t.object_type) = 'IFM'
				
		SELECT * FROM #tempResultUSE ORDER BY object_position
		
	RETURN	
		
						   
	--select distinct object_id from dabarc.vw_Active_Objects	order by object_id desc
	--select * from dabarc.t_Sql_process_executeD order by path_id  desc				   


 ---------------------------------------------------------------------------------------------------------------------
 -- -- Trabajamos con TSSIS
 --------------------------------------------------------------------------------------------------------------------
	 
 --  IF(RTRIM(@PATH_TYPE) = 'TSSIS')
 --  BEGIN	 
   
	--	IF (SELECT COUNT(*) FROM dabarc.t_Sql_process_executeD WHERE tssis_pathid = @PATHID AND path_status < 3) = 0
	--		BEGIN
 
	--		 INSERT INTO	#tempResultUSE
	--		 SELECT Obj, Objeto + ISNULL(Tiempo,'') + Ejecuto +  Estado 
	--		 FROM (
	--			 SELECT			
	--							dabarc.fnt_ObjectIdAndType(path_id,CASE WHEN RTRIM(Path_hType) = 'SSIS' THEN Path_hType ELSE path_TypeClass END) as Obj, 
	--							'<' + Path_hType + '> ' + Path_hName As Objeto,
	--							'<BR><BR><b>Tiempo de ejecución:</b> ' + UPPER(CONVERT( NVARCHAR(22), Path_hDateInitial,100)) + ' - ' + UPPER(CONVERT( NVARCHAR(22), Path_hDateFinal,100)) As Tiempo,
	--							'<BR> <b>Usuario que ejecutó:</b> ' + RTRIM(Path_hUser)  As Ejecuto,
	--							'<BR> <b>Estado: </b>' + UPPER(path_message) As Estado
	--			 FROM			dabarc.t_Sql_process_executeH 
	--			 WHERE			Path_hKey = @ppath_unickey) AS X
	 
	 
	--		 SELECT @MessagueDetails = '<b>Elementos correctos ' + RTRIM(CAST(SUM(CASE WHEN path_status = 4 THEN 1 ELSE 0 END) AS CHAR(4))) + ' de ' + RTRIM(CAST(COUNT(path_status) AS CHAR(4))) +'</b>'
	--		 FROM	dabarc.t_Sql_process_executeD 
	--		 WHERE	tssis_pathid = @PATHID

	--		 SELECT @MessagueDetails = @MessagueDetails + ISNULL(Mensage,' Termino de forma correcta ') FROM (
	--		 SELECT '<br><br>-Elementos con error:<br><br><' + path_type + '> <b>' + path_name + '</b><br><br><b>Inicio: </b>' + UPPER(CONVERT( NVARCHAR(22),  path_dateini,100)) + ' <br><b>Mensaje:</b> ' + path_message +'<br><br>'  as Mensage,
	--				path_position
	--		 FROM	dabarc.t_Sql_process_executeD  
	--		 WHERE	tssis_pathid = @PATHID AND path_status <> 4) as Temporal 
	--		 ORDER BY path_position ASC
 
	--		INSERT INTO #tempResultUSE VALUES(NULL,@MessagueDetails)
	--		END
			
	--		SELECT * FROM #tempResultUSE
	-- RETURN
	--END

 ---------------------------------------------------------------------------------------------------------------------
 -- -- Trabajamos con procesos sencillos
 --------------------------------------------------------------------------------------------------------------------
 -- INSERT INTO	#tempResultUSE
 --SELECT Obj, Objeto + ISNULL(Tiempo,'') + Ejecuto +  Estado 
 --FROM (
	-- SELECT			
	--				dabarc.fnt_ObjectIdAndType(path_id,CASE WHEN RTRIM(Path_hType) = 'SSIS' THEN Path_hType ELSE path_TypeClass END) as Obj, 
	--				'<' + Path_hType + '> ' + Path_hName As Objeto,
	--				'<BR><BR><b>Tiempo de ejecución:</b> ' + UPPER(CONVERT( NVARCHAR(22), Path_hDateInitial,100)) + ' - ' + UPPER(CONVERT( NVARCHAR(22), Path_hDateFinal,100)) As Tiempo,
	--				'<BR> <b>Usuario que ejecutó:</b> ' + RTRIM(Path_hUser)  As Ejecuto,
	--				'<BR> <b>Estado: </b>' + UPPER(path_message) As Estado
	-- FROM			dabarc.t_Sql_process_executeH 
	-- WHERE			Path_hKey = @ppath_unickey) AS X
	 
	 
 --IF (SELECT COUNT(*) FROM dabarc.t_Sql_process_executeD WHERE path_unickey = @ppath_unickey) = 1 
 --BEGIN
	-- INSERT INTO #tempResultUSE
	-- SELECT NULL,'(' + cast(path_status as CHAR(1)) + ') ' + path_message 
	-- FROM	dabarc.t_Sql_process_executeD 
	-- WHERE	path_unickey = @ppath_unickey
 -- END
 --ELSE
 --BEGIN


 --    SELECT @MessagueDetails = 'Elementos correctos ' + CAST(SUM(CASE WHEN path_status = 4 THEN 1 ELSE 0 END) AS CHAR(4)) + ' de ' + CAST(COUNT(path_status) AS CHAR(4)) 
 --    FROM	dabarc.t_Sql_process_executeD 
 --    WHERE	path_unickey = @ppath_unickey

	-- SELECT @MessagueDetails = @MessagueDetails + ISNULL(Mensage,' Termino de forma correcta ') FROM (
	-- SELECT top 1 '<' + path_type + '> ' + path_name + ' Inicio:' + UPPER(CONVERT( NVARCHAR(22),  path_dateini,100)) + ' Mensaje:' + path_message  as Mensage,
	--		path_position
	-- FROM	dabarc.t_Sql_process_executeD  
	-- WHERE	path_unickey = @ppath_unickey AND path_status <> 4) as Temporal 
	-- ORDER BY path_position ASC
 
	-- INSERT INTO #tempResultUSE VALUES(NULL,@MessagueDetails)

 --END

	--SELECT * FROM #tempResultUSE
