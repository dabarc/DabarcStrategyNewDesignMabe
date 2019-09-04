 CREATE PROCEDURE [dabarc].[sp_script_ReadListScriptCleanData]  AS
 SET NOCOUNT ON 
SELECT idsinfom
      ,tablename
      ,fieldname
      ,datecreate
      ,script_final
      ,info_name
      ,error
  FROM dabarc.t_scriptInfcleanData1
  ORDER BY idsinfom DESC
