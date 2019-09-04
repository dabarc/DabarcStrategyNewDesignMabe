--EXEC [dabarc].[sp_dbs_Table_Trunc] 3, "BDF_GEPP_TEST.dbo.TFF_TDM_PS_GEPP_PROD";
CREATE PROCEDURE [dabarc].[sp_dbs_Table_Trunc]
	@ssis_id int,
	@table_name nvarchar(128)
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @DB_id			INT,
			@Table_id		INT,
			@NameSSIS		NVARCHAR(2000),
			@sqlstr			NVARCHAR(150),
			@typestr		CHAR(5),
			@nameDB		    NVARCHAR(50),
			@nameTable		NVARCHAR(50),
            @IsOnlyDeleted	BIT = 0 ,
	        @WhereDeleted	NVARCHAR(2000),
			@instance		NVARCHAR(50);
	 ---------------------------------------------------------------------------------------
	 -- Si mi ssis no tiene tabla buscamos borrar la tabla que se manda desde la plantilla
	 ---------------------------------------------------------------------------------------
	 SELECT		@Table_id	= ISNULL(table_id,0), 
				@typestr	= RTRIM(SUBSTRING(name,6,3)),
				@NameSSIS	= RTRIM(name)
	 FROM		t_SSIS 
	 WHERE		ssis_id = @ssis_id;
 ---------------------------------------------------------------------------------------
 -- Verificamos si existe una plantilla y si debe de borrarse enves de truncarse
 ---------------------------------------------------------------------------------------
   SELECT  @IsOnlyDeleted	= add_data, 
		    @WhereDeleted	= table_where,
		    @nameDB			= table_createtable,
			@instance	    = instance_source
	FROM (
		  SELECT TOP 1 
					plantillad_id, 
					h.add_data,
					CASE WHEN h.add_data = 1 AND ISNULL(RTRIM(table_where),'') = '' THEN RTRIM(h.add_where)
					     WHEN h.add_data = 1 AND ISNULL(RTRIM(table_where),'') <> '' THEN RTRIM(h.add_where) + ' AND ' + RTRIM(table_where) 
					     ELSE RTRIM(table_where) END  as table_where,
					d.table_createtable,
					h.instance_source
		  FROM		t_PlantillaD d
		  INNER JOIN t_PlantillaH h ON d.plantilla_id = h.plantilla_id
		  WHERE	RTRIM(UPPER(table_createssis)) = RTRIM(UPPER(@NameSSIS))
		              ORDER BY d.create_date DESC 
		  ) AS X;
 ---------- Si tiene plantilla y está dice que solo agrega datos solose apica un where
   
 IF (@IsOnlyDeleted = 1 OR @instance <> '')
	BEGIN	  
		SET @sqlstr = 'DELETE FROM ' + @nameDB + ' WHERE instance = ' + '''' + @instance +''''
		EXECUTE(@sqlstr)
		RETURN
	END
 ---------------------------------------------------------------------------------------
 -- En caso de no venir de una plantilla que solo agrega datos 
 ---------------------------------------------------------------------------------------		 
 IF (@Table_id = 0)
 BEGIN
	IF (@table_name <> '')
	BEGIN
		SET @sqlstr = 'TRUNCATE TABLE ' + @table_name		
		EXEC(@sqlstr);	
	END
 END
 
 ELSE 
 BEGIN
   IF (@typestr = 'TFF')
   BEGIN
     SELECT @nameDB = b.name,
			@nameTable = f.name 
	  FROM t_BDF b
		INNER JOIN t_TFF	f ON b.database_id = f.database_id
		INNER JOIN t_SSIS	s ON f.table_id = s.table_id
	    WHERE s.ssis_id = @ssis_id
   END
   
   IF (@typestr = 'TFM')
   BEGIN
      SELECT  @nameDB = b.name,
			  @nameTable = t.name 
	  FROM t_BDM b
		INNER JOIN t_TDM	f ON b.database_id = f.database_id
		INNER JOIN t_TFM    t ON f.table_id = t.tdm_id
		INNER JOIN t_SSIS	s ON t.table_id = s.table_id
	  WHERE	s.ssis_id = @ssis_id
   END
   
   IF (@typestr = 'TDM')
   BEGIN
      SELECT  @nameDB = b.name,
			  @nameTable = f.name 
	  FROM t_BDM b
		INNER JOIN t_TDM	f ON b.database_id = f.database_id
		INNER JOIN t_SSIS	s ON f.table_id = s.table_id
		WHERE	s.ssis_id = @ssis_id
   END
   
   SET @sqlstr = 'TRUNCATE TABLE ' + @nameDB + '.dbo.' + @nameTable
   
   EXEC(@sqlstr);
  END
END
