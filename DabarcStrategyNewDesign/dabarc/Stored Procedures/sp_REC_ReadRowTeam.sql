CREATE PROCEDURE [dabarc].[sp_REC_ReadRowTeam] @Team_Id INT AS 
BEGIN
 SET NOCOUNT ON;
 SELECT	    team_id AS Id, 
		    team_name AS Name, 
			team_description AS Description, 
			team_dbid AS DbId,
			ISNULL(b.name,'No encontrado') DbName, 
			no_trans AS NoTrans,
			usuario_alta AS UsuarioAlta,
			fecha_alta   AS FechaAlta,
			usuario_modifica  AS UsuarioModifica,
			fecha_modifica  AS FechaModifica
 FROM   t_recording_team t
 LEFT OUTER JOIN t_BDM b	ON t.team_dbid = b.database_id
 WHERE  team_id = @Team_Id
END