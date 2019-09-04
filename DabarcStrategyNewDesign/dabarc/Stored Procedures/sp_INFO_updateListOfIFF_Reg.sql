CREATE PROCEDURE  [dabarc].[sp_INFO_updateListOfIFF_Reg] 	
	(	
	@table_id	int,
	@report_id	int,
	@registered int,
	@register_user nvarchar(15)
	)
	
AS
 

	DECLARE @register_date datetime

	SET @register_date = GETDATE()

	UPDATE       dabarc.t_IFF 
	SET			 registered		= @registered,								
				 register_date	= @register_date,
				 register_user	= @register_user				
	WHERE        (table_id = @table_id AND report_id = @report_id)


 EXECUTE		[dabarc].[sp_INFO_updateListOfNumber_Reg] 'TFF', @table_id, @register_user

   --IF (@registered = 1)
   --BEGIN
   --   DECLARE @name VARCHAR(50)
   --   SELECT @name = name FROM dabarc.t_IFF WHERE table_id = @table_id AND report_id = @report_id
   --   EXEC sp_INT_InsertAutoRegInterface @name, @report_id
   --END
