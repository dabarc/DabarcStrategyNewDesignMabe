CREATE PROCEDURE  [dabarc].[sp_DB_UpdateListOfDBF_Reg]
	@database_id int,
	@registered int,
	@register_user nvarchar(15)
AS
BEGIN
 SET NOCOUNT ON;
 DECLARE @register_date datetime
 SET @register_date = GETDATE()
 --EXEC [dabarc].[sp_SecurityDB] @register_user,'INSERT', @database_id
 UPDATE dabarc.t_BDF
 SET registered    = @registered,								
     register_date = @register_date,
 	 register_user = @register_user				
 WHERE database_id = @database_id;
END
