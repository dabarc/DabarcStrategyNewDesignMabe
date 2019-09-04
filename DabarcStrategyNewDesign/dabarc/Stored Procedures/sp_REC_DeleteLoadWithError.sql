CREATE PROCEDURE [dabarc].[sp_REC_DeleteLoadWithError]
 @intScript_id INT
 AS
 BEGIN
 SET NOCOUNT ON;
 IF (@intScript_id > 0)
	 BEGIN
	  DELETE FROM t_recording_fields
	  WHERE screen_id IN
			  (
			  SELECT c.screen_id
			  FROM t_recording_script s
			  INNER JOIN t_recording_screen c ON s.script_id = c.screen_id
			  WHERE s.script_id = @intScript_id
			  );

	  DELETE FROM t_recording_screen
	  WHERE script_id IN
					(
					SELECT s.script_id
					FROM t_recording_script s
					WHERE s.script_id = @intScript_id
					);

	  DELETE FROM t_recording_script
	  WHERE script_id = @intScript_id;

	 END
 END
