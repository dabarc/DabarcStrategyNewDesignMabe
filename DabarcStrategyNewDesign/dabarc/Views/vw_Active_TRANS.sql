





CREATE VIEW	[dabarc].[vw_Active_TRANS] AS

	SELECT  t.team_id,
			t.team_name,
			s.script_id,
			[script_name] = '(' + RTRIM(s.script_transcode) + ') ' +  RTRIM(ISNULL(s.script_name,'SIN NOMBRE')),
			t.team_dbid,
			m.name					AS db_name,
			s.script_sourceviewh	AS view_name,
			s.script_sourcefieldh	AS key_h,
			s.script_sourcefieldd   AS key_d,
			'C:' + RTRIM(CAST(ISNULL(s.script_fileamount,0) AS CHAR(8))) + ',T:' + RTRIM(CAST(ISNULL(s.script_toptrans,0) AS CHAR(8))) AS Separador
	FROM	t_recording_script s
			INNER JOIN t_recording_team t ON s.team_id = t.team_id
			LEFT OUTER JOIN t_BDM m		 ON t.team_dbid = m.database_id
	WHERE	script_activo = 1
