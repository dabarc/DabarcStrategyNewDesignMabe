--EXECUTE dabarc.sp_DB_ReadListOfDB 'DBF'

CREATE PROCEDURE  [dabarc].[sp_TBL_ReadListOfTablesTFF_Reg] 
@IsRegister INT,
@database_id INT AS
BEGIN
	SET NOCOUNT ON;
	SELECT table_id as id
		   ,name  
	FROM dabarc.t_TFF
	WHERE registered = @IsRegister AND database_id = @database_id;
END
