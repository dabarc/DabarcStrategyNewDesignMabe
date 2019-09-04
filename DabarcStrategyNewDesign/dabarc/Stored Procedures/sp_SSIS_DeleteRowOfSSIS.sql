CREATE PROCEDURE  [dabarc].[sp_SSIS_DeleteRowOfSSIS]
	
	(	
	@ssis_id INT,
	@delete_user NVARCHAR(15)
	)
	
AS
	DECLARE @modify_date DATETIMe,
			@name		 NVARCHAR(128),
			@description NVARCHAR(50)			 

	SET @modify_date = GETDATE()

  --------------------------------------------------------------------------------
  -- Validamos si no se esta ejecutando.. en caso de que si no se permite modificar
  -------------------------------------------------------------------------------
	EXECUTE [dabarc].[sp_run_Validate_Process_execute_SSIS] @ssis_id,@delete_user,'',1
	
	IF (@@ERROR <> 0)
		RETURN
	    
--------------------------------------------------------------------------------
  -- Se actualiza el Objetos ssis
  -------------------------------------------------------------------------------
  
		SELECT	@name = name, @description = description 
		FROM	t_SSIS 
		WHERE   (ssis_id = @ssis_id)
		
		DELETE FROM t_SSIS WHERE   (ssis_id = @ssis_id)
 ----------------------------------------------------------------------------
  -- Log de Movimientos
  ----------------------------------------------------------------------------
	EXECUTE dabarc.sp_log_InsertRegisterLogMov 'DELETE',
												't_SSIS',
												@ssis_id,
												@name,
												@modify_date,
												@delete_user
