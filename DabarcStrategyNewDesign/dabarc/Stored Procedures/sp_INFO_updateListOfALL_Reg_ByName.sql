CREATE PROCEDURE  [dabarc].[sp_INFO_updateListOfALL_Reg_ByName] 	
	(	
	@table_id		INT,
	@report_name	NVARCHAR(50),
	@report_type	NVARCHAR(15),
	@register_user  NVARCHAR(15)
	)
	
AS
 
	DECLARE @register_date	DATETIME,
			@strTable		VARCHAR(15),
			@Sql_query		NVARCHAR(400),
			@db_name		VARCHAR(30),
			@Int_Index		INT

	---------------------------------------------------------------------------------------------
	--- Crear Base de Datos Temporal
	---------------------------------------------------------------------------------------------
	
	CREATE TABLE #COUNT(iCount		INT)
	
	---------------------------------------------------------------------------------------------
	--- Validar tipo de datos
	---------------------------------------------------------------------------------------------
	
	SET @Sql_query = 'INSERT INTO #COUNT SELECT COUNT(*) FROM t_' + RTRIM(UPPER(@report_type)) + ' 
					  WHERE UPPER(RTRIM(name)) = UPPER(RTRIM(' + @report_name + ')) AND table_id =' + CAST(@table_id  AS CHAR(5))
					  
    IF (SELECT COUNT(*) FROM #COUNT) = 0
    BEGIN
      -- RAISERROR('Este informe ya se encuentra registrado.', 16, 1);
	  
  RAISERROR (50022,16,1, '','')
	   RETURN;
    END

	---------------------------------------------------------------------------------------------
	--- Llenado de datos
	---------------------------------------------------------------------------------------------	
		IF (@report_type = 'IFF')
		BEGIN
			SELECT	@db_name = d.name
			FROM	dabarc.t_BDF d 
				INNER JOIN dabarc.t_TFF t ON d.database_id = t.database_id AND table_id = @table_id			
		END						
			
		IF (@report_type = 'TDM')
		BEGIN
			SELECT	@db_name = d.name
			FROM	dabarc.t_BDM d 
				INNER JOIN dabarc.t_TDM t ON d.database_id = t.database_id AND table_id = @table_id			
		END						
			
			
		IF (@report_type = 'TFM')
		BEGIN
			SELECT	@db_name = d.name
			FROM	dabarc.t_BDM d 
				INNER JOIN dabarc.t_TDM t ON d.database_id = t.database_id 
				INNER JOIN dabarc.t_TFM f ON t.table_id = f.tdm_id AND f.table_id = @table_id
		END						

	---------------------------------------------------------------------------------------------
	--- Llenado de datos
	---------------------------------------------------------------------------------------------

	    SET @Sql_query = 'INSERT INTO t_' + RTRIM(UPPER(@report_type)) + ' (name,create_date,table_id)
						  SELECT name, create_date, ' + RTRIM(@table_id) + ' FROM ' + @db_name + '.sys.views as cat WHERE name = ''' + @report_name + ''''
	    
		
		EXEC(@Sql_query)
		
	--------------------------------------------------------------
	-- Registramos la tabla
	--------------------------------------------------------------	
	
	
	IF (@report_type = 'IFF')
		SELECT	@Int_Index = ISNULL(table_id,0) FROM t_IFF WHERE	UPPER(RTRIM(name)) = UPPER(RTRIM(@report_name)) AND table_id = @table_id
	IF (@report_type = 'IDM')
		SELECT	@Int_Index = ISNULL(table_id,0) FROM t_IDM WHERE	UPPER(RTRIM(name)) = UPPER(RTRIM(@report_name)) AND table_id = @table_id	
	IF (@report_type = 'IFM')
		SELECT	@Int_Index = ISNULL(table_id,0) FROM t_TFM WHERE	UPPER(RTRIM(name)) = UPPER(RTRIM(@report_name)) AND table_id = @table_id	
	

	
	IF (ISNULL(@Int_Index,0) = 0) 
	BEGIN
	  
	--   RAISERROR('El informe no se encontró en la base de datos.', 16, 1);
	   
  RAISERROR (50008,16,1, '','')
	   
	END
	ELSE
	BEGIN
		IF (@report_type = 'IFF')
			EXECUTE [dabarc].[sp_INFO_updateListOfIFF_Reg] @table_id, @Int_Index,1,@register_user
			
		IF (@report_type = 'IDM')
			EXECUTE [dabarc].[sp_INFO_updateListOfIDM_Reg] @table_id, @Int_Index,1,@register_user
		
		IF (@report_type = 'IFM')
			EXECUTE [dabarc].[sp_INFO_updateListOfIFM_Reg] @table_id, @Int_Index,1,@register_user

	END
