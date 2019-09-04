
 
 CREATE PROCEDURE [dabarc].[sp_RECf_InsertRowOfFields]	@screen_id			INT,
													@field_SAPname		NVARCHAR(50),
													@field_SAP			NVARCHAR(100),
													@field_description	NVARCHAR(500),
													@field_typeentry	NCHAR(10),
													@field_fieldview	NCHAR(30),
													@field_fieldspace	BIT,
													@usuario_alta		NVARCHAR(100) AS

IF (SELECT COUNT(*) FROM t_recording_fields 
	WHERE screen_id = @screen_id AND RTRIM(field_typeentry) <> 'CONS' AND RTRIM(field_SAPname) = @field_SAPname) > 0
BEGIN
	--   RAISERROR('Ya existe una definición de este campo para esta pantalla', 16, 1);
	   RAISERROR (50066,16,1, '','')
	   RETURN;
END

 --IF (SELECT COUNT(*) FROM t_recording_fields WHERE UPPER(field_SAPname) = UPPER(@field_SAPname)) > 0
	--BEGIN
	--   RAISERROR('Ya existe un campo con este nombre.', 16, 1);
	--   RETURN;
	--END
	
  DECLARE @script_id INT
  
  SELECT @script_id = s.script_id 
  FROM  t_recording_screen s 
  WHERE  screen_id = @screen_id

----------------------------------------------------------------------------------------------------------------
-- Se valida que el nombre
----------------------------------------------------------------------------------------------------------------	

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
     VALUES
           (@screen_id
           ,@field_SAPname
           ,@field_SAP
           ,@field_description
           ,@field_typeentry
           ,@field_fieldview
           ,@field_fieldspace
           ,@usuario_alta
           ,GETDATE())
           
--Recalculamos el numero de registros 
EXECUTE sp_REC_LoadtxtCalculateFields @script_id
