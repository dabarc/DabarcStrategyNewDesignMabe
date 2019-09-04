CREATE PROCEDURE [dabarc].[sp_RECs_UpdateListOfScript]
@script_id INT,
@script_activo BIT,
@script_priority INT,
@script_name	NVARCHAR(100),
@script_description NVARCHAR(500),
@usuario_modifica NVARCHAR(100)
AS
BEGIN
SET NOCOUNT ON;
	IF (@script_activo = 1 AND (@script_priority = 0 OR RTRIM(@script_description) = ''))
	BEGIN
	  --RAISERROR('No se puede activar un registro con prioridad "0" y sin descripción corta', 16, 1);
	  RAISERROR (50051,16,1,'','')
	  RETURN;
	END

	UPDATE t_recording_script
	SET   script_activo		= @script_activo,
	      script_priority	= @script_priority,
	      script_name		= @script_name,
	      script_description = @script_description,
	      usuario_modifica	= @usuario_modifica,
	      fecha_modifica	= GETDATE()
	WHERE script_id = @script_id;
END
