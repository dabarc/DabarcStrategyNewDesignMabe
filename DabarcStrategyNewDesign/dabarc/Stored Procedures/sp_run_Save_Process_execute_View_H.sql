CREATE PROCEDURE [dabarc].[sp_run_Save_Process_execute_View_H]  AS

DECLARE @SQL_STRING VARCHAR(400)
  ------------------------------------------------------------------------
  --- Creamos la tabla
  ------------------------------------------------------------------------
  
		CREATE TABLE #tmp(
			Path_hKey		nvarchar(40) NOT NULL,
			Path_hName		nvarchar(200) NOT NULL,
			Path_hDateInitial nvarchar(50) NOT NULL,
			Path_hDateFinal nvarchar(50) NULL,
			Path_hTime		nchar(20) NULL,		
			path_message	nchar(20) NULL,
			path_Option		nchar(20) NULL,
			path_Option2		nchar(20) NULL,			
			path_Porcentaje	nchar(20) NULL,
			path_PorcentajeS	decimal(5,2) NULL,
			path_order		int
		) 

  ------------------------------------------------------------------------
  --- Aquellos procesos pendiente 
  ------------------------------------------------------------------------
  

	 INSERT INTO #tmp
	 SELECT Path_hKey,  
			Path_hName + ' (Proceso: ' + path_hTypeProcess + ', Tipo: ' + Path_hType + ', Ejecuta: ' + Path_hUser + ')' Path_hName, 
			CONVERT(VARCHAR(20),Path_hDateInitial,109) Path_hDateInitial,
			CONVERT(VARCHAR(20),Path_hDateFinal,109) Path_hDateFinal,
			Path_hTime,
			path_message,
			CASE WHEN Path_hStatus = 1 THEN 'Pausa'
				 WHEN Path_hStatus = 3 THEN 'Continuar' ELSE null END as a,
			CASE WHEN Path_hStatus = 0 THEN 'Cancelar'
				 WHEN Path_hStatus = 1 THEN 'Cancelar'
				 WHEN Path_hStatus = 3 THEN 'Cancelar' ELSE null END as b,				 
			'100 %',
			0.0,
			case when Path_hStatus in (4,5) THEN  1 ELSE 0 END
	 FROM t_Sql_process_executeH
	 WHERE Path_hStatus IN (0,1,2,3)
	 ORDER BY Path_hKey
	
	------------------------------------------------------------------------
	--- De ellos calculamos el porcentaje de avance en el detalle
	------------------------------------------------------------------------	 
	 	 
	 UPDATE t
	 
	 SET	path_PorcentajeS = (CAST(i.procesado AS DECIMAL(5,1)) / CAST(i.total AS DECIMAL(5,1))) * 100
	 FROM   #tmp t
	 INNER JOIN (
	 
				SELECT path_unickey, 
					   SUM(CASE WHEN path_status  IN  (4,5)  THEN 1.0
					            WHEN path_status   = 3       THEN .5  ELSE 0.0 END) procesado,
					   COUNT(ISNULL(path_status,0)) total
				 FROM t_Sql_process_executeD id
					INNER JOIN #tmp t ON id.path_unickey = t.Path_hKey
				 GROUP BY path_unickey
				 
				 ) i ON t.Path_hKey = i.path_unickey
	
	 UPDATE 	#tmp SET 	path_Porcentaje = CAST(path_PorcentajeS AS CHAR(5)) + ' %'
	
	--------------------------------------------------------------------------
	----- Returnamos los valores
	--------------------------------------------------------------------------	 
	 	  
	 SELECT * FROM #tmp ORDER BY path_order DESC
