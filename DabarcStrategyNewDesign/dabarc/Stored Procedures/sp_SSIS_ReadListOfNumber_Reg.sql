CREATE PROCEDURE  [dabarc].[sp_SSIS_ReadListOfNumber_Reg]
	(		
		@table_id		int,
		@register_user	nvarchar(50)
	)
	
AS

	DECLARE @register_date datetime

	SET @register_date = GETDATE()
	

		UPDATE a
		SET    a.ssis_number    = b.Ssis_count,
			   a.modify_user	= @register_user,
			   a.modify_date	= @register_date
		FROM dabarc.t_TFF a 
			INNER JOIN (
				SELECT	COUNT(*)  Ssis_count
				FROM	dabarc.t_SSIS  
				WHERE	table_id = @table_id AND registered = 1 AND name like 'SSIS[_]TFF[_]%') b 
				ON		a.table_id = @table_id
	
	
		UPDATE a
		SET    a.ssis_number    = b.Ssis_count,
			   a.modify_user	= @register_user,
			   a.modify_date	= @register_date
		FROM dabarc.t_TDM a 
			INNER JOIN (
				SELECT	COUNT(*)  Ssis_count
				FROM	dabarc.t_SSIS  
				WHERE	table_id = @table_id AND registered = 1 AND name like 'SSIS[_]TDM[_]%') b 
				ON		a.table_id = @table_id

		UPDATE a
		SET    a.ssis_number    = b.Ssis_count,
			   a.modify_user	= @register_user,
			   a.modify_date	= @register_date
		FROM dabarc.t_TFM a 
			INNER JOIN (
				SELECT	COUNT(*)  Ssis_count
				FROM	dabarc.t_SSIS  
				WHERE	table_id = @table_id AND registered = 1 AND name like 'SSIS[_]TFM[_]%') b 
				ON		a.table_id = @table_id
