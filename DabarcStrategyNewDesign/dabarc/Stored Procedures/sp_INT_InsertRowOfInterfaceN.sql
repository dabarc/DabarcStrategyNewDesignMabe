CREATE PROCEDURE [dabarc].[sp_INT_InsertRowOfInterfaceN]
	
	(
	@name nvarchar(128),
	@description nvarchar(500),
	@active bit,
	@priority int,
	@active_ssis bit,
	@active_rule bit,
	@active_report bit,
	@active_table bit,
	@active_bd bit,
	@modify_user nvarchar(15)
	)
	
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @modify_date DATETIME
	DECLARE @Id			 INT

	SET @modify_date = GETDATE()
	
	IF @priority = NULL SET @priority = 0;
	
	IF (SELECT COUNT(*) FROM t_InterfacesN WHERE name = RTRIM(@name)) > 0
	BEGIN
	--  RAISERROR('Ya existe una interfaz con este nombre.', 16, 1);
		RAISERROR (50067,16,1, '','')
		RETURN;
	END
	
	INSERT INTO  t_InterfacesN 
				(
				 name,
				 description,
				 active,
				 priority,
				 execute_ssis,
				 execute_rule, 
				 execute_report,
				 execute_table, 
				 execute_database, 
				 schedule_period, 
				 period, 
				 next_execution,
				 last_error, 
				 modify_date, 
				 modify_user, 
				 objects_number
				 )
		 VALUES 
			  (
				@name, 
				@description, 
				@active, 
				@priority, 
				@active_ssis, 
				@active_rule, 
				@active_report, 
				@active_table,
				@active_bd, 
				'una vez', 
				CONVERT(char(10), 
				GETDATE(), 103),
				CONVERT(char(10), 
				GETDATE(), 103),
				'Sin ejecutar', 
				@modify_date,
				@modify_user,
				0 
				) 

	SELECT @Id = @@identity
  ----------------------------------------------------------------------------
  -- Log de Movimientos
  ----------------------------------------------------------------------------
	EXECUTE dabarc.sp_log_InsertRegisterLogMov  'INSERTAR',
												't_InterfacesN',
												@Id,
												@description,
												@modify_date,
												@modify_user
				 
	RETURN
END
