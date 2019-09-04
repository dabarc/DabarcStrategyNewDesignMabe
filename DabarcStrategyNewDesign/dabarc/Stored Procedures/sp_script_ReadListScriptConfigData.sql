 CREATE PROCEDURE [dabarc].sp_script_ReadListScriptConfigData  AS
 SET NOCOUNT ON;
SELECT idsapfd
      ,tablename
      ,fieldname
      ,datecreate
      ,sap_scriptcheck
      ,error
  FROM dabarc.t_scriptSapData
  ORDER BY idsapfd ASC;
