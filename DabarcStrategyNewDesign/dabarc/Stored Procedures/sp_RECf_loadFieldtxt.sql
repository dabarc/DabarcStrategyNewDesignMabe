
 CREATE PROCEDURE [dabarc].[sp_RECf_loadFieldtxt]    @intScreen_id		INT, 
													@strField_SAPname	NVARCHAR(50), 
													@strField_fieldview NCHAR(30),
													@strUsuario_alta	NVARCHAR(100) AS

    DECLARE @intNewId	 INT
	DECLARE @strType	 CHAR(5)
	
	--------------------------------------------------------------------------------------------------------------
	-- Validaciones 
	--------------------------------------------------------------------------------------------------------------
    SET @strType = 'DTE'
		
		
	IF (RTRIM(UPPER(@strField_SAPname)) = 'BDC_SUBSCR')
	BEGIN
	 SELECT -1;
	 RETURN 0;
	END 
	 
	IF (RTRIM(UPPER(@strField_SAPname)) = 'BDC_OKCODE' OR 
	    RTRIM(UPPER(@strField_SAPname)) = 'BDC_CURSOR' )
		SET @strType = 'CONS'
	 ELSE
		SET @strField_fieldview = '[NA]'
	 
	--------------------------------------------------------------------------------------------------------------
	-- Insertar dato
	--------------------------------------------------------------------------------------------------------------
	
 INSERT INTO t_recording_fields
           (screen_id
           ,field_SAPname
           ,field_SAP
           ,field_description
           ,field_typeentry
           ,field_fieldview
           ,field_fieldspace
           ,usuario_alta
           ,fecha_alta)
    VALUES(	@intScreen_id,
			@strField_SAPname, 
			null, 
			null, 
			@strType,
			@strField_fieldview,
			0,
			@strUsuario_alta, 
			GETDATE())

		SELECT @intNewId = @@IDENTITY

		IF @@ERROR <> 0 
		BEGIN
		--	RAISERROR ('Error al cargar el campo desde el texto.',16,1);
			
			RAISERROR (50014,
    16, -- Severity.
    1, -- State.
    '',
    '') -- Second substitution argument.
			
			
			RETURN 0;
		END
    
		SELECT @intNewId;
	
	RETURN
