 CREATE PROCEDURE [dabarc].[sp_RECc_loadScreentxt] @intScript_id INT, 
											   @strScreen_SapName NVARCHAR(100),
											   @strScreen_SapNo NCHAR(10),
											   @strUsuario_alta NVARCHAR(100) AS 
    DECLARE @intNewId	 INT
    DECLARE @intPosition INT
    
    
    SELECT @intPosition = ISNULL(MAX(screen_position),0) + 10 
    FROM   t_recording_screen 
    WHERE  script_id = @intScript_id
    

INSERT INTO t_recording_screen
           (script_id
           ,screen_title
           ,screen_position
           ,screen_sapname
           ,screen_sapno
           ,screen_typestruc
           ,screen_nofields
           ,screen_fieldview
           ,screen_fieldwhere
           ,usuario_alta
           ,fecha_alta)
    VALUES(@intScript_id, 
			null, 
			@intPosition, 
			@strScreen_SapName, 
			@strScreen_SapNo, 
			'DET', 
			0,
			'',
			'',
			@strUsuario_alta, 
			GETDATE())


		SELECT @intNewId = @@IDENTITY

		IF @@ERROR <> 0 
		BEGIN
			--RAISERROR ('Error al cargar la pantalla desde el texto.',16,1);
			
			RAISERROR (50016,
    16, -- Severity.
    1, -- State.
    '',
    '') -- Second substitution argument.
			
			
			
			
			RETURN 0;
		END
    
		SELECT @intNewId;
	
	RETURN
