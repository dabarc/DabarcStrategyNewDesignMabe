
 
 CREATE PROCEDURE [dabarc].[sp_RECf_UpdateListOfFields]	@field_id			INT,
														@field_SAPname		NVARCHAR(50),
														@field_description	NVARCHAR(500),
														@field_fieldview	NCHAR(50),
														@field_fieldspace	BIT,
														@usuario_modifica	NVARCHAR(100),
														@screen_id			INT,
														@field_typeentry	NCHAR(10) AS
													
 ------------------------------------------------------------------------------------------
 --- Validamos que no haya campos repetidos
 ------------------------------------------------------------------------------------------
 --IF (SELECT COUNT(*) FROM t_recording_fields WHERE screen_id = @screen_id and 
	--										UPPER(field_SAPname) = UPPER(@field_SAPname)) > 0
											
IF (SELECT COUNT(*) FROM t_recording_fields WHERE UPPER(RTRIM(field_SAPname)) = UPPER(RTRIM(@field_SAPname)) AND screen_id = @screen_id AND field_id <> @field_id) > 0											
	BEGIN
	 --  RAISERROR('Ya existe un campo con este nombre.', 16, 1);
	   RAISERROR (50062,16,1, '','')
	  
	  
	   RETURN;
	END
 
 ------------------------------------------------------------------------------------------
 --- Modificamos el registro
 ------------------------------------------------------------------------------------------
 
  UPDATE t_recording_fields
  SET	 field_SAPname      = @field_SAPname,
		 field_description	= @field_description,
	     field_fieldview	= @field_fieldview,
		 field_fieldspace	= @field_fieldspace,
		 usuario_modifica	= @usuario_modifica,
		 fecha_modifica		= GETDATE(),
		 field_typeentry    = @field_typeentry
  WHERE	 field_id = @field_id
