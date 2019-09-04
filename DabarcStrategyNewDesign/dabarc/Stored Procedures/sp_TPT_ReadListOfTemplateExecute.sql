CREATE PROCEDURE  [dabarc].[sp_TPT_ReadListOfTemplateExecute] 
@driver_id INT  
AS
BEGIN
SET NOCOUNT ON;
 SELECT  p.plantilla_id
		,p.plan_name
		,p.plan_description
		,p.last_error
 FROM t_PlantillaH p
	INNER JOIN t_ODBC o ON p.odbc_id = o.odbc_id
	INNER JOIN t_ODBC_driver d ON o.driver_id = d.driver_id AND o.driver_id = @driver_id
 ORDER BY p.plan_name asc
END
