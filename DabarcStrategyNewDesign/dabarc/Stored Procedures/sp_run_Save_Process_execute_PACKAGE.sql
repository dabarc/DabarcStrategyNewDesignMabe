CREATE PROCEDURE [dabarc].[sp_run_Save_Process_execute_PACKAGE] 
   @plantilla_id			int, -- Id
   @path_ofruth		nvarchar(250),
   @execute_user	nvarchar(15)
AS
BEGIN 	
	SET NOCOUNT ON;
	-----------------------------------------------------------------------------------------
	---- DECLARACIONES Y ASIGNACIONEs
	-----------------------------------------------------------------------------------------
	DECLARE @path_unickey	NVARCHAR(20) 
	SELECT	@path_unickey	= VALOR_INTER FROM dabarc.fnt_get_KeyUnic()		
	------------------------------------------------------------------------------------------------------------
	--- Validaciones
	------------------------------------------------------------------------------------------------------------										
	IF (SELECT COUNT(*) FROM dabarc.vw_Active_TemplateSSIS WHERE plantilla_id = @plantilla_id AND Empate = 100) = 0
	BEGIN
		--RAISERROR('La plantilla no tiene todas las columnas empatadas, por favor revísela nuevamente.', 16, 1);
	    RAISERROR (50033,16,1,'','') 
		RETURN;
	END	

	IF (SELECT COUNT(*) FROM dabarc.vw_Active_TemplateSSIS v INNER JOIN t_Sql_process_executeH H 
		ON v.plan_name = H.Path_hName and H.Path_hType = 'PACKAGE' AND (h.Path_hStatus <= 1 OR H.Path_hStatus = 3)
		WHERE v.plantilla_id = @plantilla_id) > 0
	BEGIN
		 --	RAISERROR('Hay un elemento en ejecución o programado para próxima ejecución, verifique este dato en el módulo de ejecuciones.', 16, 1);
		RAISERROR (50026,16, 1,'','')
		RETURN;	
	END

	-----------------------------------------------------------------------------------------
	---- EJECUCIONES
	-----------------------------------------------------------------------------------------
	INSERT INTO dabarc.t_Sql_process_executeH(Path_hKey,Path_hName,Path_hType,Path_hDateInitial,Path_hUser,path_hTypeProcess,path_TypeClass)
	SELECT	@path_unickey,plan_name,'PACKAGE',GETDATE(),@execute_user,'Proceso','BOTH'
	FROM	vw_Active_TemplateSSIS	
	WHERE	plantilla_id = @plantilla_id

	INSERT INTO dabarc.t_Sql_process_executeD (path_unickey,path_table, path_id,path_name,path_type,path_date,path_dateini,path_status,path_executeuser,path_Priority,path_extra,path_table_padre_id, path_id_name)
	SELECT	@path_unickey,
			'',
			plantilla_id,
			plan_name,
			'PACKAGE',
			GETDATE(),
			NULL,		
			0,
			@execute_user,
			Priority,
			@path_ofruth,
			0,
			'plantilla_id'
	FROM	vw_Active_TemplateSSIS
	WHERE	plantilla_id = @plantilla_id
END
