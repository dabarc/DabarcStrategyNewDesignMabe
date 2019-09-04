
CREATE VIEW [dabarc].[vw_Active_TemplateSSIS]  AS 

	SELECT  plantilla_id,
			plan_name,
			plan_description as short_description,
			1 Priority,
			'PACKAGE SSIS' Type,
			'ALL' Type_Table,
			porc_equal Empate
	FROM   t_PlantillaH
