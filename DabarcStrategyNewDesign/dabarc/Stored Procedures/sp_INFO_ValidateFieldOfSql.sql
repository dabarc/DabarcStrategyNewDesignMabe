CREATE PROCEDURE [dabarc].[sp_INFO_ValidateFieldOfSql]		@typeOfInformation	VARCHAR(5),	
														@report_id			INT, 
														@field_name		VARCHAR(100) AS
											 
	DECLARE @str_namedb		AS VARCHAR(60)
	DECLARE @str_reportname AS VARCHAR(100)
	DECLARE @str_sql		AS VARCHAR(300)						 


	----------------------------------------------------------------------------------------------------------------------------------
	-- obtenemos datos
	----------------------------------------------------------------------------------------------------------------------------------

	 IF (@typeOfInformation = 'IFF')
	 BEGIN
	   SELECT		@str_namedb = f.name,
					@str_reportname = ti.name
	   FROM			dabarc.t_BDF	f
	    INNER JOIN	dabarc.t_TFF	tf ON f.database_id = tf.database_id
		INNER JOIN	dabarc.t_IFF	ti ON tf.table_id = ti.table_id
		WHERE ti.report_id  = @report_id
	 END
	 
	 IF (@typeOfInformation = 'IDM')
	 BEGIN
	   SELECT		@str_namedb = b.name,
					@str_reportname = bi.name	
	   FROM			dabarc.t_BDM	b
		INNER JOIN	dabarc.t_TDM	b1 ON b.database_id = b1.database_id
		INNER JOIN  dabarc.t_IDM	bi ON b1.table_id = bi.table_id
	   WHERE bi.report_id = @report_id
	 END
	 
	 IF (@typeOfInformation = 'IFM')
	 BEGIN
	   SELECT		@str_namedb = b.name,
					@str_reportname = bi.name
	   FROM			dabarc.t_BDM	b
		INNER JOIN	dabarc.t_TDM	b1 ON b.database_id = b1.database_id
		INNER JOIN  dabarc.t_TFM	b2 ON b1.table_id = b2.tdm_id
		INNER JOIN  dabarc.t_IFM	bi ON b2.table_id = bi.table_id
	   WHERE bi.report_id = @report_id
	 END
	 
	 
	 
	 --SET @str_sql = ' SELECT COUNT(*) AS Num
	 --FROM	BDM_MATERIALES.sys.columns c
	 -- INNER JOIN BDM_MATERIALES.sys.views  o ON c.object_id = o.object_id AND RTRIM(UPPER(o.name)) = ''' + RTRIM(UPPER(@str_reportname))  + '''
	 --WHERE  RTRIM(UPPER(c.name)) = ''' + RTRIM(UPPER(@field_name))  + ''''
	 
	  SET @str_sql = ' SELECT COUNT(*) AS Num
	 FROM ' + RTRIM(@str_namedb) + ' .sys.columns c
	  INNER JOIN ' + RTRIM(@str_namedb) + '.sys.views  o ON c.object_id = o.object_id AND RTRIM(UPPER(o.name)) = ''' + RTRIM(@str_reportname)  + '''
	 WHERE  RTRIM(UPPER(c.name)) = ''' + RTRIM(UPPER(@field_name))  + ''''

	
	 EXECUTE(@str_sql)
