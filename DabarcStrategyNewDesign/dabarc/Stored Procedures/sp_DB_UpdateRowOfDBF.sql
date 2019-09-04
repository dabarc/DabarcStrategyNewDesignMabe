CREATE PROCEDURE  [dabarc].[sp_DB_UpdateRowOfDBF]
	
	(	
	@database_id int,
	@active bit,
	@priority int,	
	@description nvarchar(256),
	@short_description nvarchar(50),
	@db_createzip int,	
	@execute_rules bit,
	@execute_reports bit,
	@execute_ssis bit,
	@modify_user nvarchar(15)
	)
	
AS
	DECLARE @modify_date datetime

	SET @modify_date = GETDATE()

	------------------------------------------------------------------------------------------------------------------------------
	--- Validación 
	------------------------------------------------------------------------------------------------------------------------------		
	
	IF (@active = 1 AND (@priority = 0 OR RTRIM(@short_description) = ''))
	BEGIN
	--   RAISERROR('No se puede activar una BD con prioridad "0" y sin descripción corta', 16, 1);
	   RAISERROR (50053,16,1, '','')
	  
	   RETURN;
	END
	
	

		UPDATE	t_BDF
		SET		description = @description, 
				short_description = @short_description, 
				active = @active, 
				priority = @priority, 
				db_createzip = @db_createzip,			
				modify_date = @modify_date, 
				modify_user = @modify_user, 
				execute_rules = @execute_rules, 
				execute_reports = @execute_reports, 
				execute_ssis = @execute_ssis
		WHERE   (database_id = @database_id)

  ----------------------------------------------------------------------------
  -- Log de Movimientos
  ----------------------------------------------------------------------------
  
	EXECUTE dabarc.sp_log_InsertRegisterLogMov 'MODIFICAR',
										't_BDF',
										@database_id,
										@short_description,
										@modify_date,
										@modify_user
