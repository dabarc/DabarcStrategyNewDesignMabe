
 CREATE PROCEDURE [dabarc].[sp_RECc_ReadListOfscreen] @intSqcript_Id INT AS
 
 SELECT  screen_id
 		,screen_position
 		,screen_sapno
		,screen_sapname 				
 		,screen_title
		,[screen_sapdesc] = c.Short_Description
		,[screen_typestruc] = CASE  WHEN screen_typestruc = 'DET' THEN 'DETALLE'
									WHEN screen_typestruc = 'CAB' THEN 'CABECERO' ELSE 'PIE' END
		,screen_fieldview
		,screen_fieldwhere
		,screen_nofields
		,usuario_modifica
		,fecha_modifica
		,s.script_id
  FROM t_recording_screen s
	LEFT OUTER JOIN t_SapCatScreen c ON RTRIM(UPPER(s.screen_sapno)) = RTRIM(UPPER(c.Code_Screen))
  WHERE script_id = @intSqcript_Id
         order by screen_position
