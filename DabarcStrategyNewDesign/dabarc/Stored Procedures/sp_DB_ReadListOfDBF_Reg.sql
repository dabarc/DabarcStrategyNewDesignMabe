--EXECUTE dabarc.sp_DB_ReadListOfDB 'DBF'

 CREATE PROCEDURE  [dabarc].[sp_DB_ReadListOfDBF_Reg] @IsRegister INT AS
 BEGIN
  SET NOCOUNT ON;
  --EXEC dabarc.sp_sys_Sel_t_BDF_Ins
  SELECT database_id AS id,
		 [name]			
		 			
	FROM dabarc.t_BDF
	WHERE registered = @IsRegister
	ORDER BY [name] ASC
END;