CREATE PROCEDURE [dabarc].[sp_REC_LoadtxtCalculateFields] @intScript_id INT AS 
 
  --------------------------------------------------------------------------------------------------------------
  --- Calculamos el numero de renglones por pantallas 
  --------------------------------------------------------------------------------------------------------------

  UPDATE s
  SET  s.screen_nofields = e.fields_no
  FROM  t_recording_screen s
   INNER JOIN (  SELECT   screen_id, 
        COUNT(screen_id) as fields_no 
      FROM t_recording_fields
      GROUP BY screen_id) e ON s.screen_id = e.screen_id
  WHERE  s.script_id = @intScript_id

  --------------------------------------------------------------------------------------------------------------
  --- Calculamos el numero de renglones y pantallas por script
  --------------------------------------------------------------------------------------------------------------


  UPDATE s
  SET  s.script_noscreens = e.NoScreen, 
   s.script_nofields  = e.NoFields
  FROM  t_recording_script s
   INNER JOIN (
      SELECT script_id,
       [NoScreen] = COUNT(screen_id) ,
       [NoFields] = SUM(screen_nofields)
      FROM  t_recording_screen 
      WHERE  script_id = @intScript_id
      GROUP BY  script_id ) e ON s.script_id = e.script_id 
  WHERE s.script_id = @intScript_id
  
  SELECT 1
