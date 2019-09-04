CREATE PROCEDURE dabarc.sp_run_Save_Process_execute_getNextUnickey
	@NoExecute INT AS
	SET NOCOUNT ON;

	DECLARE @STR_SQL	NVARCHAR(450)
	DECLARE @INT_RUN	INT
	DECLARE @NoExecutei INT
	
  --------------------------------------------------------------------------------------------------------------------------------------------------
  -- En esta session estableceremos algunas regla de negocio en consideración de como se realizará la ejecución de lor procesos
  --------------------------------------------------------------------------------------------------------------------------------------------------
  -- 7.	Cuando se mande un conjunto de SISS, se simula como invios individuales para permitir que siempre los paquetes se ejecuten en paralelo (de 4 y 4).
  -- 8.	Prioridad en cualquier objeto (SSIS, Reglas y Informes) BDM sobre cualquier BDF.
  -- 12. En el proceso de Ejecución, cuando se genera un error en uno de los elementos del procesos BDF –> Continuan con el siguiente elemento y un error en uno de los elementos del BDM –> se detiene en ese proceso.
 
	 --Ordenamos las ejecuciones
  
  	 --Calculamos cuandos se estan ejecutando 
  	 
  	 SELECT TOP 1 @NoExecutei = ISNULL(NumberServiceProcesses,1) FROM dabarc.AspParameters
	 
	 IF (SELECT COUNT(*) FROM	dabarc.t_Sql_process_executeH h WHERE  h.Path_hStatus = 1) >= @NoExecutei -- 1 En proceso - no debe de haber dos en proceso
	 BEGIN
	   RETURN
	 END
	 
	  
	 --IF (@INT_RUN < @NoExecute)
		--SELECT @NoExecute = @NoExecute - @INT_RUN
		
         
     CREATE TABLE #tmp_return(Path_hKey NVARCHAR(40), Order1 INT) 
         
     -- Primero ordenamos los que son de BDM
          
			INSERT INTO #tmp_return
            SELECT  top 1 
					Path_hKey,
					0
            FROM  t_Sql_process_executeH
            WHERE Path_hStatus = 0 AND RTRIM(path_TypeClass) = 'BDM'
            ORDER BY Path_hKey ASC
            
            INSERT INTO #tmp_return
            SELECT  top 1 
					Path_hKey,
					1
            FROM  t_Sql_process_executeH
            WHERE Path_hStatus = 0 AND (RTRIM(path_TypeClass) <> 'BDM' OR path_TypeClass IS NULL)
            ORDER BY Path_hKey ASC
     
		    SELECT	top 1 Path_hKey
			FROM	#tmp_return
			ORDER BY  Order1
