﻿CREATE PROCEDURE  [dabarc].[sp_TBL_UpdateListOfTFF_Reg]
	
	(	
	@database_id int,
	@table_id int,
	@registered int,
	@register_user nvarchar(15)
	)
	
AS
	DECLARE @register_date datetime

	SET @register_date = GETDATE()

	UPDATE       dabarc.t_TFF 
	SET			 registered = @registered,								
				 register_date = @register_date,
				 register_user = @register_user				
	WHERE        (database_id = @database_id AND table_id = @table_id)

    EXECUTE dabarc.sp_TBL_UpdateListOfNumber_Reg 'DBF',@database_id,@register_user

   --IF (@registered = 1)
   --BEGIN
   --   DECLARE @name VARCHAR(50)
   --   SELECT @name = name FROM dabarc.t_TFF WHERE database_id = @database_id AND table_id = @table_id
   --   EXEC sp_INT_InsertAutoRegInterface @name, @table_id
   --END
