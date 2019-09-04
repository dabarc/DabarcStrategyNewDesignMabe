CREATE PROCEDURE  [dabarc].[sp_DB_UpdateListOfDBM_Reg_ByName]
	
	(	
	@database_name nvarchar(50),
	@register_user nvarchar(15)
	)
	
AS
	DECLARE @Int_Index	INT
	DECLARE @Msg_Return NVARCHAR(100)
	
	SET @Int_Index = 0
	
	
	--------------------------------------------------------------
	-- Validamos que la base de datos no este registrado ya
	--------------------------------------------------------------
	
	IF (SELECT COUNT(*) FROM t_BDF WHERE UPPER(RTRIM(name)) = UPPER(RTRIM(@database_name))) > 0
	BEGIN
	 --  RAISERROR('La base de datos ya existe en el sistema como una Base de Datos Fuente', 16, 1);
	    RAISERROR (50031,16,1, '','')
	   RETURN;
	END
	
	IF (SELECT COUNT(*) FROM t_BDM WHERE UPPER(RTRIM(name)) = UPPER(RTRIM(@database_name))) > 0
	BEGIN
	 --  RAISERROR('La base de datos ya existe en el sistema como una Base de Datos de Manipulación', 16, 1);
	   RAISERROR (50030,16,1, '','')
	   RETURN;
	END
	--------------------------------------------------------------
	-- Validamos que exista en base de datos del sistema
	--------------------------------------------------------------
	
	INSERT INTO 
	t_BDM	(	name, 
				database_id, 
				create_date)
	SELECT		name, 
				database_id, 
				create_date
    FROM        sys.databases 
    WHERE		UPPER(RTRIM(name)) = UPPER(RTRIM(@database_name))
    
    SET @Int_Index = @@IDENTITY
    
    IF (ISNULL(@Int_Index,0) = 0)
	BEGIN
	   SET @Msg_Return = 'No se encontró la Base de Datos ' + @database_name + ' en el servidor'
	   RAISERROR (50084,16,1, @database_name,'')
	 --  RAISERROR(@Msg_Return, 16, 1);
	   RETURN;
	END
	
	--------------------------------------------------------------
	-- Registramos la base de datos
	--------------------------------------------------------------
	
	IF (ISNULL(@Int_Index,0) <> 0)
		EXECUTE sp_DB_UpdateListOfDBM_Reg @Int_Index, 1, @register_user
