
CREATE PROCEDURE [dabarc].[sp_RECc_UpdateListOfScreen]  @screen_id		INT, 
													@screen_position	INT,
													@screen_title		NVARCHAR(200),
													@screen_typestruc	NCHAR(15),
													@screen_fieldview	NCHAR(30),
													@screen_fieldwhere  NVARCHAR(100),
													@usuario_modifica	NVARCHAR(100) AS 
 ------------------------------------------------------------------------------------------
 --- Modificamos el registro
 ------------------------------------------------------------------------------------------
 
	UPDATE	t_recording_screen
	SET		screen_position		= @screen_position,
			screen_title		= @screen_title,
			screen_typestruc	= SUBSTRING(@screen_typestruc,1,3),
			screen_fieldview	= @screen_fieldview,
			screen_fieldwhere	= @screen_fieldwhere,
			usuario_modifica	= @usuario_modifica,
			fecha_modifica		= GETDATE()
	WHERE	screen_id = @screen_id
