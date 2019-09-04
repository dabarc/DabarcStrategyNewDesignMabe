
 CREATE PROCEDURE [dabarc].[sp_RECs_loadScripttxt]	@intTeam_id INT, 
													@strScript_transcode NCHAR(15),
													@strUsuario_alta NVARCHAR(100) AS
											 
    DECLARE @intNewId INT
 
 
	 INSERT INTO t_recording_script
			   (team_id
			   ,script_activo
			   ,script_name
			   ,script_description
			   ,script_priority
			   ,script_transcode
			   ,script_structure
			   ,script_noscreens
			   ,script_nofields
			   ,affected_rows
			   ,usuario_alta
			   ,fecha_alta)
	           
	 VALUES(	@intTeam_id, 
				0, 
				null, 
				null, 
				0, 
				@strScript_transcode, 
				'DET',
				0,
				0,
				0,
				@strUsuario_alta, 
				GETDATE())

		SELECT @intNewId = @@IDENTITY

		IF @@ERROR <> 0 
		BEGIN
		--	RAISERROR ('Error al cargar la transacción desde el texto. ',16,1);
			  RAISERROR (50016,16,1, '','')
			
			
			
			
			RETURN;
		END
    
	
	SELECT @intNewId;
	
	RETURN
