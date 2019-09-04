 
 CREATE PROCEDURE dabarc.sp_rpt_ExecuteListexecute AS

 ---------------------------------------------------------------------------
 -- Borramos datos
 ---------------------------------------------------------------------------
  DELETE FROM t_report_logexec
 
 ---------------------------------------------------------------------------
 -- Insertamos los Objetos TSSIS
 ---------------------------------------------------------------------------
INSERT INTO t_report_logexec	
           (logexec_clave,logexec_Id,logexec_IdParent,logexec_typeO,logexec_name,logexec_dateI
           ,logexec_dateF,logexec_time,logexec_status,logexec_norow,logexec_objerror,logexec_msgerror,logexec_isinterface)
 SELECT h.Path_hKey, 
		h.path_id, 
		h.path_id, 
		'TSSIS' as Typeo,
		h.Path_hName, 
		d.path_dateini,
		d.path_datefin,
		'' as time,
		h.Path_hStatus as status,
		1 As Norow,
		'' As objerror,
		'' As msgerror,
		CASE WHEN UPPER(RTRIM(h.path_hTypeProcess)) = 'INTERFAZ' THEN 1 ELSE 0 END
 FROM 
 dabarc.t_Sql_process_executeH h
    INNER JOIN dabarc.t_Sql_process_executeD d on h.Path_hKey = d.path_unickey AND d.path_unickey  = d.tssis_pathid
 WHERE RTRIM(Path_hType) IN ('TSSIS')		


-- Colocamo los datos de lo ultimos que se ejecuto

  UPDATE de
  SET	 de.logexec_dateF = dFin, de.logexec_norow = CountElement
  FROM   t_report_logexec de
   INNER JOIN (	
		SELECT	l.logexec_clave, MAX(d.path_datefin) dFin, COUNT(*) CountElement
		FROM	dabarc.t_Sql_process_executeD d
			INNER JOIN t_report_logexec l ON d.tssis_pathid = l.logexec_clave
		GROUP BY l.logexec_clave ) i ON de.logexec_clave = i.logexec_clave

-- Elementos con error

  UPDATE de
  SET	 de.logexec_objerror = 'No de Elementos con error :' + CAST(CountElement AS CHAR(5))
  FROM   t_report_logexec de
   INNER JOIN (	
		SELECT	l.logexec_clave, COUNT(*) CountElement
		FROM	dabarc.t_Sql_process_executeD d
			INNER JOIN t_report_logexec l ON d.tssis_pathid = l.logexec_clave
			AND d.path_status <> 4
		GROUP BY l.logexec_clave  ) i ON de.logexec_clave = i.logexec_clave

 ---------------------------------------------------------------------------
 -- Insertamos elementos Base de Datos y Tablas
 ---------------------------------------------------------------------------

 
INSERT INTO t_report_logexec	
           (logexec_clave,logexec_Id,logexec_IdParent,logexec_typeO,logexec_name,logexec_dateI
           ,logexec_dateF,logexec_time,logexec_status,logexec_norow,logexec_objerror,logexec_msgerror,logexec_isinterface)
 SELECT DISTINCT h.Path_hKey, 
		h.path_id, 
		0, 
		h.path_TypeClass,
		h.Path_hName, 
		h.Path_hDateInitial,
		h.Path_hDateFinal,
		'' as time,
		h.Path_hStatus as status,
		1 As Norow,
		'' As objerror,
		'' As msgerror,
		CASE WHEN UPPER(RTRIM(h.path_hTypeProcess)) = 'INTERFAZ' THEN 1 ELSE 0 END
 FROM 
 dabarc.t_Sql_process_executeH h
    INNER JOIN dabarc.t_Sql_process_executeD d on h.Path_hKey = d.path_unickey
 WHERE RTRIM(Path_hType) IN ('BASE DE DATOS')


