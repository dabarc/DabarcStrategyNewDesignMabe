CREATE PROCEDURE [dabarc].[sp_sys_Sel_t_RFF_Ins]
	@database_id int,
	@table_id int
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @sqlstr nvarchar(1000);
	DECLARE @table_type nchar(3) = 'RFF';
	DECLARE @table_name nvarchar(128);
	
	SET @table_name = (SELECT SUBSTRING(name, 5, 124) AS Expr1
	                   FROM  t_TFF
	                   WHERE table_id = @table_id);

	EXEC dabarc.sp_gen_CreateSQLSelectSysProcedures @database_id, @table_id, @table_type, @table_name, @sqlstr OUTPUT;
	RETURN
END;
