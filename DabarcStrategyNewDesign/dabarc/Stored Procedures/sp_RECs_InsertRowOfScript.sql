CREATE PROCEDURE [dabarc].[sp_RECs_InsertRowOfScript]	@intTeam_id INT,
														@script_name NVARCHAR(100), 
														@script_description NVARCHAR(500), 
														@script_transcode NVARCHAR(50),
														@usuario_alta	NVARCHAR(100) AS 
	DECLARE @intNewId INT
	
	---------------------------------------------------------------------------------------------------------------------------------------
	-- Insertar
	---------------------------------------------------------------------------------------------------------------------------------------

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
				@script_name, 
				@script_description, 
				0, 
				@script_transcode, 
				'DET',
				0,
				0,
				0,
				@usuario_alta, 
				GETDATE())

		SELECT @intNewId = @@IDENTITY

		IF @@ERROR <> 0 
		BEGIN
		--	RAISERROR ('Error al registrar la transacción. ',16,1);
			 RAISERROR (50001,16,1, '','')
			
			RETURN;
		END
    
	
	SELECT @intNewId;
	
	RETURN
