CREATE PROCEDURE [dabarc].[sp_rpt_ReadListOfStatistical]    @typeObjeto		VARCHAR(300), 
														@Name				VARCHAR(40),
														@IsMonth			BIT,
														@IsInterface		BIT,
														@datInitial			SMALLDATETIME, 												
														@datEnd				SMALLDATETIME AS 
    DECLARE @datTemp   SMALLDATETIME
    DECLARE @strTemp   VARCHAR(10)
	DECLARE @sqlstr	   VARCHAR(2000)
	DECLARE @sqlwhere  VARCHAR(100)	
	
	DECLARE @intX	  INT
	DECLARE @intE	  INT
	DECLARE @intCSum  INT

    DECLARE @datTemp2   SMALLDATETIME
    DECLARE @strTemp2   VARCHAR(10)

	
	------------------------------------------------------------------------------------------
	-- Obtenemos columnas y periodos
	------------------------------------------------------------------------------------------
	
	CREATE TABLE #Status (istatus INT, sstatus VARCHAR(10))
	
	INSERT INTO #Status VALUES(4,'Correcto')
	INSERT INTO #Status VALUES(6,'Error')
	INSERT INTO #Status VALUES(3,'Proceso')
	
	SET @strTemp = CAST(YEAR(@datInitial) AS CHAR(4)) + '-01-01 00:00'
	SET @datTemp = CONVERT(SMALLDATETIME,@strTemp)
	SET @datTemp = DATEADD(month,MONTH(@datInitial)-1,@datTemp)
	
	
	SET @strTemp2 = CAST(YEAR(@datEnd) AS CHAR(4)) + '-01-01 00:00'
	SET @datTemp2 = CONVERT(SMALLDATETIME,@strTemp2)
	SET @datTemp2 = DATEADD(month,MONTH(@datEnd),@datTemp2)
	
	------------------------------------------------------------------------------------------
	-- Consulta
	------------------------------------------------------------------------------------------
	
	 SET @sqlstr = 'SELECT DISTINCT'
	 SET @sqlstr = @sqlstr + ' logexec_Id,' 
	 SET @sqlstr = @sqlstr + ' logexec_IdParent,' 
	 SET @sqlstr = @sqlstr + ' logexec_typeO,'
	 SET @sqlstr = @sqlstr + ' logexec_name,'
	 SET @sqlstr = @sqlstr + ' s.sstatus,'
	 SET @sqlstr = @sqlstr + ' [Elemento_m] = SUM(CASE WHEN l.logexec_dateI >= ''' + CONVERT(VARCHAR(15),@datTemp,110) + ''' AND l.logexec_dateI < ''' + CONVERT(VARCHAR(15),@datTemp2,110) + ''' THEN ISNULL(logexec_result,0) ELSE 0 END) ,'
	 SET @sqlstr = @sqlstr + ' [Ejecucion_t] = SUM(CASE WHEN l.logexec_dateI >= ''' + CONVERT(VARCHAR(15),@datTemp,110) + ''' AND l.logexec_dateI < ''' + CONVERT(VARCHAR(15),@datTemp2,110) + ''' THEN 1 ELSE 0 END) ,'
	 
	 SELECT @intE = DATEDIFF(month, @datInitial, @datEnd)
	 SELECT @intX = 0
	 
	 WHILE(@intX <= @intE)
	 BEGIN
			 
			 SET @datInitial = DATEADD(month,@intX, @datTemp) 
			 SET @strTemp	 = CONVERT(VARCHAR(6),@datInitial,112)
	    	 SET @sqlstr	 = @sqlstr + ' [' + RTRIM(@strTemp) + '] = SUM(CASE WHEN CONVERT(VARCHAR(6),l.logexec_dateI,112) = ''' + RTRIM(@strTemp) + ''' THEN 1 ELSE 0 END),'			 
		
	  SET @intX = @intX + 1
	 END
	 
	 SET @sqlstr = SUBSTRING(@sqlstr,1,LEN(@sqlstr)-1)
	 SET @sqlstr = @sqlstr + ' FROM  dabarc.t_report_logexec l'
	 SET @sqlstr = @sqlstr + ' LEFT OUTER JOIN #Status s ON l.logexec_status = s.istatus'
	 

		SET @sqlwhere = ''
		IF (RTRIM(@typeObjeto) <> '') SET @sqlwhere = @sqlwhere + ' AND logexec_typeO IN (' + @typeObjeto + ')'
		IF (RTRIM(@Name) <> '')		  SET @sqlwhere = @sqlwhere + ' AND logexec_name LIKE ''%' + @Name + '%'''
		IF (@IsInterface = 1)		  SET @sqlwhere = @sqlwhere + ' AND logexec_isinterface = 1'
		IF (RTRIM(@sqlwhere) <> '')	  SET @sqlstr = @sqlstr + ' WHERE ' + SUBSTRING(@sqlwhere,5,LEN(@sqlwhere))   
	 
	 SET @sqlstr = @sqlstr + ' GROUP BY logexec_Id,'
	 SET @sqlstr = @sqlstr + ' logexec_IdParent ,'
	 SET @sqlstr = @sqlstr + ' logexec_typeO,'
	 SET @sqlstr = @sqlstr + ' logexec_name,'
	 SET @sqlstr = @sqlstr + ' s.sstatus'
	
	 PRINT @sqlstr
	 EXEC(@sqlstr)