INSERT INTO t_report_logexec	
           (logexec_clave,logexec_Id,logexec_IdParent,logexec_typeO,logexec_name,logexec_dateI
           ,logexec_dateF,logexec_time,logexec_status,logexec_norow,logexec_objerror,logexec_msgerror,logexec_isinterface)
 SELECT DISTINCT h.Path_hKey, 
		h.path_id, 
		d.path_table_padre_id, 
		h.path_TypeClass,
		h.Path_hName, 
		h.Path_hDateInitial,
		h.Path_hDateFinal,
		'' as time,
		h.Path_hStatus as status,
		1 As Norow,
		'' As objerror,
		'' As msgerror,
		CASE WHEN UPPER(RTRIM(h.path_hTypeProcess)) = 'INTERFAZ' THEN 1 ELSE 0 END
 FROM 
 dabarc.t_Sql_process_executeH h
    INNER JOIN dabarc.t_Sql_process_executeD d on h.Path_hKey = d.path_unickey
 WHERE RTRIM(Path_hType) IN ('TABLA')

		
  UPDATE de
  SET	 de.logexec_norow = CountElement
  FROM   t_report_logexec de
   INNER JOIN (
		 SELECT	l.logexec_clave, COUNT(*) CountElement
		 FROM	dabarc.t_Sql_process_executeD d
			INNER JOIN t_report_logexec l ON d.path_unickey = l.logexec_clave
		 GROUP BY l.logexec_clave  ) i ON de.logexec_clave = i.logexec_clave AND RTRIM(de.logexec_typeO) <> 'TSSIS'
		 

  UPDATE de
  SET	 de.logexec_objerror = path_name,
		 de.logexec_msgerror = path_message
  FROM   t_report_logexec de
   INNER JOIN (		 
		 SELECT path_unickey, 
				path_name,  
				path_message  
		 FROM   dabarc.t_Sql_process_executeD 
		 WHERE  path_status <> 4 ) i ON de.logexec_clave = i.path_unickey AND RTRIM(de.logexec_typeO) <> 'TSSIS'




 ---------------------------------------------------------------------------
 -- Insertamos elementos Unicos
 ---------------------------------------------------------------------------

 INSERT INTO t_report_logexec	
           (logexec_clave,logexec_Id,logexec_IdParent,logexec_typeO,logexec_name,logexec_dateI
           ,logexec_dateF,logexec_time,logexec_status,logexec_norow,logexec_objerror,logexec_msgerror,logexec_isinterface) 
 SELECT distinct Path_hKey, 
		d.path_id, 
		d.path_table_padre_id, --Este contiene el nombre de la base de datos y no de la tabla 
		h.path_TypeClass,
		d.path_name, 
		h.Path_hDateInitial, 
		h.Path_hDateFinal,
		'',
		h.Path_hStatus,
		1 As Element,
		ObjetoError = CASE WHEN h.Path_hStatus <> 4 THEN d.path_name ELSE '' END,
		Error = CASE WHEN h.Path_hStatus <> 4 THEN d.path_message ELSE '' END,
		CASE WHEN UPPER(RTRIM(h.path_hTypeProcess)) = 'INTERFAZ' THEN 1 ELSE 0 END
 FROM	dabarc.t_Sql_process_executeH h
		INNER JOIN dabarc.t_Sql_process_executeD d ON h.Path_hKey = d.path_unickey
 WHERE RTRIM(Path_hType) IN ('INFO','RULE')	
 

UPDATE l
SET l.logexec_IdParent = i.table_id 
FROM t_report_logexec l 
	INNER JOIN (
	 SELECT rule_id as ID, 'RFF' as oTipo, table_id FROM dabarc.t_RFF UNION
	 SELECT rule_id as ID, 'RFM' as oTipo, table_id FROM dabarc.t_RFM UNION
	 SELECT rule_id as ID, 'RDM' as oTipo, table_id FROM dabarc.t_RDM UNION
	 SELECT report_id as ID, 'IFF' as oTipo, table_id FROM dabarc.t_IFF UNION
	 SELECT report_id as ID, 'IFM' as oTipo, table_id FROM dabarc.t_IFM UNION
	 SELECT report_id as ID, 'IDM' as oTipo, table_id FROM dabarc.t_IDM ) i ON l.logexec_Id = i.ID
 
 

 INSERT INTO t_report_logexec	
           (logexec_clave,logexec_Id,logexec_IdParent,logexec_typeO,logexec_name,logexec_dateI
           ,logexec_dateF,logexec_time,logexec_status,logexec_norow,logexec_objerror,logexec_msgerror, logexec_isinterface) 
 SELECT distinct Path_hKey, 
		d.path_id, 
		s.database_id, 
		h.Path_hType,
		d.path_name, 
		h.Path_hDateInitial, 
		h.Path_hDateFinal,
		'',
		h.Path_hStatus,
		1 As Element,
		ObjetoError = CASE WHEN h.Path_hStatus <> 4 THEN d.path_name ELSE '' END,
		Error = CASE WHEN h.Path_hStatus <> 4 THEN d.path_message ELSE '' END,
		CASE WHEN UPPER(RTRIM(h.path_hTypeProcess)) = 'INTERFAZ' THEN 1 ELSE 0 END
 FROM	dabarc.t_Sql_process_executeH h
		INNER JOIN dabarc.t_Sql_process_executeD d ON h.Path_hKey = d.path_unickey
		INNER JOIN dabarc.t_SSIS s ON d.path_id = s.ssis_id 
 WHERE RTRIM(h.Path_hType) IN ('SSIS')	

 ---------------------------------------------------------------------------
 -- Calculamos Tiempo
 ---------------------------------------------------------------------------
  UPDATE t_report_logexec 
  SET logexec_time = 'Min: ' + CAST((DATEDIFF(SECOND,logexec_dateI,logexec_dateF) / 60) AS CHAR(5)) + ' Seg: ' + CAST((DATEDIFF(SECOND,logexec_dateI,logexec_dateF) % 60) AS CHAR(10))  
  WHERE NOT logexec_dateF IS NULL


 ---------------------------------------------------------------------------
 -- Calculamos Tiempo
 ---------------------------------------------------------------------------
  --SELECT * FROM t_report_logexec

  UPDATE E
  SET    E.logexec_lastexec = 1
  FROM   t_report_logexec E
	INNER JOIN (
				  SELECT logexec_Id, 
						 logexec_IdParent , 
						 logexec_typeO, 
						 logexec_name,
						 logexec_isinterface, 
						 max(logexec_dateI) maxima_fecha  
				  FROM  t_report_logexec
				  GROUP BY logexec_Id, 
						 logexec_IdParent , 
						 logexec_typeO, 
						 logexec_name,
						 logexec_isinterface) I ON E.logexec_Id = I.logexec_Id
						 AND  E.logexec_IdParent = I.logexec_IdParent
						 AND  E.logexec_typeO = I.logexec_typeO
						 AND  E.logexec_name = I.logexec_name
						 AND  E.logexec_isinterface = I.logexec_isinterface
						 AND  E.logexec_dateI = I.maxima_fecha
