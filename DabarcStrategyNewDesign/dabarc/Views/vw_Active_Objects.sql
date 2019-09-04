






CREATE VIEW [dabarc].[vw_Active_Objects]  AS 

 SELECT dabarc.fnt_ObjectIdAndType(database_id,Type_Table) AS object_id,
		database_id AS objectid,
		name,
		short_description,
		Type_Table as object_type, 
		't_' + Type_Table as table_name
 FROM dabarc.vw_Active_DB
 UNION 
 SELECT dabarc.fnt_ObjectIdAndType(report_id,Type_Table) AS object_id,
		report_id AS objectid,
		name, 
		short_description,
		Type_Table as object_type, 
		't_' + Type_Table as table_name   
 FROM dabarc.vw_Active_INFO
 UNION 
 SELECT dabarc.fnt_ObjectIdAndType(ssis_id,Type) AS object_id,
		ssis_id  AS objectid,
		name, 
		short_description,
		Type as object_type, 
		't_' + Type as table_name
 FROM dabarc.vw_Active_SSIS
 UNION 
 SELECT dabarc.fnt_ObjectIdAndType(table_id,Type_Table) AS object_id,
		table_id AS objectid,
		name, 
		short_description,
		Type_Table as object_type, 
		't_' + Type_Table as table_name   
 FROM dabarc.vw_Active_TABLE
 UNION 
 SELECT dabarc.fnt_ObjectIdAndType(rule_id,Type_Table) AS object_id,
		rule_id AS objectid,
		name, 
		short_description,
		Type_Table as object_type, 
		't_' + Type_Table as table_name   
 FROM dabarc.vw_Active_RULE
 UNION
 SELECT  dabarc.fnt_ObjectIdAndType(interface_id,Type) AS object_id,
		 interface_id AS objectid,
		 name,
		 short_description,
 		 Type_Table as object_type, 
		 't_' + Type_Table as table_name  		 
 FROM dabarc.vw_Active_INTE
 UNION
  SELECT dabarc.fnt_ObjectIdAndType(database_id,'DBSS') AS object_id,
		database_id AS objectid,
		'SSIS DE ' + name, 
		short_description,
		 'DBSS' as object_type, 
		't_' + Type_Table as table_name
 FROM dabarc.vw_Active_DB
 WHERE Type_Table = 'BDF'
