CREATE PROCEDURE [dabarc].[sp_INFO_ReadListOfInformations_Zip] 
(
   @path_type		nvarchar(100), -- IFF, IFM, IDM
   @path_TableId	int, -- Id de la tabla 
   @path_Id			int, -- Id del Informe
   @execute_user	nvarchar(15)
)AS


	----------------------------------------------------------------------------------------------
	-- Retornamos una lista con la ruta y nombre de los archivos y con las extensiones que por omision tienen.
	-- 1.- buscamos lo sis
	-- 2.- buscamos la tabla en donde se encuentran
	-- 3.- buscamos la base de datos en donde se encuentran
	-- Si se crea de una sola vista, el .rar conversa el nombre de la vista
	-- Si se crea de mas de una vista, el .rar se crea con el nombre de la tabla
	----------------------------------------------------------------------------------------------

	-----------------------------------------------------------------------------------------
	---- CREATE TABLE
	-----------------------------------------------------------------------------------------

	CREATE TABLE #TBL_LIST(name_db VARCHAR(100),name_table VARCHAR(100),table_id INT, name VARCHAR(2000))
	SET @path_type = SUBSTRING(@path_type,3,3)

	-----------------------------------------------------------------------------------------
	---- Obtenemos nombre de informe
	-----------------------------------------------------------------------------------------
	IF (@path_Id > 0)
	BEGIN
			
		INSERT INTO #TBL_LIST(name_db,name_table,table_id,name)
		SELECT	null,null, table_id, RTRIM(name) + CASE	WHEN report_export = 'XLS' THEN '.xls'
									WHEN report_export = 'TXT' THEN '.txt'
									WHEN report_export = 'XML' THEN '.xml' 
									WHEN report_export = 'XLSX' THEN '.xlsx' ELSE '.txt' END	
		FROM	vw_Active_INFO 
		WHERE	Type_Table = @path_type AND report_id	= @path_Id
	
	END
	ELSE	   
	BEGIN
	
		INSERT INTO #TBL_LIST(name_db,name_table,table_id,name)		
		SELECT	null,null, table_id, RTRIM(name) + CASE	WHEN report_export = 'XLS' THEN '.xls'
									WHEN report_export = 'TXT' THEN '.txt'
									WHEN report_export = 'XML' THEN '.xml' 
									WHEN report_export = 'XLSX' THEN '.xlsx' ELSE '.txt' END	
		FROM	vw_Active_INFO 
		WHERE	Type_Table = @path_type AND table_id= @path_TableId
	END		   

    
    IF (@path_type = 'IFF')
    BEGIN    
		UPDATE t
		SET    t.name_table = f.name,
			   t.name_db	= b.name 
		FROM #TBL_LIST t
		INNER JOIN dabarc.t_TFF f ON t.table_id = f.table_id
		INNER JOIN dabarc.t_BDF b ON f.database_id = b.database_id
    END
    
    IF (@path_type = 'IDM')
    BEGIN    
    	UPDATE t
		SET    t.name_table = d.name,
			   t.name_db	= b.name 
		FROM #TBL_LIST t
		INNER JOIN dabarc.t_TDM d ON t.table_id = d.table_id
		INNER JOIN dabarc.t_BDM b ON d.database_id = b.database_id
    END
       
    IF (@path_type = 'IFM')
    BEGIN
    
     UPDATE t
	 SET    t.name_table = m.name,
			t.name_db	=  d2.name 
	  FROM #TBL_LIST t
     INNER JOIN dabarc.t_TFM m ON t.table_id = m.table_id
     INNER JOIN dabarc.t_TDM d ON m.tdm_id = d.table_id
     INNER JOIN dabarc.t_BDM d2 ON d.database_id = d2.database_id
    END
    
	SELECT name_db,name_table, name 
	FROM   #TBL_LIST
