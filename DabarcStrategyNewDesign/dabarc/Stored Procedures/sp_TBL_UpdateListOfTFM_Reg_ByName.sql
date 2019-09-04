CREATE PROCEDURE  [dabarc].[sp_TBL_UpdateListOfTFM_Reg_ByName]	
	(
	@table_id		INT,
	@table_name		NVARCHAR(50),
	@register_user	NVARCHAR(15)
	)
	
AS

	DECLARE @Int_Index		INT,
			@db_id			INT,
			@Sql_query		NVARCHAR(300),
			@db_name		NVARCHAR(60)

	SET @Int_Index = 0
	
	--------------------------------------------------------------
	-- Validamos que la base de datos no este registrado ya
	--------------------------------------------------------------

	IF (SELECT COUNT(*) FROM t_TFM WHERE UPPER(RTRIM(name)) = UPPER(RTRIM(@table_name)) AND tdm_id = @table_id) > 0
	BEGIN
	 --  RAISERROR('La tabla ya está registrada en la tabla TFM', 16, 1);
	   RAISERROR (50041,16,1, '','')
	   RETURN;
	END

	--------------------------------------------------------------
	-- Validamos que exista la tabla
		-- Obtenemos la base de datos
	--------------------------------------------------------------
	
	SELECT  @db_id   = t.table_id, -- Por que es un nivel de nodo 2
			@db_name = b.name
	FROM dabarc.t_BDM b
		INNER JOIN dabarc.t_TDM t ON b.database_id = t.database_id AND t.table_id = @table_id
		
	SET @Sql_query = 'INSERT INTO t_TFM(name, create_date, tdm_id)
					 SELECT name, create_date,' + + CAST(@table_id AS CHAR(5)) + ' FROM ' + @db_name + '.sys.tables as cat WHERE UPPER(RTRIM(name)) = ''' + UPPER(RTRIM(@table_name)) + ''''	
	EXEC(@Sql_query) 

	--------------------------------------------------------------
	-- Registramos la tabla
	--------------------------------------------------------------	
	SELECT	@Int_Index = ISNULL(table_id,0) 
	FROM	t_TFM 
	WHERE	UPPER(RTRIM(name)) = UPPER(RTRIM(@table_name)) 
			AND tdm_id = @table_id
	
	IF (ISNULL(@Int_Index,0) = 0)
	  -- RAISERROR('La tabla no se encontró en la base de datos.', 16, 1);
	   RAISERROR (50038,16,1, '','')
	ELSE
	   EXECUTE sp_TBL_UpdateListOfTFM_Reg @db_id,@Int_Index,1,@register_user
