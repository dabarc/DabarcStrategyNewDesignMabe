
CREATE VIEW [dabarc].[vw_Active_SSIS]  AS 
	SELECT  ssis_id,
			name,
			short_description,
			[priority],
			'SSIS' Type,	
			SUBSTRING(name,6,3) Type_Table,
			table_id,
			path,
			database_id
	FROM	t_SSIS 
	WHERE	registered = 1 
			AND active = 1
