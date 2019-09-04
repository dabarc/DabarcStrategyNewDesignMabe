--EXEC [dabarc].[sp_log_InExecuteUpdateAllProcess] '20190828002553', 'SSIS','admin'
CREATE PROCEDURE [dabarc].[sp_log_InExecuteUpdateAllProcess] @ppath_unickey	    NVARCHAR(80),
														     @path_type		    NVARCHAR(20),
														     @execute_user		NVARCHAR(15) AS
					
					
  DECLARE @TYPE_TABLE	NCHAR(10)
  DECLARE @TABLE		NCHAR(10)

  -- Parametros para la sub consulta 	
  DECLARE @name_table_id NVARCHAR(30)
  DECLARE @name_col_id   NVARCHAR(30)
  DECLARE @path_id	     INT
  DECLARE @p_today		 DATETIME
  DECLARE @today         DATETIME
  
  SET @today = GETDATE()
 
  -- Identificamos el tipo de objeto 
  IF (RTRIM(@path_type) = 'DB' OR RTRIM(@path_type) = 'TABLE')
  BEGIN
  
    SELECT	@TYPE_TABLE		= RTRIM(path_TypeClass), 
			@path_id		= path_id
    FROM	t_Sql_process_executeH 
    WHERE	RTRIM(Path_hKey)= @ppath_unickey 
    
	SET @TYPE_TABLE = 't_' + RTRIM(@TYPE_TABLE)	
    IF (RTRIM(@path_type) = 'DB')   EXECUTE dabarc.sp_log_InExecuteUpdateTable @path_id,'database_id',@TYPE_TABLE,1,@execute_user,@today,@today
                                                                        
    IF (RTRIM(@path_type) = 'TABLE')  EXECUTE dabarc.sp_log_InExecuteUpdateTable @path_id,'table_id',@TYPE_TABLE,1,@execute_user,@today,@today
    

  END

  IF (RTRIM(@path_type) <> 'DB' AND RTRIM(@path_type) <> 'TABLE')
  BEGIN

			SET @p_today = GETDATE()
			--SET @p_today = RTRIM(CONVERT(nvarchar(30), GETDATE(), 103)) + ' ' + RTRIM(CONVERT(nvarchar(30), GETDATE(), 108))
			

		    DECLARE DETALLES_STATUS CURSOR FOR	 
			
			SELECT  path_table, --Nombre de la tabla
					path_id_name, -- Nombre de la columna
					path_id -- Id del campo 
			FROM    t_Sql_process_executeD
			WHERE  RTRIM(path_unickey) = @ppath_unickey
				
			OPEN	DETALLES_STATUS
			FETCH	DETALLES_STATUS INTO @name_table_id, @name_col_id, @path_id
			WHILE   (@@FETCH_STATUS = 0 )
			BEGIN
						 
			BEGIN TRANSACTION
	                 
                EXECUTE dabarc.sp_log_InExecuteUpdateTable @path_id,@name_col_id,@name_table_id,1,'ADMIN',@p_today,@today
				
	  		COMMIT TRANSACTION
			FETCH DETALLES_STATUS INTO  @name_table_id, @name_col_id, @path_id
			END
			CLOSE DETALLES_STATUS
			DEALLOCATE DETALLES_STATUS  
  
  END
