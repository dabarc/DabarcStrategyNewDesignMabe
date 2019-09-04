CREATE PROCEDURE [dabarc].[sp_TPT_ReadClientforTemplate] @Plantilla_id INT 
AS
BEGIN
	SET NOCOUNT ON ;
--Data Source=.;Initial Catalog=dabarc_strategy;Persist Security Info=True;User ID=dabarc; Password=system;

  SELECT	'Data Source=' + sql_server + ';Initial Catalog=' + sql_database + ';Persist Security Info=True;User ID=' + sql_user + ';Password=' + sql_pasword + ''  as conecxion,
			'SELECT object_id, name  FROM ' +  h.sql_database + '.sys.tables WHERE name like ''TDM%''' AS sqlEsquema
  FROM		t_PlantillaH h
  WHERE		plantilla_id = @Plantilla_id;
END;
