CREATE PROCEDURE [dabarc].[sp_sys_Sel_t_AllTables_Ins]
	@database_id int,
	@table_type NVARCHAR(3),
	@table_id int = 0
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @sqlstr nvarchar(1000)
	--TFF y TDM
	IF (@table_type = 'TFF' OR @table_type = 'TDM')
	BEGIN
		EXEC dabarc.sp_gen_CreateSQLSelectSysTables @database_id, @table_type, @sqlstr OUTPUT
		--INSERT INTO t_TDM (name, create_date, database_id)
		--EXEC (@sqlstr)
	END
	IF (@table_id <> 0 AND @table_type = 'TFM')
	BEGIN
	   DECLARE @table_name nvarchar(128)
	   SET @table_name = (SELECT   SUBSTRING(name, 5, 124) AS Expr1 FROM t_TDM
	                   WHERE (table_id = @table_id))
	
	EXEC dabarc.sp_gen_CreateSQLSelectSysSubTables @database_id, @table_id, @table_type, @table_name, @sqlstr OUTPUT
	END;	
END;
