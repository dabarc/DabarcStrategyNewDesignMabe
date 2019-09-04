
CREATE PROCEDURE [dabarc].[sp_RECc_CopyRowOfScreen]     @screen_id		  INT,
													@screen_title	  NVARCHAR(200),
													@screen_position  INT,
													@usuario_modifica NVARCHAR(100) AS

DECLARE @intIdentity INT

 ------------------------------------------------------------------------------------------------------------
 -- Insertamos el nuevo elemento a partir del seleccionado
 ------------------------------------------------------------------------------------------------------------
 
	INSERT INTO t_recording_screen
			   (script_id ,screen_title ,screen_position ,screen_sapname ,screen_sapno
			   ,screen_typestruc ,screen_fieldview ,screen_fieldwhere ,screen_nofields ,usuario_alta
			   ,fecha_alta)
	           
	SELECT		script_id ,@screen_title ,@screen_position ,screen_sapname ,screen_sapno
				,screen_typestruc ,screen_fieldview ,screen_fieldwhere ,screen_nofields, @usuario_modifica
				,GETDATE()
	  FROM		t_recording_screen
	  WHERE		screen_id = @screen_id

	 SET @intIdentity = @@IDENTITY

 ------------------------------------------------------------------------------------------------------------
 -- Insertamos los campos de la pantalla
 ------------------------------------------------------------------------------------------------------------

	INSERT INTO t_recording_fields
				(screen_id ,field_SAPname ,field_SAP ,field_description ,field_typeentry
				,field_fieldview ,field_fieldspace ,usuario_alta ,fecha_alta)
	SELECT		 @intIdentity, field_SAPname ,field_SAP ,field_description ,field_typeentry
				,field_fieldview ,field_fieldspace ,@usuario_modifica, GETDATE()
	FROM		t_recording_fields
	WHERE		screen_id = @screen_id
