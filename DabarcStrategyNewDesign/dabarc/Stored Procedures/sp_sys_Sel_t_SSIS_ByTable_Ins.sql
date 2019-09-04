CREATE PROCEDURE [dabarc].[sp_sys_Sel_t_SSIS_ByTable_Ins] @table_type nchar(3)
AS
   	-------------------------------------------------------------------------------------	
	-- Creamos una tabla temporal
	-------------------------------------------------------------------------------------	
	CREATE TABLE #TEMPORAL
	(path nvarchar(1000) NULL,
     name nvarchar(128) NULL,
    description nvarchar(256) NULL,
	create_date datetime NOT NULL);
  	-------------------------------------------------------------------------------------	
	-- Guardamos todos los datos
	-------------------------------------------------------------------------------------
	WITH ChildFolders 
	AS
	(    
		SELECT	PARENT.parentfolderid, 
				PARENT.folderid, 
				PARENT.foldername, 
				cast('' as sysname) as RootFolder, 
				cast(PARENT.foldername as varchar(max)) as FullPath, 
				0 as Lvl 
		FROM msdb.dbo.sysssispackagefolders AS PARENT 
		WHERE PARENT.parentfolderid is null		  
		
		UNION ALL	
		
		SELECT	CHILD.parentfolderid, 
				CHILD.folderid, 
				CHILD.foldername, 
				CASE ChildFolders.Lvl 
					WHEN 0 THEN CHILD.foldername           
					ELSE ChildFolders.RootFolder 
				END AS RootFolder, 
				CAST(ChildFolders.FullPath + '/' + CHILD.foldername as varchar(max)) as FullPath, 
				ChildFolders.Lvl + 1 as Lvl 
		FROM msdb.dbo.sysssispackagefolders AS CHILD     
		INNER JOIN ChildFolders 
		ON ChildFolders.folderid = CHILD.parentfolderid 
	)
	-------------------------------------------------------------------------------------	
	-- Insertamos todo los paquetes
	-------------------------------------------------------------------------------------	
	INSERT INTO #TEMPORAL
		SELECT	F.FullPath, 
				P.name, 
				P.description, 
				P.createdate  
		FROM	ChildFolders AS F 
		INNER JOIN msdb.dbo.sysssispackages AS P 
		ON P.folderid = F.folderid 
	-------------------------------------------------------------------------------------	
	-- Borramos banderas
	-------------------------------------------------------------------------------------
	 UPDATE t_SSIS 
	 SET name = REPLACE(name,'(No existe)','') 
	 WHERE name LIKE '(No existe)%' 	 
	-------------------------------------------------------------------------------------	
	-- Insertamos los que no estan
	-------------------------------------------------------------------------------------	
	INSERT INTO t_SSIS (path, name, description, create_date)
	SELECT F.path, F.name, F.description, F.create_date  
	FROM #TEMPORAL F
	WHERE (name LIKE 'SSIS[_]'+ @table_type +'[_]%') AND (name NOT IN
                                (SELECT        name
                                  FROM t_SSIS AS t_SSIS_1))     
	-------------------------------------------------------------------------------------	
	-- Validamos si lo datos que estan registrado aun existen
	-------------------------------------------------------------------------------------
	UPDATE	t
	SET		t.name = '(No existe)' + t.name
	FROM	dabarc.t_SSIS AS t 
	WHERE NOT EXISTS 
	(
	SELECT * 
	FROM #TEMPORAL AS ti 
	WHERE t.name = ti.name AND t.path = ti.path
	)		 	
RETURN
