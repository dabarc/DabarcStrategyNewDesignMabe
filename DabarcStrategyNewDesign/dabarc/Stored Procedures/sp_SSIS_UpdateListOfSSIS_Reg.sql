--EXEC [dabarc].[sp_SSIS_UpdateListOfSSIS_Reg] 3, 1, 4, 0, 'admin';
CREATE PROCEDURE  [dabarc].[sp_SSIS_UpdateListOfSSIS_Reg] 	
	@ssis_id		INT,
	@table_id		INT,
	@database_id	INT,
	@registered		INT,
	@register_user	NVARCHAR(100)
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @IsFromDB	   BIT = 0
	DECLARE @register_date DATETIME
	-----------------------------------------------------------------------------------------------------
	--- Si no tiene tablaid indica que se modifica desde la base de datos
	-----------------------------------------------------------------------------------------------------
	IF (@table_id = 0)
		SELECT @IsFromDB = 1
	
	SET @register_date = GETDATE()

	IF (@registered = 1)
	BEGIN 	
		UPDATE       t_SSIS
		SET			 registered		= @registered,
					 table_id		= CASE WHEN @table_id = 0    THEN NULL ELSE @table_id END,		
					 database_id	= CASE WHEN @database_id = 0 THEN NULL ELSE @database_id END,		
					 register_date	= @register_date,
					 register_user	= @register_user				
		WHERE        (ssis_id		= @ssis_id)
	END
	ELSE
	BEGIN
		IF (@IsFromDB = 1)
			UPDATE   t_SSIS SET	database_id = NULL WHERE  (ssis_id = @ssis_id)
		ELSE
			UPDATE   t_SSIS SET	table_id    = NULL WHERE  (ssis_id = @ssis_id)
			
		UPDATE       t_SSIS
		--SET			 registered		= CASE WHEN table_id IS NULL AND database_id IS NULL THEN  0 ELSE 1 END,	
		SET			 registered		= 0,	
					 register_date	= @register_date,
					 register_user	= @register_user				
		WHERE        (ssis_id		= @ssis_id)	
	END
	   
	EXECUTE [dabarc].[sp_SSIS_ReadListOfNumber_Reg] @table_id , @register_user , @database_id
END
