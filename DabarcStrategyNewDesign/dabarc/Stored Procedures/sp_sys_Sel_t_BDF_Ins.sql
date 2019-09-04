CREATE PROCEDURE [dabarc].[sp_sys_Sel_t_BDF_Ins]
AS

  DECLARE @db_maxId			INT
  DECLARE @db_name			NVARCHAR(128)
  DECLARE @db_create_date	DATETIME

  ----------------------------------------------------------------------------------------------------------------------------------------------------------
  ---- Declaramos un ciclo para insertar la nueva db, buscando el maximo
  ----------------------------------------------------------------------------------------------------------------------------------------------------------	

		DECLARE CUR_DB CURSOR FOR	 
			SELECT [name], create_date FROM sys.databases WHERE name LIKE 'BDF_%'
			EXCEPT
			SELECT [name], create_date FROM dabarc.t_BDF
		
		OPEN	CUR_DB
			FETCH	CUR_DB INTO @db_name,@db_create_date
			WHILE (@@FETCH_STATUS = 0 )
		BEGIN
			BEGIN TRANSACTION
				SELECT  @db_maxId = ISNULL(MAX(database_id),0) + 1 FROM t_BDF
				INSERT INTO t_BDF (name, database_id, create_date, status) VALUES(@db_name,@db_maxId,@db_create_date, 0)
            COMMIT TRANSACTION
			FETCH CUR_DB INTO @db_name,@db_create_date
		END
		CLOSE CUR_DB
		DEALLOCATE CUR_DB
		
  ----------------------------------------------------------------------------------------------------------------------------------------------------------
  ---- Identificamos aquellos que ya no existen
  ----------------------------------------------------------------------------------------------------------------------------------------------------------	
                             
  -- Borramos aquellas banderas
	 UPDATE t_BDF SET name = replace(name,'(No existe)','') WHERE name like '(No existe)%' 
	 UPDATE t_BDF SET name = replace(name,'(Otra clave)','') WHERE name like '(Otra clave)%' 

  -- Quienes fueron borrados de base de datos y existen en dabarc no registrados
     --DELETE FROM t_BDF  
	 --WHERE registered = 0 AND [name] NOT IN (SELECT [name] FROM sys.databases)
	 
  -- Quienes fueron borrados de base de datos y existen en dabarc registrados
	 UPDATE t_BDF 
		SET [name] = '(No existe)' + [name] 
	 WHERE [name] NOT IN (SELECT [name] FROM sys.databases)
	 --registered = 1 AND 
	  	 
  -- Quienes fueremon movidos y no tienen la misma clave 
	 --UPDATE t
	 --SET 	t.name = '(Otra Clave)' + s.name
	 --FROM	t_BDF t 
		--INNER JOIN sys.databases s ON t.name = s.name AND t.database_id <> s.database_id
	 --WHERE registered = 1
RETURN
