CREATE PROCEDURE [dabarc].[sp_run_Save_Process_RegLog] 
					@path_position	AS INT,
					@path_unickey	AS VARCHAR(40),
					@path_status	AS INT,
					@path_message	AS NVARCHAR(3000), 
					@path_datinicio	AS SMALLDATETIME, 
					@path_datfin	AS SMALLDATETIME
				  AS
/*				  
0 - inicial
1 - en proceso
2 - en ejecutandose
3 - en pausa
4 - en terminado
5 - error
6 - cancelado 

Detalles 

7 - cancelado detalle
8 - continuar detalle*/

  
  -----------------------------------------------------------------------------------------
  -- El estatus indica que los procesos estan ejecutandose
  -- Solo cambia los iniciales o los que estan en pausa (se forza el cambio)
  -----------------------------------------------------------------------------------------

  IF (@path_status = 0)
  BEGIN
   
   UPDATE	t_Sql_process_executeH
   SET		Path_hStatus = 0,		
			path_message = 'Programado'
   WHERE	Path_hKey	 = @path_unickey
   AND		Path_hStatus IN (3)
  
   UPDATE	t_Sql_process_executeD
   SET		path_status  = 0,
			path_message = 'Programado'
   WHERE	path_unickey = @path_unickey
   AND		path_status  IN (3)
   
  END
    
  IF (@path_status = 1)
  BEGIN
   
   UPDATE	t_Sql_process_executeH
   SET		Path_hStatus = 1,
			Path_hDateInitial = GETDATE(),
			path_message = 'En proceso'
   WHERE	Path_hKey	 = @path_unickey
   AND		Path_hStatus IN (0,3)
  
   UPDATE	t_Sql_process_executeD
   SET		path_status  = 1,
			path_message = 'En proceso'
   WHERE	path_unickey = @path_unickey
   AND		path_status  IN (0,3)
   
  END

  -----------------------------------------------------------------------------------------
  -- Se coloca en Ejecución el elemento sobre el cual se esta trabajando   
  -----------------------------------------------------------------------------------------
  
    
  IF (@path_status = 2)
  BEGIN
  
   UPDATE	t_Sql_process_executeD
   SET		path_status  = 2,
			path_message = 'En ejecución',
			path_dateini = GETDATE()
   WHERE	path_position = @path_position
   AND		path_status = 1
  
  END
  
  -----------------------------------------------------------------------------------------
  -- Se coloca en pausa el proceso, siempre y cuando este terminado
  -- En el caso del detalle, se cambias solo los que no se han ejecutados
  -----------------------------------------------------------------------------------------
  
  IF (@path_status = 3)
  BEGIN  
   IF (SELECT COUNT(*) FROM t_Sql_process_executeH WHERE Path_hKey = @path_unickey AND Path_hStatus = 1) > 0
   BEGIN
   
   UPDATE	t_Sql_process_executeD
   SET		path_status  = 3,
			path_message = 'Pausa'						
   WHERE	path_unickey = @path_unickey
   AND	    path_status  = 1
   
    UPDATE t_Sql_process_executeH
    SET    Path_hStatus  = 3,
		   path_message = 'Pausa'
	WHERE  Path_hKey = @path_unickey
	
			
   END
  END
  
  
  -----------------------------------------------------------------------------------------
  -- Se coloca en terminado 
  -- Este proceso valora el estatus de todos para indicar que termino
  -----------------------------------------------------------------------------------------
  
  IF (@path_status = 4 OR @path_status = 5)
  BEGIN
  
	  -----------------------------------------------------------------------------
	  -- Colcomos el estatus resultado de la ejecución
	  -----------------------------------------------------------------------------	  	  
	  UPDATE	t_Sql_process_executeD
	  SET		path_status = @path_status,
				path_message = CASE WHEN @path_status = 4 THEN 'Terminado' ELSE 'Error: ' + @path_message END,
				path_datefin = GETDATE()
				--path_datefin = @path_datfin
	  WHERE		path_position = @path_position
	  
	  -----------------------------------------------------------------------------
	  -- Validamo si hay proceso a ejecutar
	  -- Si termino y no hay mas elemento se cierra el proceso actualizando el header
	  -- Si hubo un error y es un BDM - Se pausa todo
	  -- si hubo un error y en un BDF - Continua con el proceso
	  -----------------------------------------------------------------------------
		
		If (@path_status = 5) -- si hubo un error
		BEGIN
			
		
		
			IF (SELECT COUNT(*) FROM t_Sql_process_executeH h WHERE h.Path_hKey = @path_unickey AND RTRIM(UPPER(h.Path_hName)) = 'TODOS LOS SSIS') = 0 -- si es un bdm
			BEGIN
			
			  -- Se pausan todos los que estan en proceso
			  
			   UPDATE	t_Sql_process_executeD
			   SET		path_status  = 3,
						path_message = 'Pausa'						
			   WHERE	path_unickey = @path_unickey
			   AND	    path_status  = 1
   
			   UPDATE t_Sql_process_executeH
			   SET    Path_hStatus  = 3,
					   path_message = 'Pausa'
			   WHERE  Path_hKey = @path_unickey
					
			END
		END
		
	  -----------------------------------------------------------------------------
	  -- Verificamos si aun existen elementos no procesados status = 1
	  -----------------------------------------------------------------------------
	  
	  IF (SELECT COUNT(*) FROM	t_Sql_process_executeD  WHERE path_unickey = @path_unickey AND path_status in (1,3)) = 0
	  BEGIN	   
		UPDATE	t_Sql_process_executeH
		SET		Path_hStatus = 4,
				--path_message = CASE WHEN @path_status = 5 THEN 'Terminado Error' ELSE 'Terminado' END,
				path_message = 'Terminado',
				Path_hDateFinal = GETDATE()--@path_datfin
		WHERE	Path_hKey = @path_unickey
		
		--- Si algun elemento mostro un error de debe indicar
		IF (SELECT COUNT(*) FROM	t_Sql_process_executeD  WHERE path_unickey = @path_unickey AND path_status = 5) > 0
				UPDATE	t_Sql_process_executeH SET path_message = 'Terminado - Error' WHERE Path_hKey = @path_unickey
	  END
	  
	  UPDATE	t_Sql_process_executeH
	  SET		Path_hTime = (	SELECT	SUM(DATEDIFF(ss,path_dateini,path_datefin)) 
								FROM	t_Sql_process_executeD 
								WHERE	path_unickey = @path_unickey 
								AND		path_status in (4))
	  WHERE		Path_hKey = @path_unickey	 

  END
  
  IF (@path_status = 6)
  BEGIN  
   IF (SELECT COUNT(*) FROM t_Sql_process_executeH WHERE Path_hKey = @path_unickey AND Path_hStatus in (0,1,2,3)) > 0
   BEGIN
   
   UPDATE	t_Sql_process_executeD
   SET		path_status  = 6,
			path_message = 'Cancelado'						
   WHERE	path_unickey = @path_unickey
   AND	    path_status  in (1,3)
   
    UPDATE t_Sql_process_executeH
    SET    Path_hStatus  = 6,
		   path_message = 'Cancelado'
	WHERE  Path_hKey = @path_unickey
				
   END
  END
  
  ---------------------------------------------------------------------
  
  IF (@path_status = 7)
  BEGIN     
   UPDATE	t_Sql_process_executeD
   SET		path_status = 7,
   			path_message = 'Cancelado'   			
   WHERE	path_position = @path_position AND
			path_status = 1	
  END
  
  
  
  IF (@path_status = 8)
  BEGIN  
   
   
   UPDATE	t_Sql_process_executeD
   SET		path_status = 1,
   			path_message = 'En proceso'   			
   WHERE	path_position = @path_position AND
			path_status in (7,5)
  
  END

------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Al finalizar la ejecución de cualquier proceso se valida si se lanzo de un log, para ejecutar una
-- modificación del estado de este
------------------------------------------------------------------------------------------------------------------------------------------------------------------------


	DECLARE @id_object INT

	SELECT	@id_object = ISNULL(path_id,0)
	FROM	dabarc.t_Sql_process_executeH 
	WHERE   RTRIM(Path_hKey) = RTRIM(@path_unickey) 
			AND Path_hStatus IN (4,5,6,7)

	IF (@id_object <> 0)
		EXECUTE dabarc.sp_log_StatusLogForInterface @path_unickey, @id_object
