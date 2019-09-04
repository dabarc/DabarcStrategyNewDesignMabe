CREATE PROCEDURE [dabarc].[sp_sys_Sel_t_RRF_Ins] 
	(
	@table_id		INT,
	@info_id		INT
	)
	
AS
	
	DECLARE @sqlstr nvarchar(1000)
	DECLARE @table_type nchar(3)
	DECLARE @table_name nvarchar(128)
	DECLARE @databaseid INT
	
	SET @table_type = 'RRF'
	
	SET @table_name = (SELECT        SUBSTRING(name, 5, 124) AS Expr1
	                   FROM            t_TDM
	                   WHERE        (table_id = @table_id))
	
	SELECT @databaseid = b.database_id FROM t_BDM b
			INNER JOIN t_TDM t ON b.database_id		= t.database_id			
			INNER JOIN t_IDM t1 ON t.table_id		= t1.table_id
	WHERE t.table_id = @table_id AND t1.report_id	= @info_id
	
	EXEC dabarc.sp_gen_CreateSQLSelectSysProcedures_Inf @databaseid, @table_id,@info_id, @table_type, @table_name, @sqlstr OUTPUT
	

	RETURN
