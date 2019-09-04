CREATE PROCEDURE [dabarc].[sp_RECs_UpdateRowOfScript]
@intScript_id INT,
@script_activo BIT,
@script_priority INT,
@script_name NVARCHAR(100),
@script_description NVARCHAR(500),
@script_structure NCHAR(10),
@script_sourceviewh NVARCHAR(100),
@script_sourcefieldh NVARCHAR(50),
@script_sourcefieldd NVARCHAR(50),
@script_typeamount NCHAR(10),
@script_fileamount INT,
@script_toptrans INT,
@usuario_modifica	NVARCHAR(100)
AS
BEGIN
SET NOCOUNT ON;
	DECLARE @TYPE NCHAR(10)
	---------------------------------------------------------------------------------------------------------------------------------------
	-- Validamos la activación
	---------------------------------------------------------------------------------------------------------------------------------------
	IF (@script_activo = 1 AND (@script_priority = 0 OR RTRIM(@script_description) = ''))
	BEGIN
	  -- RAISERROR('No se puede activar un registro con prioridad "0" y sin descripción corta', 16, 1);
	  RAISERROR (50051,    16,     1, '',    '')
	  RETURN;
	END
	---------------------------------------------------------------------------------------------------------------------------------------
	-- Modificar
	---------------------------------------------------------------------------------------------------------------------------------------
    UPDATE t_recording_script
	SET   script_activo			= @script_activo,
	      script_priority		= @script_priority,
	      script_name			= @script_name,
	      script_description	= @script_description,
	      script_structure		= @script_structure,
	      usuario_modifica		= @usuario_modifica,
	      fecha_modifica		= GETDATE(),
	      script_sourceviewh	 = @script_sourceviewh,
	      script_sourcefieldh	 = @script_sourcefieldh,
	      script_sourcefieldd	 = @script_sourcefieldd,
	      script_typeamount		= @script_typeamount,
	      script_fileamount		= @script_fileamount,
	      script_toptrans		= @script_toptrans
	WHERE script_id = @intScript_id;
END
