CREATE PROCEDURE  [dabarc].[sp_SSIS_UpdateRowOfSSIS]
	
	(	
	@ssis_id	INT,
	@active		BIT,
	@priority	INT,	
	@description		NVARCHAR(256),
	@short_description	NVARCHAR(50),
	@modify_user		NVARCHAR(15)
	)
	
AS
	DECLARE @modify_date	DATETIME,
			@database_id	INT

	SET @modify_date = GETDATE()

  --------------------------------------------------------------------------------
  -- Validamos si no se esta ejecutando.. en caso de que si no se permite modificar
  -------------------------------------------------------------------------------
  

  	IF (@active = 1 AND (@priority = 0 OR RTRIM(@short_description) = ''))
	BEGIN
	--   RAISERROR('No se puede activar un SSIS con prioridad "0" y sin descripción corta', 16, 1);
	  RAISERROR (50052,
    16, -- Severity.
    1, -- State.
    '',
    '') -- Second substitution argument.

	  
	  
	  
	   RETURN;
	END
	
	
	EXECUTE [sp_run_Validate_Process_execute_SSIS] @ssis_id,@modify_user,'',1
	
	IF (@@ERROR <> 0)
		RETURN
	    
--------------------------------------------------------------------------------
  -- Se actualiza el Objetos ssis
  -------------------------------------------------------------------------------
  
		UPDATE	t_SSIS 
		SET		description = @description, 
				short_description = @short_description, 
				active = @active, 
				priority = @priority, 
				modify_date = @modify_date, 
				modify_user = @modify_user
		WHERE   (ssis_id = @ssis_id)
		
 ----------------------------------------------------------------------------
  -- Log de Movimientos
  ----------------------------------------------------------------------------
	EXECUTE sp_log_InsertRegisterLogMov 'MODIFICAR',
										't_SSIS',
										@ssis_id,
										@short_description,
										@modify_date,
										@modify_user
