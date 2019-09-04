--EXEC [dabarc].[sp_REC_getViewForBDC] 9,'C:0,T:0'
CREATE PROCEDURE [dabarc].[sp_REC_getViewForBDC]
@script_id INT,
@strSEG NVARCHAR(100)
AS
BEGIN
SET NOCOUNT ON;
  ----------------------------------------------------------------------------------------------------------------------------------------------------------------
  --- Idea. Generar una consulta basada en los especificado en el recording de tal forma que se omita columnas que no se utilicen
  --- y que las evaluaciones se realicen desde la consulta de los datos
  ----------------------------------------------------------------------------------------------------------------------------------------------------------------
 DECLARE @db_name		 NVARCHAR(128),
		 @report_name    NVARCHAR(128),
		 @field_h		 NVARCHAR(128),
		 @field_d		 NVARCHAR(128),	
		 @NoCantidad	 INT,
		 @NoTop			 INT,
		 @NoPosition	 INT,
		 @strSql		 NVARCHAR(4000)
  ----------------------------------------------------------------------------------------------------------------------------------------------------------------
  --- Obtener cantidades
  ----------------------------------------------------------------------------------------------------------------------------------------------------------------
    CREATE TABLE #tempKeys (KEYS NCHAR(255))
  ----------------------------------------------------------------------------------------------------------------------------------------------------------------
  --- Obtener cantidades , base de dat y nombre de reporte
  ----------------------------------------------------------------------------------------------------------------------------------------------------------------
	  SET @NoPosition = CHARINDEX(',',@strSEG,0)
	  SET @NoCantidad = CAST(SUBSTRING(@strSEG,3,@NoPosition-3) AS INT)
	  SET @NoTop	  = CAST(SUBSTRING(@strSEG,@NoPosition + 3,LEN(@strSEG)) AS INT)
	 
	 SELECT	@db_name		= RTRIM(ISNULL(b.name,'')), 
			@report_name	= RTRIM(view_name),
			@field_h 		= RTRIM(key_h),
			@field_d 		= RTRIM(key_d)
	 FROM   vw_Active_TRANS v
			INNER JOIN t_BDM b ON v.team_dbid = b.database_id
	 WHERE  script_id		= @script_id

	 IF (@db_name = '') 
	 BEGIN
	--	RAISERROR('¡ La transacción no encuentra una base de datos asignado !', 16, 1);
		
  RAISERROR (50006,16,1, '','')
		RETURN;
	 END	 
  ----------------------------------------------------------------------------------------------------------------------------------------------------------------
  --- Evaluar que la cantidad de archivos que saldra es menor de 40, para no saturar el proceso 
  ----------------------------------------------------------------------------------------------------------------------------------------------------------------


	  --- Si existe un TOP a la llamada de los datos
	  IF (@NoTop > 0)
	   	 SET @strSql = 'SELECT DISTINCT TOP ' + CAST(@NoTop AS NCHAR(5)) + ' ' + RTRIM(@field_h) + ' as X FROM ' + RTRIM(@db_name) + '.dbo.' + RTRIM(@report_name)
	  ELSE
	   	 SET @strSql = 'SELECT DISTINCT ' + RTRIM(@field_h) + ' as X FROM ' + RTRIM(@db_name) + '.dbo.' + RTRIM(@report_name)

		INSERT INTO #tempKeys EXECUTE(@strSql)
	 --- 
	  IF (@NoCantidad > 0)
	  BEGIN
								
	   SELECT @NoCantidad = (COUNT(*) / @NoCantidad) FROM #tempKeys
	    
	   IF (@NoCantidad > 50) 
	   BEGIN
		SET @strSql = 'La separación de archivos genera más de 50 archivos, es necesario cambiar el criterio.'
		--RAISERROR(@strSql, 16, 1);
		
  RAISERROR (50082,16,1, '','')
		RETURN
	   END

	  END
  ----------------------------------------------------------------------------------------------------------------------------------------------------------------
  --- Generar campos
  ----------------------------------------------------------------------------------------------------------------------------------------------------------------
   
    SET @strSql = ''
	SET @strSql = @strSql + @field_h + ' AS KEYH'
	IF (@field_d <> '') SET @strSql = @strSql + ',' + @field_d + ' AS KEYD'
 
  ----------------------------------------------------------------------------------------------------------------------------------------------------------------
  --- Generamos los campos de las pantallas
  ----------------------------------------------------------------------------------------------------------------------------------------------------------------
	DECLARE	 @Var_NameCol	AS NCHAR(50),
			 @Var_Where		AS NVARCHAR(500),
			 @Var_OnlyWhere AS NCHAR(50)
 
	
	-- Insertamos 
	DECLARE CUR_SCREEN CURSOR FOR	 
			 
		SELECT	RTRIM(screen_sapno) + 'P' + CAST(screen_position AS CHAR(10)),
				CASE WHEN LEN(RTRIM(screen_fieldview)) > 1 THEN '[' + RTRIM(screen_fieldview) + '] ' ELSE ' ' END + RTRIM(screen_fieldwhere),
				RTRIM(screen_fieldwhere)
		FROM  t_recording_screen 
		WHERE script_id = @script_id
		ORDER BY screen_position ASC
	
	OPEN	CUR_SCREEN
	FETCH	CUR_SCREEN INTO @Var_NameCol, @Var_Where, @Var_OnlyWhere
	WHILE   (@@FETCH_STATUS = 0 )
	BEGIN		
		BEGIN TRANSACTION
		
		IF (RTRIM(@Var_OnlyWhere) <> '')
			SET @strSql = @strSql + ',[' + RTRIM(@Var_NameCol) + '] = CASE WHEN ' + RTRIM(@Var_Where) + ' THEN 1 ELSE 0 END'
		ELSE	
			SET @strSql = @strSql + ',[' + RTRIM(@Var_NameCol) + '] = 1' 
			
		COMMIT TRANSACTION
		FETCH CUR_SCREEN INTO @Var_NameCol, @Var_Where, @Var_OnlyWhere
	END
	CLOSE CUR_SCREEN
	DEALLOCATE CUR_SCREEN

 ----------------------------------------------------------------------------------------------------------------------------------------------------------------
  --- Generamos los campos de las columnas
  ----------------------------------------------------------------------------------------------------------------------------------------------------------------
    
 	DECLARE	 @Var_fieldview AS NCHAR(100),
			 @Var_space		AS BIT
	
	-- Insertamos 
	DECLARE CUR_FIELDS CURSOR FOR	 
			 
	SELECT	field_fieldview, 
			field_fieldspace
		FROM t_recording_screen s
			INNER JOIN t_recording_fields f ON s.screen_id = f.screen_id
		WHERE script_id = @script_id AND RTRIM(f.field_typeentry) <> 'CONS'
		ORDER BY screen_position  ASC, field_id ASC
	
	OPEN	CUR_FIELDS
	FETCH	CUR_FIELDS INTO @Var_fieldview, @Var_space
	WHILE   (@@FETCH_STATUS = 0 )
	BEGIN		
		BEGIN TRANSACTION
		
		IF (@Var_space = 0)
			SET @strSql = @strSql + ',[' + RTRIM(@Var_fieldview) + ']'
		ELSE	
			SET @strSql = @strSql + ',[' + RTRIM(@Var_fieldview) + '] = CASE WHEN ISNULL([' + RTRIM(@Var_fieldview) + '],'''') = '''' THEN '' '' ELSE [' + RTRIM(@Var_fieldview) + '] END' 
			
		
		COMMIT TRANSACTION
		FETCH CUR_FIELDS INTO @Var_fieldview, @Var_space
	END
	CLOSE CUR_FIELDS
	DEALLOCATE CUR_FIELDS

  ----------------------------------------------------------------------------------------------------------------------------------------------------------------
  --- Asignamos Base de Datos y Tabla
  ----------------------------------------------------------------------------------------------------------------------------------------------------------------

	--SET @strSql = 'SELECT ' + SUBSTRING(@strSql,2,LEN(@strSql)) + ' FROM ' + RTRIM(@db_name) + '.dbo.' + RTRIM(@report_name) + ' i INNER JOIN #tempKeys t ON t.KEYS = i.' + @field_h 
   SET @strSql = 'SELECT ' + @strSql + ' FROM ' + RTRIM(@db_name) + '.dbo.' + RTRIM(@report_name) + ' i INNER JOIN #tempKeys t ON t.KEYS = i.' + @field_h + ' ORDER BY i.' + RTRIM(@field_h) + ' ASC'

   --SELECT @strSql
  ----------------------------------------------------------------------------------------------------------------------------------------------------------------
  --- Retornamos los datos
  ----------------------------------------------------------------------------------------------------------------------------------------------------------------
  --SELECT * FROM #tempKeys
  --SELECT @strSql
  EXEC(@strSql) 
END