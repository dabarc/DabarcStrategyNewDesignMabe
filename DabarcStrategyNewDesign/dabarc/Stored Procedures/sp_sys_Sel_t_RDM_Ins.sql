CREATE PROCEDURE [dabarc].[sp_sys_Sel_t_RDM_Ins]
	(
	@database_id int,
	@table_id int
	)
	
AS
	
	DECLARE @sqlstr nvarchar(1000)
	DECLARE @table_type nchar(3)
	DECLARE @table_name nvarchar(128)
	
	SET @table_type = 'RDM'
	
	SET @table_name = (SELECT        SUBSTRING(name, 5, 124) AS Expr1
	                   FROM            t_TDM
	                   WHERE        (table_id = @table_id))

	EXEC dabarc.sp_gen_CreateSQLSelectSysProcedures @database_id, @table_id, @table_type, @table_name, @sqlstr OUTPUT
	
	--INSERT INTO t_RDM (name, create_date, table_id)
	--		EXEC (@sqlstr)
	
	--SELECT @sqlstr
	
	RETURN
