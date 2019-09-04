CREATE PROCEDURE  [dabarc].[sp_TPT_ReadListOfBDFBDM] 
AS
BEGIN 
	SET NOCOUNT ON;
	--Actualizamos la tablas tff/tdm  
	execute dabarc.sp_sys_Sel_t_BDF_Ins
	execute dabarc.sp_sys_Sel_t_BDM_Ins
	--Realizamos la consulta
	
	SELECT (database_id + 10) as Id , 
			 [name] AS Name  
	FROM dabarc.t_BDF 
	WHERE name not like '(No existe)%'
	
	UNION
	
	SELECT (database_id + 100) as Id , 
			 [name] AS Name   
	FROM dabarc.t_BDM 
	WHERE name not like '(No existe)%';
END;
