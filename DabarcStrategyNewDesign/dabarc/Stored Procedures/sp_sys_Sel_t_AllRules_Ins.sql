CREATE PROCEDURE [dabarc].[sp_sys_Sel_t_AllRules_Ins]
	@database_id int,
	@table_id int,
	@table_type	nchar(3),
	@info_id INT  = 0
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @sqlstr nvarchar(1000)
	DECLARE @table_name nvarchar(128)
	IF(@table_type = 'RDM')
	BEGIN
		SET @table_name = (SELECT        SUBSTRING(name, 5, 124) AS Expr1
							FROM            t_TDM
							WHERE        (table_id = @table_id))
		EXEC sp_gen_CreateSQLSelectSysProcedures @database_id, @table_id, @table_type, @table_name, @sqlstr OUTPUT
		RETURN
	END
	IF(@table_type = 'RFF')
	BEGIN
		SET @table_name = (SELECT SUBSTRING(name, 5, 124) AS Expr1
							FROM  t_TFF
							WHERE table_id = @table_id);
		EXEC dabarc.sp_gen_CreateSQLSelectSysProcedures @database_id, @table_id, @table_type, @table_name, @sqlstr OUTPUT;
		RETURN
	END
	IF(@table_type = 'RFM')
	BEGIN
		DECLARE @databaseid INT
		SET @table_name = (SELECT        SUBSTRING(name, 5, 124) AS Expr1
		                   FROM            t_TFM
		                   WHERE        (table_id = @table_id))
		SELECT @databaseid = b.database_id FROM t_BDM b
				INNER JOIN t_TDM t ON b.database_id = t.database_id
				INNER JOIN t_TFM t1 ON t.table_id = t1.tdm_id
		WHERE t1.table_id = @table_id
		EXEC dabarc.sp_gen_CreateSQLSelectSysProcedures @databaseid, @table_id, @table_type, @table_name, @sqlstr OUTPUT
		RETURN
	END
	IF(@table_type = 'RRF')
	BEGIN
		SET @table_name = (SELECT        SUBSTRING(name, 5, 124) AS Expr1
		                   FROM            t_TDM
		                   WHERE        (table_id = @table_id))
		SELECT @databaseid = b.database_id FROM t_BDM b
				INNER JOIN t_TDM t ON b.database_id		= t.database_id			
				INNER JOIN t_IDM t1 ON t.table_id		= t1.table_id
		WHERE t.table_id = @table_id AND t1.report_id	= @info_id
		EXEC dabarc.sp_gen_CreateSQLSelectSysProcedures_Inf @databaseid, @table_id,@info_id, @table_type, @table_name, @sqlstr OUTPUT
		RETURN
	END
END
