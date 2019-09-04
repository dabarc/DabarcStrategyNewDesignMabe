CREATE PROCEDURE [dabarc].[sp_ODBC_ProcessAutoMatchesMSSQL] 
@plantillad_id INT
As 
BEGIN 
	SET NOCOUNT ON ;
	DECLARE @driver_id		INT,
			@Str_Sql		VARCHAR(1000),
			@Tipo_dato		VARCHAR(50),
			@Size			INT,
			@Scale			INT,
			@Presicion		INT,
			@plantilla_id	INT,
	        @type_action	NCHAR(15),
			@type_actionfs	NCHAR(15),
		    @MSS_Type		VARCHAR(50),
			@MSS_Size		INT,
			@MSS_Scale		INT,
			@MSS_Presicion	INT,
			@MSS_ReplaceValue VARCHAR(65),
			@Copy_All		BIT
	---------------------------------------------------------------------------------------------------------------------------
	  ---- Buscamos el driver que lecorresponde de acuerdo a la plantilla
	----------------------------------------------------------------------------------------------------------------------------
	SELECT @driver_id = o.driver_id,
		   @plantilla_id = d.plantilla_id
	FROM	dabarc.t_PlantillaD AS d
    INNER JOIN dabarc.t_PlantillaH AS h ON d.plantilla_id = h.plantilla_id
	INNER JOIN dabarc.t_ODBC AS o ON h.odbc_id = o.odbc_id
    WHERE	plantillad_id = @plantillad_id;
	----------------------------------------------------------------------------------------------------------------------------
	  ---- Realizamos una serie de consultas para ejecutar las reglas de driver
	----------------------------------------------------------------------------------------------------------------------------
	UPDATE t_PlantillaC SET pl_sType = NULL WHERE plantillad_id = @plantillad_id
	DECLARE CURSORSQL CURSOR FOR 
			 SELECT type_name, 
					type_valuesize, 
					type_valuescale,
					type_valueprecision,
					type_Action,
					type_ActionforSize,
					MSS_type,
					MSS_size,
					MSS_scale,
					MSS_precision,
					MSS_ReplaceValue
			  FROM  dabarc.t_ODBC_ctypes
			  WHERE driver_id = @driver_id
	OPEN CURSORSQL
		FETCH NEXT FROM  CURSORSQL
			INTO @Tipo_dato, @Size,@Scale,@Presicion,@type_action, @type_actionfs, @MSS_Type,@MSS_Size,@MSS_Scale,@MSS_Presicion,@MSS_ReplaceValue
		WHILE  @@fetch_status = 0
			BEGIN
				SET @Str_Sql =            'UPDATE dabarc.t_PlantillaC SET '
				SET @Str_Sql = @Str_Sql + '  pl_sType = ''' + @MSS_Type + ''''
			  --SET @Str_Sql = @Str_Sql + ' ,pl_sNull = pl_isNull'
				SET @Str_Sql = @Str_Sql + ' ,pl_sNull = 1'	
				
				IF (@MSS_ReplaceValue IS NOT NULL)
				BEGIN
					SET @MSS_ReplaceValue = REPLACE(@MSS_ReplaceValue,'''','''''')
					SET @Str_Sql = @Str_Sql + ' ,pl_ReplaceValue = REPLACE(''' + UPPER(@MSS_ReplaceValue) + ''',''CAMPO0'',pl_NameCol)'
				END  
	  
				IF (@type_actionfs = 'NULL' OR @type_actionfs IS NULL)	
					SET @Str_Sql = @Str_Sql + ' ,pl_sSize = ' + CAST(@MSS_Size AS CHAR(10)) +', pl_sScale = ' + CAST(@MSS_Scale AS CHAR(10)) +', pl_sPrecision = ' + CAST(@MSS_Presicion AS CHAR(10)) 
	
				IF (@type_actionfs = 'TP')	--Tomar Precisión
					SET @Str_Sql = @Str_Sql + ' ,pl_sSize = 0, pl_sScale = pl_scale, pl_sPrecision = pl_precision'

				IF (@type_actionfs = 'TT')	--Tomar Tamaño	
					SET @Str_Sql = @Str_Sql + ' ,pl_sSize = pl_size, pl_sScale = 0, pl_sPrecision = 0'
					--SET @Str_Sql = @Str_Sql + ' ,pl_sSize = CASE WHEN pl_size > 4000 THEN 4000 ELSE pl_size END, pl_sScale = 0, pl_sPrecision = 0'

				IF (@type_actionfs = 'TT2')	--Tomar Tamaño x2
					SET @Str_Sql = @Str_Sql + ' ,pl_sSize = (pl_size * 2), pl_sScale = 0, pl_sPrecision = 0'
	
				IF (@type_actionfs = 'TXP')	--Tomar Tamaño x2
					SET @Str_Sql = @Str_Sql + ' ,pl_sSize = 0, pl_sScale = 0, pl_sPrecision = pl_size'	
	
				SET @Str_Sql = @Str_Sql + ' WHERE (pl_sType IS NULL OR RTRIM(pl_sType) = '''') AND plantillad_id = ' + RTRIM(CAST(@plantillad_id AS CHAR(5)))
				SET @Str_Sql = @Str_Sql + ' AND pl_typeOdbc = ''' + RTRIM(@Tipo_dato) + ''''
      
				IF (@type_action = 'CEM') --Cualquier escala mayor que 0
					SET @Str_Sql = @Str_Sql + ' AND (pl_Size > 0 OR pl_Scale > 0 OR pl_Precision > 0)'
	
				IF (@type_action = 'CTLE') --Coincide Tipo de Dato, Longitud y Escala
					SET @Str_Sql = @Str_Sql + ' AND pl_sType = ''' + @MSS_Type + ''' AND pl_Size = ' + CAST(@Size AS CHAR(10)) + ' AND  pl_Scale = ' + CAST(@Scale AS CHAR(10))
	
				IF (@type_action = 'MIMT') --Mayor que o Igual a Maximo Tamaño
					SET @Str_Sql = @Str_Sql + ' AND pl_Size >= ' + CAST(@Size AS CHAR(10))
	
				--IF (@type_action = 'PCTD') --Por defecto para cualquier tipo de datos
				--BEGIN
				--END
				----IF (@type_action = 'STD') --Solo coincide Tipo de Dato
				----	SET @Str_Sql = @Str_Sql + ' AND pl_typeOdbc = ''' + @MSS_Type + ''''
				----IF (@type_action = 'TCE') --Tipo de datos y coincide con la Escala
				----	SET @Str_Sql = @Str_Sql + ' AND pl_typeOdbc = ''' + @MSS_Type + ''' AND pl_Scale = ' + CAST(@Scale AS CHAR(10))
				----IF (@type_action = 'TDCL') --Tipo de datos y coincide con la longitud
				----	SET @Str_Sql = @Str_Sql + ' AND pl_typeOdbc = ''' + @MSS_Type + ''' AND pl_Size = ' + CAST(@Size AS CHAR(10))

				IF (@type_action = 'TCE') --Tipo de datos y coincide con la Escala
					SET @Str_Sql = @Str_Sql + ' AND pl_Scale = ' + CAST(@Scale AS CHAR(10))

				IF (@type_action = 'TDCL') --Tipo de datos y coincide con la longitud
					SET @Str_Sql = @Str_Sql + ' AND pl_Size = ' + CAST(@Size AS CHAR(10))

			  EXECUTE(@Str_Sql)

			FETCH NEXT FROM  CURSORSQL
			INTO  @Tipo_dato, @Size,@Scale,@Presicion,@type_action, @type_actionfs, @MSS_Type,@MSS_Size,@MSS_Scale,@MSS_Presicion,@MSS_ReplaceValue
		END
	CLOSE  CURSORSQL
	DEALLOCATE  CURSORSQL
	EXECUTE dabarc.sp_TPT_UpdatePorc_equalOfTable @plantillad_id	 
	EXECUTE dabarc.sp_TPT_UpdatePorc_equalOfPlantilla @plantilla_id
END;
