CREATE PROCEDURE [dabarc].[sp_RECc_DeleteRowOfScreen] @screen_id INT AS 

  DECLARE @script_id INT
  
  SELECT @script_id = s.script_id 
  FROM  t_recording_screen s 
  WHERE  screen_id = @screen_id
  
   -- Borramos los renglones
   DELETE FROM t_recording_fields WHERE screen_id = @screen_id
   
   -- Borramos la pantalla
   DELETE FROM t_recording_screen WHERE screen_id = @screen_id
   
   --Recalculamos el numero de registros 
   EXECUTE sp_REC_LoadtxtCalculateFields @script_id
