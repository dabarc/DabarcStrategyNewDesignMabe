CREATE PROCEDURE [dabarc].[sp_RECs_ReadRowOfScript]
@intscript_id INT
AS
BEGIN
SET NOCOUNT ON;
  SELECT r.team_id
      ,script_activo
      ,script_name
      ,script_description
      ,script_priority
      ,script_transcode
      ,script_structure
      ,t.team_dbid
      ,ISNULL(b.name,'SIN ASIGNAR') BDM_name
      ,script_sourceviewh
      ,script_sourcefieldh
      ,script_sourcefieldd
      ,script_noscreens
	  ,script_nofields
	  ,script_typeamount
	  ,script_fileamount
	  ,script_toptrans
  FROM t_recording_script r
	   INNER JOIN	   t_recording_team t ON r.team_id = t.team_id
	   LEFT OUTER JOIN t_BDM b			  ON t.team_dbid = b.database_id
  WHERE script_id = @intscript_id;
END
