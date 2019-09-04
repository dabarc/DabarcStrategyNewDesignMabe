CREATE PROCEDURE [dabarc].[sp_sys_Sel_t_RFM_Ins]
	(
	@database_id int,
	@table_id int
	)
	
AS
	
	DECLARE @sqlstr nvarchar(1000)
	DECLARE @table_type nchar(3)
	DECLARE @table_name nvarchar(128)
	DECLARE @databaseid INT
	
	SET @table_type = 'RFM'
	
	SET @table_name = (SELECT        SUBSTRING(name, 5, 124) AS Expr1
	                   FROM            t_TFM
	                   WHERE        (table_id = @table_id))
	
	SELECT @databaseid = b.database_id FROM t_BDM b
			INNER JOIN t_TDM t ON b.database_id = t.database_id
			INNER JOIN t_TFM t1 ON t.table_id = t1.tdm_id
	WHERE t1.table_id = @table_id
	

	
	EXEC dabarc.sp_gen_CreateSQLSelectSysProcedures @databaseid, @table_id, @table_type, @table_name, @sqlstr OUTPUT
	
	--INSERT INTO t_RFM (name, create_date, table_id)
	--		EXEC (@sqlstr)
	
	RETURN
