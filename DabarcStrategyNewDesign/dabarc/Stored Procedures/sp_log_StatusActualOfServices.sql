CREATE PROCEDURE [dabarc].[sp_log_StatusActualOfServices]	@key_date	VARCHAR(16), 
															@status		NCHAR(10),
															@text		NVARCHAR(250) AS
 --ON
 --OFF
 --ERROR
-- SELECT * FROM dabarc.t_LogServices 

 
 If (SELECT COUNT(*) FROM dabarc.t_LogServices WHERE key_date = @key_date) > 0
 BEGIN
    UPDATE	t_LogServices
    SET		status  = @status,
			text	= @text,
			TodayIs = getdate()
    WHERE	key_date = @key_date
 END
 ELSE
  BEGIN
	INSERT INTO dabarc.t_LogServices VALUES(@key_date,@status,@text,getdate())
 END
