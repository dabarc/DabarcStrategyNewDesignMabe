CREATE PROCEDURE dabarc.sp_rpt_ExecuteListObject AS

 --------------------------------------------------------------------------------------------------------------------------------
 --- CREACION DE ARBOL DE OBJETOS 
 --- Conjuntamos todos lo objetos en una sola tabla 
 ---
 --------------------------------------------------------------------------------------------------------------------------------

  DELETE FROM t_report_logobject 


 --------------------------------------------------------------------------------------------------------------------------------
 --- Carga de Objetos SSIS
 --------------------------------------------------------------------------------------------------------------------------------
 INSERT INTO t_report_logobject 
	(logobject_Id,logobject_IdParent,logobject_type,logobject_typeP,logobject_name
      ,logobject_descripcion,logobject_active,logobject_typedesc,logobject_datecreate
      ,logobject_lastexecute,logobject_laststatus,logobject_dateprocess)
 SELECT ssis_id, 
		ISNULL(database_id,0), 
		'SSIS', 
		SUBSTRING(s.path,2,3),
		s.name , 
		s.short_description,
		s.active,
		'',
		s.create_date,
		s.execute_date,
		s.status,
		GETDATE()
 FROM   t_SSIS s
 
 --------------------------------------------------------------------------------------------------------------------------------
 --- Carga de Objetos Informes
 --------------------------------------------------------------------------------------------------------------------------------
 
 INSERT INTO t_report_logobject 
	(logobject_Id,logobject_IdParent,logobject_type,logobject_typeP,logobject_name
      ,logobject_descripcion,logobject_active,logobject_typedesc,logobject_datecreate
      ,logobject_lastexecute,logobject_laststatus,logobject_dateprocess)
 SELECT s.report_id, 
		ISNULL(table_id,0), 
		'IFF',
		'TFF',
		s.name , 
		s.short_description,
		s.active,
		'Informe',
		s.create_date,
		s.execute_date,
		s.status,
		GETDATE()
FROM    t_IFF s
UNION
SELECT s.report_id, 
		ISNULL(table_id,0), 
		'IDM',
		'TDM',
		s.name , 
		s.short_description,
		s.active,
		'Informe',
		s.create_date,
		s.execute_date,
		s.status,
		GETDATE()
FROM    t_IDM s
UNION
SELECT s.report_id, 
		ISNULL(table_id,0), 
		'IFM',
		'TFM', 
		s.name , 
		s.short_description,
		s.active,
		'Informe',
		s.create_date,
		s.execute_date,
		s.status,
		GETDATE()
FROM    t_IFM s
 
 --------------------------------------------------------------------------------------------------------------------------------
 ---Carga de Objetos Reglas
 --------------------------------------------------------------------------------------------------------------------------------
 
  
 INSERT INTO t_report_logobject 
	(logobject_Id,logobject_IdParent,logobject_type,logobject_typeP,logobject_name
      ,logobject_descripcion,logobject_active,logobject_typedesc,logobject_datecreate
      ,logobject_lastexecute,logobject_laststatus,logobject_dateprocess)
 SELECT s.rule_id, 
		ISNULL(table_id,0), 
		'RFF',
		'TFF',
		s.name , 
		s.short_description,
		s.active,
		'Reglas',
		s.create_date,
		s.execute_date,
		s.status,
		GETDATE()
FROM    t_RFF s
UNION
SELECT s.rule_id, 
		ISNULL(table_id,0), 
		'RFM',
		'TFM', 
		s.name , 
		s.short_description,
		s.active,
		'Reglas',
		s.create_date,
		s.execute_date,
		s.status,
		GETDATE()
FROM    t_RFM s
UNION
SELECT s.rule_id, 
		ISNULL(table_id,0), 
		'RDM',
		'TDM', 
		s.name, 
		s.short_description,
		s.active,
		'Reglas',
		s.create_date,
		s.execute_date,
		s.status,
		GETDATE()
FROM    t_RDM s

 --------------------------------------------------------------------------------------------------------------------------------
 --- Carga de Objetos Tablas
 --------------------------------------------------------------------------------------------------------------------------------
 
  
 INSERT INTO dabarc.t_report_logobject 
	(logobject_Id,logobject_IdParent,logobject_type,logobject_typeP,logobject_name
      ,logobject_descripcion,logobject_active,logobject_typedesc,logobject_datecreate
      ,logobject_lastexecute,logobject_laststatus,logobject_dateprocess)
 SELECT s.table_id, 
		ISNULL(s.database_id,0), 
		'TFF',
		'BDF',
		s.name , 
		s.short_description,
		s.active,
		'Tabla',
		s.create_date,
		s.execute_date,
		s.status,
		GETDATE()
FROM    t_TFF s
UNION
SELECT s.table_id, 
		ISNULL(s.tdm_id,0), 
		'TFM',
		'TDM', 
		s.name , 
		s.short_description,
		s.active,
		'Tabla',
		s.create_date,
		s.execute_date,
		s.status,
		GETDATE()
FROM    t_TFM s
UNION
SELECT s.table_id, 
		ISNULL(database_id,0), 
		'TDM',
		'BDM',
		s.name , 
		s.short_description,
		s.active,
		'Tabla',
		s.create_date,
		s.execute_date,
		s.status,
		GETDATE()
