CREATE PROCEDURE  [dabarc].[sp_SSIS_ReadListOfNumber_Reg]	
		@table_id		int,
		@register_user	nvarchar(100),
		@database_id int = 0
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @register_date datetime = GETDATE();

	--SSIS in table
	DECLARE @table_ssis_count INT;
	SET @table_ssis_count = (SELECT	COUNT(*) FROM	dabarc.t_SSIS  WHERE table_id = @table_id AND registered = 1 AND name like 'SSIS[_]TFF[_]%');
	UPDATE dabarc.t_TFF
	SET    ssis_number  = @table_ssis_count,
		   modify_user	= @register_user,
		   modify_date	= @register_date
	WHERE table_id = @table_id
	
	--SSIS in bd
	DECLARE @tabls_ssis_count INT;
	SET @tabls_ssis_count = (SELECT	COUNT(*) FROM	dabarc.t_SSIS  WHERE database_id = @database_id AND registered = 1 AND name like 'SSIS[_]TFF[_]%');
	UPDATE dabarc.t_BDF
	SET    ssis_number  = @tabls_ssis_count,
		   modify_user	= @register_user,
		   modify_date	= @register_date
	WHERE database_id = @database_id
END
