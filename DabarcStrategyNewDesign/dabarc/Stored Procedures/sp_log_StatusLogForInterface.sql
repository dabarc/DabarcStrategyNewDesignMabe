CREATE PROCEDURE [dabarc].[sp_log_StatusLogForInterface](@key VARCHAR(40), @id_objeto INT) As

DECLARE @INT_STATUS		AS INT
DECLARE @STATUS         AS INT
DECLARE @STR_MESSAGE	AS VARCHAR(500)
DECLARE @STR_MESSAGE1	AS VARCHAR(500)
DECLARE @EXECUTION_DATE AS DATETIME
DECLARE @PATH_TYPE		AS VARCHAR(10)
DECLARE @PATHID			AS VARCHAR(100)

 SELECT @INT_STATUS		= h.Path_hStatus, 
		@EXECUTION_DATE = Path_hDateInitial,
		@PATH_TYPE		= Path_hType
 FROM	dabarc.t_Sql_process_executeH h
 WHERE  h.Path_hKey		= @key 
		AND h.path_id	= @id_objeto
 
 ----------------------------------------------------------------------------------------------------------------------------------
 --- Obtenemos el KEy de grupo en caso de ser TSSIS
 ----------------------------------------------------------------------------------------------------------------------------------
 
 SELECT @PATHID			= tssis_pathid
 FROM	dabarc.t_Sql_process_executeD
 WHERE	path_unickey	= @key
 
 
 ----------------------------------------------------------------------------------------------------------------------------------
 --- Obtenemos el resultado del objeto procesado
 ----------------------------------------------------------------------------------------------------------------------------------
 

 SELECT TOP 1	@STR_MESSAGE = '<' + path_type + '> ' + path_name + ' Inició:' + UPPER(CONVERT( NVARCHAR(22),  path_dateini,100)) + ' Mensaje:' + path_message,
				@STATUS = path_status
 FROM			dabarc.t_Sql_process_executeD 
 WHERE			(path_unickey = @key AND path_status > 2) OR (path_unickey = @key AND path_datefin IS NULL)
 ORDER BY		path_position ASC
 
 IF(@STR_MESSAGE IS NULL)
  BEGIN
	SET @STR_MESSAGE = 'Error'
  END


  IF(RTRIM(@PATH_TYPE) = 'TSSIS')
   BEGIN

	 ------------------------------------------
	 ---------- OBJETOS TSSIS
	 ------------------------------------------
	    
	 --UPDATE		dabarc.t_LogInterfacesN 
	 --SET		execute_status  = @INT_STATUS , 
		--		execute_message = execute_message + '[ ' + SUBSTRING(@STR_MESSAGE,0,500) + ']', 
		--		execute_date	= GETDATE(), 
		--		tipo_objeto		= @PATH_TYPE 
	 --WHERE		RTRIM(execute_unickey) = RTRIM(@PATHID) and execute_object_id = @id_objeto
   
   UPDATE		dabarc.t_LogInterfacesN 
 SET		execute_status  = @INT_STATUS ,
			execute_date	= GETDATE(), 
			tipo_objeto		= @PATH_TYPE, 
			execute_message =
				
	 ( CASE WHEN @STATUS = 4 THEN
				 
				 execute_message
				 
				 ELSE 
				 
				  execute_message + '[ ' + SUBSTRING(@STR_MESSAGE,0,500) + ']'
	   END )	
					
	 WHERE		RTRIM(execute_unickey) = RTRIM(@PATHID) and execute_object_id = @id_objeto
   
   
   END
  ELSE  
   BEGIN
   
		------------------------------------------
		------- OBJETOS NORMALES
		------------------------------------------
  
     UPDATE		dabarc.t_LogInterfacesN 
     SET		execute_status	= @INT_STATUS , 
				execute_message =  SUBSTRING(@STR_MESSAGE,0,500), 
				execute_date	= @EXECUTION_DATE, 
				tipo_objeto		= @PATH_TYPE
     WHERE		RTRIM(execute_unickey) = RTRIM(@key) and execute_object_id = @id_objeto 
   END
