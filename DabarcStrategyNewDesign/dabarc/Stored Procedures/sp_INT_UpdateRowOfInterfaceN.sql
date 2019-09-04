
CREATE PROCEDURE [dabarc].[sp_INT_UpdateRowOfInterfaceN]
	
	(
	@interface_id INT,
	@name nvarchar(128),
	@description nvarchar(500),
	@active bit,
	@priority int,
	@execute_ssis bit,
	@execute_rule bit,
	@execute_report bit,
	@execute_table bit,
	@execute_database bit,
	@schedule_period nvarchar(10),	
	@period datetime,
	@day_Monday bit,
    @day_Tuesday  bit,
    @day_Wednesday bit,
    @day_Thursday bit,
    @day_Friday bit,
    @day_Saturday bit,
    @day_Sunday bit,
    @modify_user nvarchar(15)
	)
	
AS
	DECLARE @other_date		DATETIME
	DECLARE @modify_date	DATETIME
	DECLARE @next_execution	DATETIME
	DECLARE @int_dayOfWeek	INT
	DECLARE @I				INT

	SET @modify_date = GETDATE()
	
	IF @priority = NULL
		SET @priority = 0;
	

	IF (@active = 1 AND @priority = 0)
	BEGIN
	--   RAISERROR('No se puede activar un registro con prioridad "0" o "Nulo"', 16, 1);
	  RAISERROR (50049,16,1, '','')
	  
	   RETURN;
	END
	
	IF ((SELECT COUNT(*) FROM t_InterfacesN WHERE interface_id = @interface_id AND period <> @period) > 0 OR
	   (SELECT COUNT(*) FROM t_InterfacesN WHERE interface_id = @interface_id AND schedule_period <> @schedule_period) > 0)
	BEGIN
	
	   SET @schedule_period = LTRIM(RTRIM(@schedule_period))
		
	   IF (@schedule_period = 'una vez')
			 SET @next_execution = @period
			 
	   IF (@schedule_period = 'diario')
			 SET @next_execution = @period
			 
	   IF (@schedule_period = 'semanal')
			 SET @next_execution = @period
			 
	   IF (@schedule_period = 'mensual')
			 SET @next_execution = @period
			 

	   IF (@schedule_period = 'dia')
	   BEGIN
	   
			SELECT @I = 0	   
			WHILE(@I < 7)
			 BEGIN
			 SET @other_date = DATEADD(day,@I,@period)
			   SET @int_dayOfWeek   = DATEPART(WEEKDAY,@other_date) 
			  			   
			   IF (@int_dayOfWeek = 0)
			   SET @int_dayOfWeek = 6
			   ELSE
			   SET @int_dayOfWeek = (@int_dayOfWeek - 1)
			   
			   
				IF (@int_dayOfWeek = 0  and @day_Sunday   = 1)  
					BREAK
				IF (@int_dayOfWeek = 1 and @day_Monday   = 1)  
					BREAK
				IF (@int_dayOfWeek = 2 and @day_Tuesday  = 1)  
					BREAK    
				IF (@int_dayOfWeek = 3 and @day_Wednesday = 1) 
					BREAK		
				IF (@int_dayOfWeek = 4 and @day_Thursday = 1)  
					BREAK    
				If (@int_dayOfWeek = 5 and @day_Friday   = 1)  
					BREAK			
				IF (@int_dayOfWeek = 6 and @day_Saturday = 1)  
					BREAK
				
			   
			   SET @next_execution = DATEADD(day,@I,@period)
			   SET @I = @I + 1
			   
			 END
			
	   END
			--Cambiamos el estado en caso de modificar el tiempo o periodo
			UPDATE	t_InterfacesN
			SET		status = 0					  					  
			WHERE interface_id = @interface_id	
	END
	

			--next_Date_schedule = NULL,
	UPDATE	t_InterfacesN
	SET		name = @name, 
			description = @description, 
			active = @active, 
			priority = @priority, 
			modify_date = @modify_date, 
			modify_user = @modify_user, 
			execute_ssis = @execute_ssis, 
			execute_rule = @execute_rule, 
			execute_report = @execute_report, 
			execute_table = @execute_report,
			execute_database = @execute_database,
			period = CASE WHEN YEAR(@period) = 1999 THEN NULL ELSE @period END, 
			schedule_period = @schedule_period,
			next_execution = CASE WHEN YEAR(@next_execution) = 1999 THEN NULL 
									  WHEN period <> @period OR schedule_period <> @schedule_period THEN @next_execution ELSE next_execution END,			
			day_monday =    CASE WHEN UPPER(RTRIM(@schedule_period)) = 'DIA' THEN @day_monday   ELSE 0 END,
			day_tuesday =   CASE WHEN UPPER(RTRIM(@schedule_period)) = 'DIA' THEN @day_tuesday  ELSE 0 END,
			day_wednesday = CASE WHEN UPPER(RTRIM(@schedule_period)) = 'DIA' THEN @day_wednesday ELSE 0 END,
			day_thursday =  CASE WHEN UPPER(RTRIM(@schedule_period)) = 'DIA' THEN @day_thursday ELSE 0 END,
			day_friday =    CASE WHEN UPPER(RTRIM(@schedule_period)) = 'DIA' THEN @day_friday   ELSE 0 END,
			day_saturday =  CASE WHEN UPPER(RTRIM(@schedule_period)) = 'DIA' THEN @day_saturday ELSE 0 END,
			day_sunday =    CASE WHEN UPPER(RTRIM(@schedule_period)) = 'DIA' THEN @day_sunday   ELSE 0 END						  					  
	WHERE interface_id = @interface_id		
		
	EXECUTE sp_log_InsertRegisterLogMov  'MODIFICAR',
												't_InterfacesN',
												@interface_id,
												@description,
												@modify_date,
												@modify_user
