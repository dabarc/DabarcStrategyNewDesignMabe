CREATE PROCEDURE [dabarc].[sp_run_Save_Process_execute_View_H_H] @DATE_VIEW AS DATETIME, @status AS NVARCHAR(20), @typeObj AS NVARCHAR(15) AS

DECLARE @DATE_STRING VARCHAR(400)

SELECT @DATE_STRING = CONVERT(VARCHAR(12),@DATE_VIEW,112)

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
			path_PorcentajeS	decimal(4,0) NULL,
			path_order		int
		) 

------------------------------------------------------------------------
  --- insertamos la Base
  ------------------------------------------------------------------------
  DECLARE @query NVARCHAR(2000)
  SET @query = 'SELECT Path_hKey,Path_hName, CONVERT(VARCHAR(20),Path_hDateInitial,109) Path_hDateInitial,
			CONVERT(VARCHAR(20),Path_hDateFinal,109) Path_hDateFinal, dabarc.fnt_get_formtatime(Path_hTime) as Path_hTime,
			h.path_message, NULL a, NULL b, ''100 %'', 0.0, case when Path_hStatus in (4,5) THEN  1 ELSE 0 END
	 FROM	dabarc.t_sql_process_executeH h' 
	 
  IF @status = 'ALL' and @typeObj = 'ALL'
  BEGIN
	 SET @query = @query + ' WHERE Path_hStatus in (4,5,6) AND SUBSTRING(Path_hKey,1,8) = '+ @DATE_STRING + ' ORDER BY Path_hKey'	
	
	 INSERT INTO #tmp
	 EXEC(@query) 
   END	 
  IF @status <> 'ALL' and @typeObj <> 'ALL'
  BEGIN
	 SET @query = @query + ' JOIN dabarc.t_sql_process_executeD d ON h.Path_hKey = d.path_unickey  WHERE d.path_status = ' + @status + ' AND RTRIM(Path_hType) = ''' + @typeObj + ''' AND SUBSTRING(Path_hKey,1,8) = '+ @DATE_STRING + ' ORDER BY Path_hKey'
	
	 INSERT INTO #tmp
	 EXEC(@query) 
   END	
   
	 ELSE-- IF @status <> 'ALL' OR @typeObj <> 'ALL'
	 BEGIN
	 IF @status <> 'ALL'
	 BEGIN
	 IF @status in (6)
	 BEGIN
	 SET @query = @query + ' WHERE Path_hStatus = ' + @status + ' AND SUBSTRING(Path_hKey,1,8) = '+ @DATE_STRING + ' ORDER BY Path_hKey'
	  PRINT @query
	 INSERT INTO #tmp
	 EXEC(@query) 
	 END
	 ELSE
	 BEGIN
	 SET @query = @query + ' JOIN dabarc.t_sql_process_executeD d ON h.Path_hKey = d.path_unickey  WHERE d.path_status = ' + @status + ' AND SUBSTRING(Path_hKey,1,8) = '+ @DATE_STRING + ' ORDER BY Path_hKey'
	  PRINT @query
	 INSERT INTO #tmp
	 EXEC(@query) 
	 END
	 END
	 IF @typeObj <> 'ALL'
	 BEGIN
	 IF @typeObj = 'INT'
	 BEGIN
	 SET @query = @query + ' INNER JOIN dabarc.t_LogInterfacesN	n ON h.Path_hKey = n.execute_unickey WHERE SUBSTRING(Path_hKey,1,8) = ' + @DATE_STRING + ' ORDER BY Path_hKey'
	 END
	 ELSE
	 BEGIN
	 SET @query = @query + ' WHERE RTRIM(Path_hType) = ''' + @typeObj + ''' AND SUBSTRING(Path_hKey,1,8) = '+ @DATE_STRING + ' ORDER BY Path_hKey'
	 END
	 PRINT @query
	 INSERT INTO #tmp
	 EXEC(@query) 
	 END
	 END 
	 PRINT @query
	 SELECT * FROM #tmp ORDER BY Path_hKey DESC