FROM    t_TDM s
 
 --------------------------------------------------------------------------------------------------------------------------------
 --- Carga de Objetos Base de Datos
 --------------------------------------------------------------------------------------------------------------------------------
 
  
 INSERT INTO dabarc.t_report_logobject 
	(logobject_Id,logobject_IdParent,logobject_type,logobject_typeP,logobject_name
      ,logobject_descripcion,logobject_active,logobject_typedesc,logobject_datecreate
      ,logobject_lastexecute,logobject_laststatus,logobject_dateprocess)
 SELECT s.database_id, 
		0, 
		'BDF', 
		'',
		s.name , 
		s.short_description,
		s.active,
		'Base de Datos',
		s.create_date,
		s.execute_date,
		s.status,
		GETDATE()
FROM    t_BDF s
UNION
SELECT s.database_id, 
		0, 
		'BDM', 
		'',
		s.name , 
		s.short_description,
		s.active,
		'Base de Datos',
		s.create_date,
		s.execute_date,
		s.status,
		GETDATE()
FROM    t_BDM s

------------------------------------------------------------------------------------------------------------------------------
--- Carga de Objetos Todos los SSIS
------------------------------------------------------------------------------------------------------------------------------

 INSERT INTO dabarc.t_report_logobject 
	(logobject_Id,logobject_IdParent,logobject_type,logobject_typep,logobject_name
      ,logobject_descripcion,logobject_active,logobject_typedesc,logobject_datecreate
      ,logobject_lastexecute,logobject_laststatus,logobject_dateprocess)
 SELECT s.database_id, 
		s.database_id, 
		'TSSIS',
		SUBSTRING(t.path,2,3),
		'Todos los SSIS ' + s.name , 
		s.short_description,
		s.active,
		'Base de Datos',
		s.create_date,
		s.execute_date,
		s.status,
		GETDATE()
FROM    t_BDF s 
		INNER JOIN t_SSIS t ON s.database_id = t.database_id AND s.name = RTRIM(SUBSTRING(t.path,2,LEN(t.path)))
UNION
SELECT s.database_id, 
	   s.database_id, 
		'TSSIS', 
		SUBSTRING(t.path,2,3),
		'Todos los SSIS ' + s.name , 
		s.short_description,
		s.active,
		'Base de Datos',
		s.create_date,
		s.execute_date,
		s.status,
		GETDATE()
FROM    t_BDM s
		INNER JOIN t_SSIS t ON s.database_id = t.database_id AND s.name = RTRIM(SUBSTRING(t.path,2,LEN(t.path)))

 --------------------------------------------------------------------------------------------------------------------------------
 --- Actualizamos estadisticas e Base de Datos
 --------------------------------------------------------------------------------------------------------------------------------
 
 UPDATE l
 SET l.logobject_noexecute = i.Total,
     l.logobject_nocorrect = i.Correcto,
     l.logobject_noerror = i.NoCorrecto,
     l.logobject_time =  'Minutos: ' + CAST((i.TimeMax / 60) AS CHAR(5)) + ' Segundos: ' + CAST((i.TimeMax % 60) AS CHAR(10)) 
 FROM dabarc.t_report_logobject l 
	INNER JOIN (
	 SELECT logexec_Id, 
			logexec_IdParent, 
			logexec_typeO,
			COUNT(*) Total,
			SUM(CASE WHEN logexec_status = 4 THEN 1 ELSE 0 END) Correcto,
			SUM(CASE WHEN logexec_status <> 4 THEN 1 ELSE 0 END) NoCorrecto,
			MAX(CASE WHEN logexec_dateF IS NOT NULL THEN DATEDIFF(SECOND,logexec_dateI,logexec_dateF) ELSE 0 END) TimeMax
	 FROM dabarc.t_report_logexec 
	 GROUP BY logexec_Id, logexec_IdParent, logexec_typeO ) i ON l.logobject_Id = i.logexec_Id AND l.logobject_IdParent = i.logexec_IdParent 
	 AND RTRIM(l.logobject_type) = RTRIM(i.logexec_typeO)
	
	
	--DROP TABLE #TBL_COUNT
	
	--- Tabla temporal
	CREATE TABLE #TBL_COUNT(Padre_id	INT, 
							oTypeP		CHAR(10), 
							InfCount	INT,
							RegCount	INT,
							TabfCount	INT,
							ssisCount	INT)
	
	
	INSERT INTO #TBL_COUNT
	SELECT  logobject_IdParent,
			logobject_typep,
			SUM(CASE WHEN logobject_type IN ('IFF','IFM','IDM') THEN 1 ELSE 0 END),
			SUM(CASE WHEN logobject_type IN ('RDF','RDM','RFM') THEN 1 ELSE 0 END),
			SUM(CASE WHEN logobject_type IN ('TFF','TFM','TDM') THEN 1 ELSE 0 END),
			SUM(CASE WHEN logobject_type IN ('SSIS') THEN 1 ELSE 0 END)
	FROM   dabarc.t_report_logobject
	GROUP BY logobject_IdParent, logobject_typep
	
	
	
	------------------------------------------------------------------------------------------
	-- Llenamos los elementos de la tabla
	------------------------------------------------------------------------------------------
	
	UPDATE	l
	SET		l.logobject_notable = c.TabfCount, 
			l.logobject_noinfo =  c.InfCount, 
			l.logobject_norule =  c.RegCount,
			l.logobject_nossis = c.ssisCount
	FROM	dabarc.t_report_logobject l
			INNER JOIN #TBL_COUNT c ON c.Padre_id = l.logobject_Id AND c.oTypeP = l.logobject_type
	WHERE	logobject_type IN ('TFF','TFM','TDM','BDF','BDM')
