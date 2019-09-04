CREATE PROCEDURE [dabarc].[sp_REC_InsertRowOfTeam]   @team_Name NVARCHAR(100), 
												    @team_description NVARCHAR(500),
												    @team_dbid INT, 
												    @register_user NVARCHAR(100) AS
 
  	IF (SELECT COUNT(*) FROM t_recording_team WHERE UPPER(RTRIM(team_name)) = UPPER(RTRIM(@team_Name))) > 0
	BEGIN
	   --RAISERROR('Ya existe un equipo con este nombre.', 16, 1);
	    RAISERROR (50063,16,1, '','')
	   
	   RETURN;
	END

  INSERT INTO t_recording_team
           (team_name,team_description,team_dbid,no_trans ,usuario_alta ,fecha_alta)
  VALUES(@team_Name,@team_description,@team_dbid,0,@register_user,GETDATE())
