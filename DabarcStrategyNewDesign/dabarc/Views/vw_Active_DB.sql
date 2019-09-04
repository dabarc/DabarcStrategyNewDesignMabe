
CREATE VIEW [dabarc].[vw_Active_DB]  AS 
	SELECT  database_id,
			name,
			short_description,
			[priority],
			'DB' Type,	
			'BDF' Type_Table
	FROM	t_BDF
	WHERE	registered = 1 
			AND active = 1
			AND [priority] > 0
	UNION	
	SELECT  database_id,
			name,
			short_description,
			[priority] ,
			'DB' Type,	
			'BDM' Type_Table
	FROM	t_BDM
	WHERE	registered = 1 
			AND active = 1
			AND  [priority]  > 0
