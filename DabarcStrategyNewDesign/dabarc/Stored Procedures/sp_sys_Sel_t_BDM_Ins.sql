CREATE PROCEDURE [dabarc].[sp_sys_Sel_t_BDM_Ins]
AS


  DECLARE @db_maxId			INT
  DECLARE @db_name			NVARCHAR(128)
  DECLARE @db_create_date	DATETIME

  ----------------------------------------------------------------------------------------------------------------------------------------------------------
  ---- Declaramos un ciclo para insertar la nueva db, buscando el maximo
  ----------------------------------------------------------------------------------------------------------------------------------------------------------	

		DECLARE CUR_DB2 CURSOR FOR	 
	 
			SELECT        name, create_date
			FROM            sys.databases AS cat
			WHERE        (name LIKE 'BDM_%') AND (rtrim(name) NOT IN
                                (SELECT        rtrim(name)
                                  FROM            t_BDM AS t_BDM_1)) 

		OPEN	CUR_DB2
		FETCH	CUR_DB2 INTO @db_name,@db_create_date
		WHILE (@@FETCH_STATUS = 0 )
		BEGIN
		BEGIN TRANSACTION
		
			SELECT  @db_maxId = ISNULL(MAX(database_id),50) + 1 FROM t_BDM

			INSERT INTO t_BDM (name, database_id, create_date,ssis_number, status ) VALUES(@db_name,@db_maxId,@db_create_date,0, 0)
									
						COMMIT TRANSACTION
			FETCH CUR_DB2 INTO @db_name,@db_create_date
		END
		CLOSE CUR_DB2
		DEALLOCATE CUR_DB2


                                  
  -- Borramos aquellas banderas anteriores
	 UPDATE t_BDM SET name = replace(name,'(No existe)','') WHERE name like '(No existe)%' 
	 UPDATE t_BDM SET name = replace(name,'Otra clave','') WHERE name like 'Otra clave%'                                   
                                                            
  -- Quienes fueron borrados de base de datos y existen en dabarc no registrados
  --	 DELETE FROM t_BDM  WHERE registered = 0 AND database_id NOT IN (SELECT database_id FROM sys.databases)
	 
   --Quienes fueron borrados de base de datos y existen en dabarc registrados
	 UPDATE t_BDM SET name = '(No existe)' + name WHERE rtrim(name) NOT IN (SELECT rtrim(name) FROM sys.databases)
	  	 
  -- Quienes fueremon movidos y no tienen la misma clave 
	 --UPDATE t
	 --SET 	t.name = ('Otra Clave') + s.name
	 --FROM	t_BDM t 
		--INNER JOIN sys.databases s ON t.name = s.name AND t.database_id <> s.database_id
	 --WHERE registered = 1
  
  

RETURN
