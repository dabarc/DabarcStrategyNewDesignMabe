
CREATE PROCEDURE [dabarc].[sp_REC_ReadListOfTeam] AS 
BEGIN
 SET NOCOUNT ON;
 SELECT team_id AS Id, 
		    team_name AS Name, 
			team_description AS Description, 
			team_dbid AS DbId,
			ISNULL(m.name,'No encontrado') DbName, 
			no_trans AS NoTrans,
			usuario_alta AS UsuarioAlta,
			fecha_alta   AS FechaAlta,
			usuario_modifica  AS UsuarioModifica,
			fecha_modifica  AS FechaModifica
 FROM	t_recording_team AS t
 LEFT OUTER JOIN t_BDM AS m ON t.team_dbid = m.database_id
END;