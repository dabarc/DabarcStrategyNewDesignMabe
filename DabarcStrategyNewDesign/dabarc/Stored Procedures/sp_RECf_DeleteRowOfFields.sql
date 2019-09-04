 CREATE PROCEDURE [dabarc].[sp_RECf_DeleteRowOfFields] @field_id INT AS 
 
  DECLARE @script_id INT
  
  SELECT @script_id = s.script_id 
  FROM  t_recording_fields f 
 INNER JOIN t_recording_screen s ON f.screen_id = s.screen_id AND f.field_id = @field_id
  
   -- Borramos el registro 
   DELETE FROM t_recording_fields WHERE field_id = @field_id
   
   --Re calculamos el numero de registros 
   EXECUTE sp_REC_LoadtxtCalculateFields @script_id
