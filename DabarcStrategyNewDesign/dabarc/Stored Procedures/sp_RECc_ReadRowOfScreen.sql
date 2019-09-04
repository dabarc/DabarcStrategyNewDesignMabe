
create PROCEDURE [dabarc].[sp_RECc_ReadRowOfScreen] @screen_id INT AS

SELECT screen_id
      ,script_id
      ,screen_title
      ,screen_position
      ,screen_sapname
      ,screen_sapno
      ,screen_typestruc
      ,screen_fieldview
      ,screen_fieldwhere
      ,screen_nofields
      ,usuario_alta
      ,fecha_alta
      ,usuario_modifica
      ,fecha_modifica
  FROM t_recording_screen
  WHERE screen_id = @screen_id
