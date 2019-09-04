
CREATE PROCEDURE [dabarc].[sp_run_Save_Interfaz_CalculateN] AS


DECLARE @date		AS DATE
DECLARE @proxDate	AS DATETIME
DECLARE @I			AS INT
DECLARE @intDay		AS INT
	

	SELECT @date	= CONVERT(VARCHAR(10),GETDATE(),120)
	SELECT @intDay  = DATEPART(WEEKDAY,GETDATE())
	SELECT @proxDate = @date

 
---------------------------------------------------------------------------------------------
--- Create table con interfaz que estan activo
---------------------------------------------------------------------------------------------

    CREATE TABLE #Tmp(	interface_id	INT, 
						schedule_date	SMALLDATETIME,
						schedule_period INT,						
						next_date		SMALLDATETIME)

	INSERT INTO  #Tmp 
	SELECT	interface_id, 
			period,
			CASE WHEN schedule_period = 'diario'  THEN 1
				 WHEN schedule_period = 'semanal' THEN 2
				 WHEN schedule_period = 'mensual' THEN 3 
				 WHEN schedule_period = 'dia' THEN 4 END,
			NULL				 
	FROM	dabarc.t_InterfacesN
	WHERE	active = 1 AND schedule_period <> 'una vez'

---------------------------------------------------------------------------------------------
--- indicamos que ninguna ejecución de hoy se a generado en el trabajo
---------------------------------------------------------------------------------------------
	
	
---------------------------------------------------------------------------------------------
--- Aquellos que se ejecutan una sola vez se programan cuando se inserta o modifica
---------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------
--- Diario 
---------------------------------------------------------------------------------------------	
	UPDATE	#Tmp SET next_date = @proxDate WHERE	schedule_period = 1
---------------------------------------------------------------------------------------------
--- Semana
---------------------------------------------------------------------------------------------	
	UPDATE	#Tmp SET next_date = @proxDate WHERE	schedule_period = 2 AND DATEPART(weekday,schedule_date) = DATEPART(weekday,@proxDate)
---------------------------------------------------------------------------------------------
--- Mensual
---------------------------------------------------------------------------------------------	
	UPDATE	#Tmp SET next_date = @proxDate WHERE	schedule_Period = 3 AND day(schedule_date) = DAY(@proxDate)

---------------------------------------------------------------------------------------------
--- días de la semana
---------------------------------------------------------------------------------------------
	
   UPDATE t SET next_date = @proxDate
   FROM #Tmp t INNER JOIN dabarc.t_InterfacesN  i ON t.interface_id = i.interface_id
   WHERE t.schedule_period = 4 AND i.day_monday = 1 AND @intDay = 1

   UPDATE t SET next_date = @proxDate
   FROM #Tmp t INNER JOIN dabarc.t_InterfacesN  i ON t.interface_id = i.interface_id
   WHERE t.schedule_period = 4 AND i.day_tuesday = 1 AND @intDay = 2

   UPDATE t SET next_date = @proxDate
   FROM #Tmp t INNER JOIN dabarc.t_InterfacesN  i ON t.interface_id = i.interface_id
   WHERE t.schedule_period = 4 AND i.day_wednesday = 1 AND @intDay = 3

   UPDATE t SET next_date = @proxDate
   FROM #Tmp t INNER JOIN dabarc.t_InterfacesN  i ON t.interface_id = i.interface_id
   WHERE t.schedule_period = 4 AND i.day_thursday = 1 AND @intDay = 4

   UPDATE t SET next_date = @proxDate
   FROM #Tmp t INNER JOIN dabarc.t_InterfacesN  i ON t.interface_id = i.interface_id
   WHERE t.schedule_period = 4 AND i.day_friday = 1 AND @intDay = 5

   UPDATE t SET next_date = @proxDate
   FROM #Tmp t INNER JOIN dabarc.t_InterfacesN  i ON t.interface_id = i.interface_id
   WHERE t.schedule_period = 4 AND i.day_saturday = 1 AND @intDay = 6

   UPDATE t SET next_date = @proxDate
   FROM #Tmp t INNER JOIN dabarc.t_InterfacesN  i ON t.interface_id = i.interface_id
   WHERE t.schedule_period = 4 AND i.day_sunday = 1 AND @intDay = 0


---------------------------------------------------------------------------------------------
--- Agregamos hora y minuto a las fechas que si entran al dia de trabajo
---------------------------------------------------------------------------------------------		
	
	UPDATE	#Tmp SET next_date = DATEADD(hour,DATEPART(hour,schedule_date),next_date) WHERE	 NOT next_date IS NULL
	UPDATE	#Tmp SET next_date = DATEADD(minute,DATEPART(minute,schedule_date),next_date) WHERE	 NOT next_date IS NULL

---------------------------------------------------------------------------------------------
--- Regresemos la fecha a la tabla original
---------------------------------------------------------------------------------------------		

	UPDATE t
	SET t.next_execution = p.next_date,
	t.status = 0	    
	FROM dabarc.t_InterfacesN t 
		INNER JOIN #Tmp p ON t.interface_id = p.interface_id
