CREATE PROCEDURE [dabarc].[sp_XREF_UpdateRowXREF]
			@xref_id INT 
		   ,@description nvarchar(500)
		   ,@sheet_num INT
AS


	UPDATE t_XREF_REP
	SET		description = @description
           ,sheet_num = @sheet_num
	WHERE  xref_id = @xref_id
