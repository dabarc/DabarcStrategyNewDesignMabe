CREATE PROCEDURE  [dabarc].[sp_RULE_DeleteRowOfALL]
	
	(
	@rule_id	INT,
	@typeOfRule VARCHAR(5),		
	@delete_user VARCHAR(15)
	)
	
AS
	DECLARE @delete_date DATETIME,
			@name		 NVARCHAR(128)

	SET @delete_date = GETDATE()


	IF (RTRIM(@typeOfRule) = 'RFF')
	BEGIN 
	   SELECT	@name = name FROM t_RFF WHERE rule_id = @rule_id;
	   DELETE	FROM t_RFF WHERE rule_id = @rule_id;
	   EXECUTE	sp_log_InsertRegisterLogMov 'ELIMINAR','t_RFF',@rule_id,@name,@delete_date,@delete_user;   	 
	END
 
	IF (RTRIM(@typeOfRule) = 'RDM')	
	BEGIN
	   SELECT	@name = name FROM t_RDM WHERE rule_id = @rule_id;
	   DELETE	FROM t_RDM WHERE rule_id = @rule_id;
	   EXECUTE	sp_log_InsertRegisterLogMov 'ELIMINAR','t_RDM',@rule_id,@name,@delete_date,@delete_user;   
	END
	 
	IF (RTRIM(@typeOfRule) = 'RFM')	
	BEGIN
	   SELECT	@name = name FROM t_RFM WHERE rule_id = @rule_id;
	   DELETE	FROM t_RFM WHERE rule_id = @rule_id;
	   EXECUTE	sp_log_InsertRegisterLogMov 'ELIMINAR','t_RFM',@rule_id,@name,@delete_date,@delete_user;   
	END
