CREATE PROCEDURE  [dabarc].[sp_RULE_UpdateRowOfRule]
	
	(
	@typeOfRule VARCHAR(5),	
	@rule_id int,
	@active bit,
	@priority int,
	@report_type nvarchar(14),	
	@description nvarchar(256),
	@short_description nvarchar(50),
	@modify_user nvarchar(15)
	)
	
AS
	DECLARE @modify_date datetime

	SET @modify_date = GETDATE()

	----------------------------------------------------------------------------------------------------------------------------------
	--- Validar
	----------------------------------------------------------------------------------------------------------------------------------

	IF (@active = 1 AND (@priority = 0 OR RTRIM(@short_description) = ''))
	BEGIN
	 --  RAISERROR('No se puede activar un registro con prioridad "0" y sin descripción corta', 16, 1);
	   RAISERROR (50051,16,1, '','')
	   RETURN;
	END
	

	IF (RTRIM(@typeOfRule) = 'RFF')
	BEGIN 
	   UPDATE	t_RFF 
		SET		description = @description, 
				short_description = @short_description, 
				active = @active, 
				priority = @priority,
				report_type = @report_type, 
				modify_date = @modify_date, 
				modify_user = @modify_user
		WHERE   (rule_id = @rule_id)

	END
 
	IF (RTRIM(@typeOfRule) = 'RDM')	
	BEGIN
		 UPDATE	dabarc.t_RDM 
		SET		description = @description, 
				short_description = @short_description, 
				active = @active, 
				priority = @priority, 
				report_type = @report_type, 
				modify_date = @modify_date, 
				modify_user = @modify_user
		WHERE   (rule_id = @rule_id)
	END
	 
	IF (RTRIM(@typeOfRule) = 'RFM')	
	BEGIN
		UPDATE	t_RFM 
		SET		description = @description, 
				short_description = @short_description, 
				active = @active, 
				priority = @priority,
				report_type = @report_type,  
				modify_date = @modify_date, 
				modify_user = @modify_user
		WHERE   (rule_id = @rule_id)
	END

	IF (RTRIM(@typeOfRule) = 'RRF')	
	BEGIN
		UPDATE	t_RRF
		SET		description = @description, 
				short_description = @short_description, 
				active = @active, 
				priority = @priority,
				report_type = @report_type,  
				modify_date = @modify_date, 
				modify_user = @modify_user
		WHERE   (rule_id = @rule_id)
	END
	
 ----------------------------------------------------------------------------
  -- Log de Movimientos
  ----------------------------------------------------------------------------
	DECLARE @pTable NCHAR(10)
	SET		@pTable = 't_' + @typeOfRule
	EXECUTE sp_log_InsertRegisterLogMov 'MODIFICAR',
												@pTable,
												@rule_id,
												@short_description,
												@modify_date,
												@modify_user
