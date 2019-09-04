
CREATE PROCEDURE [dabarc].[sp_INT_UpdateListOfInterfaceN]
	
	(
	@interface_id int,
	@description nvarchar(500),
	@active bit,
	@priority int,
	@execute_ssis bit,
	@execute_rule bit,
	@execute_report bit,
	@execute_table bit,
	@execute_database bit,
	@schedule_period nvarchar(10),	
	@period datetime,
	@modify_user nvarchar(15)
	)
	
AS
	DECLARE @modify_date datetime

	SET @modify_date = GETDATE()
	
	IF @priority = NULL
		SET @priority = 0;
	
	
	
	IF (@active = 1 AND @priority = 0)
	BEGIN
	--   RAISERROR('No se puede activar un registro con prioridad "0" o "Nulo"', 16, 1);
	  
  RAISERROR (50049,16,1, '','')
	  
	   RETURN;
	END
	
	UPDATE	dabarc.t_InterfacesN
	SET		description		= @description, 
			active			= @active, 
			priority		= @priority, 
			period	= @period, 
			schedule_period = @schedule_period,
			execute_ssis	= @execute_ssis, 
			execute_rule	= @execute_rule, 
			execute_report = @execute_report,
			execute_table = @execute_table,
			execute_database = @execute_database, 					
			modify_date		= @modify_date, 
			modify_user		= @modify_user 			
	WHERE 	interface_id	= @interface_id				
			
  ----------------------------------------------------------------------------
  -- Log de Movimientos
  ----------------------------------------------------------------------------
  		
	EXECUTE dabarc.sp_log_InsertRegisterLogMov  'MODIFICAR',
												't_InterfacesN',
												@interface_id,
												@description,
												@modify_date,
												@modify_user	 
	RETURN
