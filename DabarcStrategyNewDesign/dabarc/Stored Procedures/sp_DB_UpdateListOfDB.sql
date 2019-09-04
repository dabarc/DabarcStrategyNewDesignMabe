CREATE PROCEDURE  [dabarc].[sp_DB_UpdateListOfDB]
	@TypeOfDB varchar(5),
	@database_id int,
	@active bit,
	@priority int,	
	@description nvarchar(256),
	@short_description nvarchar(50),
	@execute_rules bit,
	@execute_reports bit,
	@execute_ssis bit,
	@modify_user nvarchar(15)
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @modify_date DATETIME = GETDATE();
	------------------------------------------------------------------------------------------------------------
	--- Validamos permisos de usuario para realizar cambios.
	------------------------------------------------------------------------------------------------------------			
	-- DECLARE @permiso BIT;
	--EXEC @permiso = [dabarc].[sp_SecurityDB] @modify_user,'UPDATE', @database_id
	--IF (@permiso = 1) 
	--RETURN;
					
	IF (@active = 1 AND (@priority = 0 OR RTRIM(@short_description) = ''))
	BEGIN
	   --RAISERROR('No se puede activar un registro con prioridad "0" y sin descripción corta', 16, 1);
       RAISERROR (50051,16,1, '','')
	   RETURN;
	END
	
	IF (RTRIM(@TypeOfDB) = 'DBF')
	BEGIN 	
		UPDATE dabarc.t_BDF
		SET	description       = @description, 
			short_description = @short_description, 
			active            = @active, 
			priority          = @priority, 
			modify_date       = @modify_date, 
			modify_user       = @modify_user, 
			execute_rules     = @execute_rules, 
			execute_reports   = @execute_reports, 
			execute_ssis      = @execute_ssis
		WHERE database_id     = @database_id
	END
	
	IF (RTRIM(@TypeOfDB) = 'DBM')
	BEGIN
		UPDATE dabarc.t_BDM
		SET   description       = @description,
			  short_description = @short_description, 
			  active            = @active, 
			  priority          = @priority, 
			  modify_date       = @modify_date, 
			  modify_user       = @modify_user, 
			  execute_rules     = @execute_rules, 
		      execute_reports   = @execute_reports, 
			  execute_ssis      = @execute_ssis
		WHERE database_id       = @database_id		
	 END
  ----------------------------------------------------------------------------
  -- Log de Movimientos
  ----------------------------------------------------------------------------
  
	DECLARE @TableX NCHAR(10)  = 't_' + @TypeOfDB
	
	EXECUTE dabarc.sp_log_InsertRegisterLogMov 'MODIFICAR',
												@TableX,
												@database_id,
												@short_description,
												@modify_date,
												@modify_user;

END
