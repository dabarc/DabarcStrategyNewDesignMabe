
CREATE PROCEDURE [dabarc].[sp_INT_UpdateListOfObjectsN]	
	(
	@object_id int,
	@description nvarchar(500),
	@active bit,
	 @priority int,
	@modify_user nvarchar(15)
	)
	
AS
	DECLARE @modify_date datetime

	SET @modify_date = GETDATE()
	
	IF @priority = NULL
		SET @priority = 0; 
	
	
	
	IF (@active = 1 AND (@priority = 0 OR @description = '' OR @description IS NULL))
	BEGIN
	
	--      RAISERROR('No se puede activar un registro con prioridad "0" o sin descripción', 16, 1);
	     RAISERROR (50050,16,1, '','')
	 RETURN;
	END
	
	
	UPDATE	dabarc.t_InterfacesObjectsN
	SET     description = @description,
			active			= @active, 
			priority		= @priority,	
			modify_date		= @modify_date, 
			modify_user		= @modify_user 			
	WHERE 	object_id		= @object_id				
			
			
	RETURN
