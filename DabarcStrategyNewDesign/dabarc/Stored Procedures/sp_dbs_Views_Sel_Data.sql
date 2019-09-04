CREATE PROCEDURE [dabarc].[sp_dbs_Views_Sel_Data]
	(
	@type			VARCHAR(5),
	@report_id		INT	
	)
	
AS

	DECLARE @DataBase_Id INT,
			@report_name VARCHAR(100)

	DECLARE @db_name nvarchar(128),
			@sqlstr nvarchar(300)
			
			
	IF (@type = 'IFF')
	BEGIN
		SELECT @db_name		= rtrim(bf.name),
			   @DataBase_Id = f.database_id,
			   @report_name = i.name
		FROM t_BDF bf
		    INNER JOIN t_TFF f ON bf.database_id = f.database_id 
			INNER JOIN t_IFF i ON f.table_id = i.table_id
		WHERE i.report_id = @report_id
	END
	
	IF (@type = 'IDM')
	BEGIN
		SELECT @db_name		= rtrim(bm.name),
			   @DataBase_Id = f.database_id,
			   @report_name = i.name	
		FROM t_BDM bm
			INNER JOIN t_TDM f ON bm.database_id = f.database_id
			INNER JOIN t_IDM i ON f.table_id = i.table_id
		WHERE i.report_id = @report_id
	END
	
	IF (@type = 'IFM')
	BEGIN
	   SELECT @db_name		= rtrim(bm.name),
			  @DataBase_Id = t.database_id,
			  @report_name = m.name
	   FROM t_BDM bm
			INNER JOIN t_TDM t ON bm.database_id = t.database_id
			INNER JOIN t_TFM f ON t.table_id = f.tdm_id	
			INNER JOIN t_IFM m ON f.table_id = m.table_id
	   WHERE m.report_id = @report_id	
	END
	

	--SET @db_name = ISNULL(DB_NAME(@DataBase_Id),'desconocido')

	SET @sqlstr = 'SELECT * FROM ' + @db_name + '.dbo.' +  @report_name

	EXEC(@sqlstr);
	
	RETURN
