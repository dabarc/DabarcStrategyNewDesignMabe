CREATE PROCEDURE [dabarc].[sp_run_Save_Interfaz_CreateN] 
@intSegundo INT
AS
 SET NOCOUNT ON;
 SET @intSegundo = 60
 DECLARE @fecInicio  DATETIME = DATEADD(SECOND ,- @intSegundo,CONVERT(NVARCHAR(20), GETDATE(), 100))
 DECLARE @fecFin	 DATETIME = DATEADD(SECOND ,  @intSegundo,CONVERT(NVARCHAR(20), GETDATE(), 100))
 DECLARE @Interface_Id		INT
 DECLARE @Objet_Id INT
 DECLARE @Objet_Type	CHAR(5)
 DECLARE @Objet_name	NVARCHAR(200)
 DECLARE @Objet_user	NVARCHAR(15)


 DECLARE @MSGBOR_ERROR 	NVARCHAR(2000)
  
 
 IF (SELECT COUNT(*) FROM dabarc.t_InterfacesN WHERE	active = 1 AND NOT next_execution IS NULL AND next_execution BETWEEN @fecInicio AND @fecFin) = 0 
      RETURN 

	 --SELECT interface_id 
	 --FROM	dabarc.t_InterfacesN 
	 --WHERE	active = 1 
		--AND NOT next_execution IS NULL 
		--AND status = 0

		--AND	next_execution BETWEEN @fecInicio AND @fecFin
		
		

 ------------------------------------------------------------------------------------------------------------
 --- Tabla con las interfacez 
 ------------------------------------------------------------------------------------------------------------

	 DECLARE TBL_INTERFACE CURSOR FOR	 
 
	 SELECT interface_id 
	 FROM	dabarc.t_InterfacesN 
	 WHERE	active = 1 
		AND NOT next_execution IS NULL 
		AND status = 0
		AND	next_execution BETWEEN @fecInicio AND @fecFin

	OPEN	TBL_INTERFACE
	FETCH	TBL_INTERFACE INTO @Interface_Id
	WHILE   (@@FETCH_STATUS = 0 )
	BEGIN
				

	BEGIN TRANSACTION

	-----------------------------------------------------------------------------------------------
	--- Inicio Interno
	-----------------------------------------------------------------------------------------------
	DECLARE @path_unickey		  NVARCHAR(80)
	DECLARE @path_unickey_first   NVARCHAR(80)
	SELECT  @MSGBOR_ERROR = ''
	SELECT  @path_unickey_first = ''

		DECLARE TBL_INTERNOS CURSOR FOR	 
			
			SELECT	o.int_IdObj, o.object_type, o.table_name, o.modify_user 
			FROM	dabarc.t_InterfacesObjectsN o
			INNER JOIN  dabarc.t_InterfacesN i ON o.interface_id = i.interface_id
			WHERE		o.interface_id = @Interface_Id
				 AND o.active = 1 
			ORDER BY o.priority
				
			OPEN	TBL_INTERNOS
			FETCH	TBL_INTERNOS INTO @Objet_Id, @Objet_Type, @Objet_name,@Objet_user
			WHILE   (@@FETCH_STATUS = 0 )
			BEGIN
				
							
			BEGIN TRANSACTION
			
				SET		@path_unickey = ''
				SELECT  @path_unickey = VALOR_INTER  FROM dabarc.fnt_get_KeyUnic() 
				
				IF (@path_unickey_first = '') 
				SET @path_unickey_first = @path_unickey			
				
				SET @Objet_Type = RTRIM(@Objet_Type)
				
									
				-- BASE DE DATOS								
				IF (@Objet_Type = 'BDF' OR @Objet_Type = 'BDM')
				BEGIN										
					BEGIN TRY
					  execute sp_run_Save_Process_execute_DB  @Objet_Type, @Objet_Id,  @Objet_user, @path_unickey			
					END TRY
					BEGIN CATCH						  
						  SELECT  @MSGBOR_ERROR = @MSGBOR_ERROR + @Objet_name + ' >> ' +  ERROR_MESSAGE();
					END CATCH				
				END
					

				
				-- TABLAS
				IF (@Objet_Type = 'TFF' OR @Objet_Type = 'TDM' OR @Objet_Type = 'TFM')				  
				BEGIN
					BEGIN TRY
					  execute sp_run_Save_Process_execute_TABLE @Objet_Type, @Objet_Id,  @Objet_user, @path_unickey
					END TRY
					BEGIN CATCH						  
						  SELECT  @MSGBOR_ERROR = @MSGBOR_ERROR + @Objet_name + ' >> ' +  ERROR_MESSAGE();
					END CATCH				
				END
								  
				  								
				-- SSIS				
				IF (@Objet_Type = 'SSIS')				  				  
				BEGIN
					BEGIN TRY
						  execute sp_run_Save_Process_execute_SSIS @Objet_Id,  @Objet_user, @path_unickey
					END TRY
					BEGIN CATCH						  
						  SELECT  @MSGBOR_ERROR = @MSGBOR_ERROR + @Objet_name + ' >> ' +  ERROR_MESSAGE();
					END CATCH	
					
									
				END
				
				-- TODOS LOS SSIS				
				IF (@Objet_Type = 'DBSS')				  				  
				BEGIN
					BEGIN TRY
						  execute sp_run_Save_Process_execute_ALLSSIS @Objet_Id,  @Objet_user, @path_unickey
					END TRY
					BEGIN CATCH						  
						  SELECT  @MSGBOR_ERROR = @MSGBOR_ERROR + @Objet_name + ' >> ' +  ERROR_MESSAGE();
					END CATCH	
					
									
				END
				  				
				-- RULE				
				IF (@Objet_Type = 'RFF' OR @Objet_Type = 'RDM' OR @Objet_Type = 'RFM')				 
				BEGIN					
					BEGIN TRY
					   execute  sp_run_Save_Process_execute_RULE @Objet_Type, @Objet_Id,  @Objet_user, @path_unickey
					END TRY
					BEGIN CATCH						  
						  SELECT  @MSGBOR_ERROR = @MSGBOR_ERROR + @Objet_name + ' >> ' +  ERROR_MESSAGE();
					END CATCH
				
				END
				  				  				
				---- INFO				
				IF (@Objet_Type = 'IFF' OR @Objet_Type = 'IDM' OR @Objet_Type = 'IFM')				  				  
				BEGIN										
					BEGIN TRY
					   execute sp_run_Save_Process_execute_INFO @Objet_Type, @Objet_Id,  @Objet_user, @path_unickey
					END TRY
					BEGIN CATCH						  
						  SELECT  @MSGBOR_ERROR = @MSGBOR_ERROR + @Objet_name + ' >> ' +  ERROR_MESSAGE();
					END CATCH				
				END				  
     			  
				 --CREA UN REGISTRO DEL OBJETO LANZADO 
					
				INSERT INTO t_LogInterfacesN(execute_unickey,execute_object_id,execute_message,execute_status,interface_id, tssis_pathid)
				VALUES(@path_unickey, @Objet_Id,'Msj:', 0, @Interface_Id, @path_unickey_first)
				
	
				
	  		COMMIT TRANSACTION
	  		--SELECT TOP 1 * FROM dabarc.t_sql_process_executeH WHERE Path_hKey = @path_unickey ORDER BY Path_hKey DESC
			FETCH TBL_INTERNOS INTO  @Objet_Id, @Objet_Type, @Objet_name,@Objet_user
			END
			CLOSE TBL_INTERNOS
			DEALLOCATE TBL_INTERNOS


			-----------------------------------------------------------------------------------------------
			--- Fin Interno
			-----------------------------------------------------------------------------------------------
			--- manejo de error en la interfaz

			IF (RTRIM(@MSGBOR_ERROR) <> '')
			BEGIN
				UPDATE t_InterfacesN SET status = 3, last_error = SUBSTRING(@MSGBOR_ERROR,1,256), last_execution=GETDATE() WHERE interface_id = @Interface_Id
			END	
			ELSE
			BEGIN
				UPDATE t_InterfacesN SET status = 1, last_error = 'Ejecución lanzada correctamente', last_execution=GETDATE() WHERE interface_id = @Interface_Id
			END	
			
			-----------------------------------------------------------------------------------------------
			--- Fin Interno
			-----------------------------------------------------------------------------------------------
			
 		COMMIT TRANSACTION
		FETCH TBL_INTERFACE INTO @Interface_Id
	END
	CLOSE TBL_INTERFACE
	DEALLOCATE TBL_INTERFACE
	
	
 RETURN
