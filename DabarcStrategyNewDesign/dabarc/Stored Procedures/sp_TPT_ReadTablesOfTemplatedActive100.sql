
CREATE PROCEDURE [dabarc].[sp_TPT_ReadTablesOfTemplatedActive100] @Plantilla_Id INT 
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @intId INT 
 
	------------------------------------------------------------------------------------------
	--- Create table temporal 
	------------------------------------------------------------------------------------------
	CREATE TABLE #t_PlantillaD_temp
	(
		plantillad_id	int,
		table_name		nvarchar(250) NULL,
		table_esquema	nvarchar(150) NULL,
		table_nametdm	nvarchar(250) NULL,
		table_where		nvarchar(900) NULL,
		table_sql		nvarchar(max) NULL,
		table_countrow  int default(0),
		add_data		bit default(0),
		plant_where		nvarchar(900) NULL,
		ssis_strsql001	nvarchar(max) NULL,
		ssis_strsql002	nvarchar(max) NULL,
		ssis_strsql003	nvarchar(max) NULL,
		ssis_strsql004	nvarchar(max) NULL,
		instance_source nvarchar(50) NULL
	 );

	 /*Validacion para exceles*/
	Declare @table_esquema varchar(20)
	SELECT	@table_esquema=table_esquema
	FROM    dabarc.t_PlantillaD d
			INNER JOIN dabarc.t_PlantillaH h ON d.plantilla_id = h.plantilla_id
	WHERE	d.plantilla_id = @Plantilla_Id;

	INSERT INTO #t_PlantillaD_temp
						(plantillad_id,	
						 table_name, 
						 table_esquema, 
						 table_nametdm, 
						 table_where,
						 add_data,
						 plant_where,
						 instance_source)
				SELECT	plantillad_id,
						table_name,
						table_esquema,
						table_nametdm,
						table_where,
						ISNULL(d.add_data,0) AS add_data,
						h.add_where,
						h.instance_source
			FROM		dabarc.t_PlantillaD AS d
		    INNER JOIN dabarc.t_PlantillaH AS h ON d.plantilla_id = h.plantilla_id
			WHERE d.plantilla_id = @Plantilla_Id AND active = 1 AND d.porc_equal = 100;
	 ------------------------------------------------------------------------------------------
	 --- Crear consulta de los los elementos seleccionados
	 ------------------------------------------------------------------------------------------
			DECLARE Cur_Sql CURSOR FOR   
			SELECT	plantillad_id FROM #t_PlantillaD_temp
			OPEN Cur_Sql  
			   FETCH NEXT FROM Cur_Sql INTO @intId		  
			WHILE @@FETCH_STATUS = 0  
			BEGIN  
				execute dabarc.sp_CreateSQLforPlantilla @intId
				FETCH NEXT FROM Cur_Sql INTO @intId
			END   
			CLOSE Cur_Sql;  
			DEALLOCATE Cur_Sql;  
	 ------------------------------------------------------------------------------------------
	 --- Actualizamos con SQL
	 ------------------------------------------------------------------------------------------
		UPDATE t
		SET ssis_strsql001 = RTRIM(d.ssis_sql001) + ' ',
			ssis_strsql002 = RTRIM(d.ssis_sql002),
			ssis_strsql003 = RTRIM(d.ssis_sql003),
			ssis_strsql004 = RTRIM(d.ssis_sql004),
			table_countrow = (SELECT COUNT(*) FROM #t_PlantillaD_temp),
			table_where = (CASE WHEN t.add_data = 1 AND ISNULL(RTRIM(t.table_where),'') = '' THEN plant_where
								WHEN t.add_data = 1 AND ISNULL(RTRIM(t.table_where),'') <> '' THEN plant_where + ' AND ' + t.table_where ELSE t.table_where END) -- Si la plantilla agrega y no elimina
		FROM #t_PlantillaD_temp t
			INNER JOIN dabarc.t_PlantillaD d ON t.plantillad_id = d.plantillad_id

	 IF (RTRIM(UPPER(@table_esquema)) = 'XLS')
	 BEGIN
			DECLARE @IntRETURN INT
			SET @IntRETURN = 0;
		
			SELECT @IntRETURN = ISNULL(COUNT(*),0) FROM dabarc.t_PlantillaH h
			INNER JOIN dabarc.t_PlantillaD d ON h.plantilla_id = d.plantilla_id
			WHERE h.plantilla_id = @Plantilla_Id      
		
			UPDATE #t_PlantillaD_temp SET table_countrow = @IntRETURN
	 END
	 ------------------------------------------------------------------------------------------
	 --- regreso de datos
	 ------------------------------------------------------------------------------------------	
		SELECT plantillad_id	int,
			table_name,
			table_esquema,
			table_nametdm,
			table_where,
			table_sql = ISNULL(ssis_strsql001,'') + ISNULL(ssis_strsql002,'') + ISNULL(ssis_strsql003,'') + ISNULL(ssis_strsql004,''),
			table_countrow ,
			add_data,
			plant_where,
			instance_source
		FROM   #t_PlantillaD_temp;
END
