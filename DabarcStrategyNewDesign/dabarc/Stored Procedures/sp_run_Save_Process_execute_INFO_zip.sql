CREATE PROCEDURE [dabarc].[sp_run_Save_Process_execute_INFO_zip] @strUnicKey CHAR(20) AS	


 --Validamos el Objeto (Base de Datos / Tabla / Infomes)
 DECLARE @Type_Object AS NVARCHAR(30)
 DECLARE @Name_Object AS NVARCHAR(30)
 DECLARE @Id_Object   AS INT
 DECLARE @Type_Table  AS NCHAR(3)
 DECLARE @Type_Zip	  AS INT
 
	------------------------------------------------------------------------------------------------------------------------------------------------------------------
	-- Obtenemos los los datos de proceso si es base de dato o tabla o informe y si es necesario generar el ZIP	
	-- Nota. Este proceso se aplica solo con informes simples
	------------------------------------------------------------------------------------------------------------------------------------------------------------------	 
	

			 
	 SELECT @Type_Object	= RTRIM(Path_hType),
			@Name_Object	= Path_hName,
			@Id_Object		= path_id,
			@Type_Table		= SUBSTRING(Path_hName,1,3),
			@Type_Zip		= ISNULL(path_Zip,0)
	 FROM	t_Sql_process_executeH  
	 WHERE	Path_hKey		= @strUnicKey
			AND	RTRIM(Path_hType) IN ('BASE DE DATOS','TABLA','INFO') 
		--	AND Path_hStatus = 4

	------------------------------------------------------------------------------------------------------------------------------------------------------------------
	-- Creamos la tabla temporal de resultados 
	------------------------------------------------------------------------------------------------------------------------------------------------------------------	 

    CREATE TABLE #Result(Type_Zip		 CHAR(4), 
						 DirectoryOrFile NVARCHAR(1000),
						 Path_id		 INT NULL, 
						 Path_id_padre	 INT NULL,
						 Type_Info		 CHAR(3) NULL,	
						 Path_extra		 NVARCHAR(100) NULL,
						 Path_extra2	 NVARCHAR(100) NULL,
						 Path_addDate	 INT NULL,
						 Path_zip		 INT NULL,
						 Path_exten		 CHAR(4) NULL)

	CREATE TABLE #Temp  (Path_x			 NVARCHAR(200))
	
	------------------------------------------------------------------------------------------------------------------------------------------------------------------
	-- Validamos si tenemos datos 
	------------------------------------------------------------------------------------------------------------------------------------------------------------------	 

	IF (RTRIM(@Name_Object) != '')
	BEGIN
	 IF (@Type_Zip != 0)
	 BEGIN

		 -- Directo completo de una base de datos
		 IF (RTRIM(UPPER(@Type_Object)) = 'BASE DE DATOS' AND @Type_Zip = 1)
		   INSERT INTO #Result(Type_Zip,DirectoryOrFile) VALUES('DIR',@Name_Object)
		 
		 -- Directorio completo de una tabla
		 IF (RTRIM(UPPER(@Type_Object)) = 'TABLA' AND @Type_Zip = 1)
		 BEGIN
		   
		   INSERT INTO #Temp(Path_x) 
		   EXECUTE [dabarc].[sp_dbs_PathOfObjects] @Type_Table, @Id_Object
		   
		   INSERT INTO #Result(Type_Zip,DirectoryOrFile) SELECT TOP 1 'DIR',SUBSTRING(Path_x,1,LEN(Path_x)-1) FROM #Temp
		 END
	
		 --	Directorio de los archivos a cualquier nivel 
		 IF (@Type_Zip = 2)
		 BEGIN

		  --- Obtenemos todos los informes 
		  INSERT INTO #Result 	
		  SELECT 'FILE', 
				 path_name, 
				 path_id,
				 path_table_padre_id,
				 SUBSTRING(path_name,1,3),
				 path_extra, 
				 path_extra2,
				 0,0,0
		  FROM	t_Sql_process_executeD 
		  WHERE path_type = 'INFO' 
			AND path_unickey = @strUnicKey 
	  

		  --- Obtenemos de los campos extra, para obtener datos de zipiado, si agremos fecha o cual es la extención
		  UPDATE #Result
		  SET    Path_addDate   = CAST(SUBSTRING(Path_extra2,1,1) AS INT),
				 Path_zip		= CAST(SUBSTRING(Path_extra2,3,1) AS INT),
				 Path_exten		= SUBSTRING(Path_extra,3,CHARINDEX(',',Path_extra)-3)
		  
		  --- Agregamos fecha en caso de ser requerido en el reporte
		  UPDATE #Result
		  --SET    DirectoryOrFile = RTRIM(DirectoryOrFile) + '_' + CONVERT(nvarchar(6),GETDATE(),112)
		  SET    DirectoryOrFile = RTRIM(DirectoryOrFile) + '_' + REPLACE(CONVERT(VARCHAR(10), GETDATE(), 103), '/', '') 
		  WHERE  Path_addDate = 1
		  
		  --- Agregamos extesion de reporte 
		  UPDATE #Result
		  SET    DirectoryOrFile = RTRIM(DirectoryOrFile) + '.' + LOWER(RTRIM(Path_exten))
		  
		  --- Buscamos path_completo de reportes por tipos
			UPDATE	r
			SET		r.DirectoryOrFile = RTRIM(f.name) + '\' + RTRIM(t.name)+ '\' + r.DirectoryOrFile
			FROM	t_BDF		f 
				INNER JOIN t_TFF	t ON f.database_id = t.database_id
				INNER JOIN t_IFF i ON t.table_id = i.table_id
				INNER JOIN #Result		r ON i.report_id = r.Path_id AND r.Type_Info = 'IFF'

			UPDATE	r
			SET		r.DirectoryOrFile = RTRIM(f.name) + '\' + RTRIM(t.name)+ '\' + r.DirectoryOrFile
			FROM	t_BDM		f 
				INNER JOIN t_TDM	t ON f.database_id = t.database_id
				INNER JOIN t_IDM	i ON t.table_id =  i.table_id
				INNER JOIN #Result	r ON i.report_id =r.Path_id  AND r.Type_Info = 'IDM'
	
	
			UPDATE	r
			SET		r.DirectoryOrFile = RTRIM(f.name) + '\' + RTRIM(t1.name)+ '\' + r.DirectoryOrFile 
			FROM t_BDM f 
				INNER JOIN t_TDM	t  ON f.database_id = t.database_id
				INNER JOIN t_TFM	t1 ON t.table_id = t1.tdm_id
				INNER JOIN t_IFM i  ON t1.table_id = i.table_id
				INNER JOIN #Result		r  ON i.report_id =r.Path_id  AND r.Type_Info = 'IFM'


			UPDATE	#Result 
			SET		DirectoryOrFile = REPLACE(DirectoryOrFile,'.xml','.xls')

		 END 

	 END
	END

	SELECT * FROM #Result
