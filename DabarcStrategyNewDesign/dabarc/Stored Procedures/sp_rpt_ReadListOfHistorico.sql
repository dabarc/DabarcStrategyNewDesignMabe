CREATE PROCEDURE [dabarc].[sp_rpt_ReadListOfHistorico]   @typeObjeto		VARCHAR(300), 
													@Status			VARCHAR(100), 
													@Name			VARCHAR(40),
													@IsInterface	BIT,
													@IsLastHist		BIT,
													@datInitial		SMALLDATETIME, 
													@datEnd			SMALLDATETIME AS 


DECLARE @STR_SQL VARCHAR(4000)

	SET @STR_SQL = ' SELECT logexec_clave'
	SET @STR_SQL = @STR_SQL + ' ,logexec_typeO'
	SET @STR_SQL = @STR_SQL + ' ,logexec_name'
	SET @STR_SQL = @STR_SQL + ' ,logexec_dateI'
	SET @STR_SQL = @STR_SQL + ' ,logexec_dateF'
	SET @STR_SQL = @STR_SQL + ' ,logexec_time'
	SET @STR_SQL = @STR_SQL + ' ,CASE WHEN logexec_status = 4 THEN ''Correcto'' WHEN logexec_status = 6 THEN ''Error'' ELSE ''Pausa'' END as logexec_status '
	SET @STR_SQL = @STR_SQL + ' ,logexec_norow'
	SET @STR_SQL = @STR_SQL + ' ,logexec_objerror'
	SET @STR_SQL = @STR_SQL + ' ,logexec_msgerror'
	SET @STR_SQL = @STR_SQL + ' ,CASE WHEN logexec_isinterface = 1 THEN ''Inteface'' ELSE '''' END as logexec_isinterface'
	SET @STR_SQL = @STR_SQL + ' FROM dabarc.t_report_logexec '
	SET @STR_SQL = @STR_SQL + ' WHERE ((logexec_dateI >= ''' + CONVERT(VARCHAR(10),@datInitial,105) + ''' AND logexec_dateF <= ''' + CONVERT(VARCHAR(10),@datEnd,105) + ''')'
	SET @STR_SQL = @STR_SQL + ' OR (logexec_dateI >= ''' + CONVERT(VARCHAR(10),@datInitial,105) + ''' AND logexec_dateF IS NULL))'

	
	IF (RTRIM(@Name) <> '')		  SET @STR_SQL = @STR_SQL + ' AND logexec_name LIKE ''%' + @Name + '%'''
	IF (RTRIM(@typeObjeto) <> '') SET @STR_SQL = @STR_SQL + ' AND logexec_typeO IN (' + @typeObjeto + ')'
	IF (RTRIM(@Status) <> '')	  SET @STR_SQL = @STR_SQL + ' AND logexec_status IN (' + @Status + ')'
	IF (@IsInterface = 1)		  SET @STR_SQL = @STR_SQL + ' AND logexec_isinterface = 1'
	IF (@IsLastHist = 1)		  SET @STR_SQL = @STR_SQL + ' AND logexec_lastexec = 1'

	PRINT @STR_SQL

    EXECUTE(@STR_SQL)
