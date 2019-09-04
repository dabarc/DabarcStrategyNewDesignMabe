CREATE PROCEDURE  [dabarc].[sp_TBL_UpdateListOfTFF_Reg_ByName]
	
	(		
	@database_id	INT,
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

	IF (SELECT COUNT(*) FROM t_TFF WHERE UPPER(RTRIM(name)) = UPPER(RTRIM(@table_name)) AND database_id = @database_id) > 0
	BEGIN
	 --  RAISERROR('La tabla ya esta resgitrada en la tabla TFF', 16, 1);
	   RAISERROR (50042,
    16, -- Severity.
    1, -- State.
    'TFF',--
    '') -- Second substitution argument.
	   
	  	   
	   RETURN;
	END


	--------------------------------------------------------------
	-- Validamos que exista la tabla
		-- Obtenemos la base de datos
	--------------------------------------------------------------
	
	SELECT  @db_name = b.name FROM	dabarc.t_BDF b WHERE database_id = @database_id
		
	SET @Sql_query = 'INSERT INTO t_TFF(name, create_date, database_id)
					 SELECT name, create_date,' + + CAST(@database_id AS CHAR(5)) + ' FROM ' + @db_name + '.sys.tables as cat WHERE UPPER(RTRIM(name)) = ''' + UPPER(RTRIM(@table_name)) + ''''	
	EXEC(@Sql_query) 	
	
	--------------------------------------------------------------
	-- Registramos la tabla
	--------------------------------------------------------------	
	
	SELECT	@Int_Index = ISNULL(table_id,0) FROM t_TFF WHERE UPPER(RTRIM(name)) = UPPER(RTRIM(@table_name)) AND database_id = @database_id
	
	IF (ISNULL(@Int_Index,0) = 0)
--	   RAISERROR('La tabla no se encontró en la base de datos.', 16, 1);
	   
 RAISERROR (50038,
    16, -- Severity.
    1, -- State.
    '',--
    '') -- Second substitution argument.

	   
	ELSE
	   EXECUTE sp_TBL_UpdateListOfTFF_Reg @database_id,@Int_Index,1,@register_user
