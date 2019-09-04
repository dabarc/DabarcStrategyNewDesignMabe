CREATE PROCEDURE  [dabarc].[sp_INFO_DeleteRowOfAll]
	
	(
	@report_id			INT,
	@typeOfInformation	VARCHAR(5),		
	@delete_user		NVARCHAR(15)
	)
	
AS
	DECLARE @delete_date DATETIME,
			@name		 NVARCHAR(128)

	SET @delete_date = GETDATE();


	IF (UPPER(RTRIM(@typeOfInformation)) = 'IFF')
	BEGIN 
	   SELECT	@name = name FROM t_IFF WHERE report_id = @report_id;
	   DELETE	FROM t_IFF WHERE report_id = @report_id;
	   EXECUTE	sp_log_InsertRegisterLogMov 'ELIMINAR','t_IFF',@report_id,@name,@delete_date,@delete_user;  

	END
 
	IF (RTRIM(@typeOfInformation) = 'IDM')	
	BEGIN
	   SELECT	@name = name FROM t_IDM WHERE report_id = @report_id;
	   DELETE	FROM t_IDM WHERE report_id = @report_id;
	   EXECUTE	sp_log_InsertRegisterLogMov 'ELIMINAR','t_IDM',@report_id,@name,@delete_date,@delete_user;  

	END
	 
	IF (RTRIM(@typeOfInformation) = 'IFM')	
	BEGIN
	   SELECT	@name = name FROM t_IFM  WHERE report_id = @report_id;
	   DELETE	FROM t_IFM WHERE report_id = @report_id;
	   EXECUTE	sp_log_InsertRegisterLogMov 'ELIMINAR','t_IFM',@report_id,@name,@delete_date,@delete_user;  

	END
