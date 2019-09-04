--EXECUTE dabarc.sp_DB_ReadListOfDB 'DBF'

 CREATE PROCEDURE  [dabarc].[sp_TBL_ReadListOfTablesTDM_Reg] @IsRegister INT, @database_id INT AS
 


 -----------------------------------------------------------------------
 -- Carga de tabla Interfaz
 -----------------------------------------------------------------------
	
		SELECT table_id as id
		   ,name 
	  FROM dabarc.t_TDM
	  WHERE	registered = @IsRegister 
	  AND database_id = @database_id
