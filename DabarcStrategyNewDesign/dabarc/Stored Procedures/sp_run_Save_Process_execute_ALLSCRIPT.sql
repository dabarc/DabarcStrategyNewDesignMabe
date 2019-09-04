CREATE PROCEDURE [dabarc].[sp_run_Save_Process_execute_ALLSCRIPT] 
(
   @team_id			int, -- Id 
   @execute_user	nvarchar(15), -- Usuario que Ejecuta
   @ppath_unickey	NVARCHAR(80)
)AS

DECLARE @path_id INT

	
	DECLARE CursorS CURSOR FOR 

	SELECT	script_id
	FROM	dabarc.t_recording_script
	WHERE   team_id = @team_id AND script_activo = 1
	ORDER BY script_priority;

	OPEN CursorS
	FETCH NEXT FROM CursorS INTO @path_id

	WHILE @@FETCH_STATUS = 0
	BEGIN
		
		 EXECUTE sp_run_Save_Process_execute_SCRIPT @path_id, @execute_user, @ppath_unickey
		
		
		FETCH NEXT FROM CursorS 
		INTO @path_id
	END 
	CLOSE CursorS;
	DEALLOCATE CursorS;


RETURN
