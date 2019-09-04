CREATE PROCEDURE [dabarc].[sp_REC_DeleteRowOfTeam]
@Team_Id INT
AS
BEGIN
	SET NOCOUNT ON;
  	IF (SELECT COUNT(*) FROM t_recording_script WHERE team_id = @Team_Id ) > 0
	BEGIN
	  -- RAISERROR('Este equipo tiene transacciones, no puede ser eliminado.', 16, 1);
	  RAISERROR (50021,16,1,'','')
	  RETURN;
	END
  DELETE FROM t_recording_team
  WHERE team_id = @Team_Id
END;
