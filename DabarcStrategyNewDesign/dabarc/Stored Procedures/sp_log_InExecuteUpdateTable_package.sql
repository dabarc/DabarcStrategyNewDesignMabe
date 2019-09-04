CREATE PROCEDURE [dabarc].[sp_log_InExecuteUpdateTable_package]
	@Template_id int,
	@execute_user nvarchar(15),
	@execute_date datetime,
	@execute_time nvarchar(25),
	@last_error nvarchar(4000)
AS
BEGIN 
SET NOCOUNT ON;
	UPDATE  dabarc.t_PlantillaH
	SET execute_date = CONVERT(nvarchar(30), @execute_date, 109), 
		execute_user = @execute_user, 
		execute_time = @execute_time, 
		last_error   = @last_error,
		status       = 3
	WHERE plantilla_id = @Template_id;
	RETURN
END;
