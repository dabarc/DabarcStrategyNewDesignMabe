--EXEC [dabarc].[sp_TBL_ReadListOfTablesTFM_Reg] 0,2;
CREATE PROCEDURE  [dabarc].[sp_TBL_ReadListOfTablesTFM_Reg] 
@IsRegister INT, 
@database_id INT AS
BEGIN
	SET NOCOUNT ON;
	SELECT  table_id
			,name
	FROM dabarc.t_TFM 
	WHERE	registered = @IsRegister 
	AND		tdm_id = @database_id
 ORDER BY name ASC;
END;
