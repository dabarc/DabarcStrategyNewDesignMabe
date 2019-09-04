CREATE PROCEDURE [dabarc].[sp_TPT_ReadODBCforTemplate]
@odbc_id INT AS
BEGIN
SET NOCOUNT ON;
--Data Source=.;Initial Catalog=dabarc_strategy;Persist Security Info=True;User ID=dabarc; Password=system;

  SELECT	'Data Source=' + sql_server + ';Initial Catalog=' + sql_database + ';Persist Security Info=True;User ID=' + sql_user + ';Password=' + sql_pasword + ''  
			
  FROM		dabarc.t_PlantillaH
  WHERE		plantilla_id = @odbc_id;
END
