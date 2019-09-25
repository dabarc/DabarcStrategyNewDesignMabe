CREATE PROCEDURE [dabarc].[sp_RECs_ReadListOfScript] @Team_id INT AS
 
   SELECT script_id
      ,script_activo
      ,script_priority
      ,script_transcode
      ,script_name 
      ,script_description
      ,[description_sap] = c.Short_Description
      ,[script_structure] = CASE WHEN script_structure = 'DET' THEN 'DET-DETALLE'
								 WHEN script_structure = 'MDE' THEN 'MDE-MAESTRO/DETALLE' ELSE 'MDF-MAESTRO/DETALLE/PIE' END
      ,ISNULL(b.name,'No Asignado') as script_DB
      ,script_sourceviewh
      ,script_sourcefieldh
      ,script_sourcefieldd
      ,script_noscreens
      ,script_nofields
      ,t.execute_user
      ,t.execute_date
	  ,t.affected_rows
    FROM t_recording_script t
		LEFT OUTER JOIN t_recording_team a	ON t.team_id = a.team_id
		LEFT OUTER JOIN t_BDM b				ON a.team_dbid = b.database_id
		LEFT OUTER JOIN t_SapCatTransaction c ON RTRIM(UPPER(t.script_transcode)) = RTRIM(UPPER(c.Code_Transaction))
  WHERE t.team_id = @Team_id
