
CREATE PROCEDURE [dabarc].[sp_RECs_DeleteRowOfScript] @intScript_id INT AS 

	-- Borramos renglones

	DELETE FROM t_recording_fields WHERE screen_id IN (
		SELECT screen_id FROM t_recording_screen WHERE script_id = @intScript_id)
	
	-- Borramos pantallas

	DELETE FROM t_recording_screen WHERE script_id = @intScript_id	

	-- Borramos transaccion

	DELETE FROM t_recording_script WHERE script_id = @intScript_id
