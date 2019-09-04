  CREATE PROCEDURE [dabarc].[sp_REC_UpdateListOfTeams] @Team_Id INT, @strDescription NVARCHAR(500), @modify_user NVARCHAR(100) AS 
  
   DECLARE @intCount INT
  
   SELECT @intCount = ISNULL(COUNT(*),0) FROM t_recording_script WHERE team_id = @Team_Id
   
   UPDATE t_recording_team
   SET	  team_description	= @strDescription,
		  no_trans			= @intCount,
		  usuario_modifica	= @modify_user,
		  fecha_modifica	= GETDATE()
   WHERE team_id = @Team_Id
