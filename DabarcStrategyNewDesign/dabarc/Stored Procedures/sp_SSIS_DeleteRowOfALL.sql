CREATE PROCEDURE  [dabarc].[sp_SSIS_DeleteRowOfALL]
	
	(	
	@ssis_id	 INT,
	@ssistype	 CHAR(4),	
	@delete_user NVARCHAR(15)
	)
	
AS
	DECLARE @delete_date DATETIME,
		@name			 NVARCHAR(128)


	SET @delete_date = GETDATE();
 
 
 	   IF (SELECT COUNT(*) FROM t_SSIS WHERE ssis_id = @ssis_id AND name LIKE 'SSIS_' + RTRIM(@ssistype) + '_%') = 0
	   BEGIN
		--RAISERROR('El SSIS ya no existe.', 16, 1);
		RAISERROR (50013,
    16, -- Severity.
    1, -- State.
    '',
    '') -- Second substitution argument.

		
		
		RETURN;
	   END
	   
 	   SELECT	@name = name FROM dabarc.t_SSIS WHERE ssis_id = @ssis_id AND name LIKE 'SSIS_' + RTRIM(@ssistype) + '_%';
	   DELETE	FROM dabarc.t_SSIS WHERE ssis_id = @ssis_id AND name LIKE 'SSIS_' + RTRIM(@ssistype) + '_%';
	   EXECUTE	dabarc.sp_log_InsertRegisterLogMov 'ELIMINAR','t_SSIS',@ssis_id,@name,@delete_date,@delete_user;  
	
	--IF (UPPER(RTRIM(@ssistype)) = 'TFF')
	--BEGIN 
	--   SELECT	@name = name FROM t_SSIS WHERE ssis_id = @ssis_id AND name LIKE 'SSIS_TFF_%';
	--   DELETE	FROM t_SSIS WHERE ssis_id = @ssis_id AND name LIKE 'SSIS_TFF_%';
	--   EXECUTE	sp_log_InsertRegisterLogMov 'ELIMINAR','t_SSIS',@ssis_id,@name,@delete_date,@delete_user;  

	--END
 
	--IF (RTRIM(@ssistype) = 'TDM')	
	--BEGIN
	--   SELECT	@name = name FROM t_SSIS WHERE ssis_id = @ssis_id AND name LIKE 'SSIS_TDM_%';
	--   DELETE	FROM t_SSIS WHERE ssis_id = @ssis_id AND name LIKE 'SSIS_TDM_%';
	--   EXECUTE	sp_log_InsertRegisterLogMov 'ELIMINAR','t_SSIS',@ssis_id,@name,@delete_date,@delete_user;  
  

	--END
	 
	--IF (RTRIM(@ssistype) = 'TFM')	
	--BEGIN
	--   SELECT	@name = name FROM t_SSIS WHERE ssis_id = @ssis_id AND name LIKE 'SSIS_TFM_%';
	--   DELETE	FROM t_SSIS WHERE ssis_id = @ssis_id AND name LIKE 'SSIS_TFM_%';
	--   EXECUTE	sp_log_InsertRegisterLogMov 'ELIMINAR','t_SSIS',@ssis_id,@name,@delete_date,@delete_user;  
	--END
