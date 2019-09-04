CREATE PROCEDURE  [dabarc].[sp_DB_DeleteRowOfALL]
	@database_id	INT,
	@type_database	CHAR(4),
	@delete_user	NVARCHAR(15)

AS
BEGIN 
	SET NOCOUNT ON;
	DECLARE @delete_date DATETIME,
			@name		 NVARCHAR(128)
	    SET @delete_date = GETDATE()

	----------------------------------------------------------------------------------------
	--- Validamos que no tenga elementos registrados
	----------------------------------------------------------------------------------------

	IF (UPPER(RTRIM(@type_database)) = 'BDF')
	BEGIN	
	   IF (SELECT COUNT(*) FROM t_TFF WHERE database_id = @database_id) > 0
	   BEGIN
	--	RAISERROR('La Base de Datos tiene tablas(TFF) relacionadas, que deben ser quitadas para eliminarla.', 16, 1);
		 RAISERROR (50029,16,1, '','')
		RETURN;
	   END
	    ----------------------------------------------------------------------------------------
		--- Consultamos y Eliminamos el registro
		--- Registramos Movimientos
		----------------------------------------------------------------------------------------
	   SELECT	@name = name FROM t_BDF WHERE database_id = @database_id;
	   DELETE	FROM t_BDF WHERE database_id = @database_id;
	   EXECUTE	dabarc.sp_log_InsertRegisterLogMov 'ELIMINAR','t_BDF',@database_id,@name,@delete_date,@delete_user;   
	   
	END
	IF (UPPER(RTRIM(@type_database)) = 'BDM')
	BEGIN
	   IF (SELECT COUNT(*) FROM t_TDM WHERE database_id = @database_id) > 0
	   BEGIN
	--	RAISERROR('La Base de Datos tiene tablas(TFF) relacionadas, que deben ser quitadas para eliminarla.', 16, 1);
		RAISERROR (50029,16,1, '','')
		RETURN;
	   END
	    ----------------------------------------------------------------------------------------
		--- Consultamos y Eliminamos el registro
		--- Registramos Movimientos
		----------------------------------------------------------------------------------------
	   SELECT	@name = name FROM t_BDM WHERE database_id = @database_id;
	   DELETE	FROM t_BDM WHERE database_id = @database_id;
	   EXECUTE	dabarc.sp_log_InsertRegisterLogMov 'ELIMINAR','t_BDM',@database_id,@name,@delete_date,@delete_user;   
	END
END