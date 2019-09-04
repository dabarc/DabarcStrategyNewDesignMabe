CREATE PROCEDURE  [dabarc].[sp_TPT_ReadListOfTemplate]  
AS
BEGIN
SET NOCOUNT ON;
 
 SELECT  p.plantilla_id
		,p.plan_name
		,p.plan_description
		,o.odbc_name + '(' + d.driver_text + ')' as Origen
		,p.sql_server + ' ' + p.sql_database as Destino
		,p.last_error
		,p.porc_equal
 FROM dabarc.t_PlantillaH p
	INNER JOIN dabarc.t_ODBC o ON p.odbc_id = o.odbc_id
	INNER JOIN dabarc.t_ODBC_driver d ON o.driver_id = d.driver_id
 ORDER BY p.create_date desc;
END;
