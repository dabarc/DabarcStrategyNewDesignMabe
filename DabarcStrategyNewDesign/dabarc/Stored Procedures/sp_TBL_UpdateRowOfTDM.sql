CREATE PROCEDURE  [dabarc].[sp_TBL_UpdateRowOfTDM]
	
	(	
	@table_id int,
	@active bit,
	@priority int,	
	@description nvarchar(256),
	@short_description nvarchar(50),
	@table_createzip int,	
	@execute_rules bit,
	@execute_reports bit,
	@execute_ssis bit,
	@modify_user nvarchar(15)
	)
	
AS
	DECLARE @modify_date datetime

	SET @modify_date = GETDATE()

	IF (@active = 1 AND (@priority = 0 OR RTRIM(@short_description) = ''))
	BEGIN
	 --  RAISERROR('No se puede activar un registro con prioridad "0" y sin descripción corta', 16, 1);
 RAISERROR (50051,
    16, -- Severity.
    1, -- State.
    '',
    '') -- Second substitution argument.
	  
	  
	  
	  
	  
	  
	   RETURN;
	END

		UPDATE	t_TDM 
		SET		description		= @description, 
				short_description = @short_description, 
				active			= @active, 
				priority		= @priority, 
				table_createzip = @table_createzip , 
				modify_date			= @modify_date, 
				modify_user		= @modify_user, 
				execute_rules	= @execute_rules, 
				execute_reports = @execute_reports, 
				execute_ssis	= @execute_ssis
		WHERE   (table_id	= @table_id)
