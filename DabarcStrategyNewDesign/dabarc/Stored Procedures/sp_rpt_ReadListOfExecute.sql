CREATE PROCEDURE [dabarc].[sp_rpt_ReadListOfExecute] @strhKey AS VARCHAR(20) AS 		 
					 
  				  
   CREATE TABLE #Temp(Position		INT,--lugar que ocupa en la ejecución
					 NameRaiz		VARCHAR(100), --Padre del objeto 
					 NameRaizDesc	VARCHAR(500), --Padre del objeto 
					 NameObject		VARCHAR(100),-- Nombre de Objeto
					 ObjectType		VARCHAR(50), -- Tipo del Objeto
					 DateInitial	SMALLDATETIME, -- Inicio de la ejecución
					 DateEnd		SMALLDATETIME, -- Fin de ejecución 
					-- ObjectPather	VARCHAR(100), -- Objeto de quien depende
					 ObjectField	VARCHAR(100), -- Campo que afecta 
					 ObjectDesc		VARCHAR(500), -- Descripción del objeto
					 ObjtecStatus	CHAR(10), -- Estatus en el que termina
					 ObjtecStError	VARCHAR(500), -- En caso de error
					 ObjectId		INT)
	
		 
				
	-----------------------------------------------------------------------------------------------
	-- Colocamos como primer elemento el objeto principal
	-----------------------------------------------------------------------------------------------
	
	INSERT INTO #Temp(Position, 
					  NameRaiz, 
					  NameObject, 
					  ObjectType, 
					  DateInitial, 
					  DateEnd,  
					  ObjtecStatus, 
					  ObjtecStError,
					  ObjectId) 
	SELECT  1000000,
			Path_hName,
			Path_hName,
			path_TypeClass,
			Path_hDateInitial,
			Path_hDateFinal,
			Path_hStatus,
			path_message,
			path_id
	FROM	dabarc.t_Sql_process_executeH 
	WHERE Path_hKey = @strhKey
	
	
	INSERT INTO #Temp(Position, 
					  NameRaiz, 
					  NameObject, 
					  ObjectType, 
					  DateInitial, 
					  DateEnd,  
					  ObjtecStatus, 
					  ObjtecStError,
					  ObjectId) 	
	SELECT path_position,
		   '',
		   path_name,
		   SUBSTRING(path_name,1,3),
		   path_dateini,
		   path_datefin,
		   path_status,
		   path_message,
		   path_id
	FROM   dabarc.t_Sql_process_executeD 
	WHERE path_unickey = @strhKey
	
	----------------------------------------------------------------------------------------
	-- Obtenemos informacióm de SSIS y base de datos
	----------------------------------------------------------------------------------------
	
	-- Para los paquetes SSIS el papá es la base de datos
	
	UPDATE t
	SET    t.NameRaiz = SUBSTRING(s.path,2,LEN(s.path)) FROM #Temp t
		INNER JOIN dabarc.t_SSIS s ON t.ObjectId = s.ssis_id
	WHERE t.ObjectType= 'SSIS'
		

	UPDATE	t
	SET		t.ObjectDesc = b.short_description,
			t.NameRaizDesc = b.short_description,
			t.NameRaiz = b.name
	FROM #Temp t
		INNER JOIN dabarc.t_BDF b ON t.ObjectId = b.database_id
	WHERE t.ObjectType= 'BDF'
	
	UPDATE	t
	SET		t.ObjectDesc = b.short_description,
			t.NameRaizDesc = b.short_description,
			t.NameRaiz = b.name
	FROM #Temp t
		INNER JOIN dabarc.t_BDM b ON t.ObjectId = b.database_id
	WHERE t.ObjectType= 'BDM'
			
	----------------------------------------------------------------------------------------
	-- Obtenemos informacióm de tablas
	----------------------------------------------------------------------------------------
	UPDATE  t
	SET		t.NameRaiz = bf.name,
			t.NameRaizDesc = bf.short_description,
			t.ObjectDesc = f.description
	FROM #Temp t
		INNER JOIN dabarc.t_TFF f ON t.ObjectId = f.table_id
		INNER JOIN dabarc.t_BDF bf ON f.database_id = bf.database_id
	WHERE t.ObjectType= 'TFF'
	
	
	UPDATE  t
	SET		t.NameRaiz = bf.name,
			t.NameRaizDesc = bf.short_description,
			t.ObjectDesc = f.description
	FROM #Temp t
		INNER JOIN dabarc.t_TDM f ON t.ObjectId = f.table_id
		INNER JOIN dabarc.t_BDF bf ON f.database_id = bf.database_id
	WHERE t.ObjectType= 'TDM'
	
	
	UPDATE  t
	SET		t.NameRaiz = d.name,
			t.NameRaizDesc = d.short_description,
			t.ObjectDesc = f.short_description
	FROM #Temp t
		INNER JOIN dabarc.t_TFM f ON t.ObjectId = f.table_id
		INNER JOIN dabarc.t_TDM d ON f.tdm_id = d.table_id
		INNER JOIN dabarc.t_BDF bf ON d.database_id = bf.database_id
	WHERE t.ObjectType= 'TFM'
	
	
	
	----------------------------------------------------------------------------------------
	-- Obtenemos la descripción de cada objeto
	----------------------------------------------------------------------------------------
	
	
	UPDATE  t
	SET		t.NameRaiz = f.name,
			t.NameRaizDesc = f.short_description,
			t.ObjectDesc = r.short_description
	FROM #Temp t 
		INNER JOIN dabarc.t_RFF r ON t.ObjectId = r.rule_id
		INNER JOIN dabarc.t_TFF f ON r.table_id = f.table_id
	WHERE t.ObjectType= 'RFF'	
	
	
	UPDATE  t
	SET		t.NameRaiz = f.name,
			t.NameRaizDesc = f.short_description,
			t.ObjectDesc = r.short_description
	FROM #Temp t 
		INNER JOIN dabarc.t_RDM r ON t.ObjectId = r.rule_id
		INNER JOIN dabarc.t_TDM f ON r.table_id = f.table_id
	WHERE t.ObjectType= 'RDM'	
	
		
	UPDATE  t
	SET		t.NameRaiz = f.name,
			t.NameRaizDesc = f.short_description,
			t.ObjectDesc = r.short_description
	FROM #Temp t 
		INNER JOIN dabarc.t_RFM r ON t.ObjectId = r.rule_id
		INNER JOIN dabarc.t_TFM f ON r.table_id = f.table_id
	WHERE t.ObjectType= 'RFM'	
	
	
	----------------------------------------------------------------------------------------
	-- Obtenemos la descripción de informes
	----------------------------------------------------------------------------------------
	
	
	UPDATE  t
	SET		t.NameRaiz = f.name,
			t.NameRaizDesc = f.short_description,
			t.ObjectDesc = r.short_description
	FROM #Temp t 
		INNER JOIN dabarc.t_IFF r ON t.ObjectId = r.report_id
		INNER JOIN dabarc.t_TFF f ON r.table_id = f.table_id
	WHERE t.ObjectType= 'IFF'	
	
	
	UPDATE  t
	SET		t.NameRaiz = f.name,
			t.NameRaizDesc = f.short_description,
			t.ObjectDesc = r.short_description
	FROM #Temp t 
		INNER JOIN dabarc.t_IDM r ON t.ObjectId = r.report_id
		INNER JOIN dabarc.t_TDM f ON r.table_id = f.table_id
	WHERE t.ObjectType= 'IDM'	
	
	
	UPDATE  t
	SET		t.NameRaiz = f.name,
			t.NameRaizDesc = f.short_description,
			t.ObjectDesc = r.short_description
	FROM #Temp t 
		INNER JOIN dabarc.t_IFM r ON t.ObjectId = r.report_id
		INNER JOIN dabarc.t_TFM f ON r.table_id = f.table_id
	WHERE t.ObjectType= 'IFM'	
	
	
	----------------------------------------------------------------------------------------
	-- Obtenemos el campo desde el nombre del objeto
	-- Borramos los primero 
	----------------------------------------------------------------------------------------


	UPDATE #Temp SET ObjectField = substring(NameObject,5,LEN(NameObject)) WHERE ObjectType IN ('RFF','RDM','RFM','IFF','IDM','IFM')
	UPDATE #Temp SET ObjectField = REPLACE(ObjectField, SUBSTRING(NameRaiz,5,LEN(NameRaiz)) , '') WHERE ObjectType IN ('RFF','RDM','RFM','IFF','IDM','IFM')
	UPDATE #Temp SET ObjectField = SUBSTRING(ObjectField,2,CHARINDEX('_',ObjectField,2)-2) WHERE ObjectType IN ('RFF','RDM','RFM','IFF','IDM','IFM')
	
	
	
					 
	SELECT  Position,
			NameRaiz,
			NameRaizDesc,
			NameObject,
			ObjectType,
			DateInitial,
			DateEnd,
			ObjectField,
			ObjectDesc,
			ObjtecStatus,
			ObjtecStError,
			ObjectId
	 FROM #Temp
	 ORDER BY Position ASC
