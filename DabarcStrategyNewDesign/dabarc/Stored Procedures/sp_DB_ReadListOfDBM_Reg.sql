CREATE PROCEDURE  [dabarc].[sp_DB_ReadListOfDBM_Reg] @IsRegister INT AS
BEGIN
    SET NOCOUNT ON;
    --EXEC dabarc.sp_sys_Sel_t_BDM_Ins
	SELECT	database_id AS id,
			[name]					
	FROM dabarc.t_BDM
	WHERE registered = @IsRegister
    ORDER BY [name] ASC
END